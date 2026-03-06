#!/usr/bin/env bash
# ============================================================================
# Hachimi — 一键配置 Workload Identity Federation + GitHub Secrets
#
# 用途：配置 GCP WIF 认证 + 创建服务账号 + 设置 GitHub production env secrets
# 前提：gcloud 已登录、gh 已登录、已安装 jq
#
# 使用方法：
#   chmod +x scripts/setup-wif.sh && ./scripts/setup-wif.sh
# ============================================================================

set -euo pipefail

# ── 配置区（按需修改） ──────────────────────────────────────────────
PROJECT_ID="hachimi-ai"
PROJECT_NUMBER="360008924406"
POOL_ID="github-actions"
PROVIDER_ID="github-repo"
SA_NAME="play-store-publisher"
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
GITHUB_REPO="sinnohzeng/hachimi-app"
GITHUB_ENV="production"
# ────────────────────────────────────────────────────────────────────

echo "======================================"
echo " Hachimi WIF 自动配置脚本"
echo "======================================"
echo ""
echo "项目 ID:      ${PROJECT_ID}"
echo "项目编号:     ${PROJECT_NUMBER}"
echo "GitHub 仓库:  ${GITHUB_REPO}"
echo ""

# ── 前置检查 ────────────────────────────────────────────────────────
echo "▶ 检查工具是否可用..."
command -v gcloud >/dev/null 2>&1 || { echo "错误: 需要安装 gcloud CLI"; exit 1; }
command -v gh >/dev/null 2>&1 || { echo "错误: 需要安装 gh CLI"; exit 1; }

echo "▶ 检查 gcloud 登录状态..."
GCLOUD_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null || true)
if [ -z "$GCLOUD_ACCOUNT" ]; then
  echo "错误: gcloud 未登录。请先运行: gcloud auth login"
  exit 1
fi
echo "  当前账号: ${GCLOUD_ACCOUNT}"

echo "▶ 检查 gh 登录状态..."
GH_USER=$(gh api user --jq '.login' 2>/dev/null || true)
if [ -z "$GH_USER" ]; then
  echo "错误: gh 未登录。请先运行: gh auth login"
  exit 1
fi
echo "  当前用户: ${GH_USER}"
echo ""

# ── 第一步：启用 Google Play Android Developer API ──────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "步骤 1/6: 启用 Google Play Android Developer API"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
gcloud services enable androidpublisher.googleapis.com --project="${PROJECT_ID}" 2>&1 || true
echo "✓ API 已启用"
echo ""

# ── 第二步：创建 Workload Identity Pool ─────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "步骤 2/6: 创建 Workload Identity Pool"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if gcloud iam workload-identity-pools describe "${POOL_ID}" \
    --project="${PROJECT_ID}" --location="global" &>/dev/null; then
  echo "  Pool '${POOL_ID}' 已存在，跳过创建"
else
  gcloud iam workload-identity-pools create "${POOL_ID}" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --display-name="GitHub Actions Pool"
  echo "✓ Pool 创建成功"
fi
echo ""

# ── 第三步：创建 OIDC Provider ──────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "步骤 3/6: 创建 OIDC Provider（绑定到 ${GITHUB_REPO}）"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if gcloud iam workload-identity-pools providers describe "${PROVIDER_ID}" \
    --project="${PROJECT_ID}" --location="global" \
    --workload-identity-pool="${POOL_ID}" &>/dev/null; then
  echo "  Provider '${PROVIDER_ID}' 已存在，跳过创建"
else
  gcloud iam workload-identity-pools providers create-oidc "${PROVIDER_ID}" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --workload-identity-pool="${POOL_ID}" \
    --display-name="GitHub Repo Provider" \
    --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
    --attribute-condition="assertion.repository=='${GITHUB_REPO}'" \
    --issuer-uri="https://token.actions.githubusercontent.com"
  echo "✓ Provider 创建成功"
fi

# 获取 Provider 完整路径
WIF_PROVIDER=$(gcloud iam workload-identity-pools providers describe "${PROVIDER_ID}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="${POOL_ID}" \
  --format="value(name)")
echo "  Provider 完整路径: ${WIF_PROVIDER}"
echo ""

# ── 第四步：创建服务账号 + WIF 绑定 ─────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "步骤 4/6: 创建服务账号 + 授予 WIF 绑定"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if gcloud iam service-accounts describe "${SA_EMAIL}" --project="${PROJECT_ID}" &>/dev/null; then
  echo "  服务账号 '${SA_EMAIL}' 已存在，跳过创建"
else
  gcloud iam service-accounts create "${SA_NAME}" \
    --project="${PROJECT_ID}" \
    --display-name="Play Store Publisher"
  echo "✓ 服务账号创建成功"
fi

echo "  授予 WIF workloadIdentityUser 绑定..."
gcloud iam service-accounts add-iam-policy-binding "${SA_EMAIL}" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/attribute.repository/${GITHUB_REPO}" \
  --condition=None \
  2>&1 | tail -1
echo "✓ WIF 绑定完成"
echo ""

# ── 第五步：设置 GitHub production Environment Secrets ───────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "步骤 5/6: 设置 GitHub production Environment Secrets"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "  设置 WIF_PROVIDER..."
echo -n "${WIF_PROVIDER}" | gh secret set WIF_PROVIDER \
  --repo="${GITHUB_REPO}" \
  --env="${GITHUB_ENV}"

echo "  设置 WIF_SERVICE_ACCOUNT..."
echo -n "${SA_EMAIL}" | gh secret set WIF_SERVICE_ACCOUNT \
  --repo="${GITHUB_REPO}" \
  --env="${GITHUB_ENV}"

echo "✓ GitHub Secrets 设置完成"
echo ""

# ── 第六步：清理 repo-level 旧 secrets ──────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "步骤 6/6: 清理 repo-level 旧 secrets"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 删除已迁移到 production env 的 repo-level secrets
for SECRET_NAME in KEYSTORE_BASE64 KEYSTORE_PASSWORD KEY_ALIAS KEY_PASSWORD GOOGLE_SERVICES_JSON WIF_PROVIDER WIF_SERVICE_ACCOUNT; do
  if gh api "repos/${GITHUB_REPO}/actions/secrets/${SECRET_NAME}" &>/dev/null 2>&1; then
    gh secret delete "${SECRET_NAME}" --repo="${GITHUB_REPO}" 2>/dev/null || true
    echo "  已删除 repo-level: ${SECRET_NAME}"
  else
    echo "  跳过（不存在）: ${SECRET_NAME}"
  fi
done

# 删除废弃的旧 AI key secrets
for SECRET_NAME in GEMINI_API_KEY MINIMAX_API_KEY; do
  if gh api "repos/${GITHUB_REPO}/actions/secrets/${SECRET_NAME}" &>/dev/null 2>&1; then
    gh secret delete "${SECRET_NAME}" --repo="${GITHUB_REPO}" 2>/dev/null || true
    echo "  已删除废弃 secret: ${SECRET_NAME}"
  else
    echo "  跳过（不存在）: ${SECRET_NAME}"
  fi
done

echo ""
echo "  保留 repo-level: FIREBASE_OPTIONS_DART（ci.yml 需要）"
echo ""

# ── 验证 ────────────────────────────────────────────────────────────
echo "======================================"
echo " 配置完成！验证结果："
echo "======================================"
echo ""

echo "▶ GCP: Google Play Android Developer API"
gcloud services list --enabled --project="${PROJECT_ID}" --filter="config.name:androidpublisher" --format="value(config.name)" 2>/dev/null && echo "  ✓ 已启用" || echo "  ✗ 未启用"

echo ""
echo "▶ GCP: WIF Pool"
gcloud iam workload-identity-pools describe "${POOL_ID}" --project="${PROJECT_ID}" --location="global" --format="value(state)" 2>/dev/null && echo "  ✓ 状态正常" || echo "  ✗ 不存在"

echo ""
echo "▶ GCP: WIF Provider"
echo "  ${WIF_PROVIDER}"

echo ""
echo "▶ GCP: 服务账号"
echo "  ${SA_EMAIL}"

echo ""
echo "▶ GitHub: production Environment Secrets"
gh api "repos/${GITHUB_REPO}/environments/${GITHUB_ENV}/secrets" --jq '.secrets[].name' 2>/dev/null | sort | while read -r name; do
  echo "  ✓ ${name}"
done

echo ""
echo "▶ GitHub: repo-level Secrets"
gh api "repos/${GITHUB_REPO}/actions/secrets" --jq '.secrets[].name' 2>/dev/null | sort | while read -r name; do
  echo "  ✓ ${name}"
done

echo ""
echo "======================================"
echo " 剩余手动步骤："
echo "======================================"
echo ""
echo "1. 在 Play Console 邀请服务账号："
echo "   - 打开 https://play.google.com/console"
echo "   - 左侧 Users and permissions → Invite new users"
echo "   - 邮箱: ${SA_EMAIL}"
echo "   - 勾选: Release apps to testing tracks"
echo "   - 勾选: Release to production, exclude devices, and use Play App Signing"
echo "   - 点击 Invite user"
echo ""
echo "2. 等待 24-48 小时权限生效"
echo ""
echo "3. 首次发版验证："
echo "   git tag -a v2.28.0 -m 'v2.28.0: test production pipeline'"
echo "   git push origin main --tags"
echo "   gh run list --limit 3"
echo ""

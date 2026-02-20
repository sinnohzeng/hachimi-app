#!/usr/bin/env bash
# ---
# Interactive setup script for Android release signing.
#
# What this script does:
#   1. Generates a production keystore (~/hachimi-release.jks)
#   2. Creates android/key.properties for local release builds
#   3. Extracts SHA-1 fingerprint (for Firebase Console registration)
#   4. Base64-encodes files needed as GitHub Secrets
#   5. Prints a summary of all GitHub Secrets to configure
#
# Usage:
#   chmod +x scripts/setup-release-signing.sh
#   ./scripts/setup-release-signing.sh
# ---

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KEYSTORE_PATH="$HOME/hachimi-release.jks"
KEY_ALIAS="hachimi-release"
KEY_PROPERTIES="$PROJECT_ROOT/android/key.properties"

echo ""
echo -e "${BOLD}${CYAN}=== Hachimi Release Signing Setup ===${NC}"
echo ""

# ── Step 1: Check prerequisites ──

if ! command -v keytool &> /dev/null; then
    echo -e "${RED}Error: keytool not found. Install JDK 17 first.${NC}"
    echo "  brew install openjdk@17"
    exit 1
fi

if [ -f "$KEYSTORE_PATH" ]; then
    echo -e "${YELLOW}Warning: Keystore already exists at $KEYSTORE_PATH${NC}"
    read -rp "Overwrite? (y/N): " overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        echo "Skipping keystore generation. Using existing keystore."
        SKIP_KEYGEN=true
    else
        SKIP_KEYGEN=false
    fi
else
    SKIP_KEYGEN=false
fi

# ── Step 2: Generate keystore ──

if [ "$SKIP_KEYGEN" = false ]; then
    echo ""
    echo -e "${BOLD}Step 1/5: Generate production keystore${NC}"
    echo -e "The keystore will be saved to: ${CYAN}$KEYSTORE_PATH${NC}"
    echo ""

    read -rsp "Enter keystore password (min 6 chars): " STORE_PASSWORD
    echo ""
    if [ ${#STORE_PASSWORD} -lt 6 ]; then
        echo -e "${RED}Error: Password must be at least 6 characters.${NC}"
        exit 1
    fi

    read -rsp "Confirm keystore password: " STORE_PASSWORD_CONFIRM
    echo ""
    if [ "$STORE_PASSWORD" != "$STORE_PASSWORD_CONFIRM" ]; then
        echo -e "${RED}Error: Passwords do not match.${NC}"
        exit 1
    fi

    keytool -genkeypair \
        -alias "$KEY_ALIAS" \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -storetype JKS \
        -keystore "$KEYSTORE_PATH" \
        -storepass "$STORE_PASSWORD" \
        -keypass "$STORE_PASSWORD" \
        -dname "CN=Hachimi, OU=Mobile, O=Hachimi, L=Unknown, S=Unknown, C=US"

    echo -e "${GREEN}Keystore generated at $KEYSTORE_PATH${NC}"
else
    echo ""
    read -rsp "Enter existing keystore password: " STORE_PASSWORD
    echo ""
fi

# ── Step 3: Extract SHA-1 fingerprint ──

echo ""
echo -e "${BOLD}Step 2/5: Extract SHA-1 fingerprint${NC}"
echo ""

SHA1=$(keytool -list -v \
    -keystore "$KEYSTORE_PATH" \
    -alias "$KEY_ALIAS" \
    -storepass "$STORE_PASSWORD" 2>/dev/null \
    | grep "SHA1:" \
    | awk '{print $2}')

echo -e "Release SHA-1 fingerprint: ${BOLD}${GREEN}$SHA1${NC}"
echo ""
echo -e "${YELLOW}ACTION REQUIRED:${NC}"
echo "  1. Go to Firebase Console -> Project Settings -> Your Apps -> Android"
echo "  2. Click 'Add fingerprint'"
echo "  3. Paste this SHA-1: $SHA1"
echo "  4. Download the updated google-services.json"
echo "  5. Replace android/app/google-services.json with the new file"
echo ""
read -rp "Press Enter when you've completed the Firebase steps (or 's' to skip)... " firebase_done

# ── Step 4: Create key.properties ──

echo ""
echo -e "${BOLD}Step 3/5: Create android/key.properties${NC}"

cat > "$KEY_PROPERTIES" << EOF
storePassword=$STORE_PASSWORD
keyPassword=$STORE_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=$KEYSTORE_PATH
EOF

echo -e "${GREEN}Created $KEY_PROPERTIES${NC}"
echo -e "(This file is gitignored — safe to have locally)"

# ── Step 5: Generate base64-encoded secrets ──

echo ""
echo -e "${BOLD}Step 4/5: Generate GitHub Secrets values${NC}"
echo ""

KEYSTORE_B64=$(base64 -i "$KEYSTORE_PATH")

GOOGLE_SERVICES="$PROJECT_ROOT/android/app/google-services.json"
FIREBASE_OPTIONS="$PROJECT_ROOT/lib/firebase_options.dart"

if [ ! -f "$GOOGLE_SERVICES" ]; then
    echo -e "${RED}Warning: $GOOGLE_SERVICES not found.${NC}"
    echo "You'll need to add GOOGLE_SERVICES_JSON secret manually later."
    GOOGLE_SERVICES_B64="<FILE_NOT_FOUND>"
else
    GOOGLE_SERVICES_B64=$(base64 -i "$GOOGLE_SERVICES")
fi

if [ ! -f "$FIREBASE_OPTIONS" ]; then
    echo -e "${RED}Warning: $FIREBASE_OPTIONS not found.${NC}"
    echo "You'll need to add FIREBASE_OPTIONS_DART secret manually later."
    FIREBASE_OPTIONS_B64="<FILE_NOT_FOUND>"
else
    FIREBASE_OPTIONS_B64=$(base64 -i "$FIREBASE_OPTIONS")
fi

# ── Step 6: Print summary ──

echo ""
echo -e "${BOLD}Step 5/5: GitHub Secrets configuration${NC}"
echo ""
echo -e "${YELLOW}Go to: https://github.com/sinnohzeng/hachimi-app/settings/secrets/actions${NC}"
echo -e "Create the following 6 repository secrets:"
echo ""

echo -e "${BOLD}1. KEYSTORE_BASE64${NC}"
echo "---BEGIN---"
echo "$KEYSTORE_B64"
echo "---END---"
echo ""

echo -e "${BOLD}2. KEYSTORE_PASSWORD${NC}"
echo "$STORE_PASSWORD"
echo ""

echo -e "${BOLD}3. KEY_ALIAS${NC}"
echo "$KEY_ALIAS"
echo ""

echo -e "${BOLD}4. KEY_PASSWORD${NC}"
echo "$STORE_PASSWORD"
echo ""

echo -e "${BOLD}5. GOOGLE_SERVICES_JSON${NC}"
if [ "$GOOGLE_SERVICES_B64" = "<FILE_NOT_FOUND>" ]; then
    echo -e "${RED}(file not found — add manually after downloading from Firebase)${NC}"
else
    echo "---BEGIN---"
    echo "$GOOGLE_SERVICES_B64"
    echo "---END---"
fi
echo ""

echo -e "${BOLD}6. FIREBASE_OPTIONS_DART${NC}"
if [ "$FIREBASE_OPTIONS_B64" = "<FILE_NOT_FOUND>" ]; then
    echo -e "${RED}(file not found — run 'flutterfire configure' first)${NC}"
else
    echo "---BEGIN---"
    echo "$FIREBASE_OPTIONS_B64"
    echo "---END---"
fi

echo ""
echo -e "${BOLD}${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "Next steps:"
echo "  1. Copy each secret value above into GitHub repo settings"
echo "  2. Test local release build: flutter build apk --release"
echo "  3. Commit your changes and push"
echo "  4. Create a tag to trigger CI: git tag vX.Y.Z && git push --tags"
echo ""
echo -e "${YELLOW}IMPORTANT: Back up your keystore ($KEYSTORE_PATH) to a password manager!${NC}"
echo -e "${YELLOW}If you lose it, you can never publish updates to the same app.${NC}"
echo ""

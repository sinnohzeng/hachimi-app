class ObservabilityTags {
  ObservabilityTags._();

  static const Set<String> allowedExtras = {
    'feature',
    'operation',
    'operation_stage',
    'correlation_id',
    'uid_hash',
    'app_version',
    'build_number',
    'network_state',
    'retry_count',
    'error_code',
    'function_name',
    'latency_ms',
    'result',
    'provider',
    'screen',
    'service',
    'http_status',
    'issue_id',
    'trace_id',
    'model_name',
    'prompt_version',
    'spritesheet',
  };

  static const _piiHints = [
    'uid',
    'email',
    'phone',
    'mobile',
    'token',
    'name',
    'address',
  ];

  static bool isAllowedKey(String key) {
    if (!allowedExtras.contains(key)) return false;
    return !_containsSensitiveHint(key);
  }

  static bool isPiiKey(String key) {
    if (key == 'uid_hash') return false;
    return _containsSensitiveHint(key);
  }

  static bool _containsSensitiveHint(String key) {
    final lowered = key.toLowerCase();
    for (final hint in _piiHints) {
      if (lowered.contains(hint)) return true;
    }
    return false;
  }
}

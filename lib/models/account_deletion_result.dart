/// Account deletion outcome returned by [AccountDeletionOrchestrator].
///
/// `localDeleted` means local database data has been wiped.
/// `remoteDeleted` means callable hard-delete has completed successfully.
/// `queued` means remote deletion is pending retry.
class AccountDeletionResult {
  final bool localDeleted;
  final bool remoteDeleted;
  final bool queued;
  final String? errorCode;

  const AccountDeletionResult({
    required this.localDeleted,
    required this.remoteDeleted,
    required this.queued,
    this.errorCode,
  });
}

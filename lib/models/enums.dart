enum AuthError {
  wrongCredentials,
  emailAlreadyRegistered,
  noInternet,
  noVerifiedEmail,
}

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  wrongPassword,
  emailAllreadyRegistered,
  externalError,
  notVerifiedEmail,
  noInternet,
}

enum ContextMenuAction {
  createFolder,
  addFiles,
}

enum FileAction {
  delete,
  properties,
  rename,
  move,
  save,
  addFiles,
}

enum MediaAction {
  delete,
  properties,
  rename,
}

enum AvatarAction {
  changeAvatar,
  delete,
}

enum KeeperAction {
  delete,
  change,
}

enum ErrorType {
  noInternet,
  technicalError,
  alreadyExist,
  other,
}

enum Status {
  active,
  invited,
  emptyPermissions,
}

enum UserAction {
  nothing,
  uploadFiles,
  uploadMedia,
  createFolder,
  createAlbum,
  uploadFolder,
}

enum ResponseStatus {
  ok,
  declined,
  failed,
  notExecuted,
  noInternet,
}

Status? mapJsonToStatus(String? json) {
  switch (json) {
    case 'active':
      return Status.active;
    case 'invited':
      return Status.invited;
    case 'empty-permissions':
      return Status.emptyPermissions;
    default:
      return null;
  }
}

String? mapStatusToJson(Status? _enum) {
  switch (_enum) {
    case Status.active:
    case Status.invited:
      String? fullString = _enum?.toString();
      return fullString?.split('.').last;
    case Status.emptyPermissions:
      return 'empty-permissions';
    default:
      return null;
  }
}

enum PlanStatus {
  active,
  cancelAtPeriodEnd,
  error,
}

PlanStatus? mapJsonToPlanStatus(String? json) {
  switch (json) {
    case 'active':
      return PlanStatus.active;
    case 'cancel_at_period_end':
      return PlanStatus.cancelAtPeriodEnd;
    case 'error':
      return PlanStatus.error;
    default:
      return null;
  }
}

String? mapPlanStatusToJson(PlanStatus? _enum) {
  switch (_enum) {
    case PlanStatus.active:
    case PlanStatus.error:
      String? fullString = _enum?.toString();
      return fullString?.split('.').last;
    case PlanStatus.cancelAtPeriodEnd:
      return 'cancel_at_period_end';
    default:
      return null;
  }
}

enum Plan {
  free,
  growth,
  enterprise,
}

Plan? mapJsonToPlan(String? json) {
  switch (json) {
    case 'free':
      return Plan.free;
    case 'growth':
      return Plan.growth;
    case 'enterprise':
      return Plan.enterprise;
    default:
      return null;
  }
}

String? mapPlanToJson(Plan? _enum) {
  switch (_enum) {
    case Plan.free:
    case Plan.growth:
    case Plan.enterprise:
      String? fullString = _enum?.toString();
      return fullString?.split('.').last;
    default:
      return null;
  }
}

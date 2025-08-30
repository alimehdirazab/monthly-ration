part of 'models.dart';

class DriveAuthentication extends Equatable {
  const DriveAuthentication({
    this.userName,
    this.accessToken,
    this.refreshToken,
  });

  final String? userName;
  final String? accessToken;
  final String? refreshToken;

  @override
  List<Object?> get props => [userName, accessToken, refreshToken];
}

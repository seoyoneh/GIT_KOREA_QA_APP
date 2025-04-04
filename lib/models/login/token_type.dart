class JWTTokenType {
  final String accessToken;
  final String refreshToken;

  JWTTokenType.create({
    required this.accessToken,
    required this.refreshToken
  });

  factory JWTTokenType.fromJson(Map<String, dynamic> json) {
    return JWTTokenType.create(
      accessToken: json['AccessToken'] as String,
      refreshToken: json['RefreshToken'] as String
    );
  }
}
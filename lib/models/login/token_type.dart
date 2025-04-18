class JWTTokenType {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  JWTTokenType.create({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt
  });

  factory JWTTokenType.fromJson(Map<String, dynamic> json) {
    return JWTTokenType.create(
      accessToken: json['activeToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String)
    );
  }
}
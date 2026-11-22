class User {
  final String id;
  final String? email;
  final String? name;
  final String? deviceId;
  final bool isAnonymous;
  final String theme;
  final bool notificationsEnabled;
  final bool priceAlertsEnabled;
  final String fcmToken;

  User({
    required this.id,
    this.email,
    this.name,
    this.deviceId,
    this.isAnonymous = false,
    this.theme = 'vintage',
    this.notificationsEnabled = true,
    this.priceAlertsEnabled = true,
    this.fcmToken = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'deviceId': deviceId,
    'isAnonymous': isAnonymous,
    'theme': theme,
    'notificationsEnabled': notificationsEnabled,
    'priceAlertsEnabled': priceAlertsEnabled,
    'fcmToken': fcmToken,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    email: json['email'] as String?,
    name: json['name'] as String?,
    deviceId: json['deviceId'] as String?,
    isAnonymous: json['isAnonymous'] as bool? ?? false,
    theme: json['theme'] as String? ?? 'vintage',
    notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    priceAlertsEnabled: json['priceAlertsEnabled'] as bool? ?? true,
    fcmToken: json['fcmToken'] as String? ?? '',
  );
}

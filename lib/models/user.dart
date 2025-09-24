class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String role;
  final bool isActive;
  final String? phoneNumber;
  final String? address;
  final List<String> favoriteBookIds;
  final List<String> borrowedBookIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profileImageUrl,
    required this.createdAt,
    this.lastLoginAt,
    this.role = 'user',
    this.isActive = true,
    this.phoneNumber,
    this.address,
    this.favoriteBookIds = const [],
    this.borrowedBookIds = const [],
  });

  // Factory constructor untuk membuat User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt']) 
          : null,
      role: json['role'] ?? 'user',
      isActive: json['isActive'] ?? true,
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      favoriteBookIds: List<String>.from(json['favoriteBookIds'] ?? []),
      borrowedBookIds: List<String>.from(json['borrowedBookIds'] ?? []),
    );
  }

  // Method untuk mengkonversi User ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'role': role,
      'isActive': isActive,
      'phoneNumber': phoneNumber,
      'address': address,
      'favoriteBookIds': favoriteBookIds,
      'borrowedBookIds': borrowedBookIds,
    };
  }

  // Method untuk membuat copy dengan perubahan tertentu
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? role,
    bool? isActive,
    String? phoneNumber,
    String? address,
    List<String>? favoriteBookIds,
    List<String>? borrowedBookIds,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      favoriteBookIds: favoriteBookIds ?? this.favoriteBookIds,
      borrowedBookIds: borrowedBookIds ?? this.borrowedBookIds,
    );
  }

  // Method untuk memeriksa apakah user adalah admin
  bool get isAdmin => role == 'admin';

  // Method untuk mendapatkan nama tampilan
  String get displayName => name.isNotEmpty ? name : email.split('@').first;

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, role: $role}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

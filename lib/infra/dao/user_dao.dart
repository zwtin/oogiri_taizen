class UserDAO {
  UserDAO({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.introduction,
  });

  factory UserDAO.fromMap(Map<String, dynamic> map) {
    return UserDAO(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['image_url'] as String,
      introduction: map['introduction'] as String,
    );
  }

  String id;
  String name;
  String? imageUrl;
  String introduction;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'introduction': introduction,
    };
  }
}

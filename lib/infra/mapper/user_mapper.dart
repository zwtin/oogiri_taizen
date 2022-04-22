import 'package:oogiri_taizen/domain/entity/user.dart';

User mappingForUser({
  required Map<String, dynamic> userData,
}) {
  return User(
    id: userData['id'] as String,
    name: userData['name'] as String,
    imageUrl: userData['image_url'] as String,
    introduction: userData['introduction'] as String,
  );
}

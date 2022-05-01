import 'package:oogiri_taizen/app/view_data/block_user_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/users.dart';

List<BlockUserListCardViewData> mappingForBlockUserListCardViewData({
  required Users users,
}) {
  final list = <BlockUserListCardViewData>[];
  for (var i = 0; i < users.length; i++) {
    final user = users.getByIndex(i);
    if (user == null) {
      continue;
    }
    list.add(
      BlockUserListCardViewData(
        userImageUrl: user.imageUrl,
        userName: user.name,
      ),
    );
  }
  return list;
}

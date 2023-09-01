import '../../util/mapper.dart';
import 'package:stake_calculator/domain/model/notification.dart';

class JsonNotificationMapper extends Mapper<Map<String, String?>, Notification> {
  @override
  from(Map<String, String?> from) => Notification(
      type: from['type'],
      createdAt: DateTime.parse(from['createdAt']!),
      description: from['description'],
      body: from['body'],
      messageId: from['messageId'],
      title: from['title'],
      ack: from['ack'],
      category: from['category'],
      categoryId: from['categoryId']);

  @override
  Map<String, String?> to(from) {
    final map = <String, String?>{};
    map['type'] = from.type ?? "";
    map['createdAt'] = from.createdAt!.toIso8601String();
    map['description'] = from.description ?? "";
    map['body'] = from.body ?? "";
    map['title'] = from.title ?? "";
    map['messageId'] = from.messageId;
    map['categoryId'] = from.categoryId ?? "";
    map['ack'] = from.ack ?? "";
    map['category'] = from.category ?? "";
    return map;
  }
}

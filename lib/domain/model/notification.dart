import 'package:objectbox/objectbox.dart';

@Entity()
class Notification {
  @Id()
  int id = 0;
  String? type;
  String? description;
  String? body;
  String? title;
  String? category;
  String? ack;
  String? messageId;
  String? categoryId;
  bool read;

  @Property(type: PropertyType.date)
  DateTime? createdAt;

  Notification(
      {this.type,
      this.body,
      this.ack,
      this.messageId,
      this.createdAt,
      this.read = false,
      this.description,
      this.title,
      this.category,
      this.categoryId});
}

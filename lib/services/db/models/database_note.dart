import 'package:mynotes/constants/database.dart';

class DatabaseNote {
  final int id;
  final int userId;
  final String? title;
  final String text;
  final bool isSynced;

  DatabaseNote({
    required this.id,
    required this.userId,
    this.title = '',
    required this.text,
    this.isSynced = false,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        title = map[titleColumn] as String,
        text = map[textColumn] as String,
        isSynced = (map[isSyncedColumn] as int) == 1 /** ? true : false */;

  String titled() => title != null ? 'titled \'$title\', ' : '';

  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, ${titled}isSyncedWithCloud = $isSynced';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

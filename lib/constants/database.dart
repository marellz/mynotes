const dbName = 'notes.db';
const notesTable = 'notes';
const userTable = 'user';

const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        "PRIMARY KEY("id" AUTOINCREMENT)
      );''';

const createNotesTable = '''CREATE TABLE IF NOT EXISTS "notes" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "title"	TEXT,
        "text"	TEXT NOT NULL,
        "is_synced"	INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      )''';

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const titleColumn = 'title';
const textColumn = 'text';
const isSyncedColumn = 'is_synced';

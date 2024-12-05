// import 'package:flutter/foundation.dart';
import 'package:mynotes/constants/database.dart';
import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:mynotes/services/db/models/database_note.dart';
import 'package:mynotes/services/db/models/database_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mynotes/services/db/database_exceptions.dart';
import 'package:path/path.dart';

abstract class DatabaseService {

  ///
  ///
  /// DATABASE
  ///
  ///
  
  Database? _db;

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNotesTable);
    } on MissingPlatformDirectoryException catch (_) {
      throw UnableToGetDocumentsDirectoryException();
    } catch (_) {
      throw GenericDatabaseException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }


  /// 
  /// 
  /// USER
  /// 
  /// 

   Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUserException();
    }

    return DatabaseUser.fromRow(results.first);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);

    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }


  /// 
  /// 
  /// NOTES
  /// 
  /// 

    Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);

    // owner exists in the db, with correct id
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }

    const title = '';
    const text = '';

    final noteId = await db.insert(notesTable, {
      userIdColumn: owner.id,
      titleColumn: title,
      textColumn: text,
      isSyncedColumn: 0 // todo: know why 1 was used at creation.
    });

    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      title: title,
      text: text,
      isSynced: true,
    );

    return note;
  }

  Future<Iterable<DatabaseNote>> getAllNotes(
      {required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      notesTable,
    );

    return notes.map((row) => DatabaseNote.fromRow(row));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    }

    return DatabaseNote.fromRow(notes.first);
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    String title = '',
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);

    final updateCount = await db.update(notesTable, {
      titleColumn: title,
      textColumn: text,
      isSyncedColumn: 0,
    });

    if (updateCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      return await getNote(id: note.id);
    }
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return db.delete(notesTable);
  }
}

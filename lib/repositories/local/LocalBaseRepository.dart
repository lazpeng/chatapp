import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalBaseRepository {
  static const int _latestVersion = 1;

  static _v0(Database db) async {
    await db.rawQuery("CREATE TABLE IF NOT EXISTS DbUpgrade (Version INT PRIMARY KEY, DateInstalled DATE)");

    await db.rawQuery("CREATE TABLE IF NOT EXISTS KnownUsers (Id CHAR(36) PRIMARY KEY, Username VARCHAR(128) NOT NULL,"+
     " FullName VARCHAR(256) NOT NULL, Email VARCHAR(256), Bio TEXT, AccountCreated TIMESTAMPTZ NOT NULL," +
     " LastLogin TIMESTAMPTZ NOT NULL, LastSeen TIMESTAMPTZ NOT NULL, DateOfBirth DATE NOT NULL, FindInSearch BOOL NOT NULL," +
     " OpenChat BOOL NOT NULL, DataHash CHAR(36) NOT NULL)");

    await db.rawQuery("CREATE TABLE IF NOT EXISTS Messages (Id INT PRIMARY KEY, FromId CHAR(36) NOT NULL," +
     " ToId CHAR(36) NOT NULL, Content TEXT NOT NULL, InReplyTo INT, DateSent DATETIME NOT NULL," +
     " DateSeen DATETIME, Edited BOOL NOT NULL DEFAULT FALSE, Deleted BOOL NOT NULL DEFAULT FALSE) ");

    await db.rawQuery("CREATE TABLE IF NOT EXISTS Friends (UserId CHAR(36) NOT NULL PRIMARY KEY, DateSent"
     " DATETIME NOT NULL) ");

    await db.rawQuery("CREATE TABLE IF NOT EXISTS Blocked (BlockedId CHAR(36) PRIMARY KEY, DateBlocked DATETIME NOT NULL) ");

    await db.rawQuery("CREATE TABLE IF NOT EXISTS Chats (UserId CHAR(36) PRIMARY KEY, LastMessageId INT NOT NULL) ");

    await db.rawQuery("CREATE TABLE IF NOT EXISTS Logs (Id INTEGER PRIMARY KEY AUTOINCREMENT, LogDate DATE NOT NULL, Message TEXT NOT NULL, Error BOOL NOT NULL)");

    await db.rawQuery("CREATE TABLE IF NOT EXISTS EditHistory (Id INTEGER PRIMARY KEY, MessageId INT NOT NULL, EditDate DATE NOT NULL)");

    await db.rawQuery("CREATE TABLE IF NOT EXISTS DeleteHistory (Id INTEGER PRIMARY KEY, MessageId INT NOT NULL, DeleteDate DATE NOT NULL)");
  }

  static const List<Function> _upgradeFunctions = [
    _v0
  ];

  Future<Database> getDatabase() async {
    String path;
    Directory storageDir;

    if(Platform.isAndroid){
      storageDir = await getExternalStorageDirectory();
    } else {
      storageDir = await getLibraryDirectory();
    }

    path = storageDir.path.replaceAll("files", "databases");
    return await openDatabase("$path/data.db", onOpen: (db) async {
      while(true) {
        var current;

        try {
          var result = await db.rawQuery("SELECT IFNULL(MAX(Version), 0) as Version FROM DbUpgrade");
          current = result[0]['Version'];
        } catch (_) {
          current = 0;
        }

        if(current < _latestVersion) {
          await _upgradeFunctions[current](db);

          await db.rawInsert("INSERT INTO DbUpgrade (Version, DateInstalled) VALUES (?, CURRENT_DATE)", [current+1]);
        } else break;
      }
    });
  }
}
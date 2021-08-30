package io.nakano.chatapp.repositories

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import java.text.SimpleDateFormat
import java.util.*

abstract class BaseSqliteRepository (ctx: Context) : SQLiteOpenHelper(ctx, DB_NAME, null, LATEST_VERSION) {
    companion object {
        private const val DB_NAME = "data.db"
        private const val LATEST_VERSION = 1

        private const val V0_SCRIPT =
                " CREATE TABLE settings (name TEXT PRIMARY KEY, value TEXT NOT NULL); " +
                " CREATE TABLE chats (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, user_id TEXT NULL, seq INTEGER NULL); " +
                " CREATE TABLE messages (id INTEGER PRIMARY KEY AUTOINCREMENT, chat INTEGER NOT NULL, " +
                        " content TEXT NOT NULL, date_sent DATE NOT NULL, user_sent TEXT NOT NULL); " +
                " INSERT INTO chats (id, name, user_id, seq) VALUES (0, 'TEST', NULL, 0); "

        private val SCRIPTS = listOf(V0_SCRIPT)
    }

    protected fun getDateFormatter(): SimpleDateFormat {
        return SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
    }

    override fun onCreate(db: SQLiteDatabase?) {
        onUpgrade(db, 0, LATEST_VERSION)
    }

    override fun onUpgrade(db: SQLiteDatabase?, previous: Int, current: Int) {
        for (script in SCRIPTS.subList(previous, current)) {
            db?.beginTransaction()
            for (command in script.split(";")) {
                if (command.trim().isNotBlank()) {
                    db?.execSQL(command)
                }
            }
            db?.setTransactionSuccessful()
            db?.endTransaction()
        }
    }
}
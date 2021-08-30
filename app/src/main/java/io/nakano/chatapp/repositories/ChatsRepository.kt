package io.nakano.chatapp.repositories

import android.content.Context
import androidx.core.database.getStringOrNull
import io.nakano.chatapp.models.chat.Chat

class ChatsRepository (ctx: Context) : BaseSqliteRepository(ctx) {
    fun listChats(): List<Chat> {
        val db = readableDatabase

        val chats = arrayListOf<Chat>()
        val cursor = db.rawQuery("SELECT chats.id, name, last.content, last.date_sent, chats.seq FROM chats LEFT JOIN (SELECT * FROM messages WHERE chat = chat.id ORDER BY date_sent DESC LIMIT 1) last ON chats.id = last.chat ORDER BY seq ASC", arrayOf())
        while (cursor.moveToNext()) {
            val dateStr = cursor.getStringOrNull(3)
            val sent = if (dateStr != null) {
                getDateFormatter().parse(dateStr)
            } else {
                null
            }
            val seq = cursor.getInt(4)
            chats.add(Chat (cursor.getInt(0), cursor.getString(1), cursor.getStringOrNull(2) ?: "", sent, seq >= 0, seq))
        }

        cursor.close()
        return chats
    }
}
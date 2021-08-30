package io.nakano.chatapp.models.chat

import java.util.*

data class Chat (var id: Int, var name: String, var lastMessage: String, var timeSent: Date?, var pinned: Boolean, var sequence: Int)
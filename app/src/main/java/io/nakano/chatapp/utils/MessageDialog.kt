package io.nakano.chatapp.utils

import android.content.Context
import androidx.appcompat.app.AlertDialog

class MessageDialog (ctx: Context, title: String, message: String) {
    private val diag = AlertDialog.Builder(ctx)
        .setTitle(title)
        .setMessage(message)
        .setNeutralButton("Ok", null)
        .create()

    fun show() {
        diag.show()
    }
}
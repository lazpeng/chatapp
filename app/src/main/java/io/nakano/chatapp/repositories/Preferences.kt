package io.nakano.chatapp.repositories

import android.content.Context

class Preferences (private val ctx: Context) {
    companion object {
        private const val PREF_NAME = "CHATAPP_PREFS"
        private const val PREF_TOKEN = "TOKEN"
    }

    fun getSavedToken(): String {
        return ctx.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE).getString(PREF_TOKEN, null) ?: ""
    }
}
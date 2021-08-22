package io.nakano.chatapp.repositories

import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import io.nakano.chatapp.models.login.LoginResponse
import io.nakano.chatapp.models.login.ServerConfig

class Preferences (private val ctx: Context) {
    companion object {
        private const val PREF_NAME = "CHATAPP_PREFS"
        private const val PREF_TOKEN = "TOKEN"
        private const val PREF_UID = "UID"
        private const val PREF_CONFIG = "CONFIG"
    }

    private fun getPrefs(): SharedPreferences =
        ctx.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)

    fun getSavedToken(): String {
        return getPrefs().getString(PREF_TOKEN, null) ?: ""
    }

    fun getServerConfig(): ServerConfig {
        val json = getPrefs().getString(PREF_CONFIG, "") ?: ""

        return if (json.isBlank()) {
            ServerConfig.getDefault()
        } else {
            Gson().fromJson(json, ServerConfig::class.java)
        }
    }

    fun saveUserInfo(info: LoginResponse) {
        getPrefs().edit().apply {
            putString(PREF_UID, info.id)
            putString(PREF_TOKEN, info.token)
            apply()
        }
    }
}
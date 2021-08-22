package io.nakano.chatapp.services

import android.content.Context
import io.nakano.chatapp.repositories.Preferences
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody

sealed class Result {
    data class Success(val body: String) : Result()
    data class Error(val message: String, val errorCode: Int) : Result()
}

abstract class BaseService (ctx: Context) {
    companion object {
        private val JSON = "application/json; charset=utf-8".toMediaType()
    }

    private val config = Preferences(ctx).getServerConfig()
    private val token = Preferences(ctx).getSavedToken()
    private val client = OkHttpClient()

    protected fun get(endpoint: String, query: String = ""): Result {
        val suffix = if (query.isEmpty()) { "" } else { "?$query" }
        val req = Request.Builder()
            .addHeader("Authorization", token)
            .url("${config.url}/api/$endpoint$suffix")
            .get()
            .build()

        val response = client.newCall(req).execute()
        return if (response.isSuccessful) {
            Result.Success(response.body?.string() ?: "")
        } else {
            Result.Error(response.body?.string() ?: "", response.code)
        }
    }

    protected fun post(endpoint: String, query: String = "", body: String = ""): Result {
        val suffix = if (query.isEmpty()) { "" } else { "?$query" }
        val req = Request.Builder()
            .addHeader("Authorization", token)
            .url("${config.url}/api/$endpoint$suffix")
            .post(body.toRequestBody(JSON))
            .build()

        val response = client.newCall(req).execute()
        return if (response.isSuccessful) {
            Result.Success(response.body?.string() ?: "")
        } else {
            Result.Error(response.body?.string() ?: "", response.code)
        }
    }

    protected fun put(endpoint: String, query: String = "", body: String = ""): Result {
        val suffix = if (query.isEmpty()) { "" } else { "?$query" }
        val req = Request.Builder()
            .addHeader("Authorization", token)
            .url("${config.url}/api/$endpoint$suffix")
            .put(body.toRequestBody(JSON))
            .build()

        val response = client.newCall(req).execute()
        return if (response.isSuccessful) {
            Result.Success(response.body?.string() ?: "")
        } else {
            Result.Error(response.body?.string() ?: "", response.code)
        }
    }

    protected fun delete(endpoint: String, query: String = "", body: String = ""): Result {
        val suffix = if (query.isEmpty()) { "" } else { "?$query" }
        val req = Request.Builder()
            .addHeader("Authorization", token)
            .url("${config.url}/api/$endpoint$suffix")
            .delete(body.toRequestBody(JSON))
            .build()

        val response = client.newCall(req).execute()
        return if (response.isSuccessful) {
            Result.Success(response.body?.string() ?: "")
        } else {
            Result.Error(response.body?.string() ?: "", response.code)
        }
    }
}
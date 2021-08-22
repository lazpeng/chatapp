package io.nakano.chatapp.services

import android.content.Context
import com.google.gson.Gson
import io.nakano.chatapp.models.login.LoginRequest
import io.nakano.chatapp.models.login.LoginResponse
import io.nakano.chatapp.models.login.User

class LoginService(private val ctx: Context) : BaseService(ctx) {
    fun login(username: String, password: String): LoginResponse {
        val model = LoginRequest(username, password)

        val response = post("session/login", body = Gson().toJson(model))
        if (response is Result.Success) {
            return Gson().fromJson(response.body, LoginResponse::class.java)
        } else {
            throw Exception((response as Result.Error).message)
        }
    }

    fun register(user: User): User {
        val response = post("user", body = Gson().toJson(user))

        if (response is Result.Success) {
            return Gson().fromJson(response.body, User::class.java)
        } else {
            throw Exception((response as Result.Error).message)
        }
    }
}
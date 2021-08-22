package io.nakano.chatapp.models.login

data class LoginRequest (var username: String, var password: String, var appearOffline: Boolean = false)
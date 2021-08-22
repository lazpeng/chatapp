package io.nakano.chatapp.models.login

data class LoginResponse (var success: Boolean, var id: String, var token: String, var errorMessage: String)
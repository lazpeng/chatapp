package io.nakano.chatapp.models.login

data class ServerConfig (var url: String, var port: Int) {
    companion object {
        fun getDefault(): ServerConfig = ServerConfig("https://tempchatappserver.herokuapp.com", 80)
    }
}
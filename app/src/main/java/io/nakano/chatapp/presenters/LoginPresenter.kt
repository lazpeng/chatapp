package io.nakano.chatapp.presenters

import io.nakano.chatapp.models.login.User
import io.nakano.chatapp.repositories.Preferences
import io.nakano.chatapp.services.LoginService
import io.nakano.chatapp.views.ILoginView
import java.lang.Exception

class LoginPresenter(private val view: ILoginView) {
    fun onLoginClicked(username: String, password: String) {
        Thread {
            try {
                val result = LoginService(view.getContext()).login(username, password)
                Preferences(view.getContext()).saveUserInfo(result)

                view.getContext().runOnUiThread {
                    view.onSuccess()
                }
            } catch (e: Exception) {
                view.getContext().runOnUiThread {
                    view.onError(e.message ?: "")
                }
            }
        }.start()
    }

    fun onRegisterClicked(info: User) {
        Thread {
            try {
                val result = LoginService(view.getContext()).register(info)
                if (result.id.isNotBlank()) {
                    onLoginClicked(info.username, info.password)
                } else {
                    view.getContext().runOnUiThread {
                        view.onError("User creation failed")
                    }
                }
            } catch (e: Exception) {
                view.getContext().runOnUiThread {
                    view.onError(e.message ?: "")
                }
            }
        }.start()
    }
}
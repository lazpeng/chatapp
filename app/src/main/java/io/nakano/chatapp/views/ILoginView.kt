package io.nakano.chatapp.views

import android.app.Activity

interface ILoginView {
    fun onError(error: String)

    fun onProgress(message: String)

    fun onSuccess()

    fun getContext(): Activity
}
package io.nakano.chatapp.activities

import android.app.Activity
import android.app.ProgressDialog
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import androidx.constraintlayout.widget.ConstraintLayout
import io.nakano.chatapp.R
import io.nakano.chatapp.models.login.User
import io.nakano.chatapp.presenters.LoginPresenter
import io.nakano.chatapp.utils.MessageDialog
import io.nakano.chatapp.views.ILoginView

class LoginActivity : AppCompatActivity(), ILoginView {
    private val presenter = LoginPresenter(this)
    private var onLogin = true
    private lateinit var progressDialog: ProgressDialog

    private fun onModeChange() {
        if (onLogin) {
            findViewById<ConstraintLayout>(R.id.loginLayout).visibility = View.VISIBLE
            findViewById<ConstraintLayout>(R.id.registerLayout).visibility = View.GONE
        } else {
            findViewById<ConstraintLayout>(R.id.loginLayout).visibility = View.GONE
            findViewById<ConstraintLayout>(R.id.registerLayout).visibility = View.VISIBLE
        }
    }

    private fun getTextFromField(id: Int): String {
        return findViewById<EditText>(id).text.toString()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        progressDialog = ProgressDialog(this)
        progressDialog.isIndeterminate = true

        findViewById<Button>(R.id.buttonLoginLogin).setOnClickListener {
            val user = getTextFromField(R.id.textLoginUser)
            val pass = getTextFromField(R.id.textLoginPassword)

            progressDialog.show()
            presenter.onLoginClicked(user, pass)
        }

        findViewById<Button>(R.id.buttonLoginRegister).setOnClickListener {
            onLogin = false
            onModeChange()
        }

        findViewById<Button>(R.id.buttonRegisterRegister).setOnClickListener {
            val name = getTextFromField(R.id.textRegisterName)
            val user = getTextFromField(R.id.textRegisterUser)
            val email = getTextFromField(R.id.textRegisterEmail)
            val pass1 = getTextFromField(R.id.textRegisterPassword)
            val pass2 = getTextFromField(R.id.textRegisterConfirmPassword)

            if (pass1 != pass2) {
                MessageDialog(this, "Error", "Passwords do not match").show()
            }

            val info = User("", name, user, email, pass1)

            presenter.onRegisterClicked(info)
        }

        findViewById<Button>(R.id.buttonRegisterLogin).setOnClickListener {
            onLogin = true
            onModeChange()
        }

        onModeChange()
    }

    override fun onError(error: String) {
        if (progressDialog.isShowing) {
            progressDialog.dismiss()
        }
        MessageDialog(this, "Erro", error).show()
    }

    override fun onProgress(message: String) {
        TODO("Not yet implemented")
    }

    override fun onSuccess() {
        if (progressDialog.isShowing) {
            progressDialog.dismiss()
        }

        startActivity(Intent(this, HomeActivity::class.java))
    }

    override fun getContext(): Activity = this
}
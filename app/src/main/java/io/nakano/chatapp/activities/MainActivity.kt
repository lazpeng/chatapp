package io.nakano.chatapp.activities

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import io.nakano.chatapp.R
import io.nakano.chatapp.repositories.Preferences

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    override fun onResume() {
        super.onResume()
        
        val intent = Intent(this, if (Preferences(this).getSavedToken().isNotBlank()) {
            HomeActivity::class.java
        } else {
            LoginActivity::class.java
        })

        startActivity(intent)
    }
}
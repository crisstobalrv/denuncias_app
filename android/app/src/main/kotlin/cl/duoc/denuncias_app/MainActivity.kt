package cl.duoc.denuncias_app

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 👇 Esto bloquea screenshots y grabación de pantalla
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}

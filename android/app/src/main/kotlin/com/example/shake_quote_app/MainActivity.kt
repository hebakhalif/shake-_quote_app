package com.example.shake_quote_app

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import kotlin.math.sqrt

class MainActivity: FlutterActivity() {
    private val SHAKE_CHANNEL = "shake_detection"
    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null
    private var shakeDetector: ShakeDetector? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // إنشاء EventChannel للتواصل مع Flutter
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SHAKE_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    startShakeDetection()
                }

                override fun onCancel(arguments: Any?) {
                    stopShakeDetection()
                    eventSink = null
                }
            }
        )
    }

    private fun startShakeDetection() {
        // الحصول على SensorManager
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        
        // إنشاء ShakeDetector
        shakeDetector = ShakeDetector {
            // لما يتم اكتشاف shake، نبعت event لـ Flutter
            eventSink?.success("shake_detected")
        }
        
        // تسجيل الـ listener
        accelerometer?.also { acc ->
            sensorManager?.registerListener(
                shakeDetector,
                acc,
                SensorManager.SENSOR_DELAY_UI
            )
        }
    }

    private fun stopShakeDetection() {
        sensorManager?.unregisterListener(shakeDetector)
        shakeDetector = null
    }

    override fun onPause() {
        super.onPause()
        stopShakeDetection()
    }

    override fun onResume() {
        super.onResume()
        if (eventSink != null) {
            startShakeDetection()
        }
    }
}

// كلاس ShakeDetector - بيكتشف الهزة
class ShakeDetector(private val onShake: () -> Unit) : SensorEventListener {
    private var lastShakeTime: Long = 0
    private val SHAKE_THRESHOLD = 15f // قوة الهزة المطلوبة
    private val SHAKE_TIME_GAP = 500 // الوقت بين كل هزة (milliseconds)

    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type == Sensor.TYPE_ACCELEROMETER) {
            val x = event.values[0]
            val y = event.values[1]
            val z = event.values[2]

            // حساب قوة الحركة
            val acceleration = sqrt((x * x + y * y + z * z).toDouble()) - SensorManager.GRAVITY_EARTH
            
            // لو الحركة أقوى من الـ threshold
            if (acceleration > SHAKE_THRESHOLD) {
                val currentTime = System.currentTimeMillis()
                
                // التأكد إن في فترة زمنية كافية بين كل shake
                if (currentTime - lastShakeTime > SHAKE_TIME_GAP) {
                    lastShakeTime = currentTime
                    onShake()
                }
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // مش محتاجين نعمل حاجة هنا
    }
}
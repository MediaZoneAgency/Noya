package com.noyamz.noya

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.AudioTrack
import android.media.MediaRecorder
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import okhttp3.WebSocket
import okhttp3.WebSocketListener
import okio.ByteString
import okio.ByteString.Companion.toByteString
import java.io.ByteArrayOutputStream
import java.util.*
import java.util.concurrent.TimeUnit
import kotlin.concurrent.thread

class AudioCallService : Service() {

    private val TAG = "AudioCallService"
    private val wsUrl =
        "wss://real-estate-chatbot-4lmcjvi3xq-uc.a.run.app/ws/voice-chat?user_id=46" // Replace with your WebSocket URL
    private var webSocket: WebSocket? = null

    private var audioRecord: AudioRecord? = null
    private var audioTrack: AudioTrack? = null

    @Volatile
    private var isRecording = false
    private var isSessionConfirmed = false
    private var pauseSending = false

    private val sampleRate = 16000
    private val channelConfig = AudioFormat.CHANNEL_IN_MONO
    private val audioFormat = AudioFormat.ENCODING_PCM_16BIT

    private val audioBuffer = ByteArrayOutputStream()

    private val client = OkHttpClient.Builder()
        .readTimeout(0, TimeUnit.MILLISECONDS) // No timeout for WebSocket
        .build()

    private var periodicFlushTimer: Timer? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForegroundServiceWithNotification()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "audio_call_channel"
            val channel = NotificationChannel(
                channelId,
                "Audio Call",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun startForegroundServiceWithNotification() {
        val channelId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            "audio_call_channel"
        } else {
            ""
        }

        val notification: Notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Audio Call in Progress")
            .setContentText("You are in a call")
            .setSmallIcon(R.drawable.launch_background) // Replace with your icon
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()

        startForeground(1, notification)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startStreamingAudio()
        return START_STICKY
    }

    private fun startStreamingAudio() {
        thread(start = true) {
            try {
                // 1. Setup WebSocket connection
                val request = Request.Builder().url(wsUrl).build()
                webSocket = client.newWebSocket(request, object : WebSocketListener() {

                    override fun onOpen(webSocket: WebSocket, response: Response) {
                        Log.d(TAG, "🌐 WebSocket opened")
                    }

                    override fun onMessage(webSocket: WebSocket, bytes: ByteString) {
                        Log.d(TAG, "📩 Received binary message: ${bytes.size} bytes")
                        pauseSending = true
                        playAudio(bytes.toByteArray())
                        pauseSending = false
                    }

                    override fun onMessage(webSocket: WebSocket, text: String) {
                        Log.d(TAG, "📩 Received text: $text")
                        if (text.length == 36) { // example session confirmation id length
                            isSessionConfirmed = true
                            Log.d(TAG, "✅ Session confirmed with ID: $text")
                        }
                    }

                    override fun onFailure(
                        webSocket: WebSocket,
                        t: Throwable,
                        response: Response?
                    ) {
                        Log.e(TAG, "WebSocket failure: ${t.message}", t)
                        stopSelf()
                    }

                    override fun onClosing(webSocket: WebSocket, code: Int, reason: String) {
                        Log.d(TAG, "WebSocket closing: $code / $reason")
                        webSocket.close(1000, null)
                        stopSelf()
                    }
                })

                // 2. Setup AudioRecord for mic capture
                val minBufferSize =
                    AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat)
                audioRecord = AudioRecord(
                    MediaRecorder.AudioSource.MIC,
                    sampleRate,
                    channelConfig,
                    audioFormat,
                    minBufferSize
                )

                val buffer = ByteArray(minBufferSize)
                audioRecord?.startRecording()
                isRecording = true

                // 3. Timer to flush buffer every 2 seconds
                periodicFlushTimer = Timer()
                periodicFlushTimer?.schedule(object : TimerTask() {
                    override fun run() {
                        if (!pauseSending && isSessionConfirmed && audioBuffer.size() >= 4000) {
                            val bytesToSend = audioBuffer.toByteArray()
                            Log.d(TAG, "📤 Sending ${bytesToSend.size} bytes")
                            webSocket?.send(bytesToSend.toByteString(0, bytesToSend.size))
                            audioBuffer.reset()
                        }
                    }
                }, 2000, 2000)

                // 4. Read audio from mic, buffer and send periodically
                while (isRecording) {
                    val readBytes = audioRecord?.read(buffer, 0, buffer.size) ?: 0
                    if (readBytes > 0 && !pauseSending) {
                        audioBuffer.write(buffer, 0, readBytes)
                    }
                }

                // Cleanup after recording stops
                audioRecord?.stop()
                audioRecord?.release()
                audioRecord = null

                periodicFlushTimer?.cancel()
                webSocket?.close(1000, "Service stopped")

            } catch (e: Exception) {
                Log.e(TAG, "Error in startStreamingAudio: ${e.message}", e)
                stopSelf()
            }
        }
    }

    private fun playAudio(data: ByteArray) {
        try {
            // Setup AudioTrack if not already
            if (audioTrack == null) {
                val minBufferSize = AudioTrack.getMinBufferSize(
                    sampleRate,
                    AudioFormat.CHANNEL_OUT_MONO,
                    audioFormat
                )

                audioTrack = AudioTrack.Builder()
                    .setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_VOICE_COMMUNICATION)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                            .build()
                    )
                    .setAudioFormat(
                        AudioFormat.Builder()
                            .setEncoding(audioFormat)
                            .setSampleRate(sampleRate)
                            .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                            .build()
                    )
                    .setBufferSizeInBytes(minBufferSize)
                    .build()
                audioTrack?.play()
            }

            audioTrack?.write(data, 0, data.size)

        } catch (e: Exception) {
            Log.e(TAG, "Error playing audio: ${e.message}", e)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        isRecording = false
        periodicFlushTimer?.cancel()
        audioTrack?.stop()
        audioTrack?.release()
        audioTrack = null
        webSocket?.close(1000, "Service destroyed")
    }

    override fun onBind(intent: Intent?): IBinder? = null
}

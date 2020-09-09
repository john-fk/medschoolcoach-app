package com.htd.medschoolcoach

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry

class App : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
    }

    override fun registerWith(registry: PluginRegistry?) {
    }
}
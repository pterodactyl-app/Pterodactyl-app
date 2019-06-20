package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.infitio.adharasocketio.AdharaSocketIoPlugin;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import io.flutter.plugins.firebase.firebaseremoteconfig.FirebaseRemoteConfigPlugin;
import com.appleeducate.getversion.GetVersionPlugin;
import io.flutter.plugins.packageinfo.PackageInfoPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.tekartik.sqflite.SqflitePlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AdharaSocketIoPlugin.registerWith(registry.registrarFor("com.infitio.adharasocketio.AdharaSocketIoPlugin"));
    FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    FirebaseRemoteConfigPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.firebaseremoteconfig.FirebaseRemoteConfigPlugin"));
    GetVersionPlugin.registerWith(registry.registrarFor("com.appleeducate.getversion.GetVersionPlugin"));
    PackageInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.packageinfo.PackageInfoPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}

//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <adhara_socket_io/AdharaSocketIoPlugin.h>
#import <firebase_messaging/FirebaseMessagingPlugin.h>
#import <firebase_remote_config/FirebaseRemoteConfigPlugin.h>
#import <get_version/GetVersionPlugin.h>
#import <package_info/PackageInfoPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <sqflite/SqflitePlugin.h>
#import <url_launcher/UrlLauncherPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AdharaSocketIoPlugin registerWithRegistrar:[registry registrarForPlugin:@"AdharaSocketIoPlugin"]];
  [FLTFirebaseMessagingPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseMessagingPlugin"]];
  [FirebaseRemoteConfigPlugin registerWithRegistrar:[registry registrarForPlugin:@"FirebaseRemoteConfigPlugin"]];
  [GetVersionPlugin registerWithRegistrar:[registry registrarForPlugin:@"GetVersionPlugin"]];
  [FLTPackageInfoPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPackageInfoPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [FLTUrlLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTUrlLauncherPlugin"]];
}

@end

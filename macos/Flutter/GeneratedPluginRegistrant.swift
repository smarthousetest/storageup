//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import connectivity_macos
import cpp_native
import desktop_window
<<<<<<< dev
import objectbox_flutter_libs
=======
import native_context_menu
>>>>>>> context menu
import path_provider_macos
import shared_preferences_macos
import window_size

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  ConnectivityPlugin.register(with: registry.registrar(forPlugin: "ConnectivityPlugin"))
  CppNativePlugin.register(with: registry.registrar(forPlugin: "CppNativePlugin"))
  DesktopWindowPlugin.register(with: registry.registrar(forPlugin: "DesktopWindowPlugin"))
<<<<<<< dev
  ObjectboxFlutterLibsPlugin.register(with: registry.registrar(forPlugin: "ObjectboxFlutterLibsPlugin"))
=======
  NativeContextMenuPlugin.register(with: registry.registrar(forPlugin: "NativeContextMenuPlugin"))
>>>>>>> context menu
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  WindowSizePlugin.register(with: registry.registrar(forPlugin: "WindowSizePlugin"))
}

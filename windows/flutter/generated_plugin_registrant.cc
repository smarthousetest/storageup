//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <cpp_native/cpp_native_plugin.h>
#include <desktop_window/desktop_window_plugin.h>
<<<<<<< dev
#include <objectbox_flutter_libs/objectbox_flutter_libs_plugin.h>
=======
#include <native_context_menu/native_context_menu_plugin.h>
>>>>>>> context menu
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <window_size/window_size_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  CppNativePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CppNativePlugin"));
  DesktopWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWindowPlugin"));
<<<<<<< dev
  ObjectboxFlutterLibsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ObjectboxFlutterLibsPlugin"));
=======
  NativeContextMenuPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("NativeContextMenuPlugin"));
>>>>>>> context menu
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  WindowSizePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowSizePlugin"));
}

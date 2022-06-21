//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <cpp_native/cpp_native_plugin.h>
#include <desktop_window/desktop_window_plugin.h>
<<<<<<< dev
#include <objectbox_flutter_libs/objectbox_flutter_libs_plugin.h>
#include <window_size/window_size_plugin.h>
=======
#include <native_context_menu/native_context_menu_plugin.h>
>>>>>>> context menu

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) cpp_native_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CppNativePlugin");
  cpp_native_plugin_register_with_registrar(cpp_native_registrar);
  g_autoptr(FlPluginRegistrar) desktop_window_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DesktopWindowPlugin");
  desktop_window_plugin_register_with_registrar(desktop_window_registrar);
<<<<<<< dev
  g_autoptr(FlPluginRegistrar) objectbox_flutter_libs_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ObjectboxFlutterLibsPlugin");
  objectbox_flutter_libs_plugin_register_with_registrar(objectbox_flutter_libs_registrar);
  g_autoptr(FlPluginRegistrar) window_size_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WindowSizePlugin");
  window_size_plugin_register_with_registrar(window_size_registrar);
=======
  g_autoptr(FlPluginRegistrar) native_context_menu_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "NativeContextMenuPlugin");
  native_context_menu_plugin_register_with_registrar(native_context_menu_registrar);
>>>>>>> context menu
}

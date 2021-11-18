//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <cpp_native/cpp_native_plugin.h>
#include <desktop_window/desktop_window_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  CppNativePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CppNativePlugin"));
  DesktopWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopWindowPlugin"));
}

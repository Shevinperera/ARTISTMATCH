//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

<<<<<<< HEAD
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <speech_to_text_windows/speech_to_text_windows.h>
=======
#include <file_selector_linux/file_selector_plugin.h>
>>>>>>> 2c33f19ca12066cdb523f7ea680cc40682fea54e

<<<<<<< Updated upstream:frontend/linux/flutter/generated_plugin_registrant.cc
void fl_register_plugins(FlPluginRegistry* registry) {
<<<<<<< HEAD
=======
void RegisterPlugins(flutter::PluginRegistry* registry) {
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  SpeechToTextWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SpeechToTextWindows"));
>>>>>>> Stashed changes:windows/flutter/generated_plugin_registrant.cc
=======
  g_autoptr(FlPluginRegistrar) file_selector_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FileSelectorPlugin");
  file_selector_plugin_register_with_registrar(file_selector_linux_registrar);
>>>>>>> 2c33f19ca12066cdb523f7ea680cc40682fea54e
}

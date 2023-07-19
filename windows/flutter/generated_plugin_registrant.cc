//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <address_search_field/address_search_field_plugin.h>
#include <firebase_core/firebase_core_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AddressSearchFieldPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AddressSearchFieldPlugin"));
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
}

#include "./linc_wren.h"

#include <hxcpp.h>

#include <string>
#include <sstream>
#include <fstream>
#include <sys/stat.h>
#include <cassert>

namespace linc {

	namespace wren {
		WrenVM* newVM(WrenConfiguration &config) {
			return wrenNewVM(&config);
		}
		
		::String getSlotString(WrenVM* vm, int slot){
			return ::String(wrenGetSlotString(vm, slot));
		}
	} //wren
	namespace hxwren {
		void writeFn(WrenVM* vm, const char* text) {
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto obj = *root;
			auto fn = obj->__Field(HX_CSTRING("writeFn"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				fn(::String(text));
			}
		}

		void errorFn(WrenVM* vm, WrenErrorType type, const char* module, int line, const char* message) {
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto obj = *root;
			auto fn = obj->__Field(HX_CSTRING("errorFn"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				fn(type, ::String(module), line, ::String(message));
			}
		}
		
		void _onLoadModuleComplete(WrenVM* vm, const char* name, struct ::WrenLoadModuleResult result) {
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto obj = *root;
			auto fn = obj->__Field(HX_CSTRING("onLoadModuleComplete"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				fn(::String(name));
			}
			
			// TODO: release the haxe string stored in userData
		}

		WrenLoadModuleResult loadModuleFn(WrenVM* vm, const char* module) {
			WrenLoadModuleResult result;
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto obj = *root;
			auto fn = obj->__Field(HX_CSTRING("loadModuleFn"), HX_PROP_DYNAMIC);
			auto src = (::String)fn(::String(module));
			result.source = src.utf8_str();
			result.onComplete = _onLoadModuleComplete;
			result.userData = malloc(sizeof(::hx::Object*));
			return result;
		};

		
		WrenVM* makeVM(::Dynamic obj) {
			WrenConfiguration config;
			wrenInitConfiguration(&config);
			config.writeFn = writeFn;
			config.errorFn = errorFn;
			config.loadModuleFn = loadModuleFn;
			config.userData = malloc(sizeof(::hx::Object*));
			auto root = static_cast<::hx::Object**>(config.userData);
			*root = obj.mPtr;
			::hx::GCAddRoot(root);
			return wrenNewVM(&config);
		}

		void onLoadModuleComplete(WrenVM* vm, const char* name, struct ::WrenLoadModuleResult result) {
			auto root = static_cast<::hx::Object**>(result.userData);
			auto obj = *root;
			::Dynamic onComplete = obj->__Field(HX_CSTRING("onComplete"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull( onComplete )) {
				onComplete(::String(name));
			}
			::hx::GCRemoveRoot(root);
			free(result.userData);
		}
		
		WrenLoadModuleResult makeLoadModuleResult(::Dynamic obj) {
			WrenLoadModuleResult result;
			result.onComplete = onLoadModuleComplete;
			result.source = ((::String)(obj->__Field(HX_CSTRING("source"), HX_PROP_DYNAMIC))).utf8_str();
			result.userData = malloc(sizeof(::hx::Object*));
			auto root = static_cast<::hx::Object**>(result.userData);
			*root = obj.mPtr;
			::hx::GCAddRoot(root);
			return result;
		}
		
		void setSlotNewForeignDynamic(WrenVM* vm, int slot, int classSlot, ::Dynamic obj) {
			auto ptr = wrenSetSlotNewForeign(vm, slot, classSlot, sizeof(::hx::Object*));
			auto root = static_cast<::hx::Object**>(ptr);
			*root = obj.mPtr;
			::hx::GCAddRoot(root);
		}
		
		void unroot(void* ptr) {
			::hx::GCRemoveRoot(static_cast<::hx::Object**>(ptr));
		}
	} //hxwren


} //linc
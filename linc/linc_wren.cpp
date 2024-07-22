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
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("writeFn"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				fn(vm, ::String(text));
			}
		}

		void errorFn(WrenVM* vm, WrenErrorType type, const char* module, int line, const char* message) {
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("errorFn"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				fn(vm, type, ::String(module), line, ::String(message));
			}
		}
		
		void _onLoadModuleComplete(WrenVM* vm, const char* name, struct ::WrenLoadModuleResult result) {
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("onLoadModuleComplete"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				fn(vm, ::String(name));
			}
			
			// release the buffer
			delete static_cast<::hx::strbuf*>(result.userData);
		}

		WrenLoadModuleResult loadModuleFn(WrenVM* vm, const char* module) {
			WrenLoadModuleResult result;
			
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("loadModuleFn"), HX_PROP_DYNAMIC);
			auto src = (::String)fn(vm, ::String(module));
			
			// render the haxe string into a buffer
			hx::strbuf* buffer = new hx::strbuf();
			result.source = src.utf8_str(buffer);
			
			// set complete callback
			result.onComplete = _onLoadModuleComplete;
			
			// store the buffer pointer for later release
			result.userData = (void*)buffer;
			
			return result;
		};
		
		WrenForeignMethodFn bindForeignMethodFn(WrenVM* vm, const char* module, const char* className, bool isStatic, const char* signature) {
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("bindForeignMethodFn"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				::Dynamic f = fn(vm, ::String(module), ::String(className), isStatic, ::String(signature));
				return static_cast<::cpp::Function<void (WrenVM*)>>(f);
			}
			
			return NULL;
		}
		
		WrenForeignClassMethods bindForeignClassFn(WrenVM* vm, const char* module, const char* className) {
			WrenForeignClassMethods ret;
			
			ret.allocate = NULL;
			ret.finalize = NULL;
			
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("bindForeignClassFn"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				::Dynamic dyn = fn(vm, ::String(module), ::String(className));
				::cpp::Struct<WrenForeignClassMethods> m = dyn;
				
				ret.allocate = m.value.allocate;
				ret.finalize = m.value.finalize;
			}
			
			return ret;
		}


		/**
		 * Create a VM from a Haxe object as configuration
		 * The config object is stored in the VM's user data
		 * Call destroyVM to release the object
		 *  */
		WrenVM* makeVM(::Dynamic obj) {
			WrenConfiguration config;
			wrenInitConfiguration(&config);
			config.writeFn = writeFn;
			config.errorFn = errorFn;
			config.loadModuleFn = loadModuleFn;
			config.bindForeignMethodFn = bindForeignMethodFn;
			config.bindForeignClassFn = bindForeignClassFn;
			config.userData = malloc(sizeof(::hx::Object*));
			auto root = static_cast<::hx::Object**>(config.userData);
			*root = obj.mPtr;
			::hx::GCAddRoot(root);
			return wrenNewVM(&config);
		}
		
		void destroyVM(WrenVM* vm) {
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			::hx::GCRemoveRoot(root);
			free(root);
			
			wrenFreeVM(vm);
		}

		void onLoadModuleComplete(WrenVM* vm, const char* name, struct ::WrenLoadModuleResult result) {
			auto root = static_cast<::hx::Object**>(result.userData);
			auto obj = *root;
			
			::Dynamic onComplete = obj->__Field(HX_CSTRING("onComplete"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull( onComplete )) {
				onComplete(::String(name));
			}
			::hx::GCRemoveRoot(root);
			free(root);
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
		
		::cpp::Struct<WrenForeignClassMethods> wrapForeignClassMethods(const WrenForeignClassMethods &v) { 
			return v;
		}
	} //hxwren


} //linc
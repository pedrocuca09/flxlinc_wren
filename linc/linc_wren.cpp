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
		
		void onLoadModuleResultComplete(WrenVM* vm, const char* name, struct ::WrenLoadModuleResult result) {
			// free the memory (managed by us)
			delete static_cast<::hx::strbuf*>(result.userData);
		}
		
		WrenLoadModuleResult makeLoadModuleResult(::String source) {
			WrenLoadModuleResult result;
			result.onComplete = onLoadModuleResultComplete;
			
			// allocate memory (managed by us)
			auto buffer = new ::hx::strbuf();
			result.userData = buffer;
			result.source =  source.utf8_str(buffer);
			
			return result;
		}
		
	} //wren
	
	namespace hxwren {
		void writeFn(WrenVM* vm, const char* text) {
			// retrieve the haxe config object stored in the VM's userData
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("writeFn"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				fn((::cpp::Pointer<WrenVM>) vm, ::String(text));
			} else {
				printf("%s", text);
			}
		}

		void errorFn(WrenVM* vm, WrenErrorType type, const char* module, int line, const char* message) {
			// retrieve the haxe config object stored in the VM's userData
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("errorFn"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				fn((::cpp::Pointer<WrenVM>) vm, type, ::String(module), line, ::String(message));
			} else {
				printf("[%s:%d] %s\n", module, line, message);
			}
		}
		
		const char* resolveModuleFn(WrenVM* vm, const char* importer, const char* name) {
			// retrieve the haxe config object stored in the VM's userData
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("resolveModuleFn"), HX_PROP_DYNAMIC);
			if(::hx::IsNotNull(fn)) {
				auto dyn = fn((::cpp::Pointer<WrenVM>) vm, ::String(importer), ::String(name));
			
				if(::hx::IsNotNull(dyn)) {
					auto resolved = (::String) dyn;
					// Wren will want to free the returned string, so we give it a copy
					// ref: https://github.com/wren-lang/wren/blob/c2a75f1eaf9b1ba1245d7533a723360863fb012d/src/vm/wren_vm.c#L727
					return strdup(resolved);
				}
			}
			
			return NULL;
		};
		
		void onLoadModuleComplete(WrenVM* vm, const char* name, struct ::WrenLoadModuleResult result) {
			delete static_cast<::hx::strbuf*>(result.userData);
		}

		WrenLoadModuleResult loadModuleFn(WrenVM* vm, const char* module) {
			WrenLoadModuleResult result;
			
			// retrieve the haxe config object stored in the VM's userData
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("loadModuleFn"), HX_PROP_DYNAMIC);
			auto dyn = fn((::cpp::Pointer<WrenVM>) vm, ::String(module));
			
			if(::hx::IsNotNull(dyn)) {
				auto src = (::String) dyn;
				
				// render the haxe string into a buffer
				hx::strbuf* buffer = new hx::strbuf();
				result.source = src.utf8_str(buffer);
				
				// set complete callback
				result.onComplete = onLoadModuleComplete;
				
				// store the buffer pointer for later release
				result.userData = (void*)buffer;
			} else {
				result.source = nullptr;
			}
			
			return result;
		};
		
		WrenForeignMethodFn bindForeignMethodFn(WrenVM* vm, const char* module, const char* className, bool isStatic, const char* signature) {
			// retrieve the haxe config object stored in the VM's userData
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("bindForeignMethodFn"), HX_PROP_DYNAMIC);
			if (::hx::IsNotNull(fn)) {
				::Dynamic f = fn((::cpp::Pointer<WrenVM>) vm, ::String(module), ::String(className), isStatic, ::String(signature));
				if(::hx::IsNotNull(f)) {
					return static_cast<::cpp::Function<void (WrenVM*)>>(f);
				}
			}
			
			return nullptr;
		}
		
		WrenForeignClassMethods bindForeignClassFn(WrenVM* vm, const char* module, const char* className) {
			WrenForeignClassMethods ret;
			ret.allocate = nullptr;
			ret.finalize = nullptr;
			
			// retrieve the haxe config object stored in the VM's userData
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			auto config = *root;
			
			// obtain and run the callback
			auto fn = config->__Field(HX_CSTRING("bindForeignClassFn"), HX_PROP_DYNAMIC);
			
			if (::hx::IsNotNull(fn)) {
				::Dynamic dyn = fn((::cpp::Pointer<WrenVM>) vm, ::String(module), ::String(className));
				if (::hx::IsNotNull(dyn)) {
					::cpp::Struct<WrenForeignClassMethods> m = dyn;
					
					ret.allocate = m.value.allocate;
					ret.finalize = m.value.finalize;
				}
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
			config.resolveModuleFn = resolveModuleFn;
			config.loadModuleFn = loadModuleFn;
			config.bindForeignMethodFn = bindForeignMethodFn;
			config.bindForeignClassFn = bindForeignClassFn;
			
			auto initialHeapSize = obj->__FieldRef(HX_CSTRING("initialHeapSize"));
			if (initialHeapSize != null()) {
				config.initialHeapSize = (int)initialHeapSize;
			}
			
			auto minHeapSize = obj->__FieldRef(HX_CSTRING("initialHeapSize"));
			if (minHeapSize != null()) {
				config.minHeapSize = (int)minHeapSize;
			}
			
			auto heapGrowthPercent = obj->__FieldRef(HX_CSTRING("initialHeapSize"));
			if (initialHeapSize = null()) {
				config.heapGrowthPercent = (int)heapGrowthPercent;
			}
			
			// store the haxe object in the VM's user data
			// so the callbacks can access it
			config.userData = malloc(sizeof(::hx::Object*));
			auto root = static_cast<::hx::Object**>(config.userData);
			*root = obj.mPtr;
			
			// and retain it in the GC
			::hx::GCAddRoot(root);
			
			return wrenNewVM(&config);
		}
		
		/**
		 * Free the retained haxe object and release the VM
		 */
		void destroyVM(WrenVM* vm) {
			auto root = static_cast<::hx::Object**>(wrenGetUserData(vm));
			::hx::GCRemoveRoot(root);
			
			free(root);
			
			wrenFreeVM(vm);
		}

		
		void setSlotNewForeignDynamic(WrenVM* vm, int slot, int classSlot, ::Dynamic obj) {
			// allocate memory (managed by wren)
			auto ptr = wrenSetSlotNewForeign(vm, slot, classSlot, sizeof(::hx::Object*));
			
			// store the haxe object in the memory
			auto root = static_cast<::hx::Object**>(ptr);
			*root = obj.mPtr;
			
			// and retain it in the GC
			::hx::GCAddRoot(root);
		}
		
		void unroot(void* ptr) {
			::hx::GCRemoveRoot(static_cast<::hx::Object**>(ptr));
		}
		
		::cpp::Struct<WrenForeignClassMethods> wrapForeignClassMethods(const WrenForeignClassMethods &v) { return v; }
		::cpp::Struct<WrenConfiguration> wrapConfiguration(const WrenConfiguration &v) { return v; }
	} //hxwren


} //linc
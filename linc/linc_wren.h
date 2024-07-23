#ifndef _LINC_WREN_H_
#define _LINC_WREN_H_
	
// #include "../lib/____"

#include <hxcpp.h>

extern "C" {
#include <../lib/wren/src/include/wren.h>
}

namespace linc {

	namespace wren {

		extern WrenVM* newVM(WrenConfiguration &config);
		extern ::String getSlotString(WrenVM* vm, int slot);
		
		
		inline WrenConfiguration initConfiguration() {
			WrenConfiguration config;
			wrenInitConfiguration(&config);
			return config;
		}
		
		inline WrenForeignClassMethods initForeignClassMethods() {
			WrenForeignClassMethods methods;
			methods.allocate = nullptr;
			methods.finalize = nullptr;
			return methods;
		}
		
		inline WrenLoadModuleResult initLoadModuleResult() {
			WrenLoadModuleResult result;
			result.onComplete = nullptr;
			return result;
		}
		
		extern WrenLoadModuleResult makeLoadModuleResult(::String source);
		

	} //wren
	
	namespace hxwren {
		extern WrenVM* makeVM(::Dynamic obj);
		extern void destroyVM(WrenVM* vm);
			
		extern void setSlotNewForeignDynamic(WrenVM* vm, int slot, int classSlot, ::Dynamic obj);
		extern void unroot(void* ptr);
		
		extern ::cpp::Struct<WrenForeignClassMethods> wrapForeignClassMethods(const WrenForeignClassMethods &v);
		extern ::cpp::Struct<WrenConfiguration> wrapConfiguration(const WrenConfiguration &v);
		
	} // hxwren

} //linc

#endif //_LINC_WREN_H_

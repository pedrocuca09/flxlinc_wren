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
		extern void setSlotNewForeignDynamic(WrenVM* vm, int slot, int classSlot, ::Dynamic obj);
		extern void unroot(void* ptr);
		
		
		inline WrenConfiguration initConfiguration() {
			WrenConfiguration config;
			wrenInitConfiguration(&config);
			return config;
		}
		
		inline WrenForeignClassMethods initForeignClassMethods() {
			WrenForeignClassMethods methods;
			methods.allocate = NULL;
			methods.finalize = NULL;
			return methods;
		}
		
		inline WrenLoadModuleResult initLoadModuleResult() {
			WrenLoadModuleResult result;
			result.onComplete = NULL;
			return result;
		}

	} //wren

} //linc

#endif //_LINC_WREN_H_

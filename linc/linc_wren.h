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
		
		inline cpp::Struct<WrenConfiguration> wrapConfiguration(WrenConfiguration &config) {
			return config;
		}

    } //wren

} //linc

#endif //_LINC_WREN_H_

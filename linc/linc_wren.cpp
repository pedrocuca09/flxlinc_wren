#include "./linc_wren.h"

#include <hxcpp.h>

#include <string>
#include <sstream>
#include <fstream>
#include <sys/stat.h>
#include <cassert>

namespace linc {

	namespace wren {

		inline bool fileExists( const std::string& file ) {
			
			struct stat buffer;
			return ( stat( file.c_str(), &buffer) == 0 );

		}

		inline std::string fileToString( const std::string& file ) {

			std::ifstream fin;

			if ( !fileExists( file ) ) {
				throw std::runtime_error( "file not found!" );
			}

			fin.open( file, std::ios::in );

			std::stringstream buffer;
			buffer << fin.rdbuf() << '\0';

			return buffer.str();

		}

		void writeFn(WrenVM* vm, const char* text) {

			printf("%s", text);
			fflush(stdout);

		}

		char* loadModuleFn(WrenVM* vm, const char* mod) {

			std::string path(mod);
			path += ".wren";
			std::string source;

			try {
				source = fileToString(path);
			}

			catch (const std::exception&) {
				return NULL;
			}

			char* buffer = (char*)malloc(source.size());

			assert(buffer != nullptr);
			memcpy(buffer, source.c_str(), source.size());

			return buffer;

		};

		WrenVM* newVM(WrenConfiguration &config) {

			// wrenInitConfiguration(config);

			// config.writeFn = writeFn;
			// config.loadModuleFn = loadModuleFn;

			// if(_config != null()) {
			// 	// if (_config->__FieldRef(HX_CSTRING("writeFn")) != null()){
			// 	// 	config.writeFn = (WrenWriteFn) ::cpp::Function<WrenWriteFn>(::hx::AnyCast(&_config->__FieldRef(HX_CSTRING("writeFn")) ));
			// 	// }
			// 	if (_config->__FieldRef(HX_CSTRING("initialHeapSize")) != null()){
			// 		config.initialHeapSize = (int)_config->__FieldRef(HX_CSTRING("initialHeapSize"));
			// 	}
			// 	if (_config->__FieldRef(HX_CSTRING("minHeapSize")) != null()){
			// 		config.minHeapSize = (int)_config->__FieldRef(HX_CSTRING("minHeapSize"));
			// 	}
			// 	if (_config->__FieldRef(HX_CSTRING("heapGrowthPercent")) != null()){
			// 		config.heapGrowthPercent = _config->__FieldRef(HX_CSTRING("heapGrowthPercent"));
			// 	}
			// }

			return wrenNewVM(&config);

		}

		::String getSlotString(WrenVM* vm, int slot){

			return ::String(wrenGetSlotString(vm, slot));

		}
		
		void setSlotNewForeignDynamic(WrenVM* vm, int slot, int classSlot, ::Dynamic obj) {
			auto ptr = wrenSetSlotNewForeign(vm, slot, classSlot, sizeof(::hx::Object*));
			auto root = static_cast<::hx::Object**>(ptr);
			*root = obj.mPtr;
			::hx::GCAddRoot(root);
			// return root;
		}
		
		void unroot(void* ptr) {
			::hx::GCRemoveRoot(static_cast<::hx::Object**>(ptr));
		}

	} //wren


} //linc
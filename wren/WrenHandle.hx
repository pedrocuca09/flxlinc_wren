package wren;




@:native("WrenHandle")
@:include('linc_wren.h')
extern private class Wren_Handle {}

typedef WrenHandle = cpp.Pointer<Wren_Handle>;

package;

import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import tests.Haxe;
import tests.Native;

class Main extends FlxGame {
    public function new() {
        super(640, 480, PlayState);
    }
}

class PlayState extends FlxState {
    override public function create():Void {
        super.create();

        var haxeTest = new Haxe();
        var nativeTest = new Native();

        haxeTest.test();
        nativeTest.test();

        var text = new FlxText(0, 0, 640, "Tests Completed");
        text.setFormat(null, 16, 0xFFFFFFFF, "center");
        add(text);
    }
}
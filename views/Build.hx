package views;

import haxe.macro.Expr.ExprDef.EConst;
import haxe.macro.Expr.Field;
import haxe.macro.Context;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.Process;

class Build {
	macro public static function config():Array<Field> {
		var _pos = Context.currentPos();
		var _class = Context.getLocalClass();
		var _info = Context.getPosInfos(_pos);
		if (_class == null) {
			return Context.getBuildFields();
		}

        var coreLib = Context.definedValue("FLUXE_CORE_LIB");

		var xml = '
        <files id="haxe">
            <compilerflag value="-std=c++20" />
            <compilerflag value="-stdlib=libc++" />
            <compilerflag value="-mmacosx-version-min=10.9" />
            <compilerflag value="-I../../.." />
            <compilerflag value="-I../../../third_party/skia" />
            <compilerflag value="-I../../../third_party/skia/include/core" />
        </files>
        <files id="__lib__">
            <compilerflag value="-std=c++20" />
            <compilerflag value="-stdlib=libc++" />
            <compilerflag value="-mmacosx-version-min=10.9" />
        </files>
        <files id="runtime">
            <compilerflag value="-std=c++14" />
            <compilerflag value="-stdlib=libc++" />
            <compilerflag value="-mmacosx-version-min=10.9" />
        </files>
		';
        // <target id="haxe" tool="linker" toolid="exe">
        //     <flag value="-L../../../third_party/skia/out/Static"/>
        //     <lib name="-lskia" />
        //     <lib name="${coreLib}" />
        // </target>
        // <files id="__main__">
        //     <compilerflag value="-std=c++20" />
        //     <compilerflag value="-stdlib=libc++" />
        //     <compilerflag value="-mmacosx-version-min=10.9" />
        // </files>

		var buildXml = {
			expr: EConst(CString(xml)),
			pos: _pos
		};
		_class.get().meta.add(":buildXml", [buildXml], _pos);

		return Context.getBuildFields();
	}
}
#Requires AutoHotkey v2.0
#SingleInstance Force
;
;	Comprobamos que VSCompilerAHK.exe reside donde Ahk2Exe.exe
;
Compiler:= A_ScriptDir "\Ahk2Exe.exe"
If ( ! FileExist(Compiler) ) {
	ConsolaVSC("❌ No se encuentra el compilador Ahk2Exe.exe junto a VSCompilerAHK.exe.`nCancelado.", 4)
}
;
;	Comprobamos que el AHK a compilar existe (básicamente que fue guardado)
;
Main := A_Args[1]
If ( ! FileExist(Main) ) {
	ConsolaVSC("❌ El archivo AHK no existe o aún no fue guardado.`nCancelado.", 3)
}
SplitPath(Main, &ScriptAHK, &ScriptDir)
Proyecto := StrReplace(ScriptAHK, ".ahk", "")
;
;	Comprobamos si está definida RutaGeneral en VSCompilerAHK.cfg, tras lo cual y si es así,
;	validamos que el proyecto reside en una Subcarpeta con su mismo nombre
;
RutaGral:= LeerCFG("RutaGeneral")
If ( RutaGral != "" && InStr(ScriptDir, RutaGral, False) ) {
    SubCarpGral := StrSplit(ScriptDir, "\")[-1]
    If SubCarpGral != Proyecto {
		ConsolaVSC( "🚫 Ruta bajo '" RutaGral "' no cumple convención:`n" .
					"Subcarpeta '" SubCarpGral "' ≠ Nombre del script '" Proyecto "'.`n" .
					"Cancelado.", 1)
	}
}
;
;	Comprobamos que el EXE se obtiene correctamente
;
FechaInicio := A_Now
RunWait Format('"{1}" /in "{2}"', Compiler, Main), ScriptDir
RutaExe := ScriptDir "\" Proyecto ".exe"
if ( ! FileExist(RutaExe) ) {
    ConsolaVSC("❌ No se ha generado el archivo '" Proyecto ".exe'", 2)
}
FechaExe := FileGetTime(RutaExe, "M")
if ( FechaExe < FechaInicio ) {
    ConsolaVSC("❌ El ejecutable no fue actualizado en esta compilación.`n" .
               "Fecha .exe: " FechaExe " vs Inicio: " FechaInicio, 2)
}
;
;	Éxito, EXE obtenido
;
ConsolaVSC("✓ Obtenido: " Chr(34) Proyecto Chr(34) ".exe en la carpeta " Chr(34) ScriptDir Chr(34))
ExitApp 0

;=================================================
;	Mensaje en la Consola de Visual Studio Code
;=================================================
ConsolaVSC(Mensaje, Error:= 0) {
	Mensaje := StrSplit(Mensaje,"`n")
	For _,Linea In Mensaje {
		FileAppend(Linea "`n", "*", "UTF-8")
	}
	If Error {
		Exitapp Error
	}
}

;============================================
;	Leer clave del archivo VSCompile.cfg
;============================================
LeerCFG(clave) {
    archivo := A_ScriptDir "\VSCompilerAHK.cfg"
    return FileExist(archivo) ? IniRead(archivo, "", clave, "") : ""
}

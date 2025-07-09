#Requires AutoHotkey v2.0
#SingleInstance Force

Compiler:= "Ahk2Exe.exe"
Main := DepuracionInicial()
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
		EmitirMensaje( "🚫 Ruta bajo '" RutaGral "' no cumple convención:`n" .
						"Subcarpeta '" SubCarpGral "' ≠ Nombre del script '" Proyecto "'.`n" .
						"Cancelado.", 1, "VSC")
	}
}

;
;	Comprobamos que el EXE se obtiene correctamente
;
FechaInicio := A_Now
RunWait Format('"{1}" /in "{2}"', Compiler, Main), ScriptDir
RutaExe := ScriptDir "\" Proyecto ".exe"
if ( ! FileExist(RutaExe) ) {
    EmitirMensaje("❌ No se ha generado el archivo '" Proyecto ".exe'", 2, "VSC")
}
FechaExe := FileGetTime(RutaExe, "M")
if ( FechaExe < FechaInicio ) {
    EmitirMensaje("❌ El ejecutable no fue actualizado en esta compilación.`n" .
				  "Fecha .exe: " FechaExe " vs Inicio: " FechaInicio, 2, "VSC")
}

;
;	Éxito, EXE obtenido
;
EmitirMensaje("✓ Obtenido: " Chr(34) Proyecto Chr(34) ".exe en la carpeta " Chr(34) ScriptDir Chr(34), 0, "VSC")
ExitApp 0

;============================================
;	Leer clave del archivo VSCompile.cfg
;============================================
LeerCFG(clave) {
    archivo := A_ScriptDir "\VSCompilerAHK.cfg"
    return FileExist(archivo) ? IniRead(archivo, "", clave, "") : ""
}

;========================
;	Depuración Inicial
;========================
DepuracionInicial() {
	If ( ! A_IsCompiled ) {			; Autocompilación
		Autocompilacion()
	}

	If ( ! FileExist(Compiler) ) {	; Comprobamos que VSCompilerAHK.exe reside donde Ahk2Exe.exe
		EmitirMensaje("❌ No se encuentra el compilador " Compiler " junto a VSCompilerAHK.exe.`nCancelado.", 4)
	}

	if ( A_Args.Length < 1 ) {		; Comprobamos que la llamada a VSCompilerAHK.exe incluye parámetro con la ruta del AHK a compilar
		EmitirMensaje("❌ VSCompilerAHK.exe no parece haber sido invocado desde VS Code.`nCancelado.", 3)
	}
	
	Main := A_Args[1]
	If ( ! FileExist(Main) ) {		; Comprobamos que el AHK a compilar existe (básicamente que fue guardado)
		EmitirMensaje("❌ El archivo AHK no existe o aún no fue guardado.`nCancelado.", 3, "VSC")
	}
	Return Main
}

;=========================================
;	Autocompilación
;=========================================
Autocompilacion() {
	Nombre    := "VSCompilerAHK"
	NombreAHK := Nombre ".ahk"
	NombreEXE := Nombre ".exe"
	
	if ! FileExist(Compiler) {
		EmitirMensaje( "🚫 Has de disponer " NombreAHK " donde resida " Compiler ".`nCancelado", 10)
	}
	
	If FileExist(NombreEXE) {
		EmitirMensaje( "🚫 " NombreAHK " está pensado para ser ejecutado si no existe " NombreEXE ".`nCancelado", 10)
	}
	
	Tooltip "Generando " NombreEXE "..."
	RunWait(Compiler " /in " NombreAHK)
	Tooltip
	
	FileExist(NombreEXE) ? EmitirMensaje( "✓ " NombreEXE " generado correctamente.", 0)
						 : EmitirMensaje("🚫 Error al generar " NombreEXE, 1)
}

;===============================================================
;	Mensaje normal por MsgBox o Consola de VS Code según Tipo
;===============================================================
EmitirMensaje(Mensaje, Error:= 0, Tipo:= "Normal") {
	If ( Tipo == "Normal" ) {
		MsgBox(Mensaje)
	} Else {
		Mensaje := StrSplit(Mensaje,"`n")
		For _,Linea In Mensaje {
			FileAppend(Linea "`n", "*", "UTF-8")
		}
	}
	ExitApp Error
}

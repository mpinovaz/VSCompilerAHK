# 📦 VSCompilerAHK

Sistema de compilación de scripts AutoHotkey v2 para Visual Studio Code usando Code Runner.

---

## ✍️ Autor

**M. Pino** (con asistencia de [Microsoft Copilot](https://copilot.microsoft.com))

**Última versión:** julio 2025  
**Lenguaje:** [AutoHotkey v2](https://www.autohotkey.com/)  
**Plataforma:** Windows + Visual Studio Code  

---

## 🔧 Requisitos

1. [AutoHotkey v2](https://www.autohotkey.com/) instalado.
2. Visual Studio Code con extensiones:
   - AutoHotkey v2 Language Support
   - Code Runner
3. Ubicación:
   Todos los archivos del sistema deben estar en la **misma carpeta donde resida `Ahk2Exe.exe`**.  
   Ejemplo típico: `D:\Autohotkey\Compiler`

---

## 📌 Instalación

1. Clona o descarga este repositorio.
2. Coloca los siguientes archivos junto a `Ahk2Exe.exe`:
   - `VSCompilerAHK.exe`
   - `VSCompilerAHK.ahk`
   - `VSCompilerAHK.cfg` (opcional)
3. Configura `settings.json` en Visual Studio Code: (la direciva en Nota Final)

---

## ⚙️ Archivo de configuración (opcional)

Nombre: VSCompilerAHK.cfg

Ejemplo: RutaGeneral=D:\AHK Proyectos

Esto permite validar que el AHK principal esté dentro de una subcarpeta con el mismo nombre.

---

## 🧪 Validaciones automáticas

1. Verifica que Ahk2Exe.exe está junto al compilador.
2. Verifica que el AHK ha sido guardado.
3. Si RutaGeneral está definido:
4. Comprueba que el AHK principal esté en la carpeta adecuada.
5. Comprueba que el .exe fue generado en esta sesión.

---

## 🚦 Códigos de salida

Código	Significado
  0		Compilación exitosa
  1		Error de subcarpeta (RutaGeneral)
  2		No se generó el .exe
  3		El archivo AHK no existe o no fue guardado
  4		VSCompilerAHK no está junto a Ahk2Exe.exe

---

## 🧭 Integración con VS Code

La salida aparece en el panel OUTPUT.
Mensajes claros, sin globos ni interrupciones visuales.

---

## 💡 Icono personalizado (opcional)

Puedes añadir esta directiva al inicio de tu script:

;@Ahk2Exe-SetMainIcon C:\Ruta\DelIcono\icono.ico

---

## 🤝 Créditos

Este proyecto fue diseñado con la asistencia de Microsoft Copilot, herramienta basada en IA que ha contribuido a depurar y documentar el sistema con precisión.

---

## 🎯 Nota final

Este sistema está pensado para desarrolladores organizados. Valida, compila y comunica... sin molestar.

Debes configurar en visual Studio Code la directiva para Code Runner de la siguiente forma...

1. Pulsa Ctrl+Shift+P
2. Teclea "Preferencias: Abir configuración de usuario (JSON)"
3. Pincha sobre ella y te aparecerá la ventana "settings.json"
4. Antes de la última llave ( } ) ingresa
```json
"code-runner.executorMap": {
	"ahk2": "\"D:\\Autohotkey\\Compiler\\VSCompilerAHK.exe\""
}"
ajustando la ruta D:\Autohotkey\Compiler a donde resida tu Ahk2Exe.exe

---
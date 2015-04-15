; Script generated by the HM NIS Edit Script Wizard.
; !include "FileAssociation.nsh"
 ; !insertmacro RegisterExtension
 ; ${FileAssociation_VERBOSE} 4   # all verbosity
!include nsDialogs.nsh
!include LogicLib.nsh
!include "nsProcess.nsh"

; your install directories
!define BUILD_DIR "..\build2010x86\ReallyRelease"

!ifndef BUILD_DIR
!define BUILD_DIR "..\build2012x64\ReallyRelease"
!endif
!define README_DIR "Readme"

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "nomacs"
!define PRODUCT_VERSION "2.4.4 WinXP"
!define PRODUCT_WEB_SITE "http://www.nomacs.org"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\nomacs.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define MUI_WELCOMEPAGE_TEXT "Thank you for choosing nomacs - Image Lounge which is a free image viewer. We hope you enjoy it.$\r$\n$\r$\n"

!define MUI_WELCOMEFINISHPAGE_BITMAP ".\src\img\installer.bmp"
; !define MUI_HEADERIMAGE_BITMAP ".\src\img\installer.bmp"

BrandingText "nomacs - Image Lounge"
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "nomacs-setup.exe"
InstallDir "$PROGRAMFILES\nomacs"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show


; MUI 1.67 compatible ------
!include "MUI2.nsh"

!include "uninstaller.nsdinc"


; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "nomacs.ico"
!define MUI_UNICON "nomacs.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "Readme/LICENSE.GPLv3"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES


; silent install 
!include FileFunc.nsh
!insertmacro GetParameters
!insertmacro GetOptions


; ; custom page
; Page custom fileAssociation fileAssociationFinished

; Finish page
!define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Create Desktop Shortcut"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION finishpageaction

!define MUI_FINISHPAGE_RUN ""
!define MUI_FINISHPAGE_RUN_TEXT "Run ${PRODUCT_NAME}"
!define MUI_FINISHPAGE_RUN_FUNCTION launchnomacs
!insertmacro MUI_PAGE_FINISH


; custom uninstaller page
UninstPage custom un.fnc_uninstaller_Show un.uninstallNomacs

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES


; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------
; Var Dialog
; Var Label

Var params
Var fileAss 

; Uninstaller
Var hCtl_uninstaller_CheckBox1_state

Function .onInit		
	IfSilent isSilent isNotSilent
		isSilent:
			${GetParameters} $params
			ClearErrors
			${GetOptions} $params /FileAssociations= $fileAss
		isNotSilent:

FunctionEnd
	
!define SHCNE_ASSOCCHANGED 0x08000000
!define SHCNF_IDLIST 0
 
Function RefreshShellIcons
  ; By jerome tremblay - april 2003
  System::Call 'shell32.dll::SHChangeNotify(i, i, i, i) v \
  (${SHCNE_ASSOCCHANGED}, ${SHCNF_IDLIST}, 0, 0)'
FunctionEnd


Section "MainSection" SEC01#
	loop:
	${nsProcess::FindProcess} "nomacs.exe" $R0
	StrCmp $R0 0 0 +2
	MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION 'Close "nomacs - ImageLounge" before continuing' IDOK loop IDCANCEL end
	goto next
	end:
		quit

	next:
		${nsProcess::Unload}

  SetOutPath "$INSTDIR"
  SetOverwrite on
  File "${BUILD_DIR}\nomacs.exe"
  CreateDirectory "$SMPROGRAMS\nomacs - image lounge"
  CreateShortCut "$SMPROGRAMS\nomacs - image lounge\nomacs - image lounge.lnk" "$INSTDIR\nomacs.exe"
  
  File "${BUILD_DIR}\libnomacs.dll"
  File "${BUILD_DIR}\exiv2.dll"
  File "${BUILD_DIR}\libexpat.dll"
  ; File "${BUILD_DIR}\libjasper.dll"
  File "${BUILD_DIR}\libraw.dll"
  File "${BUILD_DIR}\msvcp*.dll"
  File "${BUILD_DIR}\msvcr*.dll"
  File "${BUILD_DIR}\opencv_core*.dll"
  File "${BUILD_DIR}\opencv_imgproc*.dll"
  File "${BUILD_DIR}\QtCore4.dll"
  File "${BUILD_DIR}\QtGui4.dll"
  File "${BUILD_DIR}\QtNetwork4.dll"
  File "${BUILD_DIR}\QtSoap27.dll"
  File "${BUILD_DIR}\QtXml4.dll"
  File "${BUILD_DIR}\quazip.dll"
  File "${BUILD_DIR}\zlib1.dll"
  File "${BUILD_DIR}\HUpnpAV.dll"
  File "${BUILD_DIR}\HUpnp.dll"
  
  
  File "${README_DIR}\COPYRIGHT"
  File "${README_DIR}\LICENSE.GPLv2"
  File "${README_DIR}\LICENSE.GPLv3"
  File "${README_DIR}\LICENSE.LGPL"
  File "${README_DIR}\LICENSE.OPENCV"
  
  SetOutPath "$INSTDIR\translations"
  File "${BUILD_DIR}\translations\nomacs_*.qm"
  
  SetOutPath "$INSTDIR\imageformats"
  File "${BUILD_DIR}\imageformats\*"
  
SectionEnd

Function finishpageaction	
	CreateShortCut "$DESKTOP\nomacs - Image Lounge.lnk" "$INSTDIR\nomacs.exe"
FunctionEnd

Function launchnomacs
	Exec '"$WINDIR\explorer.exe" "$INSTDIR\nomacs.exe"'
FunctionEnd  

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\nomacs - image lounge\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\nomacs - image lounge\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\nomacs.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\nomacs.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  
	; DELETE REGISTRY ENTRIES FROM OLD VERSION
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\GlobalSettings\" "saveThumb"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\GlobalSettings\" "numFiles"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\DisplaySettings\" "saveThumb"

	; some cleaning for the new settings (introduced in nomacs 2.0.2
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\DisplaySettings\" "highlightColor"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\DisplaySettings\" "bgColor"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\DisplaySettings\" "bgColorNomacs"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\DisplaySettings\" "iconColor"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\DisplaySettings\" "bgColorFrameless"
	DeleteRegValue HKCU "Software\nomacs\Image Lounge\SlideShowSettings\" "backgroundColor"

	; DELETE OLD DLLs
	Delete "$INSTDIR\opencv_imgproc220.dll"
	Delete "$INSTDIR\opencv_core220.dll"
	Delete "$INSTDIR\opencv_imgproc231.dll"
	Delete "$INSTDIR\opencv_core231.dll"
	Delete "$INSTDIR\opencv_imgproc242.dll"
	Delete "$INSTDIR\opencv_core242.dll"
	Delete "$INSTDIR\nomacs_*.qm"
	
	; RESET UPDATE FLAG
	WriteRegStr HKCU "Software\nomacs\Image Lounge\SynchronizeSettings\" "updateDialogShown" "false"
	
	Call RefreshShellIcons

SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer." /SD IDOK
FunctionEnd

Function un.onInit
	loop:
	${nsProcess::FindProcess} "nomacs.exe" $R0
	StrCmp $R0 0 0 +2
	 MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION 'Close "nomacs - ImageLounge" before continuing' IDOK loop IDCANCEL end
	 goto next
	 end:
		 quit

	next:
		${nsProcess::Unload}

	; MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" /SD IDYES IDYES +2
	; Abort    
FunctionEnd


Function un.uninstallNomacs
	${NSD_GetState} $hCtl_uninstaller_CheckBox1 $hCtl_uninstaller_CheckBox1_state
	${If} $hCtl_uninstaller_CheckBox1_state == ${BST_CHECKED}
		DeleteRegKey HKCU "Software\nomacs"
	${endif}
FunctionEnd

Section Uninstall
	Delete "$INSTDIR\${PRODUCT_NAME}.url"
	Delete "$INSTDIR\translations\*"
	Delete "$INSTDIR\imageformats\*"
	Delete "$INSTDIR\*.dll"
	Delete "$INSTDIR\*.exe"
	Delete "$INSTDIR\*.qm"
	Delete "$INSTDIR\nomacs - Image Lounge [x64].url"
	Delete "$INSTDIR\nomacs - Image Lounge.url"
	  
	Delete "$INSTDIR\COPYRIGHT"
	Delete "$INSTDIR\LICENSE.GPLv2"
	Delete "$INSTDIR\LICENSE.GPLv3"
	Delete "$INSTDIR\LICENSE.LGPL"
	Delete "$INSTDIR\LICENSE.OPENCV"
  
	; REMOVE plugins
	Delete "$APPDATA\nomacs\plugins\*"
	RMDir "$APPDATA\nomacs\plugins\"
	
	; REMOVE translations
	Delete "$APPDATA\nomacs\translations\*"
	RMDir "$APPDATA\nomacs\translations\"
	
	RMDir "$APPDATA\nomacs\"
	
	; REMOVE old translations
	SetShellVarContext all ; point to ProgramData
	Delete "$APPDATA\nomacs\translations\*"
	RMDir "$APPDATA\nomacs\translations\"
	RMDir "$APPDATA\nomacs\"
	SetShellVarContext current ; point to default
  
	Delete "$SMPROGRAMS\nomacs - image lounge\Uninstall.lnk"
	Delete "$SMPROGRAMS\nomacs - image lounge\Website.lnk"
	Delete "$DESKTOP\nomacs - image lounge.lnk"
	Delete "$SMPROGRAMS\nomacs - image lounge\nomacs - image lounge.lnk"
		
	RMDir "$SMPROGRAMS\nomacs - image lounge"
	RMDir "$INSTDIR\imageformats"
	RMDir "$INSTDIR\translations"
	RMDir "$INSTDIR"

	DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
	DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
	; DeleteRegKey HKCU "Software\nomacs"
		
	SetAutoClose true
SectionEnd


# Variables
Var StartMenuGroup
Var AppSrc
Var CourseName
Var RegKeyValue
Var ExeOut
Var LicenseFile

Name "${CourseName}"
Caption "${CourseName} Setup"


RequestExecutionLevel highest

# General Symbol Definitions
!define REGKEY "SOFTWARE\${RegKeyValue}"

# MUI Symbol Definitions
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install-colorful.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "TTU_Lessons\${CourseName}"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall-colorful.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

#Welcome Page Text
!define WELCOME_TITLE 'Welcome to the ${CourseName} Setup Wizard'
!define WELCOME_TEXT 'This wizard will guide you through the installation of ${CourseName}.$\r$\n$\r$\nIt is recommended that you close all other applications before starting Setup. This will make it possible to update relevant system files without having to reboot you computer.$\r$\n$\r$\nClick next to continue.'
!define MUI_WELCOMEPAGE_TITLE '${WELCOME_TITLE}'
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_WELCOMEPAGE_TEXT '${WELCOME_TEXT}'

#License Page Text
!define TEXT_LICENSE_SUBTITLE 'Please review the license terms before installing ${CourseName}'
!define LICENSEPAGE_TEXT_BOTTOM 'If you accept the terms of agreement, click I Agree to continue. You must accept the agreement to install ${CourseName}.'
!define MUI_TEXT_LICENSE_SUBTITLE '${TEXT_LICENSE_SUBTITLE}'
!define MUI_LICENSEPAGE_TEXT_BOTTOM '${LICENSEPAGE_TEXT_BOTTOM}'

#Directory Page Text
!define TEXT_DIRECTORY_SUBTITLE 'Choose the folder in which to install ${CourseName}.'
!define DIRECTORYPAGE_TEXT_TOP 'Setup will install ${CourseName} in the following following folder. To install in a different folder, click Browse and select another folder. Click Next to continue.'
!define MUI_TEXT_DIRECTORY_SUBTITLE '${TEXT_DIRECTORY_SUBTITLE}'
!define MUI_DIRECTORYPAGE_TEXT_TOP '${DIRECTORYPAGE_TEXT_TOP}'

#Start Menu Page Text
!define TEXT_STARTMENU_SUBTITLE 'Choose a Start Menu folder for the ${CourseName} shortcuts.'
!define MUI_TEXT_STARTMENU_SUBTITLE '${TEXT_STARTMENU_SUBTITLE}'

#Finish Page Text
!define FINISHPAGE_TITLE 'Completing the ${CourseName} Setup Wizard'
!define FINISHPAGE_TEXT '${CourseName} has been installed on your computer.$\r$\n $\r$\nClick Finish to close this wizard.'
!define MUI_FINISHPAGE_TITLE '${FINISHPAGE_TITLE}'
!define MUI_FINISHPAGE_TEXT '${FINISHPAGE_TEXT}'

#Uninstall Page Text
!define UNCONFIRMPAGE_TEXT_TOP '${CourseName} will be uninstalled from the following folder. Click Uninstall to start the uninstallation.'
!define MUI_UNCONFIRMPAGE_TEXT_TOP '${UNCONFIRMPAGE_TEXT_TOP}'
!define UNINSTALLING_TITLE 'Uninstall ${CourseName}'
!define MUI_UNTEXT_UNINSTALLING_TITLE '${UNINSTALLING_TITLE}'
!define TEXT_UNINSTALLING_SUBTITLE 'Remove ${CourseName} from your computer.'
!define MUI_UNTEXT_UNINSTALLING_SUBTITLE '${TEXT_UNINSTALLING_SUBTITLE}'

#install Page Text
!define TEXT_INSTALLING_SUBTITLE 'Please wait while ${CourseName} is being installed.'
!define MUI_TEXT_INSTALLING_SUBTITLE '${TEXT_INSTALLING_SUBTITLE}'

# Included files
!include Sections.nsh
!include MUI2.nsh

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ${LicenseFile}
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile "${ExeOut}\${CourseName}.exe"
InstallDir "$PROGRAMFILES\TTU_Lessons\${CourseName}"
CRCCheck on
XPStyle on
ShowInstDetails show
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

# Installer sections
Section -Main SEC0000
    SetOutPath $INSTDIR
    SetOverwrite on
    File /r "${AppSrc}\*"
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
SectionEnd

Section -post SEC0001
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\${CourseName}.lnk" "$INSTDIR\TTULessonPlayer.exe"
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall ${CourseName}.lnk" $INSTDIR\uninstall.exe
    SetOutPath $DESKTOP
    CreateShortcut "$DESKTOP\${CourseName}.lnk" "$INSTDIR\TTULessonPlayer.exe"
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${REGKEY}" DisplayName "${REGKEY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${REGKEY}" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${REGKEY}" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${REGKEY}" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${REGKEY}" NoRepair 1
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
Section /o -un.Main UNSEC0000
    RmDir /r /REBOOTOK $INSTDIR
    DeleteRegValue HKLM "${REGKEY}\Components" Main
SectionEnd

Section -un.post UNSEC0001
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${CourseName}"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall ${CourseName}.lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\${CourseName}.lnk"
    Delete /REBOOTOK "$DESKTOP\${CourseName}.lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd



[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{AA4328C3-006F-49F0-94F4-0BA659FCB6A5}
AppName=Blink
AppVersion=X.Y.Z
AppPublisher=AG Projects
AppPublisherURL=http://ag-projects.com
AppSupportURL=http://icanblink.com
AppUpdatesURL=http://icanblink.com
DefaultDirName={commonpf}\Blink
DefaultGroupName=Blink
AllowNoIcons=yes
LicenseFile=license.txt
InfoBeforeFile=pre_setup.txt
OutputBaseFilename=Blink-Installer
SetupIconFile=dist\blink\lib\resources\icons\blink.ico
WizardImageFile=blink_setup_panel.bmp, blink_setup_panel1.bmp
WizardSmallImageFile=blink_setup_top_icon.bmp
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=none

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "dist\blink\blink.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "dist\blink\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Apple Bonjour SDK
Source: "bonjoursdksetup.exe"; DestDir: "{tmp}"; Check: CheckBonjour
; VNC server
Source: "blinkvnc.exe"; DestDir: "{app}"; Flags: ignoreversion
; WinSparkle: self-updating framework
Source: "WinSparkle.dll"; DestDir: "{app}\lib"; Flags: ignoreversion
; psvince: check if application is running
Source: "psvince.dll"; DestDir: "{app}"; Flags: ignoreversion

[InstallDelete]
Type: filesandordirs; Name: "{app}\*.*"

[Icons]
Name: "{group}\Blink"; Filename: "{app}\blink.exe"
Name: "{group}\Website"; Filename: "http://icanblink.com"
Name: "{group}\{cm:UninstallProgram,Blink}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Blink"; Filename: "{app}\blink.exe"; IconFilename: "{app}\resources\icons\blink.ico"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Blink"; Filename: "{app}\blink.exe"; Tasks: quicklaunchicon

[Run]
; Apple Bonjour SDK
Filename: "{tmp}\bonjoursdksetup.exe"; Check: CheckBonjour
; Launch Blink after install?
Filename: "{app}\blink.exe"; Description: "{cm:LaunchProgram,Blink}"; Flags: nowait postinstall skipifsilent

[Registry]
; Remove registry entries when uninstalling
Root: HKCU; Subkey: "Software\AG Projects\Blink"; Flags: uninsdeletekey

[Code]
function IsModuleLoaded(modulename: String ): Boolean;
external 'IsModuleLoaded@files:psvince.dll stdcall setuponly';

function IsModuleLoadedU(modulename: String ): Boolean;
external 'IsModuleLoaded@{app}\psvince.dll stdcall uninstallonly';

function CheckBonjour: Boolean;
begin
  if IsAdminLoggedOn() or IsPowerUserLoggedOn() then
  begin
    if RegKeyExists(HKEY_LOCAL_MACHINE, 'Software\Apple Inc.\Bonjour') then
    begin
      Result := False;
    end else
      Result := True;
  end else
    Result := False;
end;

function InitializeSetup(): Boolean;
begin
  while IsModuleLoaded('blink.exe') do
  begin
    if MsgBox('Blink is curently running. To procceed with the update process, you must close Blink and then press OK to continue. ', mbConfirmation, MB_OKCANCEL) <> IDOK then
    begin
      Result := False;
      Exit;
    end
  end;
  Result := True;
end;

function InitializeUninstall(): Boolean;
begin
  if IsModuleLoadedU('blink.exe') then
  begin
    MsgBox('Blink is currently running, please close it and run uninstall again.', mbError, MB_OK);
    Result := False;
  end else
    Result := True;
  UnloadDLL(ExpandConstant('{app}\psvince.dll'));
end;


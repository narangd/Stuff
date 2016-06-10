#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <FontConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <WinAPIShellEx.au3>
#include <FileConstants.au3>


Global Const $_WIDTH = 600
Global Const $_HEIGHT = 400

;~ #RequireAdmin

#Region Initialization

Global $idLabelTitle, $idLabel[3], $idInputPath, $idIconFolder, $idButtonRecord

#EndRegion Initialization

GUI()

Func GUI()
    Opt("GUICoordMode", 1)

	_GUICreate()

    ; Init our vars that we will use to keep track of GUI events
    Local $iRadioVal1 = 0 ; We will assume 0 = first radio button selected, 2 = last button

    ; Show the GUI
    GUISetState(@SW_SHOW)

    Local $idMsg = 0
    ; In this message loop we use variables to keep track of changes to the radios, another
    ; way would be to use GUICtrlRead() at the end to read in the state of each control
    While 1
        $idMsg = GUIGetMsg()
        Switch $idMsg
			Case $GUI_EVENT_CLOSE
                ExitLoop
			Case $idButtonRecord
				Local $sPath = GUICtrlRead($idInputPath)
				if Not FileExists($sPath) Then
					ContinueLoop
				EndIf

				Local $pidInstallFile = Run($sPath)
				MsgBox(0, '', 'run..', 1)
				ProcessWaitClose($pidInstallFile)
				MsgBox(0, '', 'done..', 1)
				; run program.
				;
			Case $idIconFolder
				Local $sFilePath = FileOpenDialog('설치파일 선택', '', 'Runable (*.exe)|All (*.*)', $FD_FILEMUSTEXIST)
				if FileExists($sFilePath) Then
					GUICtrlSetData($idInputPath, $sFilePath)
				EndIf
;~ 				GUICtrlSetData($idPath,  )
        EndSwitch
    WEnd

    GUIDelete()
EndFunc

Func _GUICreate()
	GUICreate("자동 설치 만들기", $_WIDTH, $_HEIGHT)

    ; Create the controls
;~ 	Local $idLabelBackPanel = GUICtrlCreateLabel('', 0, 20, $_WIDTH, 40)
;~ 	GUICtrlSetBkColor($idLabelBackPanel, 0xf9f9f9)*
	$idLabelTitle = GUICtrlCreateLabel('설치 파일 경로를 설정하고 녹화를 눌러주세요.!', 20, 20, 400, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetBkColor($idLabelTitle, 0xf9f9f9)

	$idLabel[0] = GUICtrlCreateLabel('파일 경로 :', 20, 80, 70, 25, $SS_CENTERIMAGE)
	GUICtrlSetFont($idLabel[0], 10)

	$idInputPath = GUICtrlCreateInput('', 90, 80, 300, 25, $ES_READONLY + $ES_AUTOHSCROLL)
	GUICtrlSetFont($idInputPath, 10)

	$idIconFolder = GUICtrlCreateIcon('', 0, 400, 80, 25, 25)
	GUICtrlSetImage($idIconFolder, "imageres.dll", 3, 0)
;~ 	GUICtrlSetState($idIconFolder, $GUI_DISABLE + $GUI_DEFBUTTON )
	GUICtrlSetState($idIconFolder, $GUI_ENABLE  + $GUI_DEFBUTTON)

	$idButtonRecord = GUICtrlCreateButton('녹화시작', 440, 30, 70, 50)
EndFunc
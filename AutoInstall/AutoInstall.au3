#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <FontConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <WinAPIShellEx.au3>
#include <FileConstants.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <Process.au3>
#include <GuiListView.au3>

#include "MouseOnEvent.au3"

Global Const $_WIDTH = 600
Global Const $_HEIGHT = 400

;~ #RequireAdmin

#Region Initialization

Global $g_tStruct = DllStructCreate($tagPOINT) ; Create a structure that defines the point to be checked.
Global $idLabelTitle, $idLabel[3], $idInputPath, $idIconFolder, $idButtonRecord, $idListViewEvent
Global $pidInstallFile

#EndRegion Initialization

#Region Body

Opt("GUICoordMode", 1)

Local $hGUI = _GUICreate()
Opt("GUICoordMode", 0)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
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

				; moving windows up to start

				Local $aStart_Pos = ControlGetPos("[CLASS:Shell_TrayWnd]", "", "Start1")

				if IsArray($aStart_Pos) Then
					WinMove($hGUI, '', $aStart_Pos[0], $aStart_Pos[1], 100, 25, 3)

					Opt("GUICoordMode", 1)
					_ArrayDisplay($aStart_Pos)
				EndIf

				$pidInstallFile = Run($sPath)
				TrayTip('설치시작', $sPath & '의 설치를 시작합니다.', 1, 1)


				_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "__Mouse_Event")
				;~ _MouseSetOnEvent($MOUSE_PRIMARYUP_EVENT, "__Mouse_Event", 0, -1) ;Not really needed
				;~ _MouseSetOnEvent($MOUSE_SECONDARYDOWN_EVENT, "__Mouse_Event", 0, -1)
				;~ _MouseSetOnEvent($MOUSE_SECONDARYUP_EVENT, "__Mouse_Event", 0, -1)

				While ProcessExists($pidInstallFile)
					Sleep(100) ; waiting...
				WEnd

				;UnSet the events
				_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT)
				_MouseSetOnEvent($MOUSE_PRIMARYDBLCLK_EVENT)
				;~ _MouseSetOnEvent($MOUSE_PRIMARYUP_EVENT)
				;~ _MouseSetOnEvent($MOUSE_SECONDARYDOWN_EVENT)
				;~ _MouseSetOnEvent($MOUSE_SECONDARYUP_EVENT)

				ProcessWaitClose($pidInstallFile)
				TrayTip('설치완료', $sPath & '의 설치가 완료되었습니다.', 1, 1)

				WinMove($hGUI, '', _
				(@DesktopWidth-$_WIDTH)/2, _    ; x
				(@DesktopHeight-$_HEIGHT)/2, _  ; y
				$_WIDTH, _                      ; width
				$_HEIGHT, _                     ; height
				1)

			; run program.
			;
;~ 			Local $hParentHandle = _WinAPI_GetAncestor($hGUI, $GA_PARENT)
;~ 			MsgBox(0, '', WinGetTitle($hParentHandle))

		; 마우스 클릭 이벤트 -> InputPath
		Case $GUI_EVENT_PRIMARYDOWN
			$ci = GUIGetCursorInfo($hGUI)
			If IsArray($ci) Then
				If $ci[2] == 1 And $ci[4] == $idInputPath Then
					ContinueCase
				EndIf
			EndIf
		Case $idIconFolder
			Local $sFilePath = FileOpenDialog('설치파일 선택', '', 'Runable (*.exe)|All (*.*)', $FD_FILEMUSTEXIST, '설치파일을 선택하여 주세요', $hGUI)
			if FileExists($sFilePath) Then
				GUICtrlSetData($idInputPath, $sFilePath)
			EndIf
	EndSwitch
WEnd

GUIDelete()

#EndRegion Body

#Region Additional Functions

Func _GUICreate()
	Local $hGUI = GUICreate("자동 설치 만들기", $_WIDTH, $_HEIGHT, Default, Default, Default, $WS_EX_TOPMOST)

    ; Create the controls
;~ 	Local $idLabelBackPanel = GUICtrlCreateLabel('', 0, 20, $_WIDTH, 40)
;~ 	GUICtrlSetBkColor($idLabelBackPanel, 0xf9f9f9)*
	$idLabelTitle = GUICtrlCreateLabel('설치 파일 경로를 설정하고 녹화를 눌러주세요.!', 20, 20, 400, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetBkColor($idLabelTitle, 0xf9f9f9)

	$idLabel[0] = GUICtrlCreateLabel('파일 경로 :', 20, 80, 70, 20, $SS_CENTERIMAGE)
	GUICtrlSetFont($idLabel[0], 10)

	$idInputPath = GUICtrlCreateInput('', 90, 80, 300, 20, $ES_READONLY + $ES_AUTOHSCROLL)
	GUICtrlSetFont($idInputPath, 10)

	$idIconFolder = GUICtrlCreateIcon('', 0, 400, 80, 20, 20)
	GUICtrlSetImage($idIconFolder, "imageres.dll", 3, 0)
    GUICtrlSetCursor($idIconFolder, 0)

	$idButtonRecord = GUICtrlCreateButton('녹화시작', 470, 20, 80, 80)

	$idListViewEvent = GUICtrlCreateListView('X |Y |Title  |Text              ', 20, 120, 560, 260)

	Return $hGUI
EndFunc

;~ ========================================================
;~ This thing is responcible for click events
;~ ========================================================
Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

    Local $hWndFrom, $iCode, $tNMHDR, $hWndListView
    $hWndListView = $idListViewEvent
    If Not IsHWnd($idListViewEvent) Then $hWndListView = GUICtrlGetHandle($idListViewEvent)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hWndListView
            Switch $iCode

                Case $NM_DBLCLK  ; Sent by a list-view control when the user double-clicks an item with the left mouse button
                   Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)

                   $Index = DllStructGetData($tInfo, "Index")

                   $subitemNR = DllStructGetData($tInfo, "SubItem")


                   ; make sure user clicks on the listview & only the activate
                   If $Index <> -1 Then

                       ; col1 ITem index


                        ;Col item 2 index
;~                         $item2 = StringSplit(_GUICtrlListView_GetItemTextString($idListViewEvent, $subitemNR),'|')
;~                         $item2= $item2[2]

;~ 						Local $hLV = GUICtrlGetHandle($idListViewEvent)
;~                         Local $index = Int(_GUICtrlListView_GetSelectedIndices($hLV))
						Local $text = _GUICtrlListView_GetItemTextString($idListViewEvent, -1)
						ConsoleWrite($text & @CRLF)

                    EndIf

            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

; Monitor click process.. while record.
Func __Mouse_Event()
	GetMousePosition()
	Local $hMouseUnderWnd = _WinAPI_WindowFromPoint($g_tStruct) ; Retrieve the window handle.
	Local $hRootWnd = _WinAPI_GetAncestor($hMouseUnderWnd, $GA_PARENT)

	TrayTip(WinGetTitle($hRootWnd) & ' 클릭', _
	'x:' & DllStructGetData($g_tStruct, "x") & _
	', y:' & DllStructGetData($g_tStruct, "y"), 0, 1)

	GUICtrlCreateListViewItem('' & DllStructGetData($g_tStruct, "x") & _
			'|' & DllStructGetData($g_tStruct, "y") & _
			'|' & $hRootWnd & _
			'|' & WinGetClassList($hRootWnd), _
			$idListViewEvent)
EndFunc

Func GetMousePosition()
    DllStructSetData($g_tStruct, "x", MouseGetPos(0))
    DllStructSetData($g_tStruct, "y", MouseGetPos(1))
EndFunc   ;==>GetMousePosition

#EndRegion Additional Functions
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ #include <process.au3>
#include <MsgBoxConstants.au3>

#RequireAdmin

Local $command = 'devmgmt.msc'

Local $hPID =  Run(@ComSpec & ' /c ' & $command, '', @SW_HIDE)
;~ Local $exit_code = Run(@ComSpec & ' /c ' & $command, '', @SW_HIDE)

;~ WinWaitActive($hPID, "", "")


Local $hWindow = 0
while ( ProcessExists($hPID) )
	Local $hWindow = WinWaitActive('[CLASS:MMCMainFrame]', '로컬 컴퓨터의 장치 관리자', 1)
	if $hWindow == 0 Then
		ContinueLoop
	EndIf

	WinActivate($hWindow)
	if WinActive($hWindow) Then

		Local $sDriverName = 'Realtek PCIe GBE Family Controller 속성'
		Local $hDriver = DeviceManagerFindDriver($hWindow, $sDriverName)
		if MsgBox(1, '확인', '드라이버를 삭제하고 다시 검색하시겠습니까?') == $IDCANCEL Then
			Exit(0)
		EndIf

		WinActivate($hWindow)

		Send('{APPSKEY}{U}{SPACE}')
		WinWaitActive($hWindow)

		Send('{TAB}{HOME}{APPSKEY}{A}')
		WinWaitActive($hWindow, '플러그 앤 플레이를 지원하는 하드웨어 검색 중...')

	Else
		MsgBox(0, '', '창이 안떳다')
	EndIf


		; Title:	Realtek PCIe GBE Family Controller 속성
		; Class:	#32770
		; Text :
;~ 일반
;~ Realtek PCIe GBE Family Controller
;~ 장치 유형:
;~ 네트워크 어댑터
;~ 제조업체:
;~ Realtek
;~ 위치:
;~ PCI 버스 2, 장치 0, 기능 0
;~ 장치 상태
;~ 이 장치가 올바르게 작동하고 있습니다.
;~ 확인
;~ 취소

		; control : ToolbarWIndow32
		; Class:	ToolbarWindow32
		; Instance:	1
		; ClassnameNN:	ToolbarWindow321
		; Advanced (Class):	[CLASS:ToolbarWindow32; INSTANCE:1]
		; ID:	4098


	if WinExists($hWindow) Then
		ProcessClose( WinGetProcess( $hWindow ) )
		WinClose($hWindow)
	EndIf
	ExitLoop

WEnd



Func DeviceManagerOpenDriver($hWindow)
;~ 	WinActivate($hWindow)
	If WinActive($hWindow) Then
		Send('{TAB}{RIGHT 4}')
	EndIf
EndFunc

; 0:DevieceManager handler..
; 1: finding Driver name
Func DeviceManagerFindDriver($hDeviceManager, $sDriverName)
	WinActivate($hDeviceManager)
	If WinActive($hDeviceManager) Then
		Send('{TAB}')
		Send('{HOME}')
		For $i=1 To 20
;~ 			WinActivate($hDeviceManager)
			If Not WinExists($hDeviceManager) Then
				Return 0
			EndIf

			DeviceManagerOpenDriver($hDeviceManager)

			Send('{APPSKEY}{R}')

			Local $hDriver = WinWaitActive('[CLASS:#32770]')
			Local $aStyle = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hDriver, "int", -16)
			Local $aExStyle = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hDriver, "int", -20)
			If WinGetTitle($hDriver) == $sDriverName Then
;~ 				MsgBox(0, WinGetTitle($hDriver), "Style=" & Hex($aStyle[0]) & @cr & "ExStyle=" & Hex($aExStyle[0]))
				Send('{ESC}')
				Return $hDriver
			EndIf
			Send('{ESC}')
;~ 			ConsoleWrite($aExStyle & @CRLF)

			Send('{DOWN}')
		Next
	EndIf
	Return 0
EndFunc
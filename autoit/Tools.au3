#include-once
#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>

Global $file = -1

Func GetTime()
	Dim $time = "//"
	$time &= @HOUR & ":"
	$time &= @MIN & ":"
	$time &= @SEC & "."
	$time &= @MSEC
	Return $time
EndFunc

Func admin()
	#RequireAdmin
EndFunc

Func writeLine($string="")
	if $file == -1 Then
		ConsoleWrite($string & @CRLF)
		Return
	EndIf
	FileWriteLine($file, $string)
EndFunc

Func winCommand($title, $text="", $command="", $timer=0)
	If WinExists($title, $text) Then WinActivate($title, $text)
	WinWaitActive($title, $text, $timer)
	WinActivate($title, $text)
	if WinActive($title) Then
		If IsString($command) Then
			Send($command)
		ElseIf IsNumber($command) Then
			ControlClick($title, $text, $command)
		EndIf
	EndIf
 EndFunc

 Func waitColor($Title, $Text, $Color, $X, $Y)
   While 1
	  WinActivate($Title, $Text)
	  WinMove($Title, $text, 0, 0)
	  $CurrentColor = PixelGetColor($X, $Y)
	  If $CurrentColor == $Color Then
		 Return ; 현재 찾은 픽셀의 색이 같다면 이 함수 종료.
	  EndIf
   WEnd
 EndFunc

 Func _ArrayInStr(Const $Array, Const $Str, $else=0)
	Local $Index

	If Not IsArray($Array) Then return -2

	For $Index=1 To UBound($Array)-1
		If StringInStr($Array[$Index], $Str) Then
			If $else Then
				ContinueLoop
			Else
				return $Index
			EndIf
		EndIf
		If $else Then Return $Index
	Next
	return -1
 EndFunc

; $Str과 관련된 파일 리스트만을 살리고 나머지는 삭제한다.
Func _ArrayGetStr(ByRef $aFileList, $Str)
	Local $Index
	While True
		$Index = _ArrayInStr($aFileList, $Str, 1)
		If $Index > 0 Then
			$aFileList[0] -= 1
			_ArrayDelete($aFileList, $Index)
			ContinueLoop
		EndIf
		ExitLoop
	WEnd
	Return $aFileList
EndFunc


Func TimeArrayToString( Const ByRef $aArray )
	Local $str = ""
	If Not IsArray($aArray) Then
		Return -1;
	EndIf

	$str &= $aArray[0] & '.' ; 년도
    $str &= $aArray[1] & '.' ; 월
    $str &= $aArray[2] & ' ' ; 일
    $str &= $aArray[3] & ':' ; 시
    $str &= $aArray[4] & ':' ; 분
    $str &= $aArray[5]		 ; 초

	Return $str
EndFunc

Func Alert($msg, $title='', $timeout=2)
	If MsgBox(1, $title, $msg, $timeout) == $IDCANCEL Then
		Exit
	EndIf
EndFunc

Func updateAutoInstall($file_name)
	Local $path = '\\203.232.193.244\Autoit update\'
;~ 	Local $path = '\\203.232.193.87\'

	Switch $file_name
		Case '통합프로그램 자동설치'
			$path &= 'autoInstall\'
		Case '강의실 아이피설정'
			$path &= 'autoIP\'
		Case Else
			Return
	EndSwitch

	; 서버접속 후 디렉토리 읽어오기
	Local $aFileList = _FileListToArray($path)
	If Not IsArray($aFileList) Then
		Alert($path & '의 위치에 검색...' & @CRLF & '  결과 : 공유폴더에 문제가 있습니다.', '공유폴더 검색 결과')
		Exit
	EndIf

	; 관련된 것만 살리고 내림차순
	; 결과는 0이 제일 최근의 파일이 남는다 (2 ... 자동v1.36 ... 자동v1.3) 2는 총 갯수
	_ArrayGetStr($aFileList, $file_name)
	_ArraySort($aFileList, 1, 1)
;~ 	_ArrayDisplay($aArray)

	Local $lastestVersion = $aFileList[1]
	; 최신파일이라면 설치파일을 계속 실행한다.
	If StringCompare($lastestVersion, @ScriptName) <= 0 Then
		MsgBox(1, '확인결과', '현재파일이 최신파일 입니다.', 2)
		Return
	EndIf
	; 최신파일

;~ 	Alert(@ScriptName & ' -> ' & $lastest_file & @CRLF & ' 새로설치 중...')
	If MsgBox(1, '', $path & $lastestVersion & ' -> ' & @ScriptDir & @CRLF & ' 업데이트 하시겠습니까?', 5) == $IDCANCEL Then
		Return
	EndIf

	FileCopy($path & $lastestVersion, @ScriptDir, 1)

	; 최신버전을 실행하고, 현재 프로그램은 종료한다.
	Run($lastestVersion)
	Exit
EndFunc

Func deletePreviousVersion($FileName)
	Local $aFileList = _FileListToArray(@ScriptDir)
	_ArrayGetStr($aFileList, $FileName)
	_ArraySort($aFileList, 1, 1)
 	_ArrayDelete($aFileList, 1)

	If MsgBox(1, '', '이전버전의 프로그램(' & $FileName & ')들을 삭제합니다.', 4) == $IDCANCEL Then
		Return
	EndIf

	For $deleteing In $aFileList
		FileRecycle($deleteing)
	Next
EndFunc
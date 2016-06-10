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
		 Return ; ���� ã�� �ȼ��� ���� ���ٸ� �� �Լ� ����.
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

; $Str�� ���õ� ���� ����Ʈ���� �츮�� �������� �����Ѵ�.
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

	$str &= $aArray[0] & '.' ; �⵵
    $str &= $aArray[1] & '.' ; ��
    $str &= $aArray[2] & ' ' ; ��
    $str &= $aArray[3] & ':' ; ��
    $str &= $aArray[4] & ':' ; ��
    $str &= $aArray[5]		 ; ��

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
		Case '�������α׷� �ڵ���ġ'
			$path &= 'autoInstall\'
		Case '���ǽ� �����Ǽ���'
			$path &= 'autoIP\'
		Case Else
			Return
	EndSwitch

	; �������� �� ���丮 �о����
	Local $aFileList = _FileListToArray($path)
	If Not IsArray($aFileList) Then
		Alert($path & '�� ��ġ�� �˻�...' & @CRLF & '  ��� : ���������� ������ �ֽ��ϴ�.', '�������� �˻� ���')
		Exit
	EndIf

	; ���õ� �͸� �츮�� ��������
	; ����� 0�� ���� �ֱ��� ������ ���´� (2 ... �ڵ�v1.36 ... �ڵ�v1.3) 2�� �� ����
	_ArrayGetStr($aFileList, $file_name)
	_ArraySort($aFileList, 1, 1)
;~ 	_ArrayDisplay($aArray)

	Local $lastestVersion = $aFileList[1]
	; �ֽ������̶�� ��ġ������ ��� �����Ѵ�.
	If StringCompare($lastestVersion, @ScriptName) <= 0 Then
		MsgBox(1, 'Ȯ�ΰ��', '���������� �ֽ����� �Դϴ�.', 2)
		Return
	EndIf
	; �ֽ�����

;~ 	Alert(@ScriptName & ' -> ' & $lastest_file & @CRLF & ' ���μ�ġ ��...')
	If MsgBox(1, '', $path & $lastestVersion & ' -> ' & @ScriptDir & @CRLF & ' ������Ʈ �Ͻðڽ��ϱ�?', 5) == $IDCANCEL Then
		Return
	EndIf

	FileCopy($path & $lastestVersion, @ScriptDir, 1)

	; �ֽŹ����� �����ϰ�, ���� ���α׷��� �����Ѵ�.
	Run($lastestVersion)
	Exit
EndFunc

Func deletePreviousVersion($FileName)
	Local $aFileList = _FileListToArray(@ScriptDir)
	_ArrayGetStr($aFileList, $FileName)
	_ArraySort($aFileList, 1, 1)
 	_ArrayDelete($aFileList, 1)

	If MsgBox(1, '', '���������� ���α׷�(' & $FileName & ')���� �����մϴ�.', 4) == $IDCANCEL Then
		Return
	EndIf

	For $deleteing In $aFileList
		FileRecycle($deleteing)
	Next
EndFunc
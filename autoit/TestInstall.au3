
MsgBox(0, '알림', '설치를 시작합니다.')

ProgressOn('설치 시뮬레이션', '설치중', '테스트 프로그램을 설치중에 있습니다.')
For $i = 10 To 100 Step 10
	Sleep(100)
	ProgressSet($i, $i & "%")
Next

; Set the "subtext" and "maintext" of the progress bar window.
ProgressSet(100, "알림", "테스트 프로그램의 설치가 완료되었습니다.")
Sleep(1000)

ProgressOff()


MsgBox(0, '테스트', '설치를 완료하였습니다.')

MsgBox(0, '�˸�', '��ġ�� �����մϴ�.')

ProgressOn('��ġ �ùķ��̼�', '��ġ��', '�׽�Ʈ ���α׷��� ��ġ�߿� �ֽ��ϴ�.')
For $i = 10 To 100 Step 10
	Sleep(100)
	ProgressSet($i, $i & "%")
Next

; Set the "subtext" and "maintext" of the progress bar window.
ProgressSet(100, "�˸�", "�׽�Ʈ ���α׷��� ��ġ�� �Ϸ�Ǿ����ϴ�.")
Sleep(1000)

ProgressOff()


MsgBox(0, '�׽�Ʈ', '��ġ�� �Ϸ��Ͽ����ϴ�.')
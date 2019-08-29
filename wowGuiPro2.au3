#include <GUIConstantsEx.au3>
 #include <GuiListView.au3>

#include <WinAPI.au3>
#include <WindowsConstants.au3>


Global $mainLabel
Global $BtnAdd
Global $BtnGua

Global $mainTitle="δ����"
Global $mainHander=-1

Global $isStart=false
Global $isStartGua = False

Dim $itemHanders[1]

$itemHanders[0] = 0



Opt("GUIOnEventMode", 1)
MainGUI()





Global $hCallback = DllCallbackRegister("LowLevelKeyboardProc", "long", "int;wparam;lparam")
Global $hModule = _WinAPI_GetModuleHandle(0)
Global $hHook

OnAutoItExitRegister("OnAutoItExit")

;/target wuwenfu
;/follow
;/target targettarget
;/cast ����һ��(�ȼ� 1)

;===========================================================
;nCode
;С��0����CallNextHookEx

;wParam
;��Ϣ: WM_KEYDOWN, WM_KEYUP, WM_SYSKEYDOWN, WM_SYSKEYUP

;lParam
;KBDLLHOOKSTRUCT�ṹָ��

;Return
;������ӹ���û�д�����Ϣ,����CallNextHookEx
;������ӹ��̴������Ϣ,����һ������ֵ����ֹϵͳ������Ϣ������Ĺ�����Ŀ�괰��
;===========================================================
Func LowLevelKeyboardProc($nCode, $wParam, $lParam)
	If $nCode < 0 Then Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)

	Local $tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)
	Local $iCode = DllStructGetData($tKEYHOOKS, "vkCode")
	Local $iScan = DllStructGetData($tKEYHOOKS, "scanCode")
	Local $iFlag = DllStructGetData($tKEYHOOKS, "flags")

	Global $mainHander
	Global $itemHanders
	Local $hWnd



   For $i = 1 to $itemHanders[0] Step 1
		  $hWnd = $itemHanders[$i]
		  if  $hWnd <> $mainHander then
					;ToolTip("debug: ���͵Ĵ��� " & $mainHander & " ������" & $hWnd)

				  Switch $wParam
						  Case $WM_KEYDOWN
							  ;ToolTip("��������: (" & $iCode & ")")
							  If $iCode <> 65 and $iCode <> 87 and $iCode <> 83 and $iCode <>68 Then
								 _WinAPI_PostMessage($hWnd,$wParam, $iCode,0)
							  endIf

						  Case $WM_KEYUP
							  ;ToolTip("����̧��: (" & $iCode & ")")
							  If $iCode <> 65 and $iCode <> 87 and $iCode <> 83 and $iCode <>68 Then
								 _WinAPI_PostMessage($hWnd,$wParam, $iCode,0)
							  endIf

						  Case $WM_SYSKEYDOWN
							  ;ToolTip("ϵͳ��������: (" & $iCode & ")")
						  Case $WM_SYSKEYUP
							  ;ToolTip("ϵͳ����̧��: (" & $iCode & ")")
						  Case Else
							  ConsoleWrite($wParam & @CRLF)
							  ;ToolTip("������Ϣ: (" & $wParam & ")")
					  EndSwitch






		  endIf
   Next






	Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
EndFunc

Func OnAutoItExit()
	_WinAPI_UnhookWindowsHookEx($hHook)
	DllCallbackFree($hCallback)
EndFunc


 ; ----- GUIs
Func MainGUI()
  Global $listview
  $listGUI = GUICreate("ħ����������", 400, 400, 100, 200, -1)
  GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close_Main")
  $listview = GUICtrlCreateListView("ħ����Ϸ�����б�", 10, 10, 400, 150)
  _GUICtrlListView_SetColumnWidth($listview, 0, $LVSCW_AUTOSIZE_USEHEADER )

	Local $aList = WinList("[TITLE:ħ������; CLASS:GxWindowClass;]")
	;GxWindowClass
	;Local $aList = WinList("[CLASS:GxWindowClassD3d]", "")

    ; Loop through the array displaying only visable windows with a title.

	ReDim $itemHanders[$aList[0][0]+1]
	$itemHanders[0] = $aList[0][0]

    For $i = 1 To $aList[0][0]
        If $aList[$i][0] <> "" And BitAND(WinGetState($aList[$i][1]), 2) Then
              GUICtrlCreateListViewItem($aList[$i][0] & @CRLF & ":" & $aList[$i][1], $listview)
			  $itemHanders[$i]=$aList[$i][1]
        EndIf
    Next





  Global $BtnAdd = GUICtrlCreateButton("�����࿪", 10, 165, 80, 30)
  GUICtrlSetOnEvent($BtnAdd, "Addi")

  Global $BtnGua = GUICtrlCreateButton("�����һ�", 10, 165+30+10, 80, 30)
GUICtrlSetOnEvent($BtnGua, "Guai")


  $BtnSelect = GUICtrlCreateButton("����������", 100, 165, 80, 30)
  GUICtrlSetOnEvent($BtnSelect, "SelectItem")

  $mainLabel = GUICtrlCreateLabel( "������:"& $mainTitle, 190, 165+10, 300, 30)


   $myedit=GUICtrlCreateEdit("���������ʵ�ֶ࿪ħ������,ʵ��ͬʱ�������ܡ�"& @CRLF & "�����ĵ�: https://www.yuque.com/u293649/hpg76f "& @CRLF & "����: ����-����ά��-�������� ", 10,165+40+10+40+10,380,380)


  GUISetState()

   While 1
	  Sleep(10)
	  ;α�찴������
	  If $isStartGua == true Then
		 Global $itemHanders
		 Local $hWnd
		 For $i = 1 to $itemHanders[0] Step 1
			$hWnd = $itemHanders[$i]
			_WinAPI_PostMessage($hWnd,$WM_KEYUP, 32,0)
			_WinAPI_PostMessage($hWnd,$WM_KEYDOWN, 32,0)
		 Next
	  endIf
   WEnd
EndFunc
 ; ///// Functions
Func Addi()
	Global $isStart
	Global $hCallback
	Global $hModule
	Global $hHook


	if $isStartGua == true then
				MsgBox(0, "���̼���",   "����ֹͣ�һ�")
		return 1
	endIf

	if $mainHander == -1 then
				MsgBox(0, "���̼���",   "��Ҫ����������")
		return 1
	endIf

	if $isStart == false then
		Global $hCallback = DllCallbackRegister("LowLevelKeyboardProc", "long", "int;wparam;lparam")
		Global $hModule = _WinAPI_GetModuleHandle(0)
		Global $hHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($hCallback), $hModule)
		$isStart = true
		MsgBox(0, "���̼���",   "�����ɹ�")
		GUICtrlSetData ( $BtnAdd ,"ֹͣ")
	Else
		_WinAPI_UnhookWindowsHookEx($hHook)
		DllCallbackFree($hCallback)
		$isStart = false
		MsgBox(0, "���̼���",   "ֹͣ�ɹ�")
		GUICtrlSetData ( $BtnAdd ,"����")

	endIf



EndFunc


Func Guai()
	Global $isStartGua
	Global $BtnGua
	if  $itemHanders[0] <= 0 then
				MsgBox(0, "�һ�",   "û����ħ�޴���")
		return 1
	endIf

	if $isStartGua == False then
		$isStartGua = True
		MsgBox(0, "�һ�",   "�����ɹ�")
		GUICtrlSetData ( $BtnGua ,"ֹͣ�һ�")
	Else
		$isStartGua = False
		MsgBox(0, "�һ�",   "ֹͣ�ɹ�")
		GUICtrlSetData ( $BtnGua ,"�����һ�")
	endIf



EndFunc

Func SelectItem()

	Global $mainHander
	Global $mainLabel
  $sItem = GUICtrlRead(GUICtrlRead($listview))
  if $sItem == 0 then
	  MsgBox(0, "����������",   "��û��ѡ���κδ���")
	  return 1
  endIf

  $sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
  $array = StringSplit($sItem, ":")

	$mainTitle=$array[1]
	$mainHander=$array[2]
	GUICtrlSetData($mainLabel,$mainTitle & $mainHander)
	WinActivate($mainHander)
	  MsgBox(0, "����������",   "���óɹ�" & $itemHanders[0])

EndFunc

Func On_Close_Main()
   Exit
EndFunc
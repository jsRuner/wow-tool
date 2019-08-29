#include <GUIConstantsEx.au3>
 #include <GuiListView.au3>

#include <WinAPI.au3>
#include <WindowsConstants.au3>


Global $mainLabel
Global $BtnAdd
Global $BtnGua

Global $mainTitle="未设置"
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
;/cast 猛禽一击(等级 1)

;===========================================================
;nCode
;小于0返回CallNextHookEx

;wParam
;消息: WM_KEYDOWN, WM_KEYUP, WM_SYSKEYDOWN, WM_SYSKEYUP

;lParam
;KBDLLHOOKSTRUCT结构指针

;Return
;如果钩子过程没有处理消息,返回CallNextHookEx
;如果钩子过程处理的消息,返回一个非零值来防止系统传递消息给其余的钩链或目标窗口
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
					;ToolTip("debug: 发送的窗体 " & $mainHander & " 主窗体" & $hWnd)

				  Switch $wParam
						  Case $WM_KEYDOWN
							  ;ToolTip("按键按下: (" & $iCode & ")")
							  If $iCode <> 65 and $iCode <> 87 and $iCode <> 83 and $iCode <>68 Then
								 _WinAPI_PostMessage($hWnd,$wParam, $iCode,0)
							  endIf

						  Case $WM_KEYUP
							  ;ToolTip("按键抬起: (" & $iCode & ")")
							  If $iCode <> 65 and $iCode <> 87 and $iCode <> 83 and $iCode <>68 Then
								 _WinAPI_PostMessage($hWnd,$wParam, $iCode,0)
							  endIf

						  Case $WM_SYSKEYDOWN
							  ;ToolTip("系统按键按下: (" & $iCode & ")")
						  Case $WM_SYSKEYUP
							  ;ToolTip("系统按键抬起: (" & $iCode & ")")
						  Case Else
							  ConsoleWrite($wParam & @CRLF)
							  ;ToolTip("其他消息: (" & $wParam & ")")
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
  $listGUI = GUICreate("魔兽世界助手", 400, 400, 100, 200, -1)
  GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close_Main")
  $listview = GUICtrlCreateListView("魔兽游戏窗口列表", 10, 10, 400, 150)
  _GUICtrlListView_SetColumnWidth($listview, 0, $LVSCW_AUTOSIZE_USEHEADER )

	Local $aList = WinList("[TITLE:魔兽世界; CLASS:GxWindowClass;]")
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





  Global $BtnAdd = GUICtrlCreateButton("启动多开", 10, 165, 80, 30)
  GUICtrlSetOnEvent($BtnAdd, "Addi")

  Global $BtnGua = GUICtrlCreateButton("启动挂机", 10, 165+30+10, 80, 30)
GUICtrlSetOnEvent($BtnGua, "Guai")


  $BtnSelect = GUICtrlCreateButton("设置主窗体", 100, 165, 80, 30)
  GUICtrlSetOnEvent($BtnSelect, "SelectItem")

  $mainLabel = GUICtrlCreateLabel( "主窗体:"& $mainTitle, 190, 165+10, 300, 30)


   $myedit=GUICtrlCreateEdit("本软件可以实现多开魔兽世界,实现同时练级功能。"& @CRLF & "具体文档: https://www.yuque.com/u293649/hpg76f "& @CRLF & "作者: 五区-帕奇维克-我是悠悠 ", 10,165+40+10+40+10,380,380)


  GUISetState()

   While 1
	  Sleep(10)
	  ;伪造按键发送
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
				MsgBox(0, "键盘监听",   "请先停止挂机")
		return 1
	endIf

	if $mainHander == -1 then
				MsgBox(0, "键盘监听",   "需要设置主窗体")
		return 1
	endIf

	if $isStart == false then
		Global $hCallback = DllCallbackRegister("LowLevelKeyboardProc", "long", "int;wparam;lparam")
		Global $hModule = _WinAPI_GetModuleHandle(0)
		Global $hHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($hCallback), $hModule)
		$isStart = true
		MsgBox(0, "键盘监听",   "开启成功")
		GUICtrlSetData ( $BtnAdd ,"停止")
	Else
		_WinAPI_UnhookWindowsHookEx($hHook)
		DllCallbackFree($hCallback)
		$isStart = false
		MsgBox(0, "键盘监听",   "停止成功")
		GUICtrlSetData ( $BtnAdd ,"启动")

	endIf



EndFunc


Func Guai()
	Global $isStartGua
	Global $BtnGua
	if  $itemHanders[0] <= 0 then
				MsgBox(0, "挂机",   "没发现魔兽窗口")
		return 1
	endIf

	if $isStartGua == False then
		$isStartGua = True
		MsgBox(0, "挂机",   "开启成功")
		GUICtrlSetData ( $BtnGua ,"停止挂机")
	Else
		$isStartGua = False
		MsgBox(0, "挂机",   "停止成功")
		GUICtrlSetData ( $BtnGua ,"启动挂机")
	endIf



EndFunc

Func SelectItem()

	Global $mainHander
	Global $mainLabel
  $sItem = GUICtrlRead(GUICtrlRead($listview))
  if $sItem == 0 then
	  MsgBox(0, "设置主窗体",   "你没有选择任何窗体")
	  return 1
  endIf

  $sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
  $array = StringSplit($sItem, ":")

	$mainTitle=$array[1]
	$mainHander=$array[2]
	GUICtrlSetData($mainLabel,$mainTitle & $mainHander)
	WinActivate($mainHander)
	  MsgBox(0, "设置主窗体",   "设置成功" & $itemHanders[0])

EndFunc

Func On_Close_Main()
   Exit
EndFunc
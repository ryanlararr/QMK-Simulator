#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;//////////////////////////////////////////////////////////////
; initialization
; env variables
;//////////////////////////////////////////////////////////////
#SingleInstance Force ; Allow only one running instance of script.
CoordMode, ToolTip, Screen  ; Place ToolTips at absolute screen coordinates:

kbd_layer := 0
;//////////////////////////////////////////////////////////////
; env variables
;//////////////////////////////////////////////////////////////
mouse_move_max_distance := 50
mouse_move_accelation_ratio := 0.05
mouse_move_distance_start := 2
mouse_move_distance := mouse_move_distance_start
tooltip_duration := 2000

noti_type := 1
noti_x := A_ScreenWidth//2-400
noti_y := A_ScreenHeight//2-100

;//////////////////////////////////////////////////////////////
; notications
;//////////////////////////////////////////////////////////////
PopUp(msg){
  global noti_x
  global noti_y
  Tooltip, % "`n`n`t`t " . msg . "`t`t`t`n`n ", %noti_x%, %noti_y%
  ; SetTimer, RemoveToolTip, %tooltip_duration%
  SetTimer, RemoveToolTip, -2000
}
RemoveToolTip:
ToolTip
return
RemoveSplash:
SplashImage,Off
return
SetLayer(num){
  global kbd_layer
  global noti_type
  kbd_layer := num
  if(noti_type = 0){
    If(num = 0){
      PopUp("layer 0 (Normal)")
    } Else If(num = 1){
      PopUp("layer 1 (Navigation)")
    } Else If(num = 2){
      PopUp("layer 2 (Function)")
    } Else If(num = 3){
      PopUp("layer 3 (Num pad)")
    }
  } Else{
    If(num = 0){
      SplashImage, layer0.png
    } Else If(num = 1){
      SplashImage, layer1.png
    } Else If(num = 2){
      SplashImage, layer2.png
    } Else If(num = 3){
      SplashImage, layer3.png
    }
    SetTimer, RemoveSplash, -2000
  }
}
return

; all layer
; LControl = layer 0 (Normal)
; LShift = layer 1 (Navigation)
; RShift = layer 2 (Function), 3 (Numpad)
; normal http www.keyboard-layout-editor.com  


CapsLock::LControl

$LControl:: ; short tap trigger
  Send,{LControl Down} 
  KeyWait, LControl, t0.15 ; t0.x = short click time
  If ErrorLevel  {
    KeyWait, LControl
  }
  Else If(A_PriorKey = "LControl") { ;check prior key
    SetLayer(0)
  }
  Send,{LControl Up}
  Return

$Lshift:: ; short tap trigger
  Send,{Lshift Down} 
  KeyWait, Lshift, t0.1 ; t0.x = short click time
  If ErrorLevel  {
    KeyWait, Lshift
  }
  Else If(A_PriorKey = "LShift") { ;check prior key
    SetLayer(1)
  }
  Send,{Lshift Up}
  Return

$Rshift:: ; short tap trigger
  Send,{Rshift Down} 
  KeyWait, Rshift, t0.2 ; t0.x = short click time
  If ErrorLevel  {
    KeyWait, Rshift
  }
  Else If(A_PriorKey = "Rshift") { ;check prior key
    If (kbd_layer!=2) {
      SetLayer(2)
    }
    Else{
      SetLayer(3)
    }
  }
  Send,{Rshift Up}
  Return




;//////////////////////////////////////////////////////////////
; layer 1 commands
;//////////////////////////////////////////////////////////////
#If kbd_layer=1
  !u::LButton
  !o::RButton
  !p::MButton
  !y::WheelUp
  !h::WheelDown
  
  !j:: ; left mouse
  !i:: ; up
  !k:: ; down
  !l:: ; right
  global mouse_move_last
  global mouse_move_distance
  mouse_move_interval := A_TickCount - mouse_move_last
  ;ToolTip, %mouse_move_distance% . %mouse_move_last% . %mouse_move_interval%
  If(mouse_move_interval < 100)   {
    if(mouse_move_distance  < mouse_move_max_distance){
      mouse_move_distance := (mouse_move_max_distance-mouse_move_distance)*mouse_move_accelation_ratio + mouse_move_distance  
    }
  } Else{
    mouse_move_distance := mouse_move_distance_start
  }
    
  mouse_move_x := GetKeyState("l","P")*mouse_move_distance -GetKeyState("j","P")*mouse_move_distance 
  mouse_move_y := GetKeyState("k","P")*mouse_move_distance -GetKeyState("i","P")*mouse_move_distance 
  MouseMove, %mouse_move_x%, %mouse_move_y% , 0, R
  mouse_move_last := A_TickCount
  return
  
  e::=
  s::*
  d::/
  r::-
  f::+
  t::(
  g::)
  
  i::Up
  k::Down
  j::Left
  l::Right
  y::Home
  u::End
  9::PgUp
  o::PgDn 
  7::PrintScreen
  h::Backspace
  n::Delete
  m::AppsKey
  
  q::Escape
  '::Escape


return ; end kbd_layer= 1

;//////////////////////////////////////////////////////////////
; layer 2 commands
;//////////////////////////////////////////////////////////////

#If kbd_layer=2
q::F1
w::F2
e::F3
r::F4
t::F5
y::F6
u::F7
i::F8
o::F9
p::F10
[::F11
]::F12

a::1
s::2
d::3
f::4
g::5
h::6
j::7
k::8
l::9
SC027::0 ; ';' key
'::Escape

z::`
x::
c::
v::
b::(
n::)
m::-
,::=
.::|

return ; end kbd_layer= 2


;//////////////////////////////////////////////////////////////
; layer 3 commands
;//////////////////////////////////////////////////////////////

#If kbd_layer=3
8::NumpadDiv
9::NumpadMult
0::NumpadSub
u::Numpad7
i::Numpad8
o::Numpad9
p::NumpadAdd
j::Numpad4
k::Numpad5
l::Numpad6
SC027::NumpadEnter ; ';' key
m::Numpad1
,::Numpad2
.::Numpad3
/::NumpadDot
Space::Numpad0

return ; end kbd_layer= 3
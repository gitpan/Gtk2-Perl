package Gtk2::Gdk::Gdk;

# $Id: Gdk.pm,v 1.3 2003/02/16 11:38:09 gthyni Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Gdk.pm,v 1.3 2003/02/16 11:38:09 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

# Event types.
# *   Nothing: No event occurred.
# *   Delete: A window delete event was sent by the window manager.
# *	     The specified window should be deleted.
# *   Destroy: A window has been destroyed.
# *   Expose: Part of a window has been uncovered.
# *   NoExpose: Same as expose, but no expose event was generated.
# *   VisibilityNotify: A window has become fully/partially/not obscured.
# *   MotionNotify: The mouse has moved.
# *   ButtonPress: A mouse button was pressed.
# *   ButtonRelease: A mouse button was release.
# *   KeyPress: A key was pressed.
# *   KeyRelease: A key was released.
# *   EnterNotify: A window was entered.
# *   LeaveNotify: A window was exited.
# *   FocusChange: The focus window has changed. (The focus window gets
# *		  keyboard events).
# *   Resize: A window has been resized.
## *   Map: A window has been mapped. (It is now visible on the screen).
# *   Unmap: A window has been unmapped. (It is no longer visible on
# *	    the screen).
# *   Scroll: A mouse wheel was scrolled either up or down.
sub NOTHING { 'nothing' }
sub DELETE { 'delete' }
sub _DESTROY { 'destroy' }
sub EXPOSE { 'expose' }
sub MOTION_NOTIFY { 'motion-notify' }
sub BUTTON_PRESS { 'button-press' }
sub _2BUTTON_PRESS { '2button-press' }
sub _3BUTTON_PRESS { '3button-press' }
sub BUTTON_RELEASE { 'button-release' }
sub KEY_PRESS { 'key-press' }
sub KEY_RELEASE { 'key-release' }
sub ENTER_NOTIFY { 'enter-notify' }
sub LEAVE_NOTIFY { 'leave-notify' }
sub FOCUS_CHANGE { 'focus-change' }
sub CONFIGURE { 'configure' }
sub MAP { 'map' }
sub UNMAP { 'unmap' }
sub PROPERTY_NOTIFY { 'property-notify' }
sub SELECTION_CLEAR { 'selection-clear' }
sub SELECTION_REQUEST { 'selection-request' }
sub SELECTION_NOTIFY { 'selection-notify' }
sub PROXIMITY_IN { 'proximity-in' }
sub PROXIMITY_OUT { 'proximity-out' }
sub DRAG_ENTER { 'drag-enter' }
sub DRAG_LEAVE { 'drag-leave' }
sub DRAG_MOTION { 'drag-motion' }
sub DRAG_STATUS { 'drag-status' }
sub DROP_START { 'drop-start' }
sub DROP_FINISHED { 'drop-finished' }
sub CLIENT_EVENT { 'client-event' }
sub VISIBILITY_NOTIFY { 'visibility-notify' }
sub NO_EXPOSE { 'no-expose' }
sub SCROLL { 'scroll' }
sub WINDOW_STATE { 'window-state' }
sub SETTING { 'setting' }
# GdkEventType;

# Event masks. (Used to select what types of events a window will receive).
sub EXPOSURE_MASK { 'exposure-mask' }
sub POINTER_MOTION_MASK { 'pointer-motion-mask' }
sub POINTER_MOTION_HINT_MASK { 'pointer-motion-hint-mask' }
sub BUTTON_MOTION_MASK { 'button-motion-mask' }
sub BUTTON1_MOTION_MASK { 'button1-motion-mask' }
sub BUTTON2_MOTION_MASK { 'button2-motion-mask' }
sub BUTTON3_MOTION_MASK { 'button3-motion-mask' }
sub BUTTON_PRESS_MASK { 'button-press-mask' }
sub BUTTON_RELEASE_MASK { 'button-release-mask' }
sub KEY_PRESS_MASK { 'key-press-mask' }
sub KEY_RELEASE_MASK { 'key-release-mask' }
sub ENTER_NOTIFY_MASK { 'enter-notify-mask' }
sub LEAVE_NOTIFY_MASK { 'leave-notify-mask' }
sub FOCUS_CHANGE_MASK { 'focus-change-mask' }
sub STRUCTURE_MASK { 'structure-mask' }
sub PROPERTY_CHANGE_MASK { 'property-change-mask' }
sub VISIBILITY_NOTIFY_MASK { 'visibility-notify-mask' }
sub PROXIMITY_IN_MASK { 'proximity-in-mask' }
sub PROXIMITY_OUT_MASK { 'proximity-out-mask' }
sub SUBSTRUCTURE_MASK { 'substructure-mask' }
sub SCROLL_MASK { 'scroll-mask' }
sub ALL_EVENTS_MASK { 'all-events-mask' }
# GdkEventMask;

# Cursor types.
sub X_CURSOR { 'x-cursor' }
sub ARROW { 'arrow' }
sub BASED_ARROW_DOWN { 'based-arrow-down' }
sub BASED_ARROW_UP { 'based-arrow-up' }
sub BOAT { 'boat' }
sub BOGOSITY { 'bogosity' }
sub BOTTOM_LEFT_CORNER { 'bottom-left-corner' }
sub BOTTOM_RIGHT_CORNER { 'bottom-right-corner' }
sub BOTTOM_SIDE { 'bottom-side' }
sub BOTTOM_TEE { 'bottom-tee' }
sub BOX_SPIRAL { 'box-spiral' }
sub CENTER_PTR { 'center-ptr' }
sub CIRCLE { 'circle' }
sub CLOCK { 'clock' }
sub COFFEE_MUG { 'coffee-mug' }
sub CROSS { 'cross' }
sub CROSS_REVERSE { 'cross-reverse' }
sub CROSSHAIR { 'crosshair' }
sub DIAMOND_CROSS { 'diamond-cross' }
sub DOT { 'dot' }
sub DOTBOX { 'dotbox' }
sub DOUBLE_ARROW { 'double-arrow' }
sub DRAFT_LARGE { 'draft-large' }
sub DRAFT_SMALL { 'draft-small' }
sub DRAPED_BOX { 'draped-box' }
sub EXCHANGE { 'exchange' }
sub FLEUR { 'fleur' }
sub GOBBLER { 'gobbler' }
sub GUMBY { 'gumby' }
sub HAND1 { 'hand1' }
sub HAND2 { 'hand2' }
sub HEART { 'heart' }
sub ICON { 'icon' }
sub IRON_CROSS { 'iron-cross' }
sub LEFT_PTR { 'left-ptr' }
sub LEFT_SIDE { 'left-side' }
sub LEFT_TEE { 'left-tee' }
sub LEFTBUTTON { 'leftbutton' }
sub LL_ANGLE { 'll-angle' }
sub LR_ANGLE { 'lr-angle' }
sub MAN { 'man' }
sub MIDDLEBUTTON { 'middlebutton' }
sub MOUSE { 'mouse' }
sub PENCIL { 'pencil' }
sub PIRATE { 'pirate' }
sub PLUS { 'plus' }
sub QUESTION_ARROW { 'question-arrow' }
sub RIGHT_PTR { 'right-ptr' }
sub RIGHT_SIDE { 'right-side' }
sub RIGHT_TEE { 'right-tee' }
sub RIGHTBUTTON { 'rightbutton' }
sub RTL_LOGO { 'rtl-logo' }
sub SAILBOAT { 'sailboat' }
sub SB_DOWN_ARROW { 'sb-down-arrow' }
sub SB_H_DOUBLE_ARROW { 'sb-h-double-arrow' }
sub SB_LEFT_ARROW { 'sb-left-arrow' }
sub SB_RIGHT_ARROW { 'sb-right-arrow' }
sub SB_UP_ARROW { 'sb-up-arrow' }
sub SB_V_DOUBLE_ARROW { 'sb-v-double-arrow' }
sub SHUTTLE { 'shuttle' }
sub SIZING { 'sizing' }
sub SPIDER { 'spider' }
sub SPRAYCAN { 'spraycan' }
sub STAR { 'star' }
sub TARGET { 'target' }
sub TCROSS { 'tcross' }
sub TOP_LEFT_ARROW { 'top-left-arrow' }
sub TOP_LEFT_CORNER { 'top-left-corner' }
sub TOP_RIGHT_CORNER { 'top-right-corner' }
sub TOP_SIDE { 'top-side' }
sub TOP_TEE { 'top-tee' }
sub TREK { 'trek' }
sub UL_ANGLE { 'ul-angle' }
sub UMBRELLA { 'umbrella' }
sub UR_ANGLE { 'ur-angle' }
sub WATCH { 'watch' }
sub XTERM { 'xterm' }
sub LAST_CURSOR { 'last-cursor' }
sub CURSOR_IS_PIXMAP { 'cursor-is-pixmap' }
# GdkCursorType;

# some common magic values
sub CURRENT_TIME     {0}
sub PARENT_RELATIVE  {1}

#define GDK_VoidSymbol 0xFFFFFF
#define GDK_BackSpace 0xFF08
#define GDK_Tab 0xFF09
#define GDK_Linefeed 0xFF0A
#define GDK_Clear 0xFF0B
#define GDK_Return 0xFF0D
#define GDK_Pause 0xFF13
#define GDK_Scroll_Lock 0xFF14
#define GDK_Sys_Req 0xFF15
#define GDK_Escape 0xFF1B
#define GDK_Delete 0xFFFF
#define GDK_Multi_key 0xFF20
#define GDK_Codeinput 0xFF37
#define GDK_SingleCandidate 0xFF3C
#define GDK_MultipleCandidate 0xFF3D
#define GDK_PreviousCandidate 0xFF3E
#define GDK_Kanji 0xFF21
#define GDK_Muhenkan 0xFF22
#define GDK_Henkan_Mode 0xFF23
#define GDK_Henkan 0xFF23
#define GDK_Romaji 0xFF24
#define GDK_Hiragana 0xFF25
#define GDK_Katakana 0xFF26
#define GDK_Hiragana_Katakana 0xFF27
#define GDK_Zenkaku 0xFF28
#define GDK_Hankaku 0xFF29
#define GDK_Zenkaku_Hankaku 0xFF2A
#define GDK_Touroku 0xFF2B
#define GDK_Massyo 0xFF2C
#define GDK_Kana_Lock 0xFF2D
#define GDK_Kana_Shift 0xFF2E
#define GDK_Eisu_Shift 0xFF2F
#define GDK_Eisu_toggle 0xFF30
#define GDK_Kanji_Bangou 0xFF37
#define GDK_Zen_Koho 0xFF3D
#define GDK_Mae_Koho 0xFF3E
#define GDK_Home 0xFF50
#define GDK_Left 0xFF51
#define GDK_Up 0xFF52
#define GDK_Right 0xFF53
#define GDK_Down 0xFF54
#define GDK_Prior 0xFF55
#define GDK_Page_Up 0xFF55
#define GDK_Next 0xFF56
#define GDK_Page_Down 0xFF56
#define GDK_End 0xFF57
#define GDK_Begin 0xFF58
#define GDK_Select 0xFF60
#define GDK_Print 0xFF61
#define GDK_Execute 0xFF62
#define GDK_Insert 0xFF63
#define GDK_Undo 0xFF65
#define GDK_Redo 0xFF66
#define GDK_Menu 0xFF67
#define GDK_Find 0xFF68
#define GDK_Cancel 0xFF69
#define GDK_Help 0xFF6A
#define GDK_Break 0xFF6B
#define GDK_Mode_switch 0xFF7E
#define GDK_script_switch 0xFF7E
#define GDK_Num_Lock 0xFF7F
#define GDK_KP_Space 0xFF80
#define GDK_KP_Tab 0xFF89
#define GDK_KP_Enter 0xFF8D
#define GDK_KP_F1 0xFF91
#define GDK_KP_F2 0xFF92
#define GDK_KP_F3 0xFF93
#define GDK_KP_F4 0xFF94
#define GDK_KP_Home 0xFF95
#define GDK_KP_Left 0xFF96
#define GDK_KP_Up 0xFF97
#define GDK_KP_Right 0xFF98
#define GDK_KP_Down 0xFF99
#define GDK_KP_Prior 0xFF9A
#define GDK_KP_Page_Up 0xFF9A
#define GDK_KP_Next 0xFF9B
#define GDK_KP_Page_Down 0xFF9B
#define GDK_KP_End 0xFF9C
#define GDK_KP_Begin 0xFF9D
#define GDK_KP_Insert 0xFF9E
#define GDK_KP_Delete 0xFF9F
#define GDK_KP_Equal 0xFFBD
#define GDK_KP_Multiply 0xFFAA
#define GDK_KP_Add 0xFFAB
#define GDK_KP_Separator 0xFFAC
#define GDK_KP_Subtract 0xFFAD
#define GDK_KP_Decimal 0xFFAE
#define GDK_KP_Divide 0xFFAF
#define GDK_KP_0 0xFFB0
#define GDK_KP_1 0xFFB1
#define GDK_KP_2 0xFFB2
#define GDK_KP_3 0xFFB3
#define GDK_KP_4 0xFFB4
#define GDK_KP_5 0xFFB5
#define GDK_KP_6 0xFFB6
#define GDK_KP_7 0xFFB7
#define GDK_KP_8 0xFFB8
#define GDK_KP_9 0xFFB9
use constant F1 => 0xFFBE;
use constant F2 => 0xFFBF;
use constant F3 => 0xFFC0;
use constant F4 => 0xFFC1;
use constant F5 => 0xFFC2;
use constant F6 => 0xFFC3;
use constant F7 => 0xFFC4;
use constant F8 => 0xFFC5;
use constant F9 => 0xFFC6;
use constant F10 => 0xFFC7;
use constant F11 => 0xFFC8;
use constant L1 => 0xFFC8;
use constant F12 => 0xFFC9;
use constant L2 => 0xFFC9;
use constant F13 => 0xFFCA;
use constant L3 => 0xFFCA;
use constant F14 => 0xFFCB;
use constant L4 => 0xFFCB;
use constant F15 => 0xFFCC;
use constant L5 => 0xFFCC;
use constant F16 => 0xFFCD;
use constant L6 => 0xFFCD;
use constant F17 => 0xFFCE;
use constant L7 => 0xFFCE;
use constant F18 => 0xFFCF;
use constant L8 => 0xFFCF;
use constant F19 => 0xFFD0;
use constant L9 => 0xFFD0;
use constant F20 => 0xFFD1;
use constant L10 => 0xFFD1;
use constant F21 => 0xFFD2;
use constant R1 => 0xFFD2;
use constant F22 => 0xFFD3;
use constant R2 => 0xFFD3;
use constant F23 => 0xFFD4;
use constant R3 => 0xFFD4;
use constant F24 => 0xFFD5;
use constant R4 => 0xFFD5;
use constant F25 => 0xFFD6;
use constant R5 => 0xFFD6;
use constant F26 => 0xFFD7;
use constant R6 => 0xFFD7;
use constant F27 => 0xFFD8;
use constant R7 => 0xFFD8;
use constant F28 => 0xFFD9;
use constant R8 => 0xFFD9;
use constant F29 => 0xFFDA;
use constant R9 => 0xFFDA;
use constant F30 => 0xFFDB;
use constant R10 => 0xFFDB;
use constant F31 => 0xFFDC;
use constant R11 => 0xFFDC;
use constant F32 => 0xFFDD;
use constant R12 => 0xFFDD;
use constant F33 => 0xFFDE;
use constant R13 => 0xFFDE;
use constant F34 => 0xFFDF;
use constant R14 => 0xFFDF;
use constant F35 => 0xFFE0;
#define GDK_R15 => 0xFFE0;
#define GDK_Shift_L 0xFFE1
#define GDK_Shift_R 0xFFE2
#define GDK_Control_L 0xFFE3
#define GDK_Control_R 0xFFE4
#define GDK_Caps_Lock 0xFFE5
#define GDK_Shift_Lock 0xFFE6
#define GDK_Meta_L 0xFFE7
#define GDK_Meta_R 0xFFE8
#define GDK_Alt_L 0xFFE9
#define GDK_Alt_R 0xFFEA
#define GDK_Super_L 0xFFEB
#define GDK_Super_R 0xFFEC
#define GDK_Hyper_L 0xFFED
#define GDK_Hyper_R 0xFFEE
#define GDK_ISO_Lock 0xFE01
#define GDK_ISO_Level2_Latch 0xFE02
#define GDK_ISO_Level3_Shift 0xFE03
#define GDK_ISO_Level3_Latch 0xFE04
#define GDK_ISO_Level3_Lock 0xFE05
#define GDK_ISO_Group_Shift 0xFF7E
#define GDK_ISO_Group_Latch 0xFE06
#define GDK_ISO_Group_Lock 0xFE07
#define GDK_ISO_Next_Group 0xFE08
#define GDK_ISO_Next_Group_Lock 0xFE09
#define GDK_ISO_Prev_Group 0xFE0A
#define GDK_ISO_Prev_Group_Lock 0xFE0B
#define GDK_ISO_First_Group 0xFE0C
#define GDK_ISO_First_Group_Lock 0xFE0D
#define GDK_ISO_Last_Group 0xFE0E
#define GDK_ISO_Last_Group_Lock 0xFE0F
#define GDK_ISO_Left_Tab 0xFE20
#define GDK_ISO_Move_Line_Up 0xFE21
#define GDK_ISO_Move_Line_Down 0xFE22
#define GDK_ISO_Partial_Line_Up 0xFE23
#define GDK_ISO_Partial_Line_Down 0xFE24
#define GDK_ISO_Partial_Space_Left 0xFE25
#define GDK_ISO_Partial_Space_Right 0xFE26
#define GDK_ISO_Set_Margin_Left 0xFE27
#define GDK_ISO_Set_Margin_Right 0xFE28
#define GDK_ISO_Release_Margin_Left 0xFE29
#define GDK_ISO_Release_Margin_Right 0xFE2A
#define GDK_ISO_Release_Both_Margins 0xFE2B
#define GDK_ISO_Fast_Cursor_Left 0xFE2C
#define GDK_ISO_Fast_Cursor_Right 0xFE2D
#define GDK_ISO_Fast_Cursor_Up 0xFE2E
#define GDK_ISO_Fast_Cursor_Down 0xFE2F
#define GDK_ISO_Continuous_Underline 0xFE30
#define GDK_ISO_Discontinuous_Underline 0xFE31
#define GDK_ISO_Emphasize 0xFE32
#define GDK_ISO_Center_Object 0xFE33
#define GDK_ISO_Enter 0xFE34
#define GDK_dead_grave 0xFE50
#define GDK_dead_acute 0xFE51
#define GDK_dead_circumflex 0xFE52
#define GDK_dead_tilde 0xFE53
#define GDK_dead_macron 0xFE54
#define GDK_dead_breve 0xFE55
#define GDK_dead_abovedot 0xFE56
#define GDK_dead_diaeresis 0xFE57
#define GDK_dead_abovering 0xFE58
#define GDK_dead_doubleacute 0xFE59
#define GDK_dead_caron 0xFE5A
#define GDK_dead_cedilla 0xFE5B
#define GDK_dead_ogonek 0xFE5C
#define GDK_dead_iota 0xFE5D
#define GDK_dead_voiced_sound 0xFE5E
#define GDK_dead_semivoiced_sound 0xFE5F
#define GDK_dead_belowdot 0xFE60
#define GDK_First_Virtual_Screen 0xFED0
#define GDK_Prev_Virtual_Screen 0xFED1
#define GDK_Next_Virtual_Screen 0xFED2
#define GDK_Last_Virtual_Screen 0xFED4
#define GDK_Terminate_Server 0xFED5
#define GDK_AccessX_Enable 0xFE70
#define GDK_AccessX_Feedback_Enable 0xFE71
#define GDK_RepeatKeys_Enable 0xFE72
#define GDK_SlowKeys_Enable 0xFE73
#define GDK_BounceKeys_Enable 0xFE74
#define GDK_StickyKeys_Enable 0xFE75
#define GDK_MouseKeys_Enable 0xFE76
#define GDK_MouseKeys_Accel_Enable 0xFE77
#define GDK_Overlay1_Enable 0xFE78
#define GDK_Overlay2_Enable 0xFE79
#define GDK_AudibleBell_Enable 0xFE7A
#define GDK_Pointer_Left 0xFEE0
#define GDK_Pointer_Right 0xFEE1
#define GDK_Pointer_Up 0xFEE2
#define GDK_Pointer_Down 0xFEE3
#define GDK_Pointer_UpLeft 0xFEE4
#define GDK_Pointer_UpRight 0xFEE5
#define GDK_Pointer_DownLeft 0xFEE6
#define GDK_Pointer_DownRight 0xFEE7
#define GDK_Pointer_Button_Dflt 0xFEE8
#define GDK_Pointer_Button1 0xFEE9
#define GDK_Pointer_Button2 0xFEEA
#define GDK_Pointer_Button3 0xFEEB
#define GDK_Pointer_Button4 0xFEEC
#define GDK_Pointer_Button5 0xFEED
#define GDK_Pointer_DblClick_Dflt 0xFEEE
#define GDK_Pointer_DblClick1 0xFEEF
#define GDK_Pointer_DblClick2 0xFEF0
#define GDK_Pointer_DblClick3 0xFEF1
#define GDK_Pointer_DblClick4 0xFEF2
#define GDK_Pointer_DblClick5 0xFEF3
#define GDK_Pointer_Drag_Dflt 0xFEF4
#define GDK_Pointer_Drag1 0xFEF5
#define GDK_Pointer_Drag2 0xFEF6
#define GDK_Pointer_Drag3 0xFEF7
#define GDK_Pointer_Drag4 0xFEF8
#define GDK_Pointer_Drag5 0xFEFD
#define GDK_Pointer_EnableKeys 0xFEF9
#define GDK_Pointer_Accelerate 0xFEFA
#define GDK_Pointer_DfltBtnNext 0xFEFB
#define GDK_Pointer_DfltBtnPrev 0xFEFC
#define GDK_3270_Duplicate 0xFD01
#define GDK_3270_FieldMark 0xFD02
#define GDK_3270_Right2 0xFD03
#define GDK_3270_Left2 0xFD04
#define GDK_3270_BackTab 0xFD05
#define GDK_3270_EraseEOF 0xFD06
#define GDK_3270_EraseInput 0xFD07
#define GDK_3270_Reset 0xFD08
#define GDK_3270_Quit 0xFD09
#define GDK_3270_PA1 0xFD0A
#define GDK_3270_PA2 0xFD0B
#define GDK_3270_PA3 0xFD0C
#define GDK_3270_Test 0xFD0D
#define GDK_3270_Attn 0xFD0E
#define GDK_3270_CursorBlink 0xFD0F
#define GDK_3270_AltCursor 0xFD10
#define GDK_3270_KeyClick 0xFD11
#define GDK_3270_Jump 0xFD12
#define GDK_3270_Ident 0xFD13
#define GDK_3270_Rule 0xFD14
#define GDK_3270_Copy 0xFD15
#define GDK_3270_Play 0xFD16
#define GDK_3270_Setup 0xFD17
#define GDK_3270_Record 0xFD18
#define GDK_3270_ChangeScreen 0xFD19
#define GDK_3270_DeleteWord 0xFD1A
#define GDK_3270_ExSelect 0xFD1B
#define GDK_3270_CursorSelect 0xFD1C
#define GDK_3270_PrintScreen 0xFD1D
#define GDK_3270_Enter 0xFD1E
#define GDK_space 0x020
#define GDK_exclam 0x021
#define GDK_quotedbl 0x022
#define GDK_numbersign 0x023
#define GDK_dollar 0x024
#define GDK_percent 0x025
#define GDK_ampersand 0x026
#define GDK_apostrophe 0x027
#define GDK_quoteright 0x027
#define GDK_parenleft 0x028
#define GDK_parenright 0x029
#define GDK_asterisk 0x02a
#define GDK_plus 0x02b
#define GDK_comma 0x02c
#define GDK_minus 0x02d
#define GDK_period 0x02e
#define GDK_slash 0x02f
#define GDK_0 0x030
#define GDK_1 0x031
#define GDK_2 0x032
#define GDK_3 0x033
#define GDK_4 0x034
#define GDK_5 0x035
#define GDK_6 0x036
#define GDK_7 0x037
#define GDK_8 0x038
#define GDK_9 0x039
#define GDK_colon 0x03a
#define GDK_semicolon 0x03b
#define GDK_less 0x03c
#define GDK_equal 0x03d
#define GDK_greater 0x03e
#define GDK_question 0x03f
#define GDK_at 0x040
#define GDK_A 0x041
#define GDK_B 0x042
#define GDK_C 0x043
#define GDK_D 0x044
#define GDK_E 0x045
#define GDK_F 0x046
#define GDK_G 0x047
#define GDK_H 0x048
#define GDK_I 0x049
#define GDK_J 0x04a
#define GDK_K 0x04b
#define GDK_L 0x04c
#define GDK_M 0x04d
#define GDK_N 0x04e
#define GDK_O 0x04f
#define GDK_P 0x050
#define GDK_Q 0x051
#define GDK_R 0x052
#define GDK_S 0x053
#define GDK_T 0x054
#define GDK_U 0x055
#define GDK_V 0x056
#define GDK_W 0x057
#define GDK_X 0x058
#define GDK_Y 0x059
#define GDK_Z 0x05a
#define GDK_bracketleft 0x05b
#define GDK_backslash 0x05c
#define GDK_bracketright 0x05d
#define GDK_asciicircum 0x05e
#define GDK_underscore 0x05f
#define GDK_grave 0x060
#define GDK_quoteleft 0x060
#define GDK_a 0x061
#define GDK_b 0x062
#define GDK_c 0x063
#define GDK_d 0x064
#define GDK_e 0x065
#define GDK_f 0x066
#define GDK_g 0x067
#define GDK_h 0x068
#define GDK_i 0x069
#define GDK_j 0x06a
#define GDK_k 0x06b
#define GDK_l 0x06c
#define GDK_m 0x06d
#define GDK_n 0x06e
#define GDK_o 0x06f
#define GDK_p 0x070
#define GDK_q 0x071
#define GDK_r 0x072
#define GDK_s 0x073
#define GDK_t 0x074
#define GDK_u 0x075
#define GDK_v 0x076
#define GDK_w 0x077
#define GDK_x 0x078
#define GDK_y 0x079
#define GDK_z 0x07a
#define GDK_braceleft 0x07b
#define GDK_bar 0x07c
#define GDK_braceright 0x07d
#define GDK_asciitilde 0x07e
#define GDK_nobreakspace 0x0a0
#define GDK_exclamdown 0x0a1
#define GDK_cent 0x0a2
#define GDK_sterling 0x0a3
#define GDK_currency 0x0a4
#define GDK_yen 0x0a5
#define GDK_brokenbar 0x0a6
#define GDK_section 0x0a7
#define GDK_diaeresis 0x0a8
#define GDK_copyright 0x0a9
#define GDK_ordfeminine 0x0aa
#define GDK_guillemotleft 0x0ab
#define GDK_notsign 0x0ac
#define GDK_hyphen 0x0ad
#define GDK_registered 0x0ae
#define GDK_macron 0x0af
#define GDK_degree 0x0b0
#define GDK_plusminus 0x0b1
#define GDK_twosuperior 0x0b2
#define GDK_threesuperior 0x0b3
#define GDK_acute 0x0b4
#define GDK_mu 0x0b5
#define GDK_paragraph 0x0b6
#define GDK_periodcentered 0x0b7
#define GDK_cedilla 0x0b8
#define GDK_onesuperior 0x0b9
#define GDK_masculine 0x0ba
#define GDK_guillemotright 0x0bb
#define GDK_onequarter 0x0bc
#define GDK_onehalf 0x0bd
#define GDK_threequarters 0x0be
#define GDK_questiondown 0x0bf
#define GDK_Agrave 0x0c0
#define GDK_Aacute 0x0c1
#define GDK_Acircumflex 0x0c2
#define GDK_Atilde 0x0c3
#define GDK_Adiaeresis 0x0c4
#define GDK_Aring 0x0c5
#define GDK_AE 0x0c6
#define GDK_Ccedilla 0x0c7
#define GDK_Egrave 0x0c8
#define GDK_Eacute 0x0c9
#define GDK_Ecircumflex 0x0ca
#define GDK_Ediaeresis 0x0cb
#define GDK_Igrave 0x0cc
#define GDK_Iacute 0x0cd
#define GDK_Icircumflex 0x0ce
#define GDK_Idiaeresis 0x0cf
#define GDK_ETH 0x0d0
#define GDK_Eth 0x0d0
#define GDK_Ntilde 0x0d1
#define GDK_Ograve 0x0d2
#define GDK_Oacute 0x0d3
#define GDK_Ocircumflex 0x0d4
#define GDK_Otilde 0x0d5
#define GDK_Odiaeresis 0x0d6
#define GDK_multiply 0x0d7
#define GDK_Ooblique 0x0d8
#define GDK_Ugrave 0x0d9
#define GDK_Uacute 0x0da
#define GDK_Ucircumflex 0x0db
#define GDK_Udiaeresis 0x0dc
#define GDK_Yacute 0x0dd
#define GDK_THORN 0x0de
#define GDK_Thorn 0x0de
#define GDK_ssharp 0x0df
#define GDK_agrave 0x0e0
#define GDK_aacute 0x0e1
#define GDK_acircumflex 0x0e2
#define GDK_atilde 0x0e3
#define GDK_adiaeresis 0x0e4
#define GDK_aring 0x0e5
#define GDK_ae 0x0e6
#define GDK_ccedilla 0x0e7
#define GDK_egrave 0x0e8
#define GDK_eacute 0x0e9
#define GDK_ecircumflex 0x0ea
#define GDK_ediaeresis 0x0eb
#define GDK_igrave 0x0ec
#define GDK_iacute 0x0ed
#define GDK_icircumflex 0x0ee
#define GDK_idiaeresis 0x0ef
#define GDK_eth 0x0f0
#define GDK_ntilde 0x0f1
#define GDK_ograve 0x0f2
#define GDK_oacute 0x0f3
#define GDK_ocircumflex 0x0f4
#define GDK_otilde 0x0f5
#define GDK_odiaeresis 0x0f6
#define GDK_division 0x0f7
#define GDK_oslash 0x0f8
#define GDK_ugrave 0x0f9
#define GDK_uacute 0x0fa
#define GDK_ucircumflex 0x0fb
#define GDK_udiaeresis 0x0fc
#define GDK_yacute 0x0fd
#define GDK_thorn 0x0fe
#define GDK_ydiaeresis 0x0ff
#define GDK_Aogonek 0x1a1
#define GDK_breve 0x1a2
#define GDK_Lstroke 0x1a3
#define GDK_Lcaron 0x1a5
#define GDK_Sacute 0x1a6
#define GDK_Scaron 0x1a9
#define GDK_Scedilla 0x1aa
#define GDK_Tcaron 0x1ab
#define GDK_Zacute 0x1ac
#define GDK_Zcaron 0x1ae
#define GDK_Zabovedot 0x1af
#define GDK_aogonek 0x1b1
#define GDK_ogonek 0x1b2
#define GDK_lstroke 0x1b3
#define GDK_lcaron 0x1b5
#define GDK_sacute 0x1b6
#define GDK_caron 0x1b7
#define GDK_scaron 0x1b9
#define GDK_scedilla 0x1ba
#define GDK_tcaron 0x1bb
#define GDK_zacute 0x1bc
#define GDK_doubleacute 0x1bd
#define GDK_zcaron 0x1be
#define GDK_zabovedot 0x1bf
#define GDK_Racute 0x1c0
#define GDK_Abreve 0x1c3
#define GDK_Lacute 0x1c5
#define GDK_Cacute 0x1c6
#define GDK_Ccaron 0x1c8
#define GDK_Eogonek 0x1ca
#define GDK_Ecaron 0x1cc
#define GDK_Dcaron 0x1cf
#define GDK_Dstroke 0x1d0
#define GDK_Nacute 0x1d1
#define GDK_Ncaron 0x1d2
#define GDK_Odoubleacute 0x1d5
#define GDK_Rcaron 0x1d8
#define GDK_Uring 0x1d9
#define GDK_Udoubleacute 0x1db
#define GDK_Tcedilla 0x1de
#define GDK_racute 0x1e0
#define GDK_abreve 0x1e3
#define GDK_lacute 0x1e5
#define GDK_cacute 0x1e6
#define GDK_ccaron 0x1e8
#define GDK_eogonek 0x1ea
#define GDK_ecaron 0x1ec
#define GDK_dcaron 0x1ef
#define GDK_dstroke 0x1f0
#define GDK_nacute 0x1f1
#define GDK_ncaron 0x1f2
#define GDK_odoubleacute 0x1f5
#define GDK_udoubleacute 0x1fb
#define GDK_rcaron 0x1f8
#define GDK_uring 0x1f9
#define GDK_tcedilla 0x1fe
#define GDK_abovedot 0x1ff
#define GDK_Hstroke 0x2a1
#define GDK_Hcircumflex 0x2a6
#define GDK_Iabovedot 0x2a9
#define GDK_Gbreve 0x2ab
#define GDK_Jcircumflex 0x2ac
#define GDK_hstroke 0x2b1
#define GDK_hcircumflex 0x2b6
#define GDK_idotless 0x2b9
#define GDK_gbreve 0x2bb
#define GDK_jcircumflex 0x2bc
#define GDK_Cabovedot 0x2c5
#define GDK_Ccircumflex 0x2c6
#define GDK_Gabovedot 0x2d5
#define GDK_Gcircumflex 0x2d8
#define GDK_Ubreve 0x2dd
#define GDK_Scircumflex 0x2de
#define GDK_cabovedot 0x2e5
#define GDK_ccircumflex 0x2e6
#define GDK_gabovedot 0x2f5
#define GDK_gcircumflex 0x2f8
#define GDK_ubreve 0x2fd
#define GDK_scircumflex 0x2fe
#define GDK_kra 0x3a2
#define GDK_kappa 0x3a2
#define GDK_Rcedilla 0x3a3
#define GDK_Itilde 0x3a5
#define GDK_Lcedilla 0x3a6
#define GDK_Emacron 0x3aa
#define GDK_Gcedilla 0x3ab
#define GDK_Tslash 0x3ac
#define GDK_rcedilla 0x3b3
#define GDK_itilde 0x3b5
#define GDK_lcedilla 0x3b6
#define GDK_emacron 0x3ba
#define GDK_gcedilla 0x3bb
#define GDK_tslash 0x3bc
#define GDK_ENG 0x3bd
#define GDK_eng 0x3bf
#define GDK_Amacron 0x3c0
#define GDK_Iogonek 0x3c7
#define GDK_Eabovedot 0x3cc
#define GDK_Imacron 0x3cf
#define GDK_Ncedilla 0x3d1
#define GDK_Omacron 0x3d2
#define GDK_Kcedilla 0x3d3
#define GDK_Uogonek 0x3d9
#define GDK_Utilde 0x3dd
#define GDK_Umacron 0x3de
#define GDK_amacron 0x3e0
#define GDK_iogonek 0x3e7
#define GDK_eabovedot 0x3ec
#define GDK_imacron 0x3ef
#define GDK_ncedilla 0x3f1
#define GDK_omacron 0x3f2
#define GDK_kcedilla 0x3f3
#define GDK_uogonek 0x3f9
#define GDK_utilde 0x3fd
#define GDK_umacron 0x3fe
#define GDK_OE 0x13bc
#define GDK_oe 0x13bd
#define GDK_Ydiaeresis 0x13be
#define GDK_overline 0x47e
#define GDK_kana_fullstop 0x4a1
#define GDK_kana_openingbracket 0x4a2
#define GDK_kana_closingbracket 0x4a3
#define GDK_kana_comma 0x4a4
#define GDK_kana_conjunctive 0x4a5
#define GDK_kana_middledot 0x4a5
#define GDK_kana_WO 0x4a6
#define GDK_kana_a 0x4a7
#define GDK_kana_i 0x4a8
#define GDK_kana_u 0x4a9
#define GDK_kana_e 0x4aa
#define GDK_kana_o 0x4ab
#define GDK_kana_ya 0x4ac
#define GDK_kana_yu 0x4ad
#define GDK_kana_yo 0x4ae
#define GDK_kana_tsu 0x4af
#define GDK_kana_tu 0x4af
#define GDK_prolongedsound 0x4b0
#define GDK_kana_A 0x4b1
#define GDK_kana_I 0x4b2
#define GDK_kana_U 0x4b3
#define GDK_kana_E 0x4b4
#define GDK_kana_O 0x4b5
#define GDK_kana_KA 0x4b6
#define GDK_kana_KI 0x4b7
#define GDK_kana_KU 0x4b8
#define GDK_kana_KE 0x4b9
#define GDK_kana_KO 0x4ba
#define GDK_kana_SA 0x4bb
#define GDK_kana_SHI 0x4bc
#define GDK_kana_SU 0x4bd
#define GDK_kana_SE 0x4be
#define GDK_kana_SO 0x4bf
#define GDK_kana_TA 0x4c0
#define GDK_kana_CHI 0x4c1
#define GDK_kana_TI 0x4c1
#define GDK_kana_TSU 0x4c2
#define GDK_kana_TU 0x4c2
#define GDK_kana_TE 0x4c3
#define GDK_kana_TO 0x4c4
#define GDK_kana_NA 0x4c5
#define GDK_kana_NI 0x4c6
#define GDK_kana_NU 0x4c7
#define GDK_kana_NE 0x4c8
#define GDK_kana_NO 0x4c9
#define GDK_kana_HA 0x4ca
#define GDK_kana_HI 0x4cb
#define GDK_kana_FU 0x4cc
#define GDK_kana_HU 0x4cc
#define GDK_kana_HE 0x4cd
#define GDK_kana_HO 0x4ce
#define GDK_kana_MA 0x4cf
#define GDK_kana_MI 0x4d0
#define GDK_kana_MU 0x4d1
#define GDK_kana_ME 0x4d2
#define GDK_kana_MO 0x4d3
#define GDK_kana_YA 0x4d4
#define GDK_kana_YU 0x4d5
#define GDK_kana_YO 0x4d6
#define GDK_kana_RA 0x4d7
#define GDK_kana_RI 0x4d8
#define GDK_kana_RU 0x4d9
#define GDK_kana_RE 0x4da
#define GDK_kana_RO 0x4db
#define GDK_kana_WA 0x4dc
#define GDK_kana_N 0x4dd
#define GDK_voicedsound 0x4de
#define GDK_semivoicedsound 0x4df
#define GDK_kana_switch 0xFF7E
#define GDK_Arabic_comma 0x5ac
#define GDK_Arabic_semicolon 0x5bb
#define GDK_Arabic_question_mark 0x5bf
#define GDK_Arabic_hamza 0x5c1
#define GDK_Arabic_maddaonalef 0x5c2
#define GDK_Arabic_hamzaonalef 0x5c3
#define GDK_Arabic_hamzaonwaw 0x5c4
#define GDK_Arabic_hamzaunderalef 0x5c5
#define GDK_Arabic_hamzaonyeh 0x5c6
#define GDK_Arabic_alef 0x5c7
#define GDK_Arabic_beh 0x5c8
#define GDK_Arabic_tehmarbuta 0x5c9
#define GDK_Arabic_teh 0x5ca
#define GDK_Arabic_theh 0x5cb
#define GDK_Arabic_jeem 0x5cc
#define GDK_Arabic_hah 0x5cd
#define GDK_Arabic_khah 0x5ce
#define GDK_Arabic_dal 0x5cf
#define GDK_Arabic_thal 0x5d0
#define GDK_Arabic_ra 0x5d1
#define GDK_Arabic_zain 0x5d2
#define GDK_Arabic_seen 0x5d3
#define GDK_Arabic_sheen 0x5d4
#define GDK_Arabic_sad 0x5d5
#define GDK_Arabic_dad 0x5d6
#define GDK_Arabic_tah 0x5d7
#define GDK_Arabic_zah 0x5d8
#define GDK_Arabic_ain 0x5d9
#define GDK_Arabic_ghain 0x5da
#define GDK_Arabic_tatweel 0x5e0
#define GDK_Arabic_feh 0x5e1
#define GDK_Arabic_qaf 0x5e2
#define GDK_Arabic_kaf 0x5e3
#define GDK_Arabic_lam 0x5e4
#define GDK_Arabic_meem 0x5e5
#define GDK_Arabic_noon 0x5e6
#define GDK_Arabic_ha 0x5e7
#define GDK_Arabic_heh 0x5e7
#define GDK_Arabic_waw 0x5e8
#define GDK_Arabic_alefmaksura 0x5e9
#define GDK_Arabic_yeh 0x5ea
#define GDK_Arabic_fathatan 0x5eb
#define GDK_Arabic_dammatan 0x5ec
#define GDK_Arabic_kasratan 0x5ed
#define GDK_Arabic_fatha 0x5ee
#define GDK_Arabic_damma 0x5ef
#define GDK_Arabic_kasra 0x5f0
#define GDK_Arabic_shadda 0x5f1
#define GDK_Arabic_sukun 0x5f2
#define GDK_Arabic_switch 0xFF7E
#define GDK_Serbian_dje 0x6a1
#define GDK_Macedonia_gje 0x6a2
#define GDK_Cyrillic_io 0x6a3
#define GDK_Ukrainian_ie 0x6a4
#define GDK_Ukranian_je 0x6a4
#define GDK_Macedonia_dse 0x6a5
#define GDK_Ukrainian_i 0x6a6
#define GDK_Ukranian_i 0x6a6
#define GDK_Ukrainian_yi 0x6a7
#define GDK_Ukranian_yi 0x6a7
#define GDK_Cyrillic_je 0x6a8
#define GDK_Serbian_je 0x6a8
#define GDK_Cyrillic_lje 0x6a9
#define GDK_Serbian_lje 0x6a9
#define GDK_Cyrillic_nje 0x6aa
#define GDK_Serbian_nje 0x6aa
#define GDK_Serbian_tshe 0x6ab
#define GDK_Macedonia_kje 0x6ac
#define GDK_Byelorussian_shortu 0x6ae
#define GDK_Cyrillic_dzhe 0x6af
#define GDK_Serbian_dze 0x6af
#define GDK_numerosign 0x6b0
#define GDK_Serbian_DJE 0x6b1
#define GDK_Macedonia_GJE 0x6b2
#define GDK_Cyrillic_IO 0x6b3
#define GDK_Ukrainian_IE 0x6b4
#define GDK_Ukranian_JE 0x6b4
#define GDK_Macedonia_DSE 0x6b5
#define GDK_Ukrainian_I 0x6b6
#define GDK_Ukranian_I 0x6b6
#define GDK_Ukrainian_YI 0x6b7
#define GDK_Ukranian_YI 0x6b7
#define GDK_Cyrillic_JE 0x6b8
#define GDK_Serbian_JE 0x6b8
#define GDK_Cyrillic_LJE 0x6b9
#define GDK_Serbian_LJE 0x6b9
#define GDK_Cyrillic_NJE 0x6ba
#define GDK_Serbian_NJE 0x6ba
#define GDK_Serbian_TSHE 0x6bb
#define GDK_Macedonia_KJE 0x6bc
#define GDK_Byelorussian_SHORTU 0x6be
#define GDK_Cyrillic_DZHE 0x6bf
#define GDK_Serbian_DZE 0x6bf
#define GDK_Cyrillic_yu 0x6c0
#define GDK_Cyrillic_a 0x6c1
#define GDK_Cyrillic_be 0x6c2
#define GDK_Cyrillic_tse 0x6c3
#define GDK_Cyrillic_de 0x6c4
#define GDK_Cyrillic_ie 0x6c5
#define GDK_Cyrillic_ef 0x6c6
#define GDK_Cyrillic_ghe 0x6c7
#define GDK_Cyrillic_ha 0x6c8
#define GDK_Cyrillic_i 0x6c9
#define GDK_Cyrillic_shorti 0x6ca
#define GDK_Cyrillic_ka 0x6cb
#define GDK_Cyrillic_el 0x6cc
#define GDK_Cyrillic_em 0x6cd
#define GDK_Cyrillic_en 0x6ce
#define GDK_Cyrillic_o 0x6cf
#define GDK_Cyrillic_pe 0x6d0
#define GDK_Cyrillic_ya 0x6d1
#define GDK_Cyrillic_er 0x6d2
#define GDK_Cyrillic_es 0x6d3
#define GDK_Cyrillic_te 0x6d4
#define GDK_Cyrillic_u 0x6d5
#define GDK_Cyrillic_zhe 0x6d6
#define GDK_Cyrillic_ve 0x6d7
#define GDK_Cyrillic_softsign 0x6d8
#define GDK_Cyrillic_yeru 0x6d9
#define GDK_Cyrillic_ze 0x6da
#define GDK_Cyrillic_sha 0x6db
#define GDK_Cyrillic_e 0x6dc
#define GDK_Cyrillic_shcha 0x6dd
#define GDK_Cyrillic_che 0x6de
#define GDK_Cyrillic_hardsign 0x6df
#define GDK_Cyrillic_YU 0x6e0
#define GDK_Cyrillic_A 0x6e1
#define GDK_Cyrillic_BE 0x6e2
#define GDK_Cyrillic_TSE 0x6e3
#define GDK_Cyrillic_DE 0x6e4
#define GDK_Cyrillic_IE 0x6e5
#define GDK_Cyrillic_EF 0x6e6
#define GDK_Cyrillic_GHE 0x6e7
#define GDK_Cyrillic_HA 0x6e8
#define GDK_Cyrillic_I 0x6e9
#define GDK_Cyrillic_SHORTI 0x6ea
#define GDK_Cyrillic_KA 0x6eb
#define GDK_Cyrillic_EL 0x6ec
#define GDK_Cyrillic_EM 0x6ed
#define GDK_Cyrillic_EN 0x6ee
#define GDK_Cyrillic_O 0x6ef
#define GDK_Cyrillic_PE 0x6f0
#define GDK_Cyrillic_YA 0x6f1
#define GDK_Cyrillic_ER 0x6f2
#define GDK_Cyrillic_ES 0x6f3
#define GDK_Cyrillic_TE 0x6f4
#define GDK_Cyrillic_U 0x6f5
#define GDK_Cyrillic_ZHE 0x6f6
#define GDK_Cyrillic_VE 0x6f7
#define GDK_Cyrillic_SOFTSIGN 0x6f8
#define GDK_Cyrillic_YERU 0x6f9
#define GDK_Cyrillic_ZE 0x6fa
#define GDK_Cyrillic_SHA 0x6fb
#define GDK_Cyrillic_E 0x6fc
#define GDK_Cyrillic_SHCHA 0x6fd
#define GDK_Cyrillic_CHE 0x6fe
#define GDK_Cyrillic_HARDSIGN 0x6ff
#define GDK_Greek_ALPHAaccent 0x7a1
#define GDK_Greek_EPSILONaccent 0x7a2
#define GDK_Greek_ETAaccent 0x7a3
#define GDK_Greek_IOTAaccent 0x7a4
#define GDK_Greek_IOTAdiaeresis 0x7a5
#define GDK_Greek_OMICRONaccent 0x7a7
#define GDK_Greek_UPSILONaccent 0x7a8
#define GDK_Greek_UPSILONdieresis 0x7a9
#define GDK_Greek_OMEGAaccent 0x7ab
#define GDK_Greek_accentdieresis 0x7ae
#define GDK_Greek_horizbar 0x7af
#define GDK_Greek_alphaaccent 0x7b1
#define GDK_Greek_epsilonaccent 0x7b2
#define GDK_Greek_etaaccent 0x7b3
#define GDK_Greek_iotaaccent 0x7b4
#define GDK_Greek_iotadieresis 0x7b5
#define GDK_Greek_iotaaccentdieresis 0x7b6
#define GDK_Greek_omicronaccent 0x7b7
#define GDK_Greek_upsilonaccent 0x7b8
#define GDK_Greek_upsilondieresis 0x7b9
#define GDK_Greek_upsilonaccentdieresis 0x7ba
#define GDK_Greek_omegaaccent 0x7bb
#define GDK_Greek_ALPHA 0x7c1
#define GDK_Greek_BETA 0x7c2
#define GDK_Greek_GAMMA 0x7c3
#define GDK_Greek_DELTA 0x7c4
#define GDK_Greek_EPSILON 0x7c5
#define GDK_Greek_ZETA 0x7c6
#define GDK_Greek_ETA 0x7c7
#define GDK_Greek_THETA 0x7c8
#define GDK_Greek_IOTA 0x7c9
#define GDK_Greek_KAPPA 0x7ca
#define GDK_Greek_LAMDA 0x7cb
#define GDK_Greek_LAMBDA 0x7cb
#define GDK_Greek_MU 0x7cc
#define GDK_Greek_NU 0x7cd
#define GDK_Greek_XI 0x7ce
#define GDK_Greek_OMICRON 0x7cf
#define GDK_Greek_PI 0x7d0
#define GDK_Greek_RHO 0x7d1
#define GDK_Greek_SIGMA 0x7d2
#define GDK_Greek_TAU 0x7d4
#define GDK_Greek_UPSILON 0x7d5
#define GDK_Greek_PHI 0x7d6
#define GDK_Greek_CHI 0x7d7
#define GDK_Greek_PSI 0x7d8
#define GDK_Greek_OMEGA 0x7d9
#define GDK_Greek_alpha 0x7e1
#define GDK_Greek_beta 0x7e2
#define GDK_Greek_gamma 0x7e3
#define GDK_Greek_delta 0x7e4
#define GDK_Greek_epsilon 0x7e5
#define GDK_Greek_zeta 0x7e6
#define GDK_Greek_eta 0x7e7
#define GDK_Greek_theta 0x7e8
#define GDK_Greek_iota 0x7e9
#define GDK_Greek_kappa 0x7ea
#define GDK_Greek_lamda 0x7eb
#define GDK_Greek_lambda 0x7eb
#define GDK_Greek_mu 0x7ec
#define GDK_Greek_nu 0x7ed
#define GDK_Greek_xi 0x7ee
#define GDK_Greek_omicron 0x7ef
#define GDK_Greek_pi 0x7f0
#define GDK_Greek_rho 0x7f1
#define GDK_Greek_sigma 0x7f2
#define GDK_Greek_finalsmallsigma 0x7f3
#define GDK_Greek_tau 0x7f4
#define GDK_Greek_upsilon 0x7f5
#define GDK_Greek_phi 0x7f6
#define GDK_Greek_chi 0x7f7
#define GDK_Greek_psi 0x7f8
#define GDK_Greek_omega 0x7f9
#define GDK_Greek_switch 0xFF7E
#define GDK_leftradical 0x8a1
#define GDK_topleftradical 0x8a2
#define GDK_horizconnector 0x8a3
#define GDK_topintegral 0x8a4
#define GDK_botintegral 0x8a5
#define GDK_vertconnector 0x8a6
#define GDK_topleftsqbracket 0x8a7
#define GDK_botleftsqbracket 0x8a8
#define GDK_toprightsqbracket 0x8a9
#define GDK_botrightsqbracket 0x8aa
#define GDK_topleftparens 0x8ab
#define GDK_botleftparens 0x8ac
#define GDK_toprightparens 0x8ad
#define GDK_botrightparens 0x8ae
#define GDK_leftmiddlecurlybrace 0x8af
#define GDK_rightmiddlecurlybrace 0x8b0
#define GDK_topleftsummation 0x8b1
#define GDK_botleftsummation 0x8b2
#define GDK_topvertsummationconnector 0x8b3
#define GDK_botvertsummationconnector 0x8b4
#define GDK_toprightsummation 0x8b5
#define GDK_botrightsummation 0x8b6
#define GDK_rightmiddlesummation 0x8b7
#define GDK_lessthanequal 0x8bc
#define GDK_notequal 0x8bd
#define GDK_greaterthanequal 0x8be
#define GDK_integral 0x8bf
#define GDK_therefore 0x8c0
#define GDK_variation 0x8c1
#define GDK_infinity 0x8c2
#define GDK_nabla 0x8c5
#define GDK_approximate 0x8c8
#define GDK_similarequal 0x8c9
#define GDK_ifonlyif 0x8cd
#define GDK_implies 0x8ce
#define GDK_identical 0x8cf
#define GDK_radical 0x8d6
#define GDK_includedin 0x8da
#define GDK_includes 0x8db
#define GDK_intersection 0x8dc
#define GDK_union 0x8dd
#define GDK_logicaland 0x8de
#define GDK_logicalor 0x8df
#define GDK_partialderivative 0x8ef
#define GDK_function 0x8f6
#define GDK_leftarrow 0x8fb
#define GDK_uparrow 0x8fc
#define GDK_rightarrow 0x8fd
#define GDK_downarrow 0x8fe
#define GDK_blank 0x9df
#define GDK_soliddiamond 0x9e0
#define GDK_checkerboard 0x9e1
#define GDK_ht 0x9e2
#define GDK_ff 0x9e3
#define GDK_cr 0x9e4
#define GDK_lf 0x9e5
#define GDK_nl 0x9e8
#define GDK_vt 0x9e9
#define GDK_lowrightcorner 0x9ea
#define GDK_uprightcorner 0x9eb
#define GDK_upleftcorner 0x9ec
#define GDK_lowleftcorner 0x9ed
#define GDK_crossinglines 0x9ee
#define GDK_horizlinescan1 0x9ef
#define GDK_horizlinescan3 0x9f0
#define GDK_horizlinescan5 0x9f1
#define GDK_horizlinescan7 0x9f2
#define GDK_horizlinescan9 0x9f3
#define GDK_leftt 0x9f4
#define GDK_rightt 0x9f5
#define GDK_bott 0x9f6
#define GDK_topt 0x9f7
#define GDK_vertbar 0x9f8
#define GDK_emspace 0xaa1
#define GDK_enspace 0xaa2
#define GDK_em3space 0xaa3
#define GDK_em4space 0xaa4
#define GDK_digitspace 0xaa5
#define GDK_punctspace 0xaa6
#define GDK_thinspace 0xaa7
#define GDK_hairspace 0xaa8
#define GDK_emdash 0xaa9
#define GDK_endash 0xaaa
#define GDK_signifblank 0xaac
#define GDK_ellipsis 0xaae
#define GDK_doubbaselinedot 0xaaf
#define GDK_onethird 0xab0
#define GDK_twothirds 0xab1
#define GDK_onefifth 0xab2
#define GDK_twofifths 0xab3
#define GDK_threefifths 0xab4
#define GDK_fourfifths 0xab5
#define GDK_onesixth 0xab6
#define GDK_fivesixths 0xab7
#define GDK_careof 0xab8
#define GDK_figdash 0xabb
#define GDK_leftanglebracket 0xabc
#define GDK_decimalpoint 0xabd
#define GDK_rightanglebracket 0xabe
#define GDK_marker 0xabf
#define GDK_oneeighth 0xac3
#define GDK_threeeighths 0xac4
#define GDK_fiveeighths 0xac5
#define GDK_seveneighths 0xac6
#define GDK_trademark 0xac9
#define GDK_signaturemark 0xaca
#define GDK_trademarkincircle 0xacb
#define GDK_leftopentriangle 0xacc
#define GDK_rightopentriangle 0xacd
#define GDK_emopencircle 0xace
#define GDK_emopenrectangle 0xacf
#define GDK_leftsinglequotemark 0xad0
#define GDK_rightsinglequotemark 0xad1
#define GDK_leftdoublequotemark 0xad2
#define GDK_rightdoublequotemark 0xad3
#define GDK_prescription 0xad4
#define GDK_minutes 0xad6
#define GDK_seconds 0xad7
#define GDK_latincross 0xad9
#define GDK_hexagram 0xada
#define GDK_filledrectbullet 0xadb
#define GDK_filledlefttribullet 0xadc
#define GDK_filledrighttribullet 0xadd
#define GDK_emfilledcircle 0xade
#define GDK_emfilledrect 0xadf
#define GDK_enopencircbullet 0xae0
#define GDK_enopensquarebullet 0xae1
#define GDK_openrectbullet 0xae2
#define GDK_opentribulletup 0xae3
#define GDK_opentribulletdown 0xae4
#define GDK_openstar 0xae5
#define GDK_enfilledcircbullet 0xae6
#define GDK_enfilledsqbullet 0xae7
#define GDK_filledtribulletup 0xae8
#define GDK_filledtribulletdown 0xae9
#define GDK_leftpointer 0xaea
#define GDK_rightpointer 0xaeb
#define GDK_club 0xaec
#define GDK_diamond 0xaed
#define GDK_heart 0xaee
#define GDK_maltesecross 0xaf0
#define GDK_dagger 0xaf1
#define GDK_doubledagger 0xaf2
#define GDK_checkmark 0xaf3
#define GDK_ballotcross 0xaf4
#define GDK_musicalsharp 0xaf5
#define GDK_musicalflat 0xaf6
#define GDK_malesymbol 0xaf7
#define GDK_femalesymbol 0xaf8
#define GDK_telephone 0xaf9
#define GDK_telephonerecorder 0xafa
#define GDK_phonographcopyright 0xafb
#define GDK_caret 0xafc
#define GDK_singlelowquotemark 0xafd
#define GDK_doublelowquotemark 0xafe
#define GDK_cursor 0xaff
#define GDK_leftcaret 0xba3
#define GDK_rightcaret 0xba6
#define GDK_downcaret 0xba8
#define GDK_upcaret 0xba9
#define GDK_overbar 0xbc0
#define GDK_downtack 0xbc2
#define GDK_upshoe 0xbc3
#define GDK_downstile 0xbc4
#define GDK_underbar 0xbc6
#define GDK_jot 0xbca
#define GDK_quad 0xbcc
#define GDK_uptack 0xbce
#define GDK_circle 0xbcf
#define GDK_upstile 0xbd3
#define GDK_downshoe 0xbd6
#define GDK_rightshoe 0xbd8
#define GDK_leftshoe 0xbda
#define GDK_lefttack 0xbdc
#define GDK_righttack 0xbfc
#define GDK_hebrew_doublelowline 0xcdf
#define GDK_hebrew_aleph 0xce0
#define GDK_hebrew_bet 0xce1
#define GDK_hebrew_beth 0xce1
#define GDK_hebrew_gimel 0xce2
#define GDK_hebrew_gimmel 0xce2
#define GDK_hebrew_dalet 0xce3
#define GDK_hebrew_daleth 0xce3
#define GDK_hebrew_he 0xce4
#define GDK_hebrew_waw 0xce5
#define GDK_hebrew_zain 0xce6
#define GDK_hebrew_zayin 0xce6
#define GDK_hebrew_chet 0xce7
#define GDK_hebrew_het 0xce7
#define GDK_hebrew_tet 0xce8
#define GDK_hebrew_teth 0xce8
#define GDK_hebrew_yod 0xce9
#define GDK_hebrew_finalkaph 0xcea
#define GDK_hebrew_kaph 0xceb
#define GDK_hebrew_lamed 0xcec
#define GDK_hebrew_finalmem 0xced
#define GDK_hebrew_mem 0xcee
#define GDK_hebrew_finalnun 0xcef
#define GDK_hebrew_nun 0xcf0
#define GDK_hebrew_samech 0xcf1
#define GDK_hebrew_samekh 0xcf1
#define GDK_hebrew_ayin 0xcf2
#define GDK_hebrew_finalpe 0xcf3
#define GDK_hebrew_pe 0xcf4
#define GDK_hebrew_finalzade 0xcf5
#define GDK_hebrew_finalzadi 0xcf5
#define GDK_hebrew_zade 0xcf6
#define GDK_hebrew_zadi 0xcf6
#define GDK_hebrew_qoph 0xcf7
#define GDK_hebrew_kuf 0xcf7
#define GDK_hebrew_resh 0xcf8
#define GDK_hebrew_shin 0xcf9
#define GDK_hebrew_taw 0xcfa
#define GDK_hebrew_taf 0xcfa
#define GDK_Hebrew_switch 0xFF7E
#define GDK_Thai_kokai 0xda1
#define GDK_Thai_khokhai 0xda2
#define GDK_Thai_khokhuat 0xda3
#define GDK_Thai_khokhwai 0xda4
#define GDK_Thai_khokhon 0xda5
#define GDK_Thai_khorakhang 0xda6
#define GDK_Thai_ngongu 0xda7
#define GDK_Thai_chochan 0xda8
#define GDK_Thai_choching 0xda9
#define GDK_Thai_chochang 0xdaa
#define GDK_Thai_soso 0xdab
#define GDK_Thai_chochoe 0xdac
#define GDK_Thai_yoying 0xdad
#define GDK_Thai_dochada 0xdae
#define GDK_Thai_topatak 0xdaf
#define GDK_Thai_thothan 0xdb0
#define GDK_Thai_thonangmontho 0xdb1
#define GDK_Thai_thophuthao 0xdb2
#define GDK_Thai_nonen 0xdb3
#define GDK_Thai_dodek 0xdb4
#define GDK_Thai_totao 0xdb5
#define GDK_Thai_thothung 0xdb6
#define GDK_Thai_thothahan 0xdb7
#define GDK_Thai_thothong 0xdb8
#define GDK_Thai_nonu 0xdb9
#define GDK_Thai_bobaimai 0xdba
#define GDK_Thai_popla 0xdbb
#define GDK_Thai_phophung 0xdbc
#define GDK_Thai_fofa 0xdbd
#define GDK_Thai_phophan 0xdbe
#define GDK_Thai_fofan 0xdbf
#define GDK_Thai_phosamphao 0xdc0
#define GDK_Thai_moma 0xdc1
#define GDK_Thai_yoyak 0xdc2
#define GDK_Thai_rorua 0xdc3
#define GDK_Thai_ru 0xdc4
#define GDK_Thai_loling 0xdc5
#define GDK_Thai_lu 0xdc6
#define GDK_Thai_wowaen 0xdc7
#define GDK_Thai_sosala 0xdc8
#define GDK_Thai_sorusi 0xdc9
#define GDK_Thai_sosua 0xdca
#define GDK_Thai_hohip 0xdcb
#define GDK_Thai_lochula 0xdcc
#define GDK_Thai_oang 0xdcd
#define GDK_Thai_honokhuk 0xdce
#define GDK_Thai_paiyannoi 0xdcf
#define GDK_Thai_saraa 0xdd0
#define GDK_Thai_maihanakat 0xdd1
#define GDK_Thai_saraaa 0xdd2
#define GDK_Thai_saraam 0xdd3
#define GDK_Thai_sarai 0xdd4
#define GDK_Thai_saraii 0xdd5
#define GDK_Thai_saraue 0xdd6
#define GDK_Thai_sarauee 0xdd7
#define GDK_Thai_sarau 0xdd8
#define GDK_Thai_sarauu 0xdd9
#define GDK_Thai_phinthu 0xdda
#define GDK_Thai_maihanakat_maitho 0xdde
#define GDK_Thai_baht 0xddf
#define GDK_Thai_sarae 0xde0
#define GDK_Thai_saraae 0xde1
#define GDK_Thai_sarao 0xde2
#define GDK_Thai_saraaimaimuan 0xde3
#define GDK_Thai_saraaimaimalai 0xde4
#define GDK_Thai_lakkhangyao 0xde5
#define GDK_Thai_maiyamok 0xde6
#define GDK_Thai_maitaikhu 0xde7
#define GDK_Thai_maiek 0xde8
#define GDK_Thai_maitho 0xde9
#define GDK_Thai_maitri 0xdea
#define GDK_Thai_maichattawa 0xdeb
#define GDK_Thai_thanthakhat 0xdec
#define GDK_Thai_nikhahit 0xded
#define GDK_Thai_leksun 0xdf0
#define GDK_Thai_leknung 0xdf1
#define GDK_Thai_leksong 0xdf2
#define GDK_Thai_leksam 0xdf3
#define GDK_Thai_leksi 0xdf4
#define GDK_Thai_lekha 0xdf5
#define GDK_Thai_lekhok 0xdf6
#define GDK_Thai_lekchet 0xdf7
#define GDK_Thai_lekpaet 0xdf8
#define GDK_Thai_lekkao 0xdf9
#define GDK_Hangul 0xff31
#define GDK_Hangul_Start 0xff32
#define GDK_Hangul_End 0xff33
#define GDK_Hangul_Hanja 0xff34
#define GDK_Hangul_Jamo 0xff35
#define GDK_Hangul_Romaja 0xff36
#define GDK_Hangul_Codeinput 0xff37
#define GDK_Hangul_Jeonja 0xff38
#define GDK_Hangul_Banja 0xff39
#define GDK_Hangul_PreHanja 0xff3a
#define GDK_Hangul_PostHanja 0xff3b
#define GDK_Hangul_SingleCandidate 0xff3c
#define GDK_Hangul_MultipleCandidate 0xff3d
#define GDK_Hangul_PreviousCandidate 0xff3e
#define GDK_Hangul_Special 0xff3f
#define GDK_Hangul_switch 0xFF7E
#define GDK_Hangul_Kiyeog 0xea1
#define GDK_Hangul_SsangKiyeog 0xea2
#define GDK_Hangul_KiyeogSios 0xea3
#define GDK_Hangul_Nieun 0xea4
#define GDK_Hangul_NieunJieuj 0xea5
#define GDK_Hangul_NieunHieuh 0xea6
#define GDK_Hangul_Dikeud 0xea7
#define GDK_Hangul_SsangDikeud 0xea8
#define GDK_Hangul_Rieul 0xea9
#define GDK_Hangul_RieulKiyeog 0xeaa
#define GDK_Hangul_RieulMieum 0xeab
#define GDK_Hangul_RieulPieub 0xeac
#define GDK_Hangul_RieulSios 0xead
#define GDK_Hangul_RieulTieut 0xeae
#define GDK_Hangul_RieulPhieuf 0xeaf
#define GDK_Hangul_RieulHieuh 0xeb0
#define GDK_Hangul_Mieum 0xeb1
#define GDK_Hangul_Pieub 0xeb2
#define GDK_Hangul_SsangPieub 0xeb3
#define GDK_Hangul_PieubSios 0xeb4
#define GDK_Hangul_Sios 0xeb5
#define GDK_Hangul_SsangSios 0xeb6
#define GDK_Hangul_Ieung 0xeb7
#define GDK_Hangul_Jieuj 0xeb8
#define GDK_Hangul_SsangJieuj 0xeb9
#define GDK_Hangul_Cieuc 0xeba
#define GDK_Hangul_Khieuq 0xebb
#define GDK_Hangul_Tieut 0xebc
#define GDK_Hangul_Phieuf 0xebd
#define GDK_Hangul_Hieuh 0xebe
#define GDK_Hangul_A 0xebf
#define GDK_Hangul_AE 0xec0
#define GDK_Hangul_YA 0xec1
#define GDK_Hangul_YAE 0xec2
#define GDK_Hangul_EO 0xec3
#define GDK_Hangul_E 0xec4
#define GDK_Hangul_YEO 0xec5
#define GDK_Hangul_YE 0xec6
#define GDK_Hangul_O 0xec7
#define GDK_Hangul_WA 0xec8
#define GDK_Hangul_WAE 0xec9
#define GDK_Hangul_OE 0xeca
#define GDK_Hangul_YO 0xecb
#define GDK_Hangul_U 0xecc
#define GDK_Hangul_WEO 0xecd
#define GDK_Hangul_WE 0xece
#define GDK_Hangul_WI 0xecf
#define GDK_Hangul_YU 0xed0
#define GDK_Hangul_EU 0xed1
#define GDK_Hangul_YI 0xed2
#define GDK_Hangul_I 0xed3
#define GDK_Hangul_J_Kiyeog 0xed4
#define GDK_Hangul_J_SsangKiyeog 0xed5
#define GDK_Hangul_J_KiyeogSios 0xed6
#define GDK_Hangul_J_Nieun 0xed7
#define GDK_Hangul_J_NieunJieuj 0xed8
#define GDK_Hangul_J_NieunHieuh 0xed9
#define GDK_Hangul_J_Dikeud 0xeda
#define GDK_Hangul_J_Rieul 0xedb
#define GDK_Hangul_J_RieulKiyeog 0xedc
#define GDK_Hangul_J_RieulMieum 0xedd
#define GDK_Hangul_J_RieulPieub 0xede
#define GDK_Hangul_J_RieulSios 0xedf
#define GDK_Hangul_J_RieulTieut 0xee0
#define GDK_Hangul_J_RieulPhieuf 0xee1
#define GDK_Hangul_J_RieulHieuh 0xee2
#define GDK_Hangul_J_Mieum 0xee3
#define GDK_Hangul_J_Pieub 0xee4
#define GDK_Hangul_J_PieubSios 0xee5
#define GDK_Hangul_J_Sios 0xee6
#define GDK_Hangul_J_SsangSios 0xee7
#define GDK_Hangul_J_Ieung 0xee8
#define GDK_Hangul_J_Jieuj 0xee9
#define GDK_Hangul_J_Cieuc 0xeea
#define GDK_Hangul_J_Khieuq 0xeeb
#define GDK_Hangul_J_Tieut 0xeec
#define GDK_Hangul_J_Phieuf 0xeed
#define GDK_Hangul_J_Hieuh 0xeee
#define GDK_Hangul_RieulYeorinHieuh 0xeef
#define GDK_Hangul_SunkyeongeumMieum 0xef0
#define GDK_Hangul_SunkyeongeumPieub 0xef1
#define GDK_Hangul_PanSios 0xef2
#define GDK_Hangul_KkogjiDalrinIeung 0xef3
#define GDK_Hangul_SunkyeongeumPhieuf 0xef4
#define GDK_Hangul_YeorinHieuh 0xef5
#define GDK_Hangul_AraeA 0xef6
#define GDK_Hangul_AraeAE 0xef7
#define GDK_Hangul_J_PanSios 0xef8
#define GDK_Hangul_J_KkogjiDalrinIeung 0xef9
#define GDK_Hangul_J_YeorinHieuh 0xefa
#define GDK_Korean_Won 0xeff
#define GDK_EcuSign 0x20a0
#define GDK_ColonSign 0x20a1
#define GDK_CruzeiroSign 0x20a2
#define GDK_FFrancSign 0x20a3
#define GDK_LiraSign 0x20a4
#define GDK_MillSign 0x20a5
#define GDK_NairaSign 0x20a6
#define GDK_PesetaSign 0x20a7
#define GDK_RupeeSign 0x20a8
#define GDK_WonSign 0x20a9
#define GDK_NewSheqelSign 0x20aa
#define GDK_DongSign 0x20ab
#define GDK_EuroSign 0x20ac

1;

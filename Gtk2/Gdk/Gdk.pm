package Gtk2::Gdk::Gdk;

# $Id: Gdk.pm,v 1.1 2002/11/20 18:06:07 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Gdk.pm,v 1.1 2002/11/20 18:06:07 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

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

1;

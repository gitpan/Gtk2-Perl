package Gtk2::Gtk2;

# $Id: Gtk2.pm,v 1.2 2002/11/20 19:30:03 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt
# Contributor:
# - Dermot Musgrove

our $rcsid = '$Id: Gtk2.pm,v 1.2 2002/11/20 19:30:03 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use base qw(Gtk2::_Object);

#use constant TRUE  => 1;
#use constant FALSE => 0;

## enums ##

# GtkUpdateType
sub UPDATE_CONTINUOUS { 'continuous' }
sub UPDATE_DISCONTINUOUS { 'discontinuous' }
sub UPDATE_DELAYED { 'delayed' }

# GtkPositionType
sub POS_LEFT { 'left' }
sub POS_RIGHT { 'right' }
sub POS_TOP { 'top' }
sub POS_BOTTOM { 'bottom' }

# GtkJustification;
sub  JUSTIFY_LEFT   { 'left' }
sub  JUSTIFY_RIGHT  { 'right' }
sub  JUSTIFY_CENTER { 'center' }
sub  JUSTIFY_FILL   { 'fill' }

#/* Arrow types */
sub  ARROW_UP    { 'up' }
sub  ARROW_DOWN  { 'down' }
sub  ARROW_LEFT  { 'left' }
sub  ARROW_RIGHT { 'right' }
# GtkArrowType;

#/* Shadow types */
sub SHADOW_NONE { 'none' }
sub SHADOW_IN { 'in' }
sub SHADOW_OUT { 'out' }
sub SHADOW_ETCHED_IN { 'etched-in' }
sub SHADOW_ETCHED_OUT { 'etched-out' }
# GtkShadowType;

#/* Attach options (for tables) */
sub EXPAND { 'expand' }
sub SHRINK { 'shrink' }
sub FILL   { 'fill' }
# GtkAttachOptions;

# GtkMetricType;
sub PIXELS { 'pixels' }
sub INCHES { 'inches' }
sub CENTIMETERS { 'centimeters' }

# Window position types
sub WIN_POS_NONE   { 'none' }
sub WIN_POS_CENTER { 'center' }
sub WIN_POS_MOUSE  { 'mouse' }
sub WIN_POS_CENTER_ALWAYS    { 'center-always' }
sub WIN_POS_CENTER_ON_PARENT { 'center-on-parent' }
# GtkWindowPosition;

# Widget states
sub STATE_NORMAL      { 'normal' }
sub STATE_ACTIVE      { 'active' }
sub STATE_PRELIGHT    { 'prelight' }
sub STATE_SELECTED    { 'selected' }
sub STATE_INSENSITIVE { 'insensitive' }
# GtkStateType;

#/* Convenience enum to use for response_id's.  Positive values are
# * totally user-interpreted. GTK will sometimes return
# * GTK_RESPONSE_NONE if no response_id is available.
#   * GTK returns this if a response widget has no response_id,
#   * or if the dialog gets programmatically hidden or destroyed.
sub RESPONSE_NONE { 'none' }
#   * GTK won't return these unless you pass them in
#   * as the response for an action widget. They are
#   * for your convenience.
sub RESPONSE_REJECT { 'reject' }
sub RESPONSE_ACCEPT { 'accept' }
# If the dialog is deleted.
sub RESPONSE_DELETE_EVENT { 'delete-event' }
#   * These are returned from GTK dialogs, and you can also use them
#   * yourself if you like.
sub RESPONSE_OK     { 'ok' }
sub RESPONSE_CANCEL { 'cancel' }
sub RESPONSE_CLOSE  { 'close' }
sub RESPONSE_YES    { 'yes' }
sub RESPONSE_NO     { 'no' }
sub RESPONSE_APPLY  { 'apply' }
sub RESPONSE_HELP   { 'help' }
# GtkResponseType;

# Scrollbar policy types (for scrolled windows)
sub POLICY_ALWAYS    { 'always' }
sub POLICY_AUTOMATIC { 'automatic' }
sub POLICY_NEVER   { 'never' }
# GtkPolicyType;

# Orientation for toolbars, etc.
sub ORIENTATION_HORIZONTAL { 'horizontal' }
sub ORIENTATION_VERTICAL   { 'vertical' }
#} GtkOrientation;

# list selection modes
sub SELECTION_NONE	{ 'none' }
sub SELECTION_SINGLE	{ 'single' }
sub SELECTION_BROWSE	{ 'browse' }
sub SELECTION_MULTIPLE	{ 'multiple' }
# GtkSelectionMode

sub init
  {
    my ($class, $a) = @_;
    if (defined($a)) { unshift @$a, $0; }
    else { $a = [ $0 ]; }
    __PACKAGE__->_init($a);
    shift @$a; # remove $0 again
    @main::ARGV = @$a;
    1; # success
  }

sub init_check
  {
    my ($class, $a) = @_;
    if (defined($a)) { unshift @$a, $0; }
    else { $a = [ $0 ]; }
    my $ret = __PACKAGE__->_init_check($a);
    shift @$a; # remove $0 again
    @main::ARGV = @$a;
    $ret; # success
  }

sub timeout_add
  {
    my ($class, $interval, $func, $data) = @_;
    return Gtk2::GSignal->timeout_add($interval,$func,$data);
  }

sub timeout_remove
  {
    my ($class, $id) = @_;
    Gtk2::GSignal->timeout_remove($id);
  }

sub idle_add {
    my ($class, $func, $data) = @_;
    return Gtk2::GSignal->idle_add($func, $data);
}

sub idle_remove {
    my ($class, $id) = @_;
    Gtk2::GSignal->idle_remove($id);
}

#
# UTILITY FUNCTIONS
#

# create a standard main window fast
sub main_window
  {
    my ($class, $args) = @_;
    Gtk2->init(\@main::ARGV);
    my $w = Gtk2::Window->new('toplevel');
    # standard signals
    $w->signal_connect('destroy', sub {Gtk2->quit});
    $w->signal_connect('delete_event', sub {Gtk2->quit});
    # process args defining properties
    if (defined $args) {
      $w->set_title($args->{TITLE}) if $args->{TITLE};
      $w->set_border_width($args->{BORDER_WIDTH}) if $args->{BORDER_WIDTH};
    }
    $w;
  }

1;




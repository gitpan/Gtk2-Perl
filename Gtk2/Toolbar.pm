package Gtk2::Toolbar;

# $Id: Toolbar.pm,v 1.6 2003/01/16 21:24:02 joered Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Toolbar.pm,v 1.6 2003/01/16 21:24:02 joered Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Container;
@ISA=qw(Gtk2::Container);

use Gtk2::_Helpers;

# these is needed for most toolbars anyway
use Gtk2::Image;
use Gtk2::RadioButton;

#/* Style for toolbars */
sub ICONS { 'icons' }
sub TEXT  { 'text' }
sub BOTH  { 'both' }
sub BOTH_HORIZ { 'both-horiz' }
# GtkToolbarStyle;

# GtkToolbarChildType;
sub CHILD_SPACE        { 'space' }
sub CHILD_BUTTON       { 'button' }
sub CHILD_TOGGLEBUTTON { 'togglebutton' }
sub CHILD_RADIOBUTTON  { 'radiobutton' }
sub CHILD_WIDGET       { 'widget' }
# GtkToolbarChildType;


sub new {
    Gtk2::_Helpers::check_usage(\@_, [], [ 'string orientation', 'string style' ]);
    my $obj = shift->_new;
    @_ and $obj->set_orientation($_[0]), $obj->set_style($_[1]);
    @_ or  $obj->set_orientation('horizontal'), $obj->set_style('both');
    return $obj;
}


# pass-thru, here for a reason"
sub append_item
  {
    my ($self, $text, $tooltip, $private, $icon, $callback, $user_data) = @_;
    my $new = $self->_append_item($text, $tooltip, $private, $icon);
    defined $callback and $new->signal_connect('clicked', $callback, $user_data);
    return $new;
  }

sub append_element
  {
    my ($self, $type, $widget, $text, $tooltip, $privat, $icon, $callback, $user_data) = @_;
    my $new = $self->_append_element($type, $widget, $text, $tooltip, $privat, $icon);
    defined $callback and $new->signal_connect('clicked', $callback, $user_data);
    return $new;
  }

1;




package Gtk2::Widget;

# $Id: Widget.pm,v 1.25 2002/11/21 15:35:51 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Widget.pm,v 1.25 2002/11/21 15:35:51 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Object;
@ISA=qw(Gtk2::Object);

use Gtk2::_Helpers;
use Gtk2::Gdk::Atom;


sub set_sensitive { $_[0]->set_property('sensitive', $_[1]) }
sub set_name { $_[0]->set_property('name', $_[1]) }
sub get_name { $_[0]->get_property('name') }

sub FLAGS {
    my ($self, $set) = @_;
    if (defined($set)) {
	$self->SET_FLAGS($set);
    } else {
	return $self->GET_FLAGS();
    }
}

sub STATE {
    my ($self, $set) = @_;
    if (defined($set)) {
	$self->set_state($set);
    } else {
	return $self->get_state();
    }
}


sub set_usize {
    Gtk2::_Helpers::deprecated('set_size_request', @_);
}


sub _flag_setget_wrap {
    my ($self, $flag_name, $set) = @_;
    if (defined($set)) {
	if ($set) {
	    $self->SET_FLAGS($flag_name);
	} else {
	    $self->UNSET_FLAGS($flag_name);
	}
    } else {
	(my $funcname = uc($flag_name)) =~ s/-/_/g;
	return $self->$funcname();
    }
}

sub can_default {
    my ($self, $set) = @_;
    _flag_setget_wrap($self, 'can-default', $set);
}

sub can_focus {
    my ($self, $set) = @_;
    _flag_setget_wrap($self, 'can-focus', $set);
}


sub style_get {
    my $self = shift;
    my @values = map { $self->style_get_property($_) } @_;
    return wantarray ? @values : (@values == 1 ? $values[0] : \@values);
}


# PROPERTIES

#  "name"                 gchararray           : Read / Write
#  "parent"               GtkContainer         : Read / Write
#  "width-request"        gint                 : Read / Write
#  "height-request"       gint                 : Read / Write

#  "visible"              gboolean             : Read / Write
sub visible { shift->get_set('visible', @_); }

#  "sensitive"            gboolean             : Read / Write
#  "app-paintable"        gboolean             : Read / Write
#  "has-focus"            gboolean             : Read / Write
#  "is-focus"             gboolean             : Read / Write
#  "has-default"          gboolean             : Read / Write
#  "receives-default"     gboolean             : Read / Write
#  "composite-child"      gboolean             : Read

#  "style"                GtkStyle             : Read / Write
sub style {
  my $self = shift;
  @_ ? $self->set_style(@_) : $self->get_style;
}

#  "events"               GdkEventMask         : Read / Write
#  "extension-events"     GdkExtensionMode     : Read / Write

1;

package Gtk2::Window;

# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Window.pm,v 1.20 2002/11/23 13:39:02 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use base qw(Gtk2::Bin);


## PROPERTIES
# NOT IMPLEMENTED YET:
#  "type"                 GtkWindowType        : Read / Write / Construct Only
#  "screen"               GdkScreen            : Read / Write
#  "type-hint"            GdkWindowTypeHint    : Read / Write
#  "window-position"      GtkWindowPosition    : Read / Write
#  "icon"                 GdkPixbuf            : Read / Write

# AUTOCREATE PROPERTY ACCESS:
for my $prop (qw(allow-grow allow-shrink default-height default-width destroy-with-parent has-top-level-focus icon is-active modal resizable title window-position))
  {
    my $field = $prop;
    $field =~ s/\-/_/g;
    *$field = sub { shift->get_set($prop, @_) };
  }

sub get_size {
    my $values = shift->_get_size();
    return wantarray ? @$values : $values;
}

sub get_default_size {
    my $values = shift->_get_default_size();
    return wantarray ? @$values : $values;
}

sub get_position {
    my $values = shift->_get_position();
    return wantarray ? @$values : $values;
}

sub get_frame_dimensions {
    my $values = shift->_get_frame_dimensions();
    return wantarray ? @$values : $values;
}

1;



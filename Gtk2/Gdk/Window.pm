package Gtk2::Gdk::Window;

# $Id: Window.pm,v 1.11 2002/12/17 11:01:05 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Window.pm,v 1.11 2002/12/17 11:01:05 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Gdk::Drawable;
@ISA = qw(Gtk2::Gdk::Drawable);

sub at_pointer {
    my $values = shift->_at_pointer;
    return wantarray ? @$values : $values;
}

sub new_foreign {
    Gtk2::_Helpers::deprecated('foreign_new', @_);
}

sub get_pointer {
    my $values = shift->_get_pointer;
    return wantarray ? @$values : $values;
}

sub get_geometry {
    my $values = shift->_get_geometry;
    return wantarray ? @$values : $values;
}

sub get_position {
    my $values = shift->_get_position;
    return wantarray ? @$values : $values;
}

sub get_origin {
    my $values = shift->_get_origin;
    return wantarray ? @$values : $values;
}

sub get_root_origin {
    my $values = shift->_get_root_origin;
    return wantarray ? @$values : $values;
}
    
1;




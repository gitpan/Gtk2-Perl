package Gtk2::Gdk::Atom;

# $Id: Atom.pm,v 1.4 2002/12/16 17:24:06 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Atom.pm,v 1.4 2002/12/16 17:24:06 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

sub FALSE {0}

sub intern
  {
    my ($self, $name, $flag) = @_;
    $self->_intern($name, defined $flag ? $flag : FALSE);
  }

1;




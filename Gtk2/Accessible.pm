package Gtk2::Accessible;

# $Id: Accessible.pm,v 1.2 2002/12/16 17:06:08 ggc Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Accessible.pm,v 1.2 2002/12/16 17:06:08 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Atk::Object;
@ISA=qw(Gtk2::Atk::Object);

1;



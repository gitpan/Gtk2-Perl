package Gtk2::Invisible;

# $Id: Invisible.pm,v 1.3 2002/12/16 17:20:27 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Invisible.pm,v 1.3 2002/12/16 17:20:27 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Widget;
@ISA=qw(Gtk2::Widget);


1;

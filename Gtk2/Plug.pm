package Gtk2::Plug;

# $Id: Plug.pm,v 1.3 2002/12/16 17:21:11 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Plug.pm,v 1.3 2002/12/16 17:21:11 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Window;
@ISA=qw(Gtk2::Window);


1;


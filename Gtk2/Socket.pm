package Gtk2::Socket;

# $Id: Socket.pm,v 1.2 2002/12/02 21:45:30 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Socket.pm,v 1.2 2002/12/02 21:45:30 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Container;
@ISA=qw(Gtk2::Container);

1;

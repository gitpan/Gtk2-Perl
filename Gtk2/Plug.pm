package Gtk2::Plug;

# $Id: Plug.pm,v 1.2 2002/12/02 21:45:29 ggc Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Plug.pm,v 1.2 2002/12/02 21:45:29 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Window;
@ISA=qw(Gtk2::Window);


1;


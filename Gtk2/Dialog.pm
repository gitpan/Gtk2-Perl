package Gtk2::Dialog;

# $Id: Dialog.pm,v 1.8 2002/12/16 17:12:43 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Dialog.pm,v 1.8 2002/12/16 17:12:43 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Window;
@ISA = qw(Gtk2::Window);

1;



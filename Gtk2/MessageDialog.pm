package Gtk2::MessageDialog;

# $Id: MessageDialog.pm,v 1.2 2002/12/16 17:20:54 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: MessageDialog.pm,v 1.2 2002/12/16 17:20:54 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Dialog;
@ISA = qw(Gtk2::Dialog);


1;



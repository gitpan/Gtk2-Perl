package Gtk2::FontSelectionDialog;

# $Id: FontSelectionDialog.pm,v 1.6 2002/12/16 17:14:37 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: FontSelectionDialog.pm,v 1.6 2002/12/16 17:14:37 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Dialog;
@ISA = qw(Gtk2::Dialog);

1;



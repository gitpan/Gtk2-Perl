package Gtk2::ColorSelectionDialog;

# $Id: ColorSelectionDialog.pm,v 1.7 2002/12/16 17:10:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ColorSelectionDialog.pm,v 1.7 2002/12/16 17:10:21 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Dialog;
@ISA = qw(Gtk2::Dialog);

use Gtk2::ColorSelection;
use Gtk2::Gdk::Color;

1;



package Gtk2::Progress;

# $Id: Progress.pm,v 1.7 2002/12/16 17:21:27 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Progress.pm,v 1.7 2002/12/16 17:21:27 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Widget;
@ISA = qw(Gtk2::Widget);


# GtkProgressBarOrientation;
sub LEFT_TO_RIGHT { 'left-to-right' }
sub RIGHT_TO_LEFT { 'right-to-left' }
sub BOTTOM_TO_TOP { 'bottom-to-top' }
sub TOP_TO_BOTTOM { 'top-to-bottom' }


1;

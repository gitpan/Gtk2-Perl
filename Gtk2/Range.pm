package Gtk2::Range;

# $Id: Range.pm,v 1.7 2003/02/11 11:42:44 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Range.pm,v 1.7 2003/02/11 11:42:44 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Widget;
@ISA = qw(Gtk2::Widget);

1;

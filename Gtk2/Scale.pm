package Gtk2::Scale;

# $Id: Scale.pm,v 1.6 2002/12/16 17:21:50 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Scale.pm,v 1.6 2002/12/16 17:21:50 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Range;
@ISA=qw(Gtk2::Range);


1;

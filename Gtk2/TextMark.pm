package Gtk2::TextMark;

# $Id: TextMark.pm,v 1.4 2003/03/04 12:25:39 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TextMark.pm,v 1.4 2003/03/04 12:25:39 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use base qw(Gtk2::GObject);


1;


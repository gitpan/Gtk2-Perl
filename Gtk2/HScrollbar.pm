package Gtk2::HScrollbar;

# $Id: HScrollbar.pm,v 1.3 2002/12/16 17:19:09 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: HScrollbar.pm,v 1.3 2002/12/16 17:19:09 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }


use Gtk2::Scrollbar;
@ISA=qw(Gtk2::Scrollbar);


1;


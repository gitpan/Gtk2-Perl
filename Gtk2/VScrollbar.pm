package Gtk2::VScrollbar;

# $Id: VScrollbar.pm,v 1.3 2002/12/16 17:23:52 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: VScrollbar.pm,v 1.3 2002/12/16 17:23:52 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }


use Gtk2::Scrollbar;
@ISA=qw(Gtk2::Scrollbar);


1;


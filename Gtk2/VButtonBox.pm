package Gtk2::VButtonBox;

# $Id: VButtonBox.pm,v 1.3 2002/12/16 17:23:42 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: VButtonBox.pm,v 1.3 2002/12/16 17:23:42 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }


use Gtk2::ButtonBox;
@ISA=qw(Gtk2::ButtonBox);


1;




package Gtk2::Bin;

# $Id: Bin.pm,v 1.5 2002/12/16 17:07:01 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Bin.pm,v 1.5 2002/12/16 17:07:01 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Container;
@ISA=qw(Gtk2::Container);

sub child { shift->get_child }

1;


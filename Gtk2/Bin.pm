package Gtk2::Bin;

# $Id: Bin.pm,v 1.4 2002/11/26 13:46:47 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Bin.pm,v 1.4 2002/11/26 13:46:47 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Container;
@ISA=qw(Gtk2::Container);

sub child { shift->get_child }

1;


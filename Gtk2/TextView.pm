package Gtk2::TextView;

# $Id: TextView.pm,v 1.6 2002/12/16 17:22:53 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TextView.pm,v 1.6 2002/12/16 17:22:53 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Container;
@ISA=qw(Gtk2::Container);

use Gtk2::TextBuffer;


1;




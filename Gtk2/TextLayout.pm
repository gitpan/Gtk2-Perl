package Gtk2::TextLayout;

# $Id: TextLayout.pm,v 1.3 2002/12/16 17:22:43 ggc Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TextLayout.pm,v 1.3 2002/12/16 17:22:43 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::GObject;
@ISA=qw(Gtk2::GObject);


1;


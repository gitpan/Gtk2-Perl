package Gtk2::FontSelection;

# $Id: FontSelection.pm,v 1.3 2002/12/16 17:14:40 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: FontSelection.pm,v 1.3 2002/12/16 17:14:40 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::VBox;
@ISA = qw(Gtk2::VBox);

#sub get_font {
#    Gtk2::_Helpers::deprecated('get_font', @_);
#}


1;



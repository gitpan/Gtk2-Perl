package Gtk2::TextBuffer;

# $Id: TextBuffer.pm,v 1.9 2002/11/12 18:43:41 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TextBuffer.pm,v 1.9 2002/11/12 18:43:41 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::GObject;
@ISA=qw(Gtk2::GObject);

use Gtk2::TextIter;
use Gtk2::TextTag;

sub get_bounds {
    my $b = shift->_get_bounds();
    return wantarray ? @$b : $b;
}

1;


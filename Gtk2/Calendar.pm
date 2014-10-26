package Gtk2::Calendar;

# $Id: Calendar.pm,v 1.8 2002/12/16 17:08:08 ggc Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Calendar.pm,v 1.8 2002/12/16 17:08:08 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Widget;
@ISA=qw(Gtk2::Widget);

sub get_date
{
  my $a = shift->_get_date;
  wantarray ? @$a : $a;
}

1;


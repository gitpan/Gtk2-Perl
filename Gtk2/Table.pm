package Gtk2::Table;

# $Id: Table.pm,v 1.7 2003/01/16 21:24:02 joered Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Table.pm,v 1.7 2003/01/16 21:24:02 joered Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Container;
@ISA=qw(Gtk2::Container);

sub new
  {
    my $class = shift;
    @_ == 2 ? $class->_new (@_, 0) :
              $class->_new (@_);
  }

1;




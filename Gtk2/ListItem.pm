package Gtk2::ListItem;

# $Id: ListItem.pm,v 1.6 2002/11/20 20:42:53 gthyni Exp $
# Copyright 2002, Marin Purgar
# licensed under Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ListItem.pm,v 1.6 2002/11/20 20:42:53 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use base qw(Gtk2::Item);

sub new
  {
    my ($class, $label) = @_;
    defined $label ? $class->new_with_label($label) : $class->_new;
  }
1;

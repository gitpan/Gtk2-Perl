package Gtk2::CheckMenuItem;

# $Id: CheckMenuItem.pm,v 1.3 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: CheckMenuItem.pm,v 1.3 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::MenuItem;
@ISA=qw(Gtk2::MenuItem);

sub active
  {
    my ($self, $flag) = @_;
    my $ret = $self->get_active;
    $self->set_active($flag) if defined $flag;
    $ret;
  }

1;


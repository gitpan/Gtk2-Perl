package Gtk2::Box;

# $Id: Box.pm,v 1.7 2002/12/16 17:07:31 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Box.pm,v 1.7 2002/12/16 17:07:31 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Container;
@ISA=qw(Gtk2::Container);

sub children {
    my $values = shift->_children;
    return wantarray ? @$values : $values;
}

sub query_child_packing {
    my ($self, $child) = @_;
    my $values = $self->_query_child_packing($child);
    return wantarray ? @$values : $values;
}


1;




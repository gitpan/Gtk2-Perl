package Gtk2::Frame;

# $Id: Frame.pm,v 1.7 2002/11/12 20:29:23 gthyni Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Frame.pm,v 1.7 2002/11/12 20:29:23 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Bin;
@ISA= qw( Gtk2::Bin );

sub new
{
shift->_new(@_ ? @_ : undef);
}
sub get_label_align {
    my ($o) = @_;
    my $s = $o->_get_label_align();
    return wantarray ? @$s : $s;
}

1;


package Gtk2::Rc;

# $Id: Rc.pm,v 1.2 2002/11/27 19:46:39 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Rc.pm,v 1.2 2002/11/27 19:46:39 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

# not a GObject
use Gtk2::_Object;
@ISA=qw(Gtk2::_Object);

# should be 3 classes RcSet RcFile RcContext ??

sub set_default_files {
    my ($self, $file, @more) = @_;
    $self->_set_default_files(ref($file) eq 'ARRAY' ? $file : [ $file, @more ]);
}

sub get_default_files {
    my $values = shift->_get_default_files;
    return wantarray ? @$values : $values;
}

1;

package Gtk2::TreeModel;

# $Id: TreeModel.pm,v 1.7 2002/11/21 19:55:14 borup Exp $
# Copyright 2002, Christian Borup <borup@users.sourceforge.net>
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TreeModel.pm,v 1.7 2002/11/21 19:55:14 borup Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::GObject;
@ISA= qw(Gtk2::GObject);

sub get {
    my $model= shift;
    my $iter= shift;
    $iter= $model->get_iter($iter) if $iter->isa("Gtk2::TreePath"); # mush be free'd
    my @q= map { $model->_get($iter, $_) } @_; # this should be moved to C
    return wantarray ? @q : $q[0];
}


# --- helper functions

# gets the string representation of a TreeIter
sub get_path_str {
    my ($self, $iter) = @_;
    my $path = $self->get_path($iter);
    $path or return;
    my $path_str = $path->to_string;
    $path->free;
    return $path_str;
}

1;


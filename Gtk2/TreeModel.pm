package Gtk2::TreeModel;

# $Id: TreeModel.pm,v 1.11 2003/02/11 12:05:50 ggc Exp $
# Copyright 2002, Christian Borup <borup@users.sourceforge.net>
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TreeModel.pm,v 1.11 2003/02/11 12:05:50 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::GObject;
@ISA= qw(Gtk2::GObject);

sub get {
    my ($model, $iter) = splice @_, 0, 2;
    my $free;
    $free = $iter = $model->get_iter($iter) if $iter->isa("Gtk2::TreePath"); # mush be free'd
    my @q = map { $model->_get($iter, $_) } @_; # this should be moved to C
    $free->free if $free;
    return wantarray ? @q : $q[0];
}

sub get_iter_root { get_iter_first(@_) }


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


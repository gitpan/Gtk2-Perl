package Gtk2::TreeView;

# $Id: TreeView.pm,v 1.14 2003/01/08 17:03:30 ggc Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TreeView.pm,v 1.14 2003/01/08 17:03:30 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Container;
@ISA=qw(Gtk2::Container);

# Gtk2::TreeView::get_selection() returns a Gtk2::TreeSelection object...
use Gtk2::TreeSelection;
use Gtk2::TreeIter;
use Gtk2::TreePath;


sub get_cursor {
    my $values = shift->_get_cursor;
    return wantarray ? @$values : $values;
}

sub get_path_at_pos {
    my $values = shift->_get_path_at_pos(@_);
    return wantarray ? @$values : $values;
}

sub expand_to_path {
    Gtk2->CHECK_VERSION(2, 1, 0) or die "Gtk2::TreeView::expand_to_path not available in gtk+ versions < 2.1.0";
    _expand_to_path(@_);
}


# --- helper functions

# likewise gtk-1.2 function
sub toggle_expansion {
    my ($self, $path, $open_all) = @_;
    if ($self->row_expanded($path)) {
	$self->collapse_row($path);
    } else {
	$self->expand_row($path, $open_all || 0);
    }
}

1;

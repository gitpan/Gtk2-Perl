package Gtk2::TreeStore;

# Copyright (c) 2002 Guillaume Cottenceau (gc at mandrakesoft dot com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License
# version 2, as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

our $rcsid = '$Id: TreeStore.pm,v 1.7 2003/03/06 12:58:07 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::TreeModel;
@ISA = qw(Gtk2::TreeModel);

use Gtk2::TreeIter;

sub new {
    my ($class, @more) = @_;
    if (ref($more[0]) eq 'ARRAY') {
	return $class->_new($more[0]);
    } else {
	return $class->_new([ @more ]);
    }
}


# --- helper functions

# Append a new row, set the values, return the TreeIter
sub append_set {
    my ($model, $parent, $values) = @_;
    ref($values) eq 'ARRAY' or die 'Usage: $treestore->append_set(Gtk2::TreeIter $parent, ARRAYREF $values)';
    my $iter = Gtk2::TreeIter->new;
    $model->append($iter, $parent);
    $model->set($iter, $values);
    return $iter;
}
    

1;



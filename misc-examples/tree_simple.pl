#!/usr/bin/perl
#*****************************************************************************
# 
#  Copyright (c) 2002 Guillaume Cottenceau (gc at mandrakesoft dot com)
# 
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2, as
#  published by the Free Software Foundation.
# 
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
# 
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# $Id: tree_simple.pl,v 1.2 2002/11/26 10:14:22 gthyni Exp $
#
#*****************************************************************************

use Gtk2;

Gtk2->init(\@ARGV);

# tried to select hardware manufacturers known to be linux friendly :)
@all = ({ parent => 'Epson',  values => [ 'Stylus', 'Aculaser', 'Perfection' ] },
	{ parent => '3com',   values => [ 'Tornado', 'Vortex', 'Boomerang', 'Cyclone' ] },
	{ parent => 'Gravis', values => [ 'Ultrasound', 'Ultrasound max' ] });

@parents  = map { $_->{parent} } @all;
@children = map { my $p = $_->{parent}; map { { parent => $p, value => $_ } } @{$_->{values}} } @all;


$tree_model = Gtk2::TreeStore->new(Gtk2::GType->STRING);
$tree = Gtk2::TreeView->new_with_model($tree_model);
$tree->append_column(Gtk2::TreeViewColumn->new_with_attributes('Hardware listing', Gtk2::CellRendererText->new, 'text' => 0));
foreach (@parents) {
    my $iter = Gtk2::TreeIter->new;
    $tree_model->append($iter, undef);
    $tree_model->set($iter, [ 0 => $_ ]);
    $parents_iterators{$_} = $iter;
}

my $iter = Gtk2::TreeIter->new;
foreach (@children) {
    $tree_model->append($iter, $parents_iterators{$_->{parent}});
    $tree_model->set($iter, [ 0 => $_->{value} ]);
}
$iter->free;


my $window = Gtk2::Window->new('toplevel');
$window->set_position('center');
$window->signal_connect("delete_event", sub { Gtk2->quit });

$window->add($tree);
$window->show_all();

Gtk2->main();

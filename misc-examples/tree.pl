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
#*****************************************************************************

use strict;

use Gtk2;

Gtk2->init(\@ARGV);


my $window = Gtk2::Window->new('toplevel');
$window->set_position('center');

my $tree_view = Gtk2::TreeView->new();

my $model = Gtk2::TreeStore->new(Gtk2::GType->STRING);


my $iter = Gtk2::TreeIter->new();

foreach (1..5) {
	$model->append($iter, undef);
	$model->set($iter, [0 => "Item #$_"]);
}

my $cell = Gtk2::CellRendererText->new();
my $column = Gtk2::TreeViewColumn->new_with_attributes("Text", $cell, 'text' => 0);
$tree_view->append_column($column);


my $parent = $model->get_iter_from_string('3');
$model->append($iter, $parent);
$model->set($iter, [0 => "Child Item to '3'"]);

$parent = $model->get_iter_from_string('3:0');
$model->append($iter, $parent);
$model->set($iter, [0 => "Child Item to '3:0' (depth is ".$model->iter_depth($iter).") (2 was expected)"]);

$parent = $model->get_iter_from_string('3');
$model->append($iter, $parent);
$model->set($iter, [0 => "Child Item n. 2 to '3'"]);

$model->insert($iter, undef, 2);
$model->set($iter, [0 => "Inserted Item at position 2"]);

$model->prepend($iter, undef);
$model->set($iter, [0 => "Prepended Item"]);

$tree_view->set_model($model);

$iter->free();
$parent->free();

my $path = Gtk2::TreePath->new_from_string('5');
$tree_view->expand_row($path, 1);
$path->down();
$path->next();
$path->down();
printf "After going 'down' 'next' 'down', the path which was '5' is now '%s'\n", join(':', $path->get_indices());
while (!($iter = $model->get_iter($path))) {
    printf "Argh, %s is not an existing path... going up.\n", join(':', $path->get_indices());
    $path->up();
}
printf "The value here (%s) is: %s\n", join(':', $path->get_indices()), $model->get($iter, 0);
my $path2 = Gtk2::TreePath->new_from_string('5');
printf "Path's %s and %s compare to the value %d.\n", $path2->to_string(), $path->to_string(), $path2->compare($path);

my $vb = Gtk2::VBox->new(0, 0);
$vb->pack_start($tree_view, 1, 1, 0);
my $b = Gtk2::Button->new("traverse tree");
$b->signal_connect('clicked', sub { $model->foreach(sub { print "traversed ", $_[0]->get($_[2], 0), "\n"; 0 }, undef) });
$vb->pack_start($b, 0, 0, 0);
$window->add($vb);
$window->show_all();
$tree_view->get_selection()->select_path($path);

$iter->free();
$path->free();
$path2->free();

Gtk2->main();

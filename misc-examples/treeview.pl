#!/usr/bin/perl -w

# $Id: treeview.pl,v 1.9 2003/01/08 17:15:30 ggc Exp $
# Copyright 2002, Christian Borup <borup@users.sourceforge.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License
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
#

use warnings;
use strict;
use Gtk2;

Gtk2->init(\@ARGV);

$|= 1;

my $model = Gtk2::ListStore->new(Gtk2::GType->INT, Gtk2::GType->STRING);
my $iter = Gtk2::TreeIter->new;

for(1..10) {
	$model->append($iter);
	# this works now - Göran rocks
	$model->set($iter, [0 => $_, 1 => "Item #$_"]);
}

$iter->free();

my $window = Gtk2::Window->new('toplevel');
$window->signal_connect("destroy", sub { Gtk2->quit }, undef);

my $tree_view = Gtk2::TreeView->new;
$tree_view->set_model($model);
$tree_view->signal_connect(button_press_event => \&button_press_handler);

# And now this works too - Martin rocks also :-)
my $selection= $tree_view->get_selection();
print "selection mode: " . ($selection->get_mode()||"undef") . "\n";
$selection->set_mode("multiple"); # doesn't work with $selection->get_selected()...
$selection->signal_connect("changed", \&changed_handler, undef);
$selection->set_select_function(sub {
				    my $v = $_[1]->get($_[2], 0);
				    $v =~ /4/ and print("Forbidding selection of element labelled '4'\n"), return 0;
				    return 1;
				}, undef);

my $cell = Gtk2::CellRendererText->new;
my $column = Gtk2::TreeViewColumn->new_with_attributes("No", $cell, 'text' => 0);
$tree_view->append_column($column);
my $column1 = Gtk2::TreeViewColumn->new_with_attributes("Text", $cell, 'text' => 1);
$tree_view->append_column($column1);
$tree_view->show;

$window->add($tree_view);
$window->show_all;
Gtk2->main;

0;

sub changed_handler {
	my($selection)= @_;

	print "selection changed\n";
	my($model, @q) = $selection->get_selected_rows();
	print "selection: " . join(", ", map { $model->get($_, 0) } @q) . "\n";
}

sub changed_handler_single {
	my($selection)= @_;

	my @q= $selection->get_selected();
	if(@q) {
		my($model,$iter)= @q;
		print "selection: " . $model->get($iter, 0) . "\n";
	} else {
		print "but nothing selected\n";
	}

}

sub button_press_handler {
    printf "button pressed on treeview, coordinates x:%d y:%d\n", $_[1]->x, $_[1]->y;
    my ($returns, $path, $col) = $tree_view->get_path_at_pos($_[1]->x, $_[1]->y);
    if ($returns) {
	printf "\ton the row of path: %s\n", $path->to_string;
	print  "\ton first column\n" if Gtk2->equals($col, $column);
	print  "\ton second column\n" if Gtk2->equals($col, $column1);
	$path->free;
    }
}

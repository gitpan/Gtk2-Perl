#!/usr/bin/perl -w

# $Id: list.pl,v 1.4 2002/11/12 22:32:10 gthyni Exp $
# Copyright 2002, Marin Purgar
# licensed under General Public License (GPL)
# see http://www.fsf.org/licenses/gpl.txt

use Gtk2;
use Data::Dumper;

sub FALSE { 0 }
sub TRUE  { 1 }

# Exit Button callback function
sub cbs_exit_demo{
    Gtk2->quit;
}

# Add Item Button callback function
sub cbs_add_item{
    my($widget, $data)=@_;

    my $list=$data->[0];
    my $itemnr=$data->[1];

    my $listitem=Gtk2::ListItem->new_with_label("List Item Nr. $$itemnr");
    $$itemnr++;
    $listitem->show;
    $list->append_items([$listitem]);
}

# Add 3 Items Button callback function
sub cbs_add_3_items{
    my($widget, $data)=@_;

    my $list=$data->[0];
    my $itemnr=$data->[1];

    my @items=();

    for my $i(0..2){
        my $listitem=Gtk2::ListItem->new_with_label("List Item Nr. $$itemnr");
        $$itemnr++;
        $listitem->show;
	push(@items, $listitem);
    }
    $list->append_items(\@items);
}

Gtk2->init(\@ARGV);

my $window = Gtk2::Window->new('toplevel');
$window->set_title('GtkList');

Gtk2::GSignal->connect($window, 'destroy', sub { Gtk2->quit; }, 0);
Gtk2::GSignal->connect($window, 'delete_event', sub { Gtk2->quit; }, 0);
$window->set_border_width(10);

my $main_box=Gtk2::VBox->new(FALSE, 0);

my $list=Gtk2::List->new();
for $itemnr (1..10){
    my $listitem=Gtk2::ListItem->new_with_label("List item Nr. $itemnr");
    $listitem->show;
    $list->append_items([$listitem]);
}
my $itemnr=11;
$list->show;

my $scrolled_win=Gtk2::ScrolledWindow->new(undef, undef);
$scrolled_win->show;

$scrolled_win->add_with_viewport($list);

my $button;

my $add_items_box=Gtk2::HBox->new(FALSE, 0);

$button = Gtk2::Button->new_with_label('Add Item');
Gtk2::GSignal->connect($button, 'clicked', \&cbs_add_item, [$list, \$itemnr]);
$button->show;
$add_items_box->pack_start($button, TRUE, TRUE, 3);

$button = Gtk2::Button->new_with_label('Add 3 Items');
Gtk2::GSignal->connect($button, 'clicked', \&cbs_add_3_items, [$list, \$itemnr]);
$button->show;
$add_items_box->pack_start($button, TRUE, TRUE, 3);

$add_items_box->show;

my $exit_box=Gtk2::HBox->new(FALSE, 0);

$button = Gtk2::Button->new_with_label('Exit');
Gtk2::GSignal->connect($button, 'clicked', \&cbs_exit_demo, undef);
$button->show;
$exit_box->pack_start($button, TRUE, TRUE, 3);

$exit_box->show;

$main_box->pack_start($scrolled_win, TRUE, TRUE, 3);
$main_box->pack_end($exit_box, FALSE, FALSE, 3);
$main_box->pack_end($add_items_box, FALSE, FALSE, 3);

$main_box->show;

$window->add($main_box);
$window->show;

Gtk2->main;

0;

# EOF

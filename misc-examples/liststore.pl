#!/usr/bin/perl -w

# Copyright 2002, Marin Purgar
# licensed under General Public License (GPL)
# see http://www.fsf.org/licenses/gpl.txt

use strict;
use Gtk2;
use Data::Dumper;

use constant TRUE					=> 1;
use constant FALSE					=> 0;

use constant COLUMN_FIXED			=> 0;
use constant COLUMN_NUMBER			=> 1;
use constant COLUMN_SEVERITY		=> 2;
use constant COLUMN_DESCRIPTION		=> 3;
use constant NUM_COLUMNS			=> 4;

my @data=(
	[ FALSE,	60482,	"Normal",		"scrollable notebooks and hidden tabs" ],
	[ FALSE,	60620,	"Critical",		"gdk_window_clear_area (gdkwindow-win32.c) is not thread-safe" ],
	[ FALSE,	50214,	"Major",		"Xft support does not clean up correctly" ],
	[ TRUE,		52877,	"Major",		"GtkFileSelection needs a refresh method. " ],
	[ FALSE,	56070,	"Normal",		"Can't click button after setting in sensitive" ],
	[ TRUE,		56355,	"Normal",		"GtkLabel - Not all changes propagate correctly" ],
	[ FALSE,	50055,	"Normal",		"Rework width/height computations for TreeView" ],
	[ FALSE,	58278,	"Normal",		"gtk_dialog_set_response_sensitive () doesn't work" ],
	[ FALSE,	55767,	"Normal",		"Getters for all setters" ],
	[ FALSE,	56925,	"Normal",		"Gtkcalender size" ],
	[ FALSE,	56221,	"Normal",		"Selectable label needs right-click copy menu" ],
	[ TRUE,		50939,	"Normal",		"Add shift clicking to GtkTextView" ],
	[ FALSE,	6112,	"Enhancement",	"netscape-like collapsable toolbars" ],
	[ FALSE,	1,		"Normal",		"First bug :=)" ]
);

sub create_model {

	my $iter = Gtk2::TreeIter->new;
	my $store = Gtk2::ListStore->new(
		Gtk2::GType::BOOLEAN,
		Gtk2::GType::UINT,
		Gtk2::GType::STRING,
		Gtk2::GType::STRING
	);

	for my $i (0..$#data) {
		$store->append($iter);

		my $argv_ref= [
				COLUMN_FIXED, $data[$i][0],
				COLUMN_NUMBER, $data[$i][1],
				COLUMN_SEVERITY, $data[$i][2],
				COLUMN_DESCRIPTION, $data[$i][3]
		];

		$store->set($iter, $argv_ref);
	}

	return $store;
}

sub fixed_toggled {
	my ($cell, $model, $path) = @_;
	my $iter = $model->get_iter_from_string($path);
	$model->set($iter, [ COLUMN_FIXED, !$model->get($iter, COLUMN_FIXED) ]);
}

sub add_columns {
	my ($treeview) = @_;

	my $model = $treeview->get_model();

	my $renderer;
	my $column;

	$renderer = Gtk2::CellRendererToggle->new();
	$renderer->signal_connect('toggled', \&fixed_toggled, $model);
	$column = Gtk2::TreeViewColumn->new_with_attributes('Fixed?', $renderer, 'active', COLUMN_FIXED);
	$column->set_sizing('fixed');
	$column->set_fixed_width(50);
	$treeview->append_column($column);

	$renderer = Gtk2::CellRendererText->new();
	$column = Gtk2::TreeViewColumn->new_with_attributes('Bug number', $renderer, 'text', COLUMN_NUMBER);
	$column->set_sort_column_id(COLUMN_NUMBER);
	$treeview->append_column($column);

	$renderer = Gtk2::CellRendererText->new();
	$column = Gtk2::TreeViewColumn->new_with_attributes('Severity', $renderer, 'text', COLUMN_SEVERITY);
	$column->set_sort_column_id(COLUMN_SEVERITY);
	$treeview->append_column($column);

	$renderer = Gtk2::CellRendererText->new();
	$column = Gtk2::TreeViewColumn->new_with_attributes('Description', $renderer, 'text', COLUMN_DESCRIPTION);
	$column->set_sort_column_id(COLUMN_DESCRIPTION);
	$treeview->append_column($column);

}

# Main

Gtk2->init(\@ARGV);

my $window = Gtk2::Window->new('toplevel');
$window->set_title('GtkListStore demo');

Gtk2::GSignal->connect($window, 'destroy', sub { Gtk2->quit; }, 0);
Gtk2::GSignal->connect($window, 'delete_event', sub { Gtk2->quit; }, 0);
$window->set_border_width(8);

my $vbox = Gtk2::VBox->new(FALSE, 8);
$window->add($vbox);

my $label = Gtk2::Label->new('This is the bug list (note: not based on real data, it would be nice to have a nice ODBC interface to bugzilla or so, though).');
$vbox->pack_start($label, FALSE, FALSE, 0);

my $sw = Gtk2::ScrolledWindow->new;
$sw->set_shadow_type('etched-in');
$sw->set_policy('never', 'automatic');
$vbox->pack_start($sw, TRUE, TRUE, 0);

my $model = create_model();

my $treeview = Gtk2::TreeView->new_with_model($model);
$treeview->set_rules_hint(TRUE);
$treeview->set_search_column(COLUMN_DESCRIPTION);

$sw->add($treeview);
add_columns($treeview);

$window->set_default_size(280, 250);
$window->show_all();

Gtk2->main;

0;

# EOF

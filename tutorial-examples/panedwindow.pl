#!/usr/bin/perl -w

# $Id: panedwindow.pl,v 1.9 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-panedwindowwidgets.html

use Gtk2;

# Create the list of "messages"
sub create_list
  {
    my $iter = Gtk2::TreeIter->new;
    # Create a new scrolled window, with scrollbars only if needed
    my $scrolled_window = Gtk2::ScrolledWindow->new(undef, undef);
    $scrolled_window->set_policy('automatic', 'automatic');
    my $model = Gtk2::ListStore->new(Gtk2::GType->STRING);
    my $tree_view = Gtk2::TreeView->new;
    $scrolled_window->add_with_viewport($tree_view);
    $tree_view->set_model($model);
    $tree_view->show;
    # Add some messages to the window
    for (my $i = 0; $i < 10; $i++) {
      my $msg = sprintf ("Message #%d", $i);
      $model->append($iter);
      $model->set($iter, [0 => $msg]);
    }
    my $cell = Gtk2::CellRendererText->new;
    my $column = Gtk2::TreeViewColumn->new_with_attributes("Messages", $cell,
							   'text' => 0);
    $tree_view->append_column($column);
    return $scrolled_window;
  }

# Add some text to our text widget - this is a callback that is invoked
# when our window is realized. We could also force our window to be
# realized with gtk_widget_realize, but it would have to be part of
# a hierarchy first
sub insert_text
{
  my $buffer = shift;
  $buffer->set_text("From: pathfinder\@nasa.gov\n" .
		  "To: mom\@nasa.gov\n" .
		  "Subject: Made it!\n" .
		  "\n" .
		  "We just got in this morning. The weather has been\n" .
		  "great - clear but cold, and there are lots of fun sights.\n" .
		  "Sojourner says hi. See you soon.\n" .
		  " -Path\n", -1);
 }

# Create a scrolled text area that displays a "message"
sub create_text
  {
    my $view = Gtk2::TextView->new;
    my $buffer = $view->get_buffer;
    my $scrolled_window = Gtk2::ScrolledWindow->new(undef, undef);
    $scrolled_window->set_policy('automatic', 'automatic');
    $scrolled_window->add($view);
    insert_text($buffer);
    $scrolled_window->show_all;
    return $scrolled_window;
  }

Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Paned Windows");
Gtk2::GSignal->connect($window, "destroy" => sub { Gtk2->quit });
$window->set_border_width(10);
$window->set_size_request(450, 400);
# create a vpaned widget and add it to our toplevel window
my $vpaned = Gtk2::VPaned->new;
$window->add($vpaned);
$vpaned->show;
# Now create the contents of the two halves of the window
my $list = create_list;
$vpaned->add1($list);
$list->show;
my $text = create_text;
$vpaned->add2($text);
$text->show;
$window->show;
Gtk2->main;
0;



#!/usr/bin/perl -w

# $Id: notebook.pl,v 1.3 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-notebooks.html

use Gtk2;

sub TRUE  {1}
sub FALSE {0}


#/* This function rotates the position of the tabs */
sub rotate_book
{
  my ($button, $notebook) = @_;
  my @position_rotater = qw(left right top bottom left);
  my $new_pos;
  for (my $i=0; $i<@position_rotater; $i++) {
      if ($position_rotater[$i] eq $notebook->tab_pos) {
	  $notebook->set_tab_pos($position_rotater[$i+1]);
	  return
      }
  }
}

#/* Add/Remove the page tabs and the borders */
sub tabsborder_book
{
  my ($button, $notebook) = @_;
  my $tval = FALSE;
  my $bval = FALSE;
  $tval = TRUE if $notebook->show_tabs == 0;
  $bval = TRUE if $notebook->show_border == 0;
  $notebook->set_show_tabs($tval);
  $notebook->set_show_border($bval);
}

#/* Remove a page from the notebook */
sub remove_book
{
  my ($button, $notebook) = @_;
  my $page = $notebook->get_current_page;
  $notebook->remove_page($page);
  # Need to refresh the widget -- This forces the widget to redraw itself
  $notebook->queue_draw;
}

sub delete
{
  Gtk2->quit;
  return FALSE;
}

my $label;
Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
$window->signal_connect('delete_event' => \&delete);
$window->set_border_width(10);
my $table = Gtk2::Table->new(3, 6, FALSE);
$window->add($table);
#/* Create a new notebook, place the position of the tabs */
my $notebook = Gtk2::Notebook->new;
$notebook->set_tab_pos('top');
$table->attach_defaults($notebook, 0, 6, 0, 1);
$notebook->show;
# Let's append a bunch of pages to the notebook
for (my $i = 0; $i < 5; $i++) {
  my $bufferf = sprintf('Append Frame %d', $i + 1);
  my $bufferl = sprintf('Page %d', $i + 1);
  my $frame = Gtk2::Frame->new($bufferf);
  $frame->set_border_width(10);
  $frame->set_size_request(100, 75);
  $frame->show;
  $label = Gtk2::Label->new($bufferf);
  $frame->add($label);
  $label->show;
  $label = Gtk2::Label->new($bufferl);
  $notebook->append_page($frame, $label);
}
#/* Now let's add a page to a specific spot */
my $checkbutton = Gtk2::CheckButton->new_with_label('Check me please!');
$checkbutton->set_size_request(100, 75);
$checkbutton->show;
$label = Gtk2::Label->new('Add page');
$notebook->insert_page($checkbutton, $label, 2);
#/* Now finally let's prepend pages to the notebook */
for ($i = 0; $i < 5; $i++) {
  my $bufferf = sprintf('Prepend Frame %d', $i + 1);
  my $bufferl = sprintf('PPage %d', $i + 1);
  my $frame = Gtk2::Frame->new($bufferf);
  $frame->set_border_width(10);
  $frame->set_size_request(100, 75);
  $frame->show;
  $label = Gtk2::Label->new($bufferf);
  $frame->add($label);
  $label->show;
  $label = Gtk2::Label->new($bufferl);
  $notebook->prepend_page($frame, $label);
}
#/* Set what page to start at (page 4) */
$notebook->set_current_page(3);
#/* Create a bunch of buttons */
my $button = Gtk2::Button->new_with_label('close');
$button->signal_connect_swapped('clicked' => \&delete);
$table->attach_defaults($button, 0, 1, 1, 2);
$button->show;
$button = Gtk2::Button->new_with_label('next page');
$button->signal_connect_swapped('clicked', sub { shift->next_page }, $notebook);
$table->attach_defaults($button, 1, 2, 1, 2);
$button->show;
$button = Gtk2::Button->new_with_label('prev page');
$button->signal_connect_swapped('clicked', sub { shift->prev_page }, $notebook);
$table->attach_defaults($button, 2, 3, 1, 2);
$button->show;
$button = Gtk2::Button->new_with_label('tab position');
$button->signal_connect('clicked', \&rotate_book, $notebook);
$table->attach_defaults($button, 3, 4, 1, 2);
$button->show;
$button = Gtk2::Button->new_with_label('tabs/border on/off');
$button->signal_connect('clicked', \&tabsborder_book, $notebook);
$table->attach_defaults($button, 4, 5, 1, 2);
$button->show;
$button = Gtk2::Button->new_with_label('remove page');
$button->signal_connect('clicked', \&remove_book, $notebook);
$table->attach_defaults($button, 5, 6, 1, 2);
$button->show;
$table->show;
$window->show;
Gtk2->main;
0;

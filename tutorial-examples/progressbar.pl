#!/usr/bin/perl -w

# $Id: progressbar.pl,v 1.4 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-progressbars.html

use Gtk2;

sub TRUE {1}
sub FALSE {0}


#typedef struct _ProgressData {
#  GtkWidget *window;
#  GtkWidget *pbar;
#  int timer;
#  gboolean activity_mode;
#} ProgressData;

#/* Update the value of the progress bar so that we get
# * some movement */
sub progress_timeout
  {
    my $pdata = shift; # ProgressData*
    if ($pdata->{ACTIVITY_MODE})
      { $pdata->{PBAR}->pulse }
    else
      {
	#/* Calculate the value of the progress bar using the
	# * value range set in the adjustment object */
	my $new_val = $pdata->{PBAR}->fraction + 0.01;
	$new_val = 0.0 if $new_val > 1.0;
	#/* Set the new value */
	$pdata->{PBAR}->fraction($new_val);
    }
    #/* As this is a timeout function, return TRUE so that it
    # * continues to get called */
    return TRUE;
  }

#/* Callback that toggles the text display within the progress bar trough */
sub toggle_show_text
  {
    my ($widget, $pdata) = @_;
    my $text = $pdata->{PBAR}->text;
    if (defined $text && $text) { $pdata->{PBAR}->set_text(""); }
    else { $pdata->{PBAR}->set_text("some text"); }
}

#/* Callback that toggles the activity mode of the progress bar */
sub toggle_activity_mode
  {
    my ($widget, $pdata) = @_;
    $pdata->{ACTIVITY_MODE} = ! $pdata->{ACTIVITY_MODE};
    if ($pdata->{ACTIVITY_MODE})
      { $pdata->{PBAR}->pulse; }
    else 
      { $pdata->{PBAR}->fraction(0.0); }
  }
 
#/* Callback that toggles the orientation of the progress bar */
sub toggle_orientation
  {
    my ($widget, $pdata) = @_;
    my $ori = $pdata->{PBAR}->get_orientation;
    if ($ori eq 'left-to-right')
      { $pdata->{PBAR}->set_orientation('right-to-left'); }
    elsif ($ori eq 'right-to-left')
      { $pdata->{PBAR}->set_orientation('left-to-right'); }
    else { } # nada
  }

#/* Clean up allocated memory and remove the timer */
sub destroy_progress
  {
    my ($widget, $pdata) = @_;
    Gtk2->timeout_remove($pdata->{TIMER});
    $pdata->{TIMER} = 0;
    $pdata->{WINDOW} = undef;
    Gtk2->quit;
  }

#    GtkWidget *check;

Gtk2->init(\@ARGV);
#/* Allocate memory for the data that is passed to the callbacks */
my $pdata = {};
$pdata->{WINDOW} = Gtk2::Window->new('toplevel');
$pdata->{WINDOW}->resizable(TRUE);
Gtk2::GSignal->connect($pdata->{WINDOW}, "destroy", \&destroy_progress, $pdata);
$pdata->{WINDOW}->set_title("GtkProgressBar");
$pdata->{WINDOW}->set_border_width(0);
my $vbox = Gtk2::VBox->new(FALSE, 5);
$vbox->set_border_width(10);
$pdata->{WINDOW}->add($vbox);
$vbox->show;
# Create a centering alignment object
my $align = Gtk2::Alignment->new(0.5, 0.5, 0, 0);
$vbox->pack_start($align, FALSE, FALSE, 5);
$align->show;
# Create the GtkProgressBar
$pdata->{PBAR} = Gtk2::ProgressBar->new;
$align->add($pdata->{PBAR});
$pdata->{PBAR}->show;
# Add a timer callback to update the value of the progress bar
$pdata->{TIMER} = Gtk2->timeout_add(100, \&progress_timeout, $pdata);
my $separator = Gtk2::HSeparator->new;
$vbox->pack_start($separator, FALSE, FALSE, 0);
$separator->show;
# /* rows, columns, homogeneous */
my $table = Gtk2::Table->new(2, 2, FALSE);
$vbox->pack_start($table, FALSE, TRUE, 0);
$table->show;
# Add a check button to select displaying of the trough text
my $check = Gtk2::CheckButton->new_with_label("Show text");
$table->attach($check, 0, 1, 0, 1, ['expand', 'fill'], ['expand', 'fill'], 5, 5);
Gtk2::GSignal->connect($check, "clicked", \&toggle_show_text, $pdata);
$check->show;
# Add a check button to toggle activity mode */
$check = Gtk2::CheckButton->new_with_label("Activity mode");
$table->attach($check, 0, 1, 1, 2, ['expand', 'fill'], ['expand', 'fill'], 5, 5);
Gtk2::GSignal->connect($check, "clicked", \&toggle_activity_mode, $pdata);
$check->show;
# Add a check button to toggle orientation
$check = Gtk2::CheckButton->new_with_label("Right to Left");
$table->attach($check, 0, 1, 2, 3, ['expand', 'fill'], ['expand', 'fill'], 5, 5);
Gtk2::GSignal->connect($check, "clicked", \&toggle_orientation, $pdata);
$check->show;
# Add a button to exit the program
my $button = Gtk2::Button->new_with_label("close");
Gtk2::GSignal->connect_swapped($button, "clicked", 
			       sub { shift->destroy; }, $pdata->{WINDOW});
$vbox->pack_start($button, FALSE, FALSE, 0);
#/* This makes it so the button is the default. */
$button->SET_FLAGS('can-default');
#/* This grabs this button to be the default button. Simply hitting
#* the "Enter" key will cause this button to activate. */
$button->grab_default;
$button->show;
$pdata->{WINDOW}->show;
Gtk2->main;
0;


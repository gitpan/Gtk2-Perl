#!/usr/bin/perl -w

use Gtk2;

sub TRUE  {1}
sub FALSE {0}

# Get the selected filename and print it to the console 
sub file_ok_sel
{
  my ($w, $fs) = @_;
  print $fs->get_filename, "\n";
}

Gtk2->init(\@ARGV);
# Create a new file selection widget
my $filew = Gtk2::FileSelection->new("File selection");
Gtk2::GSignal->connect($filew, "destroy", sub { Gtk2->quit });
# Connect the ok_button to file_ok_sel function
Gtk2::GSignal->connect($filew->ok_button, "clicked" => \&file_ok_sel, $filew);
# Connect the cancel_button to destroy the widget
Gtk2::GSignal->connect_swapped($filew->cancel_button, "clicked" => sub {shift->destroy}, $filew);
# Lets set the filename, as if this were a save dialog, and we are giving a default filename
$filew->set_filename("penguin.png");
$filew->show;
Gtk2->main;
0;



#!/usr/bin/perl -w

use Gtk2;


# I'm going to be lazy and use some global variables to store the position of 
# the widget within the fixed container
my $x = 50;
my $y = 50;

# This callback function moves the button to a new position in the Fixed container.
sub move_button
{
  my ($widget, $fixed) = @_;
  $x = ($x + 30) % 300;
  $y = ($y + 50) % 300;
  $fixed->move($widget, $x, $y);
}

#  /* GtkWidget is the storage type for widgets */
#  GtkWidget *fixed;

Gtk2->init(\@ARGV);
# Create a new window
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Fixed Container");
# Here we connect the "destroy" event to a signal handler
Gtk2::GSignal->connect($window, "destroy", sub { Gtk2->quit });
# Sets the border width of the window.
$window->set_border_width(10);
# Create a Fixed Container
my $fixed = Gtk2::Fixed->new;
$window->add($fixed);
$fixed->show;
for (my $i = 1; $i <= 3 ; $i++) 
  {
    # Creates a new button with the label "Press me"
    my $button = Gtk2::Button->new_with_label("Press me");
    # When the button receives the "clicked" signal, it will call the
    # function move_button() passing it the Fixed Container as its argument.
    Gtk2::GSignal->connect($button, "clicked", \&move_button, $fixed);
    # This packs the button into the fixed containers window.
    $fixed->put($button, $i * 50, $i * 50);
    # The final step is to display this newly created widget.
    $button->show;
  }
# Display the window
$window->show;
# Enter the event loop */
Gtk2->main;
0;

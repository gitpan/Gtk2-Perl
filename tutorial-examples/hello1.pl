#!/usr/bin/perl -w

use Gtk2;


# $Id: hello1.pl,v 1.5 2002/11/26 16:38:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

#/* This is a callback function. The data arguments are ignored
# * in this example. More on callbacks below. */
sub hello
{
  my ($widget, $data) = @_;
  print "Hello World\n";
}

sub delete_event
{
  my ($widget, $event, $data) = @_;
#    /* If you return FALSE in the "delete_event" signal handler,
#     * GTK will emit the "destroy" signal. Returning TRUE means
#     * you don't want the window to be destroyed.
#     * This is useful for popping up 'are you sure you want to quit?'
#     * type dialogs. */
  print "event: $event occurred\n";
#    /* Change TRUE to FALSE and the main window will be destroyed with
#     * a "delete_event". */
    1;
}

#/* Another callback */
sub destroy
{
  my ($widget, $data) = @_;
  Gtk2->quit;
}

sub wdestroy
  {
    my ($widget, $data) = @_;
    print "W: $widget\n", "D: $data\n";
    $data->destroy;
  }

#    /* This is called in all GTK applications. Arguments are parsed
#     * from the command line and are returned to the application. */
Gtk2->init(\@ARGV);
#    /* create a new window */
my $window = Gtk2::Window->new('toplevel');
#    /* When the window is given the "delete_event" signal (this is given
#     * by the window manager, usually by the "close" option, or on the
#     * titlebar), we ask it to call the delete_event () function
#     * as defined above. The data passed to the callback
#     * function is undef and is ignored in the callback function. */
Gtk2::GSignal->connect($window, "delete_event", \&delete_event);
#    /* Here we connect the "destroy" signal to a signal handler.  
#     * This signal occurs when we call gtk_widget_destroy() on the window,
#     * or if we return FALSE in the "delete_event" callback. */
Gtk2::GSignal->connect($window, "destroy" => \&destroy);
#    /* Sets the border width of the window. */
$window->set_border_width(10);
#    /* Creates a new button with the label "Hello World". */
my $button = Gtk2::Button->new_with_label("Hello World");
#    /* When the button receives the "clicked" signal, it will call the
#     * function hello() passing it undef as its argument.  The hello()
#     * function is defined above. */
Gtk2::GSignal->connect($button, "clicked" => \&hello);
#    /* This will cause the window to be destroyed by calling
#     * gtk_widget_destroy(window) when "clicked".  Again, the destroy
#     * signal could come from here, or the window manager. */
Gtk2::GSignal->connect($button, "clicked" => \&wdestroy, $window);
#    /* This packs the button into the window (a gtk container). */
$window->add($button);
#    /* The final step is to display this newly created widget. */
$button->show;
#   /* and the window */
$window->show;
#    /* All GTK applications must have a gtk_main(). Control ends here
#     * and waits for an event to occur (like a key press or
#     * mouse event). */
Gtk2->main;
0;


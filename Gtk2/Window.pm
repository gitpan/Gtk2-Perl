package Gtk2::Window;

# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Window.pm,v 1.23 2002/12/16 17:23:57 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use base qw(Gtk2::Bin);


## PROPERTIES
# NOT IMPLEMENTED YET:
#  "type"                 GtkWindowType        : Read / Write / Construct Only
#  "screen"               GdkScreen            : Read / Write
#  "type-hint"            GdkWindowTypeHint    : Read / Write
#  "window-position"      GtkWindowPosition    : Read / Write
#  "icon"                 GdkPixbuf            : Read / Write

# AUTOCREATE PROPERTY ACCESS:
for my $prop (qw(allow-grow allow-shrink default-height default-width destroy-with-parent has-top-level-focus icon is-active modal resizable title window-position))
  {
    my $field = $prop;
    $field =~ s/\-/_/g;
    *$field = sub { shift->get_set($prop, @_) };
  }

sub get_size {
    my $values = shift->_get_size;
    return wantarray ? @$values : $values;
}

sub get_default_size {
    my $values = shift->_get_default_size;
    return wantarray ? @$values : $values;
}

sub get_position {
    my $values = shift->_get_position;
    return wantarray ? @$values : $values;
}

sub get_frame_dimensions {
    my $values = shift->_get_frame_dimensions;
    return wantarray ? @$values : $values;
}

1;


=head1 NAME

Gtk2::Window - Widget for a Window.

=head1 SYNOPSIS

# Load and Initialise Gtk2.
    use Gtk2;
    Gtk2->init;

# Create our Gtk2::Window
    my $window = Gtk2::Window->new('toplevel');

# Show our window to the world.
    $window->show;

# Pass control to the Gtk2 mainloop.
    Gtk2->main;

=head1 DESCRIPTION

Gtk2::Window is the object which represents a Window. 

=head1 METHODS

The following methods are available for this object.  This list is not
exhaustive.

=over

=item B<new($type)>

This is the constructor method for this widget.  The first and only
argument is the "type" of window.  In Gtk2 there are only two types;

    toplevel - Almost all of your windows will be of this type.
        This is a standard window type.  The window manager has
	full control of it and is able to decorate it (provide
	bars, minimise/iconify/destroy buttons).

    popup    - This window type denies the window manager any
        control over its positioning, sizing, iconifing or
        decoration.  This window type is typically used for
        things like pop-up menus.  Use of this type is rare.

        If you need a window with no decoration, you should still
        use type "toplevel" but make a call to the set_decorated
        method below.

The object or its contents is not rendered until you call the show() or
show_all() methods.

The old behaviour catagorised by the type "dialog" is now achieved using
calls which are described in the set_transient_for() and set_position()
section.

=item B<set_title($text)>

This method allows you to set, or change the text which is displayed as
the title of your window as rendered by your window manager.  This
defaults to the name of your application.

    $window->set_title("MyNewsClient: (Browsing: comp.lang.perl)");

=item B<get_title()>

This method allows you to get the title from your window.  It returns
a scalar which contains this text.

    my $text = $window->get_title;

=item B<set_resizable($bool)>

This method allows you to instruct the window manager whether or not the
user is allowed to resize the window.  Its single argument is a boolean
true or false, or a 1 or 0.

    # Allow resizable
    $window->set_resizeable(1);

    # Disallow resizable
    $window->set_resizeable(0);

=item B<get_resizable()>

This method queries your window object to discover if the Window is
resizable.  It returns 1 for true (can be resized) or 0 for false
(cannot be resized).

    if ($window->get_resizable) {
        print("Window is resizable\n");
    }

=item B<set_default_size($width, $height)>

This method allows you set the B<initial> minimum size of your window.
If your widgets within your Window request a larger sized window than
you specify here this request will be ignored.

    # Set the initial size of the window to 100x200 pixels.
    $window->set_default_size(100, 200);

To change the size of an already rendered window see resize().

To set size of the Window regardless of the consequences, see
set_size_request() in Gtk2::Widget.

=item B<set_transient_for($main_window)>

This method allows you to "bind" windows behaviour to another by
informing it that the window that you call this method on is
"subservient" to $main_window; the first argument you pass.

This may also affect the initial positioning of the window by the
window manager a common positioning policy is to place subservient
windows on the top of their parents.  You can request a change
in this policy using the set_position() method although, again,
the window manager does not have to honour this.

=item B<get_transient_for()>

This method allows you to identify the parent window of your
window.  It takes no arguments but returns the reference
to the parent window.

=item B<set_position($type)>

This method allows you to pass hints to the window manager as to where
you want your window to appear.  This is only a request, your window
manager does not have to honour it.

Options are:

    none     - This instructs the window manager to use its own
        policy.

    center   - This instructs the window manager that you wish
        the window to appear in the center of the screen.

    mouse    - This instructs the window manager that you wish
        the window to appear at the position that the mouse is.

    center_always - This instructs the window manager that you
        always want the window to appear in the center, even
        after resize.

    center_on_parent - This instructs the window manager to
        position this window in the center on its parent window.
	See set_transient_for().

Example:

    # Create two windows.
    my $main_window = Gtk2::Window->new(-toplevel);
    my $child_window = Gtk2::Window->new(-toplevel);

    # Make $child_window subservient to $main_window
    $child_window->set_transient_for($main_window);

    # Make $child_window initial placement in the center of
    # $main_window
    $child_window->set_position(-center_on_parent);

    # Render $main_window first else $child_window won't be able to
    # appear in the center on top of it.
    $main_window->show;
    $child_window->show;

=item B<set_destroy_with_parent($bool)>

This method allows you to set or unset the behaviour whereby the
window will destroy itself if its parent window is destroyed (see
set_transient_for()).

The first and only argument is boolean, 0 for false and 1 for true.

    # Suicidal window on death of parent.
    $window->set_destroy_with_parent(1);

    # Not suicidal on death of parent.
    $window->set_destroy_with_parent(0);

=item B<present()>

This method causes the window to appear in front of the user.

The window may be moved from a different screen, de-iconified, rendered,
raised to the top.  It may also give the window focus and move the
mouse depending on the configuration of the window manager.

    $window->present;

=item B<iconify()>

This method requests to the window manager than the window be minimised.

    $window->iconify;

=item B<deiconify()>

This method requests to the window manager that the window by de-iconified.
You may wish to read the documentation above for present() as this is
more likely to be the effect you are looking for in an application
design as a window may be de-iconified onto a different screen or under
other windows.

    $window->deiconify;

=item B<stick()>

This method causes your window to become sticky.  Sticky windows are
windows that stay on the screen even when you change virtual screens.

Support for this request is variable across window managers.

=item B<unstick()>

This method causes your window to cease being sticky.

Support for this request is variable across window managers.

=item B<maximize()>

This method causes your window to maximise the same way as if you had
pressed that icon in your window managers decoration.

=item B<unmaximize()>

This method causes your window to un-maximise the same way as if you
had pressed that icon in your window managers decoration.  The window
is restored to its pre-maximised size.

=item B<fullscreen()> and B<unfullscreen()>

These methods allow you to fullscreen and unfullscreen your window.
This is done by changing the resolution of your X server, placing your
window in the middle and blacking out the rest of the screen.

Although we allow you to pass the request to the window manager
its support is very poor.  Expect bad things to happen if you use
this.

=item B<set_decorated($bool)>

This method allows you to instruct the window manager to apply or
not apply decorations to your window.  The default is to allow
decorations.  Decorations consist of the borders, title and
window manager icons surrounding your window.

    # Make window un-decorated (borderless)
    $window->set_decorated(0);

=item B<get_decorated()>

This method returns whether the window is decorated or not.  The value
returned is 0 for undecorated, or 1 for decorated.

=item B<get_size()>

This method allows you to acquire the dimensions of your window.
The method returns a list in the for (width, height).

    my ($width, $height) = $window->get_size;

Note, these dimensions do not include any window manager decorations.

=item B<resize($width, $height)>

This method allows you to resize your window object.  This method is
typically called after the window has been displayed.  If you call this
method before rendering, then its setting overrides that set
by set_default_size().

If the widgets in the window request more space than you specify in
resize(), then this method is silently ignored.

=back

=head1 AUTHOR

The author of this documentation is Redvers Davies <red@criticalintegration.com>.

(C) Redvers Davies 2002, under the LGPL.

=head1 SEE ALSO

Gtk2


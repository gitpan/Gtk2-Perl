package Gtk2::Label;

# $Id: Label.pm,v 1.11 2002/12/16 17:20:38 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Label.pm,v 1.11 2002/12/16 17:20:38 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }


use Gtk2::Misc;
@ISA = qw(Gtk2::Misc);

# Allows calling it without any text argument
sub new {
    my ($self, $text) = @_;
    $self->_new($text || '');
}

sub set
  {
    my ($self, $text) = @_;
    $self->set_text($text);
  }

sub get_selection_bounds {
    my $values = shift->_get_selection_bounds;
    return wantarray ? @$values : $values;
}

sub get_layout_offsets {
    my $values = shift->_get_layout_offsets;
    return wantarray ? @$values : $values;
}

1;


=head1 NAME

Gtk2::Label - Widget for a small to medium amount of text.

=head1 SYNOPSIS

# Load and Initialise Gtk2.
    use Gtk2;
    Gtk2->init;

# Create a window within which we can display our Gtk2::Label.
    my $window = Gtk2::Window->new('toplevel');

# Create the Gtk2::Label using the new() constructor method.
    my $label = Gtk2::Label->new("This is the contents of a Gtk2::Label");

# Alternatively, you can set the text after creation.
    $label->set_text("Or you can set the text of the Label after creation");

# Or read back the text that is contained within the Gtk2::Label.
    my $text = $label->get_text;

# Place the Gtk2::Label within our window and display it and the label.
    $window->add($label);
    $window->show_all;

# Pass control to the Gtk2 mainloop.
    Gtk2->main;

=head1 DESCRIPTION

Gtk2::Label is a widget which allows you to display a small to medium amount of text.
It is different from its Gtk.pm breathern with the addition of some rather useful
formatting methods.

=head1 METHODS

The following methods are available for this object.  This list is not exhaustive.

=over

=item B<new($text)>

This is the constructor method for this widget.  The single option is a scalar which
contains the text you with to display in the widget.  If you specify a carriage return
within your text (eg, \n) Gtk2::Label will start a new line at this point.

The argument is optional as it defaults to an empty string.  This is sometimes useful
in occasions when you wish to set the contents of the Gtk2::Label after the widget
has been rendered.  See B<set_text> method below.

my $label = Gtk2::Label->new("This is my text\nwhich is on\nthree lines.");

=item B<set_text($text)>

This method allows you to set, or change the text which is displayed within your Label.
The only argument is a scalar which contains the text to be set.

 $label->set_text("This is the text\nwhich we set after creation");

=item B<get_text()>

This method allows you to get the text which is displayed by your Label.  This method
takes no arguments but returns the displayed text.

 my $text = $label->get_text;

=item B<set_pattern($pattern)>

This method allows you to specify characters in your Label to be underlined.  A "pattern"
consists of a string which contains either a space (' ') or an underscore ('_').  The
position where a space is is rendered as a normal character whereas a position with an
underscore is rendered as underlined.

The following code produces a Label with the word "Underlined" underlined.

my $label = new Gtk2::Label("Test Underlined");
$label->set_pattern("     __________");

=item B<set_justify($GtkJustification)>

This is a new method which was not available to the Gtk::Label object.  Its single
argument is the string 'left', 'right', 'center' or 'fill' to set the text
within that widget to that justification style.

=back

=head1 AUTHOR

The author of this documentation is Redvers Davies <red@criticalintegration.com>.

(C) Redvers Davies 2002, under the LGPL.

=head1 SEE ALSO

Gtk2


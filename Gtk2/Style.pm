package Gtk2::Style;

# $Id: Style.pm,v 1.12 2002/11/26 16:30:14 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Style.pm,v 1.12 2002/11/26 16:30:14 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::GObject;
@ISA =qw(Gtk2::GObject);

use Gtk2::_Helpers;


sub fg_gc {
    Gtk2::_Helpers::check_usage(\@_, ['Gtk2::StateType state'], ['Gtk2::StateType state', 'Gtk2::Gdk::GC gc' ]);
    my ($self, $state, $set) = @_;
    if (defined($set)) {
	$self->set_fg_gc($state, $set);
    } else {
	return $self->get_fg_gc($state);
    }
}

sub bg_gc {
    Gtk2::_Helpers::check_usage(\@_, ['Gtk2::StateType state'], ['Gtk2::StateType state', 'Gtk2::Gdk::GC gc' ]);
    my ($self, $state, $set) = @_;
    if (defined($set)) {
	$self->set_bg_gc($state, $set);
    } else {
	return $self->get_bg_gc($state);
    }
}

sub light_gc {
    Gtk2::_Helpers::check_usage(\@_, ['Gtk2::StateType state'], ['Gtk2::StateType state', 'Gtk2::Gdk::GC gc' ]);
    my ($self, $state, $set) = @_;
    if (defined($set)) {
	$self->set_light_gc($state, $set);
    } else {
	return $self->get_light_gc($state);
    }
}

sub dark_gc {
    Gtk2::_Helpers::check_usage(\@_, ['Gtk2::StateType state'], ['Gtk2::StateType state', 'Gtk2::Gdk::GC gc' ]);
    my ($self, $state, $set) = @_;
    if (defined($set)) {
	$self->set_dark_gc($state, $set);
    } else {
	return $self->get_dark_gc($state);
    }
}

sub mid_gc {
    Gtk2::_Helpers::check_usage(\@_, ['Gtk2::StateType state'], ['Gtk2::StateType state', 'Gtk2::Gdk::GC gc' ]);
    my ($self, $state, $set) = @_;
    if (defined($set)) {
	$self->set_mid_gc($state, $set);
    } else {
	return $self->get_mid_gc($state);
    }
}

sub text_gc {
    Gtk2::_Helpers::check_usage(\@_, ['Gtk2::StateType state'], ['Gtk2::StateType state', 'Gtk2::Gdk::GC gc' ]);
    my ($self, $state, $set) = @_;
    if (defined($set)) {
	$self->set_text_gc($state, $set);
    } else {
	return $self->get_text_gc($state);
    }
}

sub base_gc {
    Gtk2::_Helpers::check_usage(\@_, ['Gtk2::StateType state'], ['Gtk2::StateType state', 'Gtk2::Gdk::GC gc' ]);
    my ($self, $state, $set) = @_;
    if (defined($set)) {
	$self->set_base_gc($state, $set);
    } else {
	return $self->get_base_gc($state);
    }
}

sub text_aa_gc {
    Gtk2::_Helpers::check_usage(\@_, ['Gtk2::StateType state'], ['Gtk2::StateType state', 'Gtk2::Gdk::GC gc' ]);
    my ($self, $state, $set) = @_;
    if (defined($set)) {
	$self->set_text_aa_gc($state, $set);
    } else {
	return $self->get_text_aa_gc($state);
    }
}

sub white_gc {
    my ($self, $set) = @_;
    if (defined($set)) {
	$self->set_white_gc($set);
    } else {
	return $self->get_white_gc();
    }
}

sub black_gc {
    my ($self, $set) = @_;
    if (defined($set)) {
	$self->set_black_gc($set);
    } else {
	return $self->get_black_gc();
    }
}

# colors
sub _state  {
  my $state = shift;
  return 0 if $state eq 'normal';
  return 1 if $state eq 'active';
  return 2 if $state eq 'prelight';
  return 3 if $state eq 'selected';
  return 4 if $state eq 'insensitive';
}

sub get_bg_color { shift->_get_bg_color(_state(@_)); }
*bg_color = \&get_bg_color;

1;

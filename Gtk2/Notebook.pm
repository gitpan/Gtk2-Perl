package Gtk2::Notebook;

# $Id: Notebook.pm,v 1.3 2002/11/13 22:50:10 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Notebook.pm,v 1.3 2002/11/13 22:50:10 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Container;
@ISA=qw(Gtk2::Container);

sub tab_pos
  {
    my ($self, $flag) = @_;
    my $ret = $self->get_tab_pos;
    $self->set_tab_pos($flag) if defined $flag;
    $ret;
  }

sub show_tabs
  {
    my ($self, $flag) = @_;
    my $ret = $self->get_show_tabs;
    $self->set_show_tabs($flag) if defined $flag;
    $ret;
  }

sub show_border
  {
    my ($self, $flag) = @_;
    my $ret = $self->get_show_border;
    $self->set_show_border($flag) if defined $flag;
    $ret;
  }

sub append_page {
    my ($self, $child, $tab_label) = @_;
    _append_page($self, $child, $tab_label);
}

sub set_page {
    Gtk2::_Helpers::deprecated('set_current_page', @_);
}

sub current_page {
    Gtk2::_Helpers::deprecated('get_current_page', @_);
}

1;




#!/usr/bin/perl
#==============================================================================
#=== This generates test scripts
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

# $Id: write_test_scripts.pl,v 1.3 2002/11/14 05:38:40 glade-perl Exp $

our $rcsid = '$Id: write_test_scripts.pl,v 1.3 2002/11/14 05:38:40 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN {
    use Gtk2::Test;
    use vars qw (@files);
}
    @files = qw(
Gtk2::main
Gtk2::GObject
Gtk2::AccelGroup
Gtk2::Object
Gtk2::Widget
Gtk2::Misc
Gtk2::Label
Gtk2::AccelLabel
Gtk2::TipsQuery
Gtk2::Arrow
Gtk2::Image
Gtk2::Pixmap
Gtk2::Container
Gtk2::Bin
Gtk2::Alignment
Gtk2::Frame
Gtk2::AspectFrame
Gtk2::Button
Gtk2::ToggleButton
Gtk2::CheckButton
Gtk2::RadioButton
Gtk2::OptionMenu
Gtk2::Item
Gtk2::MenuItem
Gtk2::CheckMenuItem
Gtk2::RadioMenuItem
Gtk2::ImageMenuItem
Gtk2::SeparatorMenuItem
Gtk2::TearoffMenuItem
Gtk2::ListItem
Gtk2::TreeItem
Gtk2::Window
Gtk2::Dialog
Gtk2::ColorSelectionDialog
Gtk2::FileSelection
Gtk2::FontSelectionDialog
Gtk2::InputDialog
Gtk2::MessageDialog
Gtk2::Plug
Gtk2::EventBox
Gtk2::HandleBox
Gtk2::ScrolledWindow
Gtk2::Viewport
Gtk2::Box
Gtk2::ButtonBox
Gtk2::HButtonBox
Gtk2::VButtonBox
Gtk2::VBox
Gtk2::ColorSelection
Gtk2::FontSelection
Gtk2::GammaCurve
Gtk2::HBox
Gtk2::Combo
Gtk2::Statusbar
Gtk2::CList
Gtk2::CTree
Gtk2::Fixed
Gtk2::Paned
Gtk2::HPaned
Gtk2::VPaned
Gtk2::Layout
Gtk2::List
Gtk2::MenuShell
Gtk2::MenuBar
Gtk2::Menu
Gtk2::Notebook
Gtk2::Socket
Gtk2::Table
Gtk2::TextView
Gtk2::Toolbar
Gtk2::Tree
Gtk2::TreeView
Gtk2::Calendar
Gtk2::DrawingArea
Gtk2::Curve
Gtk2::Entry
Gtk2::SpinButton
Gtk2::Ruler
Gtk2::HRuler
Gtk2::VRuler
Gtk2::Range
Gtk2::Scale
Gtk2::HScale
Gtk2::VScale
Gtk2::Scrollbar
Gtk2::HScrollbar
Gtk2::VScrollbar
Gtk2::Separator
Gtk2::HSeparator
Gtk2::VSeparator
Gtk2::Invisible
Gtk2::OldEditable
Gtk2::Text
Gtk2::Preview
Gtk2::Progress
Gtk2::ProgressBar
Gtk2::Adjustment
Gtk2::CellRenderer
Gtk2::CellRendererPixbuf
Gtk2::CellRendererText
Gtk2::CellRendererToggle
Gtk2::ItemFactory
Gtk2::Tooltips
Gtk2::TreeViewColumn
Gtk2::AtkObject
Gtk2::Accessible
Gtk2::IconFactory
Gtk2::IMContext
Gtk2::IMContextSimple
Gtk2::IMMulticontext
Gtk2::ListStore
Gtk2::RcStyle
Gtk2::Settings
Gtk2::SizeGroup
Gtk2::Style
Gtk2::TextBuffer
Gtk2::TextChildAnchor
Gtk2::TextMark
Gtk2::TextTag
Gtk2::TextTagTable
Gtk2::TreeModelSort
Gtk2::TreeSelection
Gtk2::TreeStore
Gtk2::WindowGroup
Gtk2::Gdk::DragContext
Gtk2::Gdk::Pixbuf
Gtk2::Gdk::Drawable
Gtk2::Gdk::Pixmap
Gtk2::Gdk::Image
Gtk2::Gdk::PixbufAnimation
Gtk2::Gdk::Device
);

my $seq = 10;
for my $file (@files) {
    my $filename = sprintf("t/%03d_%s.t", $seq++, $file);
    $filename =~ s/::/_/g;
#    print "----------------------------\n";
    print "Writing $filename","\n";
    &string_to_file(&test_string("$file", "$filename"), $filename);
}

sub string_to_file {
    my ($string, $filename) = @_;
    open OUTFILE, ">$filename" or 
        die sprintf((
            "error - can't open file '%s' for output"),
            $filename);    
    print OUTFILE $string;
    close OUTFILE;
}

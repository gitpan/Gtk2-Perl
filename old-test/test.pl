#!/usr/bin/perl -w

# Note: this is a generic launcher script, designed to work with all Gtk versions.
# If you are interested in the Perl port of the Gtk widget demo, please look at
# Gtk/samples/test.pl.

use strict;
use Gtk2;
use IO::File;

use warnings;

my ($run, $source, $current_sample);
my ($title_label, $file_label, $requires_label);

sub show_sample {
  my($sample) = @_;
  open (F, "<" . $sample->{directory} . $sample->{file});
  $source->freeze;
  $source->realize;
  $source->delete_text(0, $source->get_length);
  while (<F>) {
    $source->insert_text($_, $source->get_length);
  }
  $source->thaw;
  close(F);
  $current_sample = $sample;
  $run->set_sensitive(1);
  $title_label->set("Title: " . $sample->{title});
  $file_label->set("File: " . $sample->{directory}.$sample->{file});
  $requires_label->set("Requires: " . $sample->{requires});
}


# Build list of available sample scripts
my @samples = ();
foreach my $file (<old-test/samples/*.pl samples/*.pl>)
 {
    my $f = IO::File->new("< $file");
    $file =~ m!^(.*/)!;
    my $directory = $1;
    $file = $';
    my ($title, $requires) = ();
    while (<$f>)
      {
	chop;
	$title = $1 if /TITLE:\s+(.*?)\s*$/;
	$requires = $1 if /REQUIRES:\s+(.*?)\s*$/;
	last if $title and $requires;
      }
    $f->close;
    if (defined $title or defined $requires)
      {
	push @samples, {file => $file, directory => $directory,
			title => $title, requires => $requires};
      }
  }

# Build execution environment
my @exec = ();
push @exec, $^X, "-w";

foreach (@INC) {
  if (m!^/!) { push @exec, "-I$_" }
  else { push @exec, "-I../../$_" }
}

sub run {
  my($script) = @_;
  my(@blib) = ();
  foreach (split(/\s+/, $script->{requires})) {
    next if /^Gtk$/;
    push(@blib, "-Mblib=../../$_") if -d "$_/blib";
    push(@blib, "-Mblib=../../GdkImlib") 
      if (/^Gnome$/ && -d "GdkImlib/blib");
  }
  print
    "\nExecuting (in $script->{directory}: ", 
      join(' ', @exec, @blib, $script->{file}), "\n";
  if (!fork) {
    chdir($script->{directory});
    exec @exec, @blib, $script->{file};
  }
}

# Build UI
my $main_window = Gtk2->main_window;
$main_window->set_title("Samples for Perl/Gtk+ 2");
$main_window->set_border_width(5);
$main_window->set_usize(600, 500);
my $hbox = Gtk2::HBox->new(0, 0);
$hbox->show;
$main_window->add($hbox);
my $list_scroller = Gtk2::ScrolledWindow->new;
$list_scroller->set_policy('automatic', 'automatic');
$list_scroller->border_width(5);
$list_scroller->show;
my $sample_list = Gtk2::List->new;
$sample_list->set_selection_mode('multiple');
$sample_list->signal_connect('select_child' => sub { show_sample($*{$_[1]}{sample}); });
$list_scroller->add_with_viewport($sample_list);
$list_scroller->set_usize(150, 100);
$hbox->pack_start($list_scroller, 0, 1, 5);
$sample_list->show;
my $vbox = Gtk2::VBox->new(0,0);
$vbox->show;
$title_label = new Gtk2::Label->new('');
$title_label->show;
$vbox->pack_start($title_label, 0, 1, 0);
$file_label =  Gtk2::Label->new('');
$file_label->show;
$vbox->pack_start($file_label, 0, 1, 0);
$requires_label = Gtk2::Label->new('');
$requires_label->show;
$vbox->pack_start($requires_label, 0, 1, 0);
my $source_hbox = Gtk2::HBox->new(0,0);
$source = Gtk2::Text->new;
$source->show;
$source_hbox->pack_start($source, 1, 1, 0);
$source_hbox->show;
my $source_vscroll = Gtk2::VScrollbar->new($source->vadj);
$source_vscroll->show;
$source_hbox->pack_end($source_vscroll, 0, 0, 0);
$vbox->pack_start($source_hbox, 1, 1, 0);
my $hbbox = Gtk2::HButtonBox->new;
$run = Gtk2::Button->new('Quit');
$run->signal_connect("clicked" => sub { Gtk2->exit(0);} );
$run->show;
$hbbox->add($run);
$run =  Gtk2::Button->new('Run');
$run->signal_connect('clicked' => sub {$current_sample->run if defined $current_sample});
$run->show;
$run->can_default(1);
$run->set_sensitive(0);
$hbbox->add($run);
$hbbox->show;
$vbox->pack_end($hbbox, 0, 1, 5);
$hbox->pack_start($vbox, 1, 1, 5);
foreach (sort {$a->{title} cmp $b->{title}} @samples)
  {
    my $list_item = Gtk2::ListItem->new($_->{title});
    $*{$list_item}{sample} = $_;
    $sample_list->add($list_item);
    $list_item->show;
  }

sub idle 
  {
    $sample_list->set_selection_mode('browse');
    $sample_list->select_item(0);
    0;
  }

Gtk2->idle_add(\&idle);
$main_window->signal_connect('destroy' => sub { $main_window->destroy; Gtk2->quit });
$run->grab_default();
$main_window->show;
Gtk2->main;

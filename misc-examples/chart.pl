#!/usr/bin/perl -w

#TITLE: Chart demo
#REQUIRES: Gtk

# chart-demo.pl
#
# Gtk+/Perl chart demo.
#
# 19980813 PMC Created.
#
# Coding and mathematics are horrible, but this is just to demonstrate
# the use of colors and graphics contexts.

# adapted to gtk+ 2.0

#use strict;

use Gtk2;

Gtk2->init(\@ARGV);

my $pixmapChart = undef;
my $width = 600;
my $height = 240;

sub do_chart_expose {
  my ($widget, $event) = @_;
  my @values = $event->area()->values();
  $widget->window->draw_drawable($widget->style->fg_gc('normal'),
				 $pixmapChart,
				 $values[0],
				 $values[1],
				 $values[0],
				 $values[1],
				 $values[2],
				 $values[3]);
  
  0;
}

sub make_color {
    my ($w, $r, $g, $b) = @_;
    my $color = Gtk2::Gdk::Color->new($r, $g, $b);
    $w->window()->get_colormap()->rgb_find_color($color);
    $color;
}

sub draw_chart {
  my ($widget) = @_;
  my ($margin, $axemargin) = ( 20, 20 );
  my ($xticks, $yticks, $tickwidth ) = ( 10, 24, 5 );
  my $steps = 90;
  my ($step);
  my ($tick);
  my $red_gc = Gtk2::Gdk::GC->new($widget->window);
  my $green_gc = Gtk2::Gdk::GC->new($widget->window);
  my $blue_gc = Gtk2::Gdk::GC->new($widget->window);

  my $red_color = make_color($widget, 65000, 0, 0);
  my $green_color = make_color($widget, 0, 65000, 0);
  my $blue_color = make_color($widget, 0, 0, 65000);
  $red_gc->set_rgb_fg_color($red_color);
  $green_gc->set_rgb_fg_color($green_color);
  $blue_gc->set_rgb_fg_color($blue_color);
  $red_color->free();
  $green_color->free();
  $blue_color->free();

  $pixmapChart = new Gtk2::Gdk::Pixmap($widget->window, $width,  $height, -1);
  # clear the pixmap to white
  $pixmapChart->draw_rectangle($widget->style->white_gc, 1, 0, 0, $width, $height);
  $pixmapChart->draw_line($blue_gc, $margin, $height - $margin - $axemargin,
			  $width - $margin, $height - $margin - $axemargin);
  $pixmapChart->draw_line($blue_gc, $margin + $axemargin, $margin,
			  $margin + $axemargin, $height - $margin);
  $tickstep = ( $height - ( $margin * 2 ) - ( $axemargin * 2 ) ) / $xticks;
  for $tick ( 1 .. $xticks ) {
    $pixmapChart->draw_line($red_gc,
			    $margin + $axemargin - $tickwidth,
			    $height - $margin - $axemargin - ( $tick * $tickstep ),
			    $margin + $axemargin,
			    $height - $margin - $axemargin - ( $tick * $tickstep ));
  }
  $tickstep = ( $width - ( $margin * 2 ) - ( $axemargin * 2 ) ) / $yticks;
  for $tick ( 1 .. $yticks ) {
    $pixmapChart->draw_line($red_gc,
			    $margin + $axemargin + ( $tick * $tickstep ),
			    $height - $margin - $axemargin,
			    $margin + $axemargin + ( $tick * $tickstep ),
			    $height - $margin - $axemargin + $tickwidth);
  }
  $range = $width - 2 * $margin - 2 * $axemargin;
  $center = $height / 2;
  $old = $center;
  for $step ( 1 .. $range ) {
    $new = 3.14 / ( $range / 2 - $step + 0.000000001 ) * 20 + $center;
    if ( $new > ( $height - $margin - $axemargin ) ) {
      $new = $margin + $axemargin;
    }
    $pixmapChart->draw_line($green_gc, $margin + $axemargin + $step,
			    $old, $margin + $axemargin + $step + 1, $new);
    $old = $new;
  }
}

# main
my $windowMain = Gtk2::Window->new('toplevel');
$windowMain->signal_connect( 'destroy', sub { Gtk2->quit } );
$windowMain->set_title( 'Chart drawing' );
$windowMain->set_border_width(0);
my $vboxMain = Gtk2::VBox->new(0, 0);
$vboxMain->set_border_width(10);
$windowMain->add($vboxMain);
$vboxMain->show;
my $dareaChart = Gtk2::DrawingArea->new;
$dareaChart->signal_connect( 'expose_event', \&do_chart_expose );
$dareaChart->size( $width, $height );
$vboxMain->pack_start( $dareaChart, 1, 1, 0 );
$dareaChart->set_events( [ 'exposure_mask' ] );
$dareaChart->show;
$dareaChart->realize;
draw_chart($dareaChart);
$windowMain->show;
Gtk2->main;
# end


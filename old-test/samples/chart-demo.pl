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
# ported to Gtk2
# $Id: chart-demo.pl,v 1.1 2002/11/20 20:42:57 gthyni Exp $
#
#use strict;

use Gtk2;

Gtk2->init;

$pixmapChart = undef;
$width = 600;
$height = 240;

sub do_chart_expose {
  my (
    $widget,
    $event
  ) = @_;

  my (
    $event_area
  );

  $event_area = ${$event}{'area'};

  $widget->window->draw_pixmap(
    $widget->style->fg_gc('normal'),
    $pixmapChart,
    ${$event_area}[0],
    ${$event_area}[1],
    ${$event_area}[0],
    ${$event_area}[1],
    ${$event_area}[2],
    ${$event_area}[3]
  );

  0;
}

sub draw_chart {
  my ( $widget ) = @_;
  my ( $margin, $axemargin ) = ( 20, 20 );
  my ( $xticks, $yticks, $tickwidth ) = ( 10, 24, 5 );
  my $steps = 90;
  my $red_gc   = new Gtk2::Gdk::GC($widget->window);
  my $green_gc = new Gtk2::Gdk::GC($widget->window);
  my $blue_gc  = new Gtk2::Gdk::GC($widget->window);
  my $red_color   = $widget->window->get_colormap->rgb_find_color(Gtk2::Gdk::Color->new(65000,0,0));
  my $green_color = $widget->window->get_colormap->rgb_find_color(Gtk2::Gdk::Color->new(0,65000,0));
  my $blue_color  = $widget->window->get_colormap->rgb_find_color(Gtk2::Gdk::Color->new(0,0,65000));

  $red_gc->set_foreground($red_color);
  $green_gc->set_foreground($green_color);
  $blue_gc->set_foreground($blue_color);
  $pixmapChart = new Gtk2::Gdk::Pixmap ($widget->window, $width, $height, -1);
  # clear the pixmap to white
  $pixmapChart->draw_rectangle($widget->style->white_gc, 1, 0, 0, $width, $height);
  $pixmapChart->draw_line($blue_gc, $margin, $height - $margin - $axemargin,
			  $width - $margin, $height - $margin - $axemargin);
  $pixmapChart->draw_line($blue_gc, $margin + $axemargin, $margin, $margin + $axemargin, $height - $margin);
  $tickstep = ( $height - ( $margin * 2 ) - ( $axemargin * 2 ) ) / $xticks;
  for my $tick ( 1 .. $xticks ) {
    $pixmapChart->draw_line($red_gc, $margin + $axemargin - $tickwidth,
			    $height - $margin - $axemargin - ( $tick * $tickstep ),
			    $margin + $axemargin, $height - $margin - $axemargin - ($tick * $tickstep));
  }
  $tickstep = ( $width - ( $margin * 2 ) - ( $axemargin * 2 ) ) / $yticks;
  for my $tick ( 1 .. $yticks ) {
    $pixmapChart->draw_line($red_gc, $margin + $axemargin + ( $tick * $tickstep ),
			    $height - $margin - $axemargin, $margin + $axemargin + ( $tick * $tickstep ),
			    $height - $margin - $axemargin + $tickwidth);
  }
  $range = $width - 2 * $margin - 2 * $axemargin;
  $center = $height / 2;
  $old = $center;
  for my $step ( 1 .. $range ) {
    $new = 3.14 / ( $range / 2 - $step + 0.000000001 ) * 20 + $center;
    $new = $margin + $axemargin
      if $new > ($height - $margin - $axemargin);
    $pixmapChart->draw_line($green_gc, $margin + $axemargin + $step, $old, 
			    $margin + $axemargin + $step + 1, $new);
    $old = $new;
  }
}

# main

my $windowMain = new Gtk2::Window( 'toplevel' );
$windowMain->signal_connect('destroy' => sub { Gtk2->quit });
$windowMain->set_title( 'Chart drawing' );
$windowMain->border_width( 0 );
my $vboxMain = new Gtk2::VBox ( 0, 0 );
$vboxMain->border_width( 10 );
$windowMain->add( $vboxMain );
$vboxMain->show;
my $dareaChart = new Gtk2::DrawingArea;
$dareaChart->signal_connect( 'expose_event', \&do_chart_expose );
$dareaChart->size( $width, $height );
$vboxMain->pack_start( $dareaChart, 1, 1, 0 );
$dareaChart->set_events( [ 'exposure_mask' ] );
$dareaChart->show;
$dareaChart->realize;
draw_chart ( $dareaChart );
$windowMain->show;
Gtk2->main;



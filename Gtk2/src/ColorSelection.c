/* $Id: ColorSelection.c,v 1.5 2002/11/04 19:13:02 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"


SV* gtkperl_color_selection_new(char* class)
{
    return gtk2_perl_new_object(gtk_color_selection_new());
}

SV* gtkperl_color_selection_get_previous_color(SV* colorsel)
{
    GdkColor* c = g_malloc0(sizeof(GdkColor));
    gtk_color_selection_get_previous_color(SvGtkColorSelection(colorsel), c);
    return gtk2_perl_new_object_from_pointer(c, "Gtk2::Gdk::Color");
}

SV* gtkperl_color_selection_get_current_color(SV* colorsel)
{
    GdkColor* c = g_malloc0(sizeof(GdkColor));
    gtk_color_selection_get_current_color(SvGtkColorSelection(colorsel), c);
    return gtk2_perl_new_object_from_pointer(c, "Gtk2::Gdk::Color");
}

void gtkperl_color_selection_set_previous_color(SV* colorsel, SV* color)
{
    gtk_color_selection_set_previous_color(
        SvGtkColorSelection(colorsel), SvGdkColor(color));
}

void gtkperl_color_selection_set_current_color(SV* colorsel, SV* color)
{
    gtk_color_selection_set_current_color(
        SvGtkColorSelection(colorsel), SvGdkColor(color));
}

void gtkperl_color_selection_set_has_palette(SV* colorsel, int flag)
{
    gtk_color_selection_set_has_palette(
        SvGtkColorSelection(colorsel), flag);
}

void gtkperl_color_selection_set_has_opacity_control(SV* colorsel, int flag)
{
    gtk_color_selection_set_has_opacity_control(
        SvGtkColorSelection(colorsel), flag);
}

/*
  gboolean    gtk_color_selection_get_has_opacity_control
                                              (GtkColorSelection *colorsel);
  gboolean    gtk_color_selection_get_has_palette
                                              (GtkColorSelection *colorsel);
  guint16     gtk_color_selection_get_current_alpha
                                              (GtkColorSelection *colorsel);
  void        gtk_color_selection_set_current_alpha
                                              (GtkColorSelection *colorsel,
                                               guint16 alpha);
  guint16     gtk_color_selection_get_previous_alpha
                                              (GtkColorSelection *colorsel);
  void        gtk_color_selection_set_previous_alpha
                                              (GtkColorSelection *colorsel,
                                               guint16 alpha);
  gboolean    gtk_color_selection_is_adjusting
                                              (GtkColorSelection *colorsel);
  gboolean    gtk_color_selection_palette_from_string
                                              (const gchar *str,
                                               GdkColor **colors,
                                               gint *n_colors);
  gchar*      gtk_color_selection_palette_to_string
                                              (const GdkColor *colors,
                                               gint n_colors);
  GtkColorSelectionChangePaletteFunc gtk_color_selection_set_change_palette_hook
                                              (GtkColorSelectionChangePaletteFunc func);
  void        (*GtkColorSelectionChangePaletteFunc)
                                              (const GdkColor *colors,
                                               gint n_colors);
*/

/* Deprecated
  void        gtk_color_selection_set_update_policy
                                              (GtkColorSelection *colorsel,
                                               GtkUpdateType policy);
  void        gtk_color_selection_set_color   (GtkColorSelection *colorsel,
                                               gdouble *color);
  void        gtk_color_selection_get_color   (GtkColorSelection *colorsel,
                                               gdouble *color);
*/

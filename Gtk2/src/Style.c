/* $Id: Style.c,v 1.11 2002/12/13 14:28:05 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"


SV* gtkperl_style_new(char* class)
{
    return gtk2_perl_new_object(gtk_style_new());
}


SV* gtkperl_style_copy(SV *style)
{
    return gtk2_perl_new_object(gtk_style_copy(SvGtkStyle(style)));
}

/* GtkIconSet* gtk_style_lookup_icon_set (GtkStyle *style, const gchar *stock_id) */
SV* gtkperl_style_lookup_icon_set(SV* style, gchar* stock_id)
{
    return gtk2_perl_new_object_from_pointer(gtk_style_lookup_icon_set(SvGtkStyle(style), stock_id),
					     "Gtk2::IconSet");
}


/** access functions **/

void gtkperl_style_set_font_desc(SV* style, SV* pango_font)
{
    SvGtkStyle(style)->font_desc = SvPangoFontDescription(pango_font);
}

SV* gtkperl_style_get_font_desc(SV* style)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->font_desc,
					     "Gtk2::Pango::FontDescription");
}

void gtkperl_style_set_fg_gc(SV* style, SV* state, SV* gc)
{
    SvGtkStyle(style)->fg_gc[SvGtkStateType(state)] = SvGdkGC(gc);
}

SV* gtkperl_style_get_fg_gc(SV* style, SV* state)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->fg_gc[SvGtkStateType(state)],
					     "Gtk2::Gdk::GC");
}

void gtkperl_style_set_bg_gc(SV* style, SV* state, SV* gc)
{
    SvGtkStyle(style)->bg_gc[SvGtkStateType(state)] = SvGdkGC(gc);
}

SV* gtkperl_style_get_bg_gc(SV* style, SV* state)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->bg_gc[SvGtkStateType(state)],
					     "Gtk2::Gdk::GC");
}

void gtkperl_style_set_light_gc(SV* style, SV* state, SV* gc)
{
    SvGtkStyle(style)->light_gc[SvGtkStateType(state)] = SvGdkGC(gc);
}

SV* gtkperl_style_get_light_gc(SV* style, SV* state)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->light_gc[SvGtkStateType(state)],
					     "Gtk2::Gdk::GC");
}

void gtkperl_style_set_dark_gc(SV* style, SV* state, SV* gc)
{
    SvGtkStyle(style)->dark_gc[SvGtkStateType(state)] = SvGdkGC(gc);
}

SV* gtkperl_style_get_dark_gc(SV* style, SV* state)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->dark_gc[SvGtkStateType(state)],
					     "Gtk2::Gdk::GC");
}

void gtkperl_style_set_mid_gc(SV* style, SV* state, SV* gc)
{
    SvGtkStyle(style)->mid_gc[SvGtkStateType(state)] = SvGdkGC(gc);
}

SV* gtkperl_style_get_mid_gc(SV* style, SV* state)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->mid_gc[SvGtkStateType(state)],
					     "Gtk2::Gdk::GC");
}

void gtkperl_style_set_text_gc(SV* style, SV* state, SV* gc)
{
    SvGtkStyle(style)->text_gc[SvGtkStateType(state)] = SvGdkGC(gc);
}

SV* gtkperl_style_get_text_gc(SV* style, SV* state)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->text_gc[SvGtkStateType(state)],
					     "Gtk2::Gdk::GC");
}

void gtkperl_style_set_base_gc(SV* style, SV* state, SV* gc)
{
    SvGtkStyle(style)->base_gc[SvGtkStateType(state)] = SvGdkGC(gc);
}

SV* gtkperl_style_get_base_gc(SV* style, SV* state)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->base_gc[SvGtkStateType(state)],
					     "Gtk2::Gdk::GC");
}

void gtkperl_style_set_text_aa_gc(SV* style, SV* state, SV* gc)
{
    SvGtkStyle(style)->text_aa_gc[SvGtkStateType(state)] = SvGdkGC(gc);
}

SV* gtkperl_style_get_text_aa_gc(SV* style, SV* state)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->text_aa_gc[SvGtkStateType(state)],
					     "Gtk2::Gdk::GC");
}

void gtkperl_style_set_white_gc(SV* style, SV* gc)
{
    SvGtkStyle(style)->white_gc = SvGdkGC(gc);
}

SV* gtkperl_style_get_white_gc(SV* style)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->white_gc, "Gtk2::Gdk::GC");
}

void gtkperl_style_set_black_gc(SV* style, SV* gc)
{
    SvGtkStyle(style)->black_gc = SvGdkGC(gc);
}

SV* gtkperl_style_get_black_gc(SV* style)
{
    return gtk2_perl_new_object_from_pointer(SvGtkStyle(style)->black_gc, "Gtk2::Gdk::GC");
}

// colors

SV* gtkperl_style__get_bg_color(SV* style, int state)
{
    GdkColor* colors = SvGtkStyle(style)->bg;
    return gtk2_perl_new_object_from_pointer(&colors[state], "Gtk2::Gdk::Color");
}

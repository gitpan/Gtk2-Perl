/* $Id: Label.c,v 1.9 2002/11/20 18:15:37 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

/* GtkWidget* gtk_label_new (const char *str) */
SV* gtkperl_label__new(char* class, gchar* str)
{
    return gtk2_perl_new_object(gtk_label_new(str));
}

/* GtkWidget* gtk_label_new_with_mnemonic (const char *str) */
SV* gtkperl_label_new_with_mnemonic(gchar* str)
{
    return gtk2_perl_new_object(gtk_label_new_with_mnemonic(str));
}

/* void gtk_label_set_text (GtkLabel *label, const char *str) */
void gtkperl_label_set_text(SV* label, gchar* str)
{
    gtk_label_set_text(SvGtkLabel(label), str);
}

/* G_CONST_RETURN gchar* gtk_label_get_text (GtkLabel *label) */
gchar* gtkperl_label_get_text(SV* label)
{
    return gtk_label_get_text(SvGtkLabel(label));
}

/* void gtk_label_set_attributes (GtkLabel *label, PangoAttrList *attrs) */
void gtkperl_label_set_attributes(SV* label, SV* attrs)
{
    gtk_label_set_attributes(SvGtkLabel(label), SvPangoAttrList(attrs));
}

/* PangoAttrList *gtk_label_get_attributes (GtkLabel *label) */
SV* gtkperl_label_get_attributes(SV* label)
{
    return gtk2_perl_new_object_from_pointer_nullok(gtk_label_get_attributes(SvGtkLabel(label)),
						    "Gtk2::Pango::AttrList");
}

/* void gtk_label_set_label (GtkLabel *label, const gchar *str) */
void gtkperl_label_set_label(SV* label, gchar* str)
{
    gtk_label_set_label(SvGtkLabel(label), str);
}

/* G_CONST_RETURN gchar *gtk_label_get_label (GtkLabel *label) */
gchar* gtkperl_label_get_label(SV* label)
{
    return gtk_label_get_label(SvGtkLabel(label));
}

/* void gtk_label_set_markup (GtkLabel *label, const gchar *str) */
void gtkperl_label_set_markup(SV* label, gchar* str)
{
    gtk_label_set_markup(SvGtkLabel(label), str);
}

/* void gtk_label_set_use_markup (GtkLabel *label, gboolean setting) */
void gtkperl_label_set_use_markup(SV* label, int setting)
{
    gtk_label_set_use_markup(SvGtkLabel(label), setting);
}

/* gboolean gtk_label_get_use_markup (GtkLabel *label) */
int gtkperl_label_get_use_markup(SV* label)
{
    return gtk_label_get_use_markup(SvGtkLabel(label));
}

/* void gtk_label_set_use_underline (GtkLabel *label, gboolean setting) */
void gtkperl_label_set_use_underline(SV* label, int setting)
{
    gtk_label_set_use_underline(SvGtkLabel(label), setting);
}

/* gboolean gtk_label_get_use_underline (GtkLabel *label) */
int gtkperl_label_get_use_underline(SV* label)
{
    return gtk_label_get_use_underline(SvGtkLabel(label));
}

/* void gtk_label_set_markup_with_mnemonic (GtkLabel *label, const gchar *str) */
void gtkperl_label_set_markup_with_mnemonic(SV* label, gchar* str)
{
    gtk_label_set_markup_with_mnemonic(SvGtkLabel(label), str);
}

/* guint gtk_label_get_mnemonic_keyval (GtkLabel *label) */
int gtkperl_label_get_mnemonic_keyval(SV* label)
{
    return gtk_label_get_mnemonic_keyval(SvGtkLabel(label));
}

/* void gtk_label_set_mnemonic_widget (GtkLabel *label, GtkWidget *widget) */
void gtkperl_label_set_mnemonic_widget(SV* label, SV* widget)
{
    gtk_label_set_mnemonic_widget(SvGtkLabel(label), SvGtkWidget(widget));
}

/* GtkWidget *gtk_label_get_mnemonic_widget (GtkLabel *label) */
SV* gtkperl_label_get_mnemonic_widget(SV* label)
{
    return gtk2_perl_new_object_nullok(gtk_label_get_mnemonic_widget(SvGtkLabel(label)));
}

/* void gtk_label_set_text_with_mnemonic (GtkLabel *label, const gchar *str) */
void gtkperl_label_set_text_with_mnemonic(SV* label, gchar* str)
{
    gtk_label_set_text_with_mnemonic(SvGtkLabel(label), str);
}

/* void gtk_label_set_justify (GtkLabel *label, GtkJustification jtype) */
void gtkperl_label_set_justify(SV* label, SV* jtype)
{
    gtk_label_set_justify(SvGtkLabel(label), SvGtkJustification(jtype));
}

/* GtkJustification gtk_label_get_justify (GtkLabel *label) */
SV* gtkperl_label_get_justify(SV* label)
{
    return newSVGtkJustification(gtk_label_get_justify(SvGtkLabel(label)));
}

/* void gtk_label_set_pattern (GtkLabel *label, const gchar *pattern) */
void gtkperl_label_set_pattern(SV* label, gchar* pattern)
{
    gtk_label_set_pattern(SvGtkLabel(label), pattern);
}

/* void gtk_label_set_line_wrap (GtkLabel *label, gboolean wrap) */
void gtkperl_label_set_line_wrap(SV* label, int wrap)
{
    gtk_label_set_line_wrap(SvGtkLabel(label), wrap);
}

/* gboolean gtk_label_get_line_wrap (GtkLabel *label) */
int gtkperl_label_get_line_wrap(SV* label)
{
    return gtk_label_get_line_wrap(SvGtkLabel(label));
}

/* void gtk_label_set_selectable (GtkLabel *label, gboolean setting) */
void gtkperl_label_set_selectable(SV* label, int setting)
{
    gtk_label_set_selectable(SvGtkLabel(label), setting);
}

/* gboolean gtk_label_get_selectable (GtkLabel *label) */
int gtkperl_label_get_selectable(SV* label)
{
    return gtk_label_get_selectable(SvGtkLabel(label));
}

/* void gtk_label_select_region (GtkLabel *label, gint start_offset, gint end_offset) */
void gtkperl_label_select_region(SV* label, int start_offset, int end_offset)
{
    gtk_label_select_region(SvGtkLabel(label), start_offset, end_offset);
}

/* gboolean gtk_label_get_selection_bounds (GtkLabel *label, gint *start, gint *end) */
SV* gtkperl_label__get_selection_bounds(SV* label)
{
    gint start, end;
    AV* values = newAV();
    gtk_label_get_selection_bounds(SvGtkLabel(label), &start, &end);
    av_push(values, newSViv(start));
    av_push(values, newSViv(end));
    return newRV_noinc((SV*) values);
}

/* PangoLayout *gtk_label_get_layout (GtkLabel *label) */
SV* gtkperl_label_get_layout(SV* label)
{
    return gtk2_perl_new_object_from_pointer_nullok(gtk_label_get_layout(SvGtkLabel(label)),
						    "Gtk2::Pango::Layout");
}

/* void gtk_label_get_layout_offsets (GtkLabel *label, gint *x, gint *y) */
SV* gtkperl_label__get_layout_offsets(SV* label)
{
    gint x, y;
    AV* values = newAV();
    gtk_label_get_layout_offsets(SvGtkLabel(label), &x, &y);
    av_push(values, newSViv(x));
    av_push(values, newSViv(y));
    return newRV_noinc((SV*) values);
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

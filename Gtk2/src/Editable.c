/* $Id: Editable.c,v 1.5 2002/11/20 20:42:56 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

/* Just an interface */

void gtkperl_editable_select_region(SV* editable, int start, int end)
{
    gtk_editable_select_region(SvGtkEditable(editable), start, end);
}

SV* gtkperl_editable__get_selection_bounds(SV* editable)
{
    gint start, end;
    AV* bounds = newAV();
    gtk_editable_get_selection_bounds(SvGtkEditable(editable), &start, &end);
    av_push(bounds, newSViv(start));
    av_push(bounds, newSViv(end));
    return newRV_noinc((SV*) bounds);
}

int gtkperl_editable_insert_text(SV* editable, gchar* new_text, int position)
{
    gint g_position = position;
    gtk_editable_insert_text(SvGtkEditable(editable), new_text, strlen(new_text), &g_position);
    return g_position;
}

void gtkperl_editable_delete_text(SV* editable, int start_pos, int end_pos)
{
    gtk_editable_delete_text(SvGtkEditable(editable), start_pos, end_pos);
}

SV* gtkperl_editable_get_chars(SV* editable, int start_pos, int end_pos)
{
    return newSVgchar(gtk_editable_get_chars(SvGtkEditable(editable), start_pos, end_pos));
}

void gtkperl_editable_cut_clipboard(SV* editable)
{
    gtk_editable_cut_clipboard(SvGtkEditable(editable));
}

void gtkperl_editable_copy_clipboard(SV* editable)
{
    gtk_editable_copy_clipboard(SvGtkEditable(editable));
}

void gtkperl_editable_paste_clipboard(SV* editable)
{
    gtk_editable_paste_clipboard(SvGtkEditable(editable));
}

void gtkperl_editable_delete_selection(SV* editable)
{
    gtk_editable_delete_selection(SvGtkEditable(editable));
}

void gtkperl_editable_set_position(SV* editable, int position)
{
    gtk_editable_set_position(SvGtkEditable(editable), position);
}

int gtkperl_editable_get_position(SV* editable)
{
    return gtk_editable_get_position(SvGtkEditable(editable));
}

void gtkperl_editable_set_editable(SV* editable, int is_editable)
{
    gtk_editable_set_editable(SvGtkEditable(editable), is_editable);
}

int gtkperl_editable_get_editable(SV* editable)
{
    return gtk_editable_get_editable(SvGtkEditable(editable));
}



/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

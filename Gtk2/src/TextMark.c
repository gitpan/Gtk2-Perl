/*
 * Copyright (c) 2002 Guillaume Cottenceau (gc at mandrakesoft dot com)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * $Id: TextMark.c,v 1.1 2003/03/04 12:25:22 ggc Exp $
 */

#include "gtk2-perl.h"

/* void gtk_text_mark_set_visible (GtkTextMark *mark, gboolean setting) */
void gtkperl_text_mark_set_visible(SV* mark, int setting)
{
    gtk_text_mark_set_visible(SvGtkTextMark(mark), setting);
}

/* gboolean gtk_text_mark_get_visible (GtkTextMark *mark) */
int gtkperl_text_mark_get_visible(SV* mark)
{
    return gtk_text_mark_get_visible(SvGtkTextMark(mark));
}

/* G_CONST_RETURN gchar* gtk_text_mark_get_name (GtkTextMark *mark) */
SV* gtkperl_text_mark_get_name(SV* mark)
{
    return newSVgchar_nofree(gtk_text_mark_get_name(SvGtkTextMark(mark)));
}

/* gboolean gtk_text_mark_get_deleted (GtkTextMark *mark) */
int gtkperl_text_mark_get_deleted(SV* mark)
{
    return gtk_text_mark_get_deleted(SvGtkTextMark(mark));
}

/* GtkTextBuffer* gtk_text_mark_get_buffer (GtkTextMark *mark) */
SV* gtkperl_text_mark_get_buffer(SV* mark)
{
    return gtk2_perl_new_object_nullok(gtk_text_mark_get_buffer(SvGtkTextMark(mark)));
}

/* gboolean gtk_text_mark_get_left_gravity (GtkTextMark *mark) */
int gtkperl_text_mark_get_left_gravity(SV* mark)
{
    return gtk_text_mark_get_left_gravity(SvGtkTextMark(mark));
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

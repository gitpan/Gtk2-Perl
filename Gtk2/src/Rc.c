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
 * $Id: Rc.c,v 1.1 2002/11/27 19:46:41 ggc Exp $
 */

#include "gtk2-perl.h"


/* void gtk_rc_add_default_file (const gchar *filename) */
void gtkperl_rc_add_default_file(char* class, gchar* filename)
{
    gtk_rc_add_default_file(filename);
}

/* void gtk_rc_set_default_files (gchar **filenames) */
void gtkperl_rc__set_default_files(char* class, SV* files)
{
    AV* a_files = (AV*) SvRV(files);
    gchar ** g_files = (gchar **) g_malloc0((av_len(a_files)+2) * sizeof(gchar*));
    int i;
    for (i=0; i<=av_len(a_files); i++)
	g_files[i] = SvPV_nolen(*av_fetch(a_files, i, 0));
    gtk_rc_set_default_files(g_files);
    g_free(g_files);
}

/* gchar** gtk_rc_get_default_files (void) */
SV* gtkperl_rc__get_default_files(char* class)
{
    AV* a_files = newAV();
    gchar ** g_files = gtk_rc_get_default_files();
    while (g_files && *g_files) {
	av_push(a_files, newSVpv(*g_files, 0));
	g_files++;
    }
    return newRV_noinc((SV*) a_files);
}

/* GtkStyle* gtk_rc_get_style (GtkWidget *widget) */
SV* gtkperl_rc_get_style(char* class, SV* widget)
{
    return gtk2_perl_new_object(gtk_rc_get_style(SvGtkWidget(widget)));
}

/* GtkStyle* gtk_rc_get_style_by_paths (GtkSettings *settings, const char *widget_path, const char *class_path, GType type) */
SV* gtkperl_rc_get_style_by_paths(char* class, SV* settings, char* widget_path, char* class_path, int type)
{
    return gtk2_perl_new_object(gtk_rc_get_style_by_paths(SvGtkSettings(settings), widget_path, class_path, type));
}

/* gboolean gtk_rc_reparse_all_for_settings (GtkSettings *settings, gboolean force_load) */
int gtkperl_rc_reparse_all_for_settings(char* class, SV* settings, int force_load)
{
    return gtk_rc_reparse_all_for_settings(SvGtkSettings(settings), force_load);
}

/* void gtk_rc_parse (const gchar *filename) */
void gtkperl_rc_parse(char* class, gchar* filename)
{
    gtk_rc_parse(filename);
}

/* void gtk_rc_parse_string (const gchar *rc_string) */
void gtkperl_rc_parse_string(char* class, gchar* rc_string)
{
    gtk_rc_parse_string(rc_string);
}

/* gboolean gtk_rc_reparse_all (void) */
int gtkperl_rc_reparse_all(char* class)
{
    return gtk_rc_reparse_all();
}



/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

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
 * $Id: TreePath.c,v 1.4 2002/11/26 13:46:14 ggc Exp $
 */

#include "gtk2-perl.h"

/* GtkTreePath *gtk_tree_path_new (void) */
SV* gtkperl_tree_path_new(char* class)
{
    return gtk2_perl_new_object_from_pointer(gtk_tree_path_new(), class);
}

/* GtkTreePath *gtk_tree_path_new_from_string (const gchar *path) */
SV* gtkperl_tree_path_new_from_string(char* class, char* path)
{
    return gtk2_perl_new_object_from_pointer_nullok(gtk_tree_path_new_from_string(path), class);
}

/* gchar *gtk_tree_path_to_string (GtkTreePath *path) */
SV* gtkperl_tree_path_to_string(SV* path)
{
    return newSVgchar(gtk_tree_path_to_string(SvGtkTreePath(path)));
}

/* GtkTreePath *gtk_tree_path_new_first (void) */
SV* gtkperl_tree_path_new_first(char* class)
{
    return gtk2_perl_new_object_from_pointer(gtk_tree_path_new_first(), class);
}

/* void gtk_tree_path_append_index (GtkTreePath *path, gint index) */
void gtkperl_tree_path_append_index(SV* path, int index)
{
    gtk_tree_path_append_index(SvGtkTreePath(path), index);
}

/* void gtk_tree_path_prepend_index (GtkTreePath *path, gint index) */
void gtkperl_tree_path_prepend_index(SV* path, int index)
{
    gtk_tree_path_prepend_index(SvGtkTreePath(path), index);
}

/* gint gtk_tree_path_get_depth (GtkTreePath *path) */
int gtkperl_tree_path_get_depth(SV* path)
{
    return gtk_tree_path_get_depth(SvGtkTreePath(path));
}

/* gint *gtk_tree_path_get_indices (GtkTreePath *path) */
SV* gtkperl_tree_path__get_indices(SV* path)
{
    gint* g_indices;
    AV* indices;
    gint i, depth;
    
    depth = gtk_tree_path_get_depth(SvGtkTreePath(path));
    if (depth == 0)
	return &PL_sv_undef;

    g_indices = gtk_tree_path_get_indices(SvGtkTreePath(path));
    indices = newAV();
    for (i=0; i<depth; i++)
	av_push(indices, newSViv(g_indices[i]));

    return newRV_noinc((SV*) indices);
}

/* This function is really needed, a TreePath is a little bit more than a standard boxed type */
/* void gtk_tree_path_free (GtkTreePath *path) */
void gtkperl_tree_path_free(SV* path)
{
    gtk_tree_path_free(SvGtkTreePath(path));
}

/* GtkTreePath *gtk_tree_path_copy (const GtkTreePath *path) */
SV* gtkperl_tree_path_copy(SV* path)
{
    return gtk2_perl_new_object_from_pointer(gtk_tree_path_copy(SvGtkTreePath(path)),
					     "Gtk2::TreePath");
}

/* gint gtk_tree_path_compare (const GtkTreePath *a, const GtkTreePath *b) */
int gtkperl_tree_path_compare(SV* a, SV* b)
{
    return gtk_tree_path_compare(SvGtkTreePath(a), SvGtkTreePath(b));
}

/* void gtk_tree_path_next (GtkTreePath *path) */
void gtkperl_tree_path_next(SV* path)
{
    gtk_tree_path_next(SvGtkTreePath(path));
}

/* gboolean gtk_tree_path_prev (GtkTreePath *path) */
int gtkperl_tree_path_prev(SV* path)
{
    return gtk_tree_path_prev(SvGtkTreePath(path));
}

/* gboolean gtk_tree_path_up (GtkTreePath *path) */
int gtkperl_tree_path_up(SV* path)
{
    return gtk_tree_path_up(SvGtkTreePath(path));
}

/* void gtk_tree_path_down (GtkTreePath *path) */
void gtkperl_tree_path_down(SV* path)
{
    gtk_tree_path_down(SvGtkTreePath(path));
}

/* gboolean gtk_tree_path_is_ancestor (GtkTreePath *path, GtkTreePath *descendant) */
int gtkperl_tree_path_is_ancestor(SV* path, SV* descendant)
{
    return gtk_tree_path_is_ancestor(SvGtkTreePath(path), SvGtkTreePath(descendant));
}

/* gboolean gtk_tree_path_is_descendant (GtkTreePath *path, GtkTreePath *ancestor) */
int gtkperl_tree_path_is_descendant(SV* path, SV* ancestor)
{
    return gtk_tree_path_is_descendant(SvGtkTreePath(path), SvGtkTreePath(ancestor));
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

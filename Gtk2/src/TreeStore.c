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
 * $Id: TreeStore.c,v 1.3 2003/03/04 11:26:37 ggc Exp $
 */

#include "gtk2-perl.h"

SV* gtkperl_tree_store__new(char* class, SV* argv_ref)
{
    AV* argv = (AV*) SvRV(argv_ref);
    int i, n_columns = av_len(argv) + 1;
    GType* types = g_malloc0(n_columns * sizeof(GType));
    SV* obj;
    for (i=0; i<n_columns; i++)
	types[i] = SvIV(*av_fetch(argv, i, 0));

    obj = gtk2_perl_new_object(gtk_tree_store_newv(n_columns, types));

    g_free(types);
    return obj;
}

void gtkperl_tree_store_set(SV* tree_store, SV* iter, SV* argv_ref)
{
    int i;
    AV* argv = (AV*) SvRV(argv_ref); 
    int len = av_len(argv) + 1;
    GtkTreeStore* ts = SvGtkTreeStore(tree_store);
    GtkTreeIter* giter = SvGtkTreeIter(iter);
    for (i = 0; i < len; i += 2) {
	SV* column = *av_fetch(argv, i,   0);
	SV* value  = *av_fetch(argv, i+1, 0);
	GValue gval = { 0, };
	sv_utf8_upgrade(value);
	g_value_init(&gval, gtk_tree_model_get_column_type(GTK_TREE_MODEL(ts), SvIV(column)));
	if (gperl_value_from_object(&gval, value))
	    fprintf(stderr, "%s: value is of the wrong type for column %d (expecting type %s)\n",
		    __FUNCTION__, (int)SvIV(column), g_type_name(G_TYPE_FUNDAMENTAL(G_VALUE_TYPE(&gval)))); 
	else
	    gtk_tree_store_set_value(ts, giter, SvIV(column), &gval);
    }
}

/* void gtk_tree_store_remove (GtkTreeStore *tree_store, GtkTreeIter *iter) */
void gtkperl_tree_store_remove(SV* tree_store, SV* iter)
{
    gtk_tree_store_remove(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter));
}

/* void gtk_tree_store_insert (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *parent, gint position) */
void gtkperl_tree_store_insert(SV* tree_store, SV* iter, SV* parent, int position)
{
    gtk_tree_store_insert(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter), SvGtkTreeIter_nullok(parent), position);
}

/* void gtk_tree_store_insert_before (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *parent, GtkTreeIter *sibling) */
void gtkperl_tree_store_insert_before(SV* tree_store, SV* iter, SV* parent, SV* sibling)
{
    gtk_tree_store_insert_before(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter),
				 SvGtkTreeIter_nullok(parent), SvGtkTreeIter_nullok(sibling));
}

/* void gtk_tree_store_insert_after (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *parent, GtkTreeIter *sibling) */
void gtkperl_tree_store_insert_after(SV* tree_store, SV* iter, SV* parent, SV* sibling)
{
    gtk_tree_store_insert_after(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter),
				SvGtkTreeIter_nullok(parent), SvGtkTreeIter_nullok(sibling));
}

/* void gtk_tree_store_prepend (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *parent) */
void gtkperl_tree_store_prepend(SV* tree_store, SV* iter, SV* parent)
{
    gtk_tree_store_prepend(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter), SvGtkTreeIter_nullok(parent));
}

/* void gtk_tree_store_append (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *parent) */
void gtkperl_tree_store_append(SV* tree_store, SV* iter, SV* parent)
{
    gtk_tree_store_append(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter), SvGtkTreeIter_nullok(parent));
}

/* gboolean gtk_tree_store_is_ancestor (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *descendant) */
int gtkperl_tree_store_is_ancestor(SV* tree_store, SV* iter, SV* descendant)
{
    return gtk_tree_store_is_ancestor(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter), SvGtkTreeIter(descendant));
}

/* gint gtk_tree_store_iter_depth (GtkTreeStore *tree_store, GtkTreeIter *iter) */
int gtkperl_tree_store_iter_depth(SV* tree_store, SV* iter)
{
    return gtk_tree_store_iter_depth(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter));
}

/* void gtk_tree_store_clear (GtkTreeStore *tree_store) */
void gtkperl_tree_store_clear(SV* tree_store)
{
    gtk_tree_store_clear(SvGtkTreeStore(tree_store));
}

#if GTK_CHECK_VERSION(2,2,0)
/* gboolean gtk_tree_store_iter_is_valid (GtkTreeStore *tree_store, GtkTreeIter *iter) */
int gtkperl_tree_store_iter_is_valid(SV* tree_store, SV* iter)
{
    return gtk_tree_store_iter_is_valid(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter));
}

/* void gtk_tree_store_swap (GtkTreeStore *tree_store, GtkTreeIter *a, GtkTreeIter *b) */
void gtkperl_tree_store_swap(SV* tree_store, SV* a, SV* b)
{
    gtk_tree_store_swap(SvGtkTreeStore(tree_store), SvGtkTreeIter(a), SvGtkTreeIter(b));
}

/* void gtk_tree_store_move_before (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *position) */
void gtkperl_tree_store_move_before(SV* tree_store, SV* iter, SV* position)
{
    gtk_tree_store_move_before(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter), SvGtkTreeIter_nullok(position));
}

/* void gtk_tree_store_move_after (GtkTreeStore *tree_store, GtkTreeIter *iter, GtkTreeIter *position) */
void gtkperl_tree_store_move_after(SV* tree_store, SV* iter, SV* position)
{
    gtk_tree_store_move_after(SvGtkTreeStore(tree_store), SvGtkTreeIter(iter), SvGtkTreeIter_nullok(position));
}
#endif

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

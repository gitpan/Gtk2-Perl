/* $Id: ListStore.c,v 1.14 2003/03/18 00:19:47 muppetman Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"
#include <stdio.h>
#include <stdarg.h>


SV* gtkperl_list_store__new(char* class, int n_columns, SV* argv_ref)
{
    int i;
    AV* argv = (AV*) SvRV(argv_ref);
    SV* liststore;
    GType* types = g_malloc0(n_columns * sizeof(GType));
    for (i = 0; i < n_columns; i++) {
	SV* sv = av_shift(argv);
	types[i] = SvIV(sv);
    }
    liststore = gtk2_perl_new_object(gtk_list_store_newv(n_columns, types));
    g_free(types);
    return liststore;
}

void gtkperl_list_store_set(SV* list_store, SV* iter, SV* argv_ref)
{
    int i;
    AV* argv = (AV*) SvRV(argv_ref); 
    int len = av_len(argv) + 1;
    GtkListStore* ls = SvGtkListStore(list_store);
    GtkTreeIter* giter = SvGtkTreeIter(iter);
    for (i = 0; i < len; i += 2) {
	SV *column, *value;
	GValue gval = { 0 };
	column = av_shift(argv);
	value = av_shift(argv);
	sv_utf8_upgrade(value);
	g_value_init(&gval, gtk_tree_model_get_column_type(GTK_TREE_MODEL(ls), SvIV(column)));
	if (gperl_value_from_object(&gval, value)) {
	    fprintf(stderr, "%s: value is of the wrong type for column %d (expecting type %s)\n",
		    __FUNCTION__, (int)SvIV(column), g_type_name(G_TYPE_FUNDAMENTAL(G_VALUE_TYPE(&gval)))); 
	}
	else
	    gtk_list_store_set_value(GTK_LIST_STORE(ls),
				     giter, SvIV(column), &gval);
    }
}

/* gboolean gtk_list_store_remove (GtkListStore *list_store, GtkTreeIter *iter) */
int gtkperl_list_store_remove(SV* list_store, SV* iter)
{
#if GTK_CHECK_VERSION(2,2,0)
    return gtk_list_store_remove(SvGtkListStore(list_store), SvGtkTreeIter(iter));
#else
    gtk_list_store_remove(SvGtkListStore(list_store), SvGtkTreeIter(iter));
    return FALSE;
#endif
}

/* void gtk_list_store_insert (GtkListStore *list_store, GtkTreeIter *iter, gint position) */
void gtkperl_list_store_insert(SV* list_store, SV* iter, int position)
{
    gtk_list_store_insert(SvGtkListStore(list_store), SvGtkTreeIter(iter), position);
}

/* void gtk_list_store_insert_before (GtkListStore *list_store, GtkTreeIter *iter, GtkTreeIter *sibling) */
void gtkperl_list_store_insert_before(SV* list_store, SV* iter, SV* sibling)
{
    gtk_list_store_insert_before(SvGtkListStore(list_store), SvGtkTreeIter(iter), SvGtkTreeIter(sibling));
}

/* void gtk_list_store_insert_after (GtkListStore *list_store, GtkTreeIter *iter, GtkTreeIter *sibling) */
void gtkperl_list_store_insert_after(SV* list_store, SV* iter, SV* sibling)
{
    gtk_list_store_insert_after(SvGtkListStore(list_store), SvGtkTreeIter(iter), SvGtkTreeIter(sibling));
}

/* void gtk_list_store_prepend (GtkListStore *list_store, GtkTreeIter *iter) */
void gtkperl_list_store_prepend(SV* list_store, SV* iter)
{
    gtk_list_store_prepend(SvGtkListStore(list_store), SvGtkTreeIter(iter));
}

/* void gtk_list_store_append (GtkListStore *list_store, GtkTreeIter *iter) */
void gtkperl_list_store_append(SV* list_store, SV* iter)
{
    gtk_list_store_append(SvGtkListStore(list_store), SvGtkTreeIter(iter));
}

/* void gtk_list_store_clear (GtkListStore *list_store) */
void gtkperl_list_store_clear(SV* list_store)
{
    gtk_list_store_clear(SvGtkListStore(list_store));
}

#if GTK_CHECK_VERSION(2,2,0)
/* gboolean gtk_list_store_iter_is_valid (GtkListStore *list_store, GtkTreeIter *iter) */
int gtkperl_list_store_iter_is_valid(SV* list_store, SV* iter)
{
    return gtk_list_store_iter_is_valid(SvGtkListStore(list_store), SvGtkTreeIter(iter));
}

/* void gtk_list_store_swap (GtkListStore *store, GtkTreeIter *a, GtkTreeIter *b) */
void gtkperl_list_store_swap(SV* store, SV* a, SV* b)
{
    gtk_list_store_swap(SvGtkListStore(store), SvGtkTreeIter(a), SvGtkTreeIter(b));
}

/* void gtk_list_store_move_after (GtkListStore *store, GtkTreeIter *iter, GtkTreeIter *position) */
void gtkperl_list_store_move_after(SV* store, SV* iter, SV* position)
{
    gtk_list_store_move_after(SvGtkListStore(store), SvGtkTreeIter(iter), SvGtkTreeIter_nullok(position));
}

/* void gtk_list_store_move_before (GtkListStore *store, GtkTreeIter *iter, GtkTreeIter *position) */
void gtkperl_list_store_move_before(SV* store, SV* iter, SV* position)
{
    gtk_list_store_move_before(SvGtkListStore(store), SvGtkTreeIter(iter), SvGtkTreeIter_nullok(position));
}
#endif

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

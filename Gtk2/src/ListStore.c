/* $Id: ListStore.c,v 1.11 2003/01/22 11:57:00 dlacroix Exp $
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

/* NOT IMPLEMENTED YET 
GtkListStore* gtk_list_store_newv(gint n_columns,GType *types);
void gtk_list_store_set_column_types(GtkListStore *list_store,gint n_columns,GType *types);
*/

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
	    fprintf(stderr, G_GNUC_FUNCTION ": value is of the wrong type for this column");
	}
	else
	    gtk_list_store_set_value(GTK_LIST_STORE(ls),
				     giter, SvIV(column), &gval);
    }
}

/* NOT IMPLEMENTED YET 
void gtk_list_store_set_valist(GtkListStore *list_store,GtkTreeIter *iter,va_list var_args);
void gtk_list_store_set_value(GtkListStore *list_store,GtkTreeIter *iter,gint column,GValue *value);
*/

int gtkperl_list_store_remove(SV *list_store, SV *iter)
{
  return gtk_list_store_remove(SvGtkListStore(list_store),SvGtkTreeIter(iter));
}

/* NOT IMPLEMENTED YET
void gtk_list_store_insert(GtkListStore *list_store,GtkTreeIter *iter,gint position);
void gtk_list_store_insert_before(GtkListStore *list_store,GtkTreeIter *iter,GtkTreeIter *sibling);
void gtk_list_store_insert_after(GtkListStore *list_store,GtkTreeIter *iter,GtkTreeIter *sibling);
void gtk_list_store_prepend(GtkListStore *list_store,GtkTreeIter *iter);
*/

void gtkperl_list_store_append(SV* list_store, SV* iter)
{
    gtk_list_store_append(SvGtkListStore(list_store), SvGtkTreeIter(iter));
}

void gtkperl_list_store_clear(SV* list_store)
{
    gtk_list_store_clear(SvGtkListStore(list_store));
}


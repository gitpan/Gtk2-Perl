/*
 * Copyright 2002, Marin Purgar <numessiah@users.sourceforge.net>
 * licensed under Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

void gtkperl_tree_selection_set_mode(SV *selection, SV *type)
{
    gtk_tree_selection_set_mode(SvGtkTreeSelection(selection), SvGtkSelectionMode(type));
}

SV* gtkperl_tree_selection_get_tree_view(SV *selection)
{
    return gtk2_perl_new_object(gtk_tree_selection_get_tree_view(SvGtkTreeSelection(selection)));
}

SV* gtkperl_tree_selection_get_mode(SV *selection)
{
    return newSVGtkSelectionMode(gtk_tree_selection_get_mode(SvGtkTreeSelection(selection)));
}

AV* gtkperl_tree_selection__get_selected(SV *selection)
{
    GtkTreeModel* model;
    GtkTreeIter* iter = g_malloc0(sizeof(GtkTreeIter));
    AV* result = newAV();
    if (gtk_tree_selection_get_selected(SvGtkTreeSelection(selection), &model, iter)) {
        av_push(result, gtk2_perl_new_object(model));
        av_push(result, gtk2_perl_new_object_from_pointer(iter, "Gtk2::TreeIter"));
    } else
        g_free(iter);
    return result;
}

/* auto generated marshal for GtkTreeSelectionForeachFunc (using genscripts/castmacros-autogen.pl GtkTreeSelectionForeachFunc) */
static void marshal_GtkTreeSelectionForeachFunc(GtkTreeModel *model, GtkTreePath *path, GtkTreeIter *iter, gpointer data)
{
    struct callback_data * cb_data = data;
    dSP;
    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    XPUSHs(sv_2mortal(gtk2_perl_new_object_from_pointer_nullok(model, "Gtk2::TreeModel")));
    XPUSHs(sv_2mortal(gtk2_perl_new_object_from_pointer_nullok(path, "Gtk2::TreePath")));
    XPUSHs(sv_2mortal(gtk2_perl_new_object_from_pointer_nullok(iter, "Gtk2::TreeIter")));
    XPUSHs(cb_data->data);
    PUTBACK;
    perl_call_sv(cb_data->pl_func, G_DISCARD);
    FREETMPS;
    LEAVE;
}

void gtkperl_tree_selection_selected_foreach(SV* selection, SV* func, SV* data)
{
    struct callback_data cb_data = { func, data };
    gtk_tree_selection_selected_foreach(SvGtkTreeSelection(selection), marshal_GtkTreeSelectionForeachFunc, &cb_data);
}

/* auto generated marshal for GtkTreeSelectionFunc (using genscripts/castmacros-autogen.pl GtkTreeSelectionFunc) */
static gboolean marshal_GtkTreeSelectionFunc(GtkTreeSelection *selection, GtkTreeModel *model, GtkTreePath *path,
					     gboolean path_currently_selected, gpointer data)
{
    int i;
    struct callback_data * cb_data = data;
    dSP;
    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    XPUSHs(sv_2mortal(gtk2_perl_new_object_from_pointer_nullok(selection, "Gtk2::TreeSelection")));
    XPUSHs(sv_2mortal(gtk2_perl_new_object_from_pointer_nullok(model, "Gtk2::TreeModel")));
    XPUSHs(sv_2mortal(gtk2_perl_new_object_from_pointer_nullok(path, "Gtk2::TreePath")));
    XPUSHs(sv_2mortal(newSViv(path_currently_selected)));
    XPUSHs(cb_data->data);
    PUTBACK;
    i = perl_call_sv(cb_data->pl_func, G_SCALAR);
    SPAGAIN;
    if (i != 1) croak("Big trouble\n"); else i = POPi;
    PUTBACK;
    FREETMPS;
    LEAVE;
    return i;
}

void gtkperl_tree_selection_set_select_function(SV* selection, SV* func, SV* data)
{
    /* the real calls of the callback function are deferred, hence we
       need to allocate the cb_data, incref the stuff inside it, and
       use gtk2_perl_destroy_notify (this one will decref and g_free) */
    struct callback_data * cb_data = g_malloc0(sizeof(struct callback_data));
    cb_data->pl_func = func;
    cb_data->data = data;
    SvREFCNT_inc(cb_data->pl_func);
    SvREFCNT_inc(cb_data->data);
    gtk_tree_selection_set_select_function(SvGtkTreeSelection(selection), marshal_GtkTreeSelectionFunc, cb_data, gtk2_perl_destroy_notify);
}


/*
Unimplemented

gpointer         gtk_tree_selection_get_user_data       (GtkTreeSelection            *selection);

*/
AV* gtkperl_tree_selection__get_selected_rows (SV* selection) 
{
    GtkTreeModel* model;
    GList* list = gtk_tree_selection_get_selected_rows(SvGtkTreeSelection(selection), &model);
    AV* result = newAV();
    GList *item;
    if (!list)
	return result;
    item = g_list_first(list);

    av_push(result, gtk2_perl_new_object(model));
    do {
        av_push(result, gtk2_perl_new_object_from_pointer(item->data, "Gtk2::TreePath"));
    } while((item = g_list_next(item)) != NULL);
    /* g_list_foreach (list, gtk_tree_path_free, NULL); */
    g_list_free (list);

    return result;
}

/* void gtk_tree_selection_select_path (GtkTreeSelection *selection, GtkTreePath *path) */
void gtkperl_tree_selection_select_path(SV* selection, SV* path)
{
    gtk_tree_selection_select_path(SvGtkTreeSelection(selection), SvGtkTreePath(path));
}

/* void gtk_tree_selection_unselect_path (GtkTreeSelection *selection, GtkTreePath *path) */
void gtkperl_tree_selection_unselect_path(SV* selection, SV* path)
{
    gtk_tree_selection_unselect_path(SvGtkTreeSelection(selection), SvGtkTreePath(path));
}

/* void gtk_tree_selection_select_iter (GtkTreeSelection *selection, GtkTreeIter *iter) */
void gtkperl_tree_selection_select_iter(SV* selection, SV* iter)
{
    gtk_tree_selection_select_iter(SvGtkTreeSelection(selection), SvGtkTreeIter(iter));
}

/* void gtk_tree_selection_unselect_iter (GtkTreeSelection *selection, GtkTreeIter *iter) */
void gtkperl_tree_selection_unselect_iter(SV* selection, SV* iter)
{
    gtk_tree_selection_unselect_iter(SvGtkTreeSelection(selection), SvGtkTreeIter(iter));
}

/* gboolean gtk_tree_selection_path_is_selected (GtkTreeSelection *selection, GtkTreePath *path) */
int gtkperl_tree_selection_path_is_selected(SV* selection, SV* path)
{
    return gtk_tree_selection_path_is_selected(SvGtkTreeSelection(selection), SvGtkTreePath(path));
}

/* gboolean gtk_tree_selection_iter_is_selected (GtkTreeSelection *selection, GtkTreeIter *iter) */
int gtkperl_tree_selection_iter_is_selected(SV* selection, SV* iter)
{
    return gtk_tree_selection_iter_is_selected(SvGtkTreeSelection(selection), SvGtkTreeIter(iter));
}

/* void gtk_tree_selection_select_all (GtkTreeSelection *selection) */
void gtkperl_tree_selection_select_all(SV* selection)
{
    gtk_tree_selection_select_all(SvGtkTreeSelection(selection));
}

/* void gtk_tree_selection_unselect_all (GtkTreeSelection *selection) */
void gtkperl_tree_selection_unselect_all(SV* selection)
{
    gtk_tree_selection_unselect_all(SvGtkTreeSelection(selection));
}

/* void gtk_tree_selection_select_range (GtkTreeSelection *selection, GtkTreePath *start_path, GtkTreePath *end_path) */
void gtkperl_tree_selection_select_range(SV* selection, SV* start_path, SV* end_path)
{
    gtk_tree_selection_select_range(SvGtkTreeSelection(selection), SvGtkTreePath(start_path), SvGtkTreePath(end_path));
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

/*
 * $Id: TreeModel.c,v 1.6 2002/11/22 12:02:47 ggc Exp $
 * Copyright 2002, Christian Borup <borup@users.sourceforge.net>
 * licensed under Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


SV* gtkperl_tree_model__get(SV* model, SV* iter, int column)
{
    GValue gval = { 0, };
    SV *value;

    gtk_tree_model_get_value(SvGtkTreeModel(model), SvGtkTreeIter(iter), column, &gval);
    value = gperl_object_from_value(&gval);

    return value ? value : &PL_sv_undef;
}

/* GtkTreeModelFlags gtk_tree_model_get_flags (GtkTreeModel *tree_model) */
SV* gtkperl_tree_model_get_flags(SV* tree_model)
{
    return newSVGtkTreeModelFlags(gtk_tree_model_get_flags(SvGtkTreeModel(tree_model)));
}

/* gint gtk_tree_model_get_n_columns (GtkTreeModel *tree_model) */
int gtkperl_tree_model_get_n_columns(SV* tree_model)
{
    return gtk_tree_model_get_n_columns(SvGtkTreeModel(tree_model));
}

/* GType gtk_tree_model_get_column_type (GtkTreeModel *tree_model, gint index) */
int gtkperl_tree_model_get_column_type(SV* tree_model, int index)
{
    return gtk_tree_model_get_column_type(SvGtkTreeModel(tree_model), index);
}

/* let's be clever and factorize a bit the get_iter style functions */
#define get_iter_generic(func)                                                \
{                                                                             \
    GtkTreeIter* iter = g_malloc0(sizeof(GtkTreeIter));			      \
    if (func)								      \
	return gtk2_perl_new_object_from_pointer(iter, "Gtk2::TreeIter");     \
    else {								      \
	g_free(iter);							      \
	return &PL_sv_undef;                                                  \
    }                                                                         \
}

/* gboolean gtk_tree_model_get_iter (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreePath *path) */
SV* gtkperl_tree_model_get_iter(SV* tree_model, SV* path)
{
    get_iter_generic(gtk_tree_model_get_iter(SvGtkTreeModel(tree_model), iter, SvGtkTreePath(path)));
}

/* gboolean gtk_tree_model_get_iter_from_string (GtkTreeModel *tree_model, GtkTreeIter *iter, const gchar *path_string) */
SV* gtkperl_tree_model_get_iter_from_string(SV* tree_model, gchar* path_string)
{
    get_iter_generic(gtk_tree_model_get_iter_from_string(SvGtkTreeModel(tree_model), iter, path_string));
}

/* gboolean gtk_tree_model_get_iter_first (GtkTreeModel *tree_model, GtkTreeIter *iter) */
SV* gtkperl_tree_model_get_iter_first(SV* tree_model)
{
    get_iter_generic(gtk_tree_model_get_iter_first(SvGtkTreeModel(tree_model), iter));
}

/* gboolean gtk_tree_model_iter_next (GtkTreeModel *tree_model, GtkTreeIter *iter) */
SV* gtkperl_tree_model_iter_next(SV* tree_model, SV* iter_now)
{
    GtkTreeIter* iter = gtk_tree_iter_copy(SvGtkTreeIter(iter_now));
    if (gtk_tree_model_iter_next(SvGtkTreeModel(tree_model), iter))
	return gtk2_perl_new_object_from_pointer(iter, "Gtk2::TreeIter");
    else {
	gtk_tree_iter_free(iter);
	return &PL_sv_undef;
    }
}

/* gboolean gtk_tree_model_iter_children (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent) */
SV* gtkperl_tree_model_iter_children(SV* tree_model, SV* parent)
{
    get_iter_generic(gtk_tree_model_iter_children(SvGtkTreeModel(tree_model), iter, SvGtkTreeIter(parent)));
}

/* gboolean gtk_tree_model_iter_has_child (GtkTreeModel *tree_model, GtkTreeIter *iter) */
int gtkperl_tree_model_iter_has_child(SV* tree_model, SV* iter)
{
    return gtk_tree_model_iter_has_child(SvGtkTreeModel(tree_model), SvGtkTreeIter(iter));
}

/* gint gtk_tree_model_iter_n_children (GtkTreeModel *tree_model, GtkTreeIter *iter) */
int gtkperl_tree_model_iter_n_children(SV* tree_model, SV* iter)
{
    return gtk_tree_model_iter_n_children(SvGtkTreeModel(tree_model), SvGtkTreeIter_nullok(iter));
}

/* gboolean gtk_tree_model_iter_nth_child (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent, gint n) */
SV* gtkperl_tree_model_iter_nth_child(SV* tree_model, SV* parent, int n)
{
    get_iter_generic(gtk_tree_model_iter_nth_child(SvGtkTreeModel(tree_model), iter, SvGtkTreeIter_nullok(parent), n));
}

/* gboolean gtk_tree_model_iter_parent (GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *child) */
SV* gtkperl_tree_model_iter_parent(SV* tree_model, SV* child)
{
    get_iter_generic(gtk_tree_model_iter_parent(SvGtkTreeModel(tree_model), iter, SvGtkTreeIter(child)));
}


/* GtkTreePath * gtk_tree_model_get_path (GtkTreeModel *tree_model, GtkTreeIter *iter) */
SV* gtkperl_tree_model_get_path(SV* tree_model, SV* iter)
{
    return gtk2_perl_new_object_from_pointer(gtk_tree_model_get_path(SvGtkTreeModel(tree_model), SvGtkTreeIter(iter)),
					     "Gtk2::TreePath");
}


/* auto generated marshal for GtkTreeModelForeachFunc (using genscripts/castmacros-autogen.pl GtkTreeModelForeachFunc) */
static gboolean marshal_GtkTreeModelForeachFunc(GtkTreeModel *model, GtkTreePath *path, GtkTreeIter *iter, gpointer data)
{
    int i;
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
    i = perl_call_sv(cb_data->pl_func, G_SCALAR);
    SPAGAIN;
    if (i != 1) croak("Big trouble\n"); else i = POPi;
    PUTBACK;
    FREETMPS;
    LEAVE;
    return i;
}

/* void gtk_tree_model_foreach (GtkTreeModel *model, GtkTreeModelForeachFunc func, gpointer user_data) */
void gtkperl_tree_model_foreach(SV* model, SV* func, SV* user_data)
{
    struct callback_data cb_data = { func, user_data };
    gtk_tree_model_foreach(SvGtkTreeModel(model), marshal_GtkTreeModelForeachFunc, &cb_data);
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

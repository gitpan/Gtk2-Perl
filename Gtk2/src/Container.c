/* $Id: Container.c,v 1.9 2002/11/25 17:30:01 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

void gtkperl_container_add(SV *container, SV *widget)
{
    gtk_container_add(SvGtkContainer(container), SvGtkWidget(widget));
}

void gtkperl_container_remove(SV *container, SV *widget)
{
    gtk_container_remove(SvGtkContainer(container), SvGtkWidget(widget));
}

void gtkperl_container_set_border_width(SV* cont, int width)
{
    gtk_container_set_border_width(SvGtkContainer(cont), width);
}

int gtkperl_container_get_border_width(SV* container)
{
    return gtk_container_get_border_width(SvGtkContainer(container));
}

void gtkperl_container_set_resize_mode(SV* container, SV* resize_mode)
{
    gtk_container_set_resize_mode(SvGtkContainer(container), SvGtkResizeMode(resize_mode));
}

SV* gtkperl_container_get_resize_mode(SV* container)
{
    return newSVGtkResizeMode(gtk_container_get_resize_mode(SvGtkContainer(container)));
}

void gtkperl_container_check_resize(SV* container)
{
    gtk_container_check_resize(SvGtkContainer(container));
}

void gtkperl_container_set_reallocate_redraws(SV* container, int needs_redraws)
{
    gtk_container_set_reallocate_redraws(SvGtkContainer(container), needs_redraws);
}

void gtkperl_container_set_focus_child(SV* container, SV* child)
{
    gtk_container_set_focus_child(SvGtkContainer(container), SvGtkWidget(child));
}

void gtkperl_container_set_focus_vadjustment(SV* container, SV* adjustment)
{
    gtk_container_set_focus_vadjustment(SvGtkContainer(container), SvGtkAdjustment(adjustment));
}

SV* gtkperl_container_get_focus_vadjustment(SV* container)
{
    return gtk2_perl_new_object(gtk_container_get_focus_vadjustment(SvGtkContainer(container)));
}

void gtkperl_container_set_focus_hadjustment(SV* container, SV* adjustment)
{
    gtk_container_set_focus_hadjustment(SvGtkContainer(container), SvGtkAdjustment(adjustment));
}

SV* gtkperl_container_get_focus_hadjustment(SV* container)
{
    return gtk2_perl_new_object(gtk_container_get_focus_hadjustment(SvGtkContainer(container)));
}

void gtkperl_container_resize_children(SV* container)
{
    gtk_container_resize_children(SvGtkContainer(container));
}

SV* gtkperl_container__get_children(SV* container)
{
    GList * c = gtk_container_get_children(SvGtkContainer(container));
    GList * start = c;
    AV* children = newAV();
    while(c) {
        av_push(children, gtk2_perl_new_object(c->data));
        c = c->next;
    }
    if (start)
        g_list_free(start);
        
    return newRV_noinc((SV*) children);
}

/* void gtk_container_foreach (GtkContainer *container, GtkCallback callback, gpointer callback_data) */
void gtkperl_container_foreach(SV* container, SV* callback, SV* callback_data)
{
    struct callback_data cb_data = { callback, callback_data };
    gtk_container_foreach(SvGtkContainer(container), gtk2_perl_marshal_GtkCallback, &cb_data);
}

/* void gtk_container_forall (GtkContainer *container, GtkCallback callback, gpointer callback_data) */
void gtkperl_container_forall(SV* container, SV* callback, SV* callback_data)
{
    struct callback_data cb_data = { callback, callback_data };
    gtk_container_forall(SvGtkContainer(container), gtk2_perl_marshal_GtkCallback, &cb_data);
}

/*
  #define     GTK_IS_RESIZE_CONTAINER         (widget)
  #define     GTK_CONTAINER_WARN_INVALID_CHILD_PROPERTY_ID(object, property_id, pspec)
  void        gtk_container_add_with_properties
                                              (GtkContainer *container,
                                               GtkWidget *widget,
                                               const gchar *first_prop_name,
                                               ...);
  GtkType     gtk_container_child_type        (GtkContainer *container);
  void        gtk_container_child_get         (GtkContainer *container,
                                               GtkWidget *child,
                                               const gchar *first_prop_name,
                                               ...);
  void        gtk_container_child_set         (GtkContainer *container,
                                               GtkWidget *child,
                                               const gchar *first_prop_name,
                                               ...);
  void        gtk_container_child_get_property
                                              (GtkContainer *container,
                                               GtkWidget *child,
                                               const gchar *property_name,
                                               GValue *value);
  void        gtk_container_child_set_property
                                              (GtkContainer *container,
                                               GtkWidget *child,
                                               const gchar *property_name,
                                               const GValue *value);
  void        gtk_container_child_get_valist  (GtkContainer *container,
                                               GtkWidget *child,
                                               const gchar *first_property_name,
                                               va_list var_args);
  void        gtk_container_child_set_valist  (GtkContainer *container,
                                               GtkWidget *child,
                                               const gchar *first_property_name,
                                               va_list var_args);
  void        gtk_container_propagate_expose  (GtkContainer *container,
                                               GtkWidget *child,
                                               GdkEventExpose *event);
  gboolean    gtk_container_get_focus_chain   (GtkContainer *container,
                                               GList **focusable_widgets);
  void        gtk_container_set_focus_chain   (GtkContainer *container,
                                               GList *focusable_widgets);
  void        gtk_container_unset_focus_chain (GtkContainer *container);
  GParamSpec* gtk_container_class_find_child_property
                                              (GObjectClass *cclass,
                                               const gchar *property_name);
  void        gtk_container_class_install_child_property
                                              (GtkContainerClass *cclass,
                                               guint property_id,
                                               GParamSpec *pspec);
  GParamSpec** gtk_container_class_list_child_properties
                                              (GObjectClass *cclass,
                                               guint *n_properties);
*/
/* Deprecated
  #define     gtk_container_border_width
  #define     gtk_container_children
*/

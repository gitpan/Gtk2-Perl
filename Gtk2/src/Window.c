/* $Id: Window.c,v 1.16 2002/11/15 11:38:42 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_window_new(char* class, SV* type)
{
    return gtk2_perl_new_object(gtk_window_new(SvGtkWindowType(type)));
}

gchar* gtkperl_window_get_title(SV* window)
{
    return gtk_window_get_title(SvGtkWindow(window));
}

void gtkperl_window_set_title(SV* window, gchar* title)
{
    gtk_window_set_title(SvGtkWindow(window), title);
}

void gtkperl_window_set_wmclass(SV* window, gchar* wmclass_name, gchar* wmclass_class)
{
    gtk_window_set_wmclass(SvGtkWindow(window), wmclass_name, wmclass_class);
}

void gtkperl_window_add_accel_group(SV *window, SV *accel_group)
{
    gtk_window_add_accel_group(SvGtkWindow(window), SvGtkAccelGroup(accel_group));
}

SV* gtkperl_window_get_focus(SV* window, SV* focus)
{
    return gtk2_perl_new_object(gtk_window_get_focus(SvGtkWindow(window)));
}

void gtkperl_window_set_focus(SV* window, SV* focus)
{
    gtk_window_set_focus(SvGtkWindow(window), SvGtkWidget(focus));
}

void gtkperl_window_set_position(SV* window, SV* pos)
{
    gtk_window_set_position(SvGtkWindow(window), SvGtkWindowPosition(pos));
}

/* void gtk_window_set_default_size (GtkWindow *window, gint width, gint height) */
void gtkperl_window_set_default_size(SV* window, int width, int height)
{
    gtk_window_set_default_size(SvGtkWindow(window), width, height);
}

/* void gtk_window_get_default_size (GtkWindow *window, gint *width, gint *height) */
SV* gtkperl_window__get_default_size(SV* window)
{
    gint width;
    gint height;
    AV* values = newAV();
    gtk_window_get_default_size(SvGtkWindow(window), &width, &height);
    av_push(values, newSViv(width));
    av_push(values, newSViv(height));
    return newRV_noinc((SV*) values);
}

/* void gtk_window_resize (GtkWindow *window, gint width, gint height) */
void gtkperl_window_resize(SV* window, int width, int height)
{
    gtk_window_resize(SvGtkWindow(window), width, height);
}

/* void gtk_window_get_size (GtkWindow *window, gint *width, gint *height) */
SV* gtkperl_window__get_size(SV* window)
{
    gint width;
    gint height;
    AV* values = newAV();
    gtk_window_get_size(SvGtkWindow(window), &width, &height);
    av_push(values, newSViv(width));
    av_push(values, newSViv(height));
    return newRV_noinc((SV*) values);
}

/* void gtk_window_move (GtkWindow *window, gint x, gint y) */
void gtkperl_window_move(SV* window, int x, int y)
{
    gtk_window_move(SvGtkWindow(window), x, y);
}

/* void gtk_window_get_position (GtkWindow *window, gint *root_x, gint *root_y) */
SV* gtkperl_window__get_position(SV* window)
{
    gint root_x;
    gint root_y;
    AV* values = newAV();
    gtk_window_get_position(SvGtkWindow(window), &root_x, &root_y);
    av_push(values, newSViv(root_x));
    av_push(values, newSViv(root_y));
    return newRV_noinc((SV*) values);
}

void gtkperl_window_set_default(SV* window, SV* default_widget)
{
    gtk_window_set_default(SvGtkWindow(window), SvGtkWidget(default_widget));
}

int gtkperl_window_get_resizable(SV* window)
{
    return gtk_window_get_resizable(SvGtkWindow(window));
}

void gtkperl_window_set_resizable (SV* window, int resizable)
{
    gtk_window_set_resizable(SvGtkWindow(window), resizable);
}

int gtkperl_window_get_destroy_with_parent(SV* window)
{
    return gtk_window_get_destroy_with_parent(SvGtkWindow(window));
}

void gtkperl_window_set_destroy_with_parent(SV* window, int setting)
{
    gtk_window_set_destroy_with_parent(SvGtkWindow(window), setting);
}

int gtkperl_window_get_decorated(SV* window)
{
    return gtk_window_get_decorated(SvGtkWindow(window));
}

void gtkperl_window_set_decorated(SV* window, int setting)
{
    gtk_window_set_decorated(SvGtkWindow(window), setting);
}

int gtkperl_window_get_modal(SV* window)
{
    return gtk_window_get_modal(SvGtkWindow(window));
}

void gtkperl_window_set_modal(SV* window, int setting)
{
    gtk_window_set_modal(SvGtkWindow(window), setting);
}

SV* gtkperl_window_get_transient_for(SV* window)
{
    return gtk2_perl_new_object_nullok(gtk_window_get_transient_for(SvGtkWindow(window)));
}

void gtkperl_window_set_transient_for(SV* window, SV* parent)
{
    gtk_window_set_transient_for(SvGtkWindow(window), SvGtkWindow(parent));
}

/* void gtk_window_present (GtkWindow *window) */
void gtkperl_window_present(SV* window)
{
    gtk_window_present(SvGtkWindow(window));
}

/* void gtk_window_iconify (GtkWindow *window) */
void gtkperl_window_iconify(SV* window)
{
    gtk_window_iconify(SvGtkWindow(window));
}

/* void gtk_window_deiconify (GtkWindow *window) */
void gtkperl_window_deiconify(SV* window)
{
    gtk_window_deiconify(SvGtkWindow(window));
}

/* void gtk_window_stick (GtkWindow *window) */
void gtkperl_window_stick(SV* window)
{
    gtk_window_stick(SvGtkWindow(window));
}

/* void gtk_window_unstick (GtkWindow *window) */
void gtkperl_window_unstick(SV* window)
{
    gtk_window_unstick(SvGtkWindow(window));
}

/* void gtk_window_maximize (GtkWindow *window) */
void gtkperl_window_maximize(SV* window)
{
    gtk_window_maximize(SvGtkWindow(window));
}

/* void gtk_window_unmaximize (GtkWindow *window) */
void gtkperl_window_unmaximize(SV* window)
{
    gtk_window_unmaximize(SvGtkWindow(window));
}

/* gboolean gtk_window_activate_focus (GtkWindow *window) */
int gtkperl_window_activate_focus(SV* window)
{
    return gtk_window_activate_focus(SvGtkWindow(window));
}

/* gboolean gtk_window_activate_default (GtkWindow *window) */
int gtkperl_window_activate_default(SV* window)
{
    return gtk_window_activate_default(SvGtkWindow(window));
}

/* void gtk_window_set_gravity (GtkWindow *window, GdkGravity gravity) */
void gtkperl_window_set_gravity(SV* window, SV* gravity)
{
    gtk_window_set_gravity(SvGtkWindow(window), SvGdkGravity(gravity));
}

/* GdkGravity gtk_window_get_gravity (GtkWindow *window) */
SV* gtkperl_window_get_gravity(SV* window)
{
    return newSVGdkGravity(gtk_window_get_gravity(SvGtkWindow(window)));
}

/* void gtk_window_set_has_frame (GtkWindow *window, gboolean setting) */
void gtkperl_window_set_has_frame(SV* window, int setting)
{
    gtk_window_set_has_frame(SvGtkWindow(window), setting);
}

/* gboolean gtk_window_get_has_frame (GtkWindow *window) */
int gtkperl_window_get_has_frame(SV* window)
{
    return gtk_window_get_has_frame(SvGtkWindow(window));
}

/* void gtk_window_set_frame_dimensions (GtkWindow *window, gint left, gint top, gint right, gint bottom) */
void gtkperl_window_set_frame_dimensions(SV* window, int left, int top, int right, int bottom)
{
    gtk_window_set_frame_dimensions(SvGtkWindow(window), left, top, right, bottom);
}

/* void gtk_window_get_frame_dimensions (GtkWindow *window, gint *left, gint *top, gint *right, gint *bottom) */
SV* gtkperl_window__get_frame_dimensions(SV* window)
{
    gint left, top, right, bottom;
    AV* values = newAV();
    gtk_window_get_frame_dimensions(SvGtkWindow(window), &left, &top, &right, &bottom);
    av_push(values, newSViv(left));
    av_push(values, newSViv(top));
    av_push(values, newSViv(right));
    av_push(values, newSViv(bottom));
    return newRV_noinc((SV*) values);
}

/* void gtk_window_set_icon (GtkWindow *window, GdkPixbuf *icon) */
void gtkperl_window_set_icon(SV* window, SV* icon)
{
    gtk_window_set_icon(SvGtkWindow(window), SvGdkPixbuf(icon));
}

/* GdkPixbuf* gtk_window_get_icon (GtkWindow *window) */
SV* gtkperl_window_get_icon(SV* window)
{
    return gtk2_perl_new_object(gtk_window_get_icon(SvGtkWindow(window)));
}

/* void gtk_window_set_type_hint (GtkWindow *window, GdkWindowTypeHint hint) */
void gtkperl_window_set_type_hint(SV* window, SV* hint)
{
    gtk_window_set_type_hint(SvGtkWindow(window), SvGdkWindowTypeHint(hint));
}

/* GdkWindowTypeHint gtk_window_get_type_hint (GtkWindow *window) */
SV* gtkperl_window_get_type_hint(SV* window)
{
    return newSVGdkWindowTypeHint(gtk_window_get_type_hint(SvGtkWindow(window)));
}

/* void gtk_window_reshow_with_initial_size (GtkWindow *window) */
void gtkperl_window_reshow_with_initial_size(SV* window)
{
    gtk_window_reshow_with_initial_size(SvGtkWindow(window));
}

/* NOT IMPLEMENTED YET
void        gtk_window_remove_accel_group   (GtkWindow *window,
                                             GtkAccelGroup *accel_group);

void        gtk_window_set_geometry_hints   (GtkWindow *window,
                                             GtkWidget *geometry_widget,
                                             GdkGeometry *geometry,
                                             GdkWindowHints geom_mask);
void        gtk_window_set_screen           (GtkWindow *window,
                                             GdkScreen *screen);
GdkScreen*  gtk_window_get_screen           (GtkWindow *window);
GList*      gtk_window_list_toplevels       (void);
void        gtk_window_add_mnemonic         (GtkWindow *window,
                                             guint keyval,
                                             GtkWidget *target);
void        gtk_window_remove_mnemonic      (GtkWindow *window,
                                             guint keyval,
                                             GtkWidget *target);
gboolean    gtk_window_mnemonic_activate    (GtkWindow *window,
                                             guint keyval,
                                             GdkModifierType modifier);

void        gtk_window_begin_resize_drag    (GtkWindow *window,
                                             GdkWindowEdge edge,
                                             gint button,
                                             gint root_x,
                                             gint root_y,
                                             guint32 timestamp);
void        gtk_window_begin_move_drag      (GtkWindow *window,
                                             gint button,
                                             gint root_x,
                                             gint root_y,
                                             guint32 timestamp);
void        gtk_window_set_mnemonic_modifier
                                            (GtkWindow *window,
                                             GdkModifierType modifier);
void        gtk_window_set_role             (GtkWindow *window,
                                             const gchar *role);
GList*      gtk_window_get_default_icon_list
                                            (void);
GList*      gtk_window_get_icon_list        (GtkWindow *window);
GdkModifierType gtk_window_get_mnemonic_modifier
                                            (GtkWindow *window);
G_CONST_RETURN gchar* gtk_window_get_role   (GtkWindow *window);
gboolean    gtk_window_parse_geometry       (GtkWindow *window,
                                             const gchar *geometry);
void        gtk_window_set_default_icon_list
                                            (GList *list);
void        gtk_window_set_icon_list        (GtkWindow *window,
                                             GList *list);


void        gtk_decorated_window_init       (GtkWindow *window);
void        gtk_decorated_window_calculate_frame_size
                                            (GtkWindow *window);
void        gtk_decorated_window_set_title  (GtkWindow *window,
                                             const gchar *title);
void        gtk_decorated_window_move_resize_window
                                            (GtkWindow *window,
                                             gint x,
                                             gint y,
                                             gint width,
                                             gint height);

*/

/* Deprecated

void        gtk_window_set_policy           (GtkWindow *window,
                                             gint allow_shrink,
                                             gint allow_grow,
                                             gint auto_shrink);
#define     gtk_window_position
*/

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

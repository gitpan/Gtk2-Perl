/* $Id: Widget.c,v 1.47 2003/02/03 17:12:03 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


/* SOME NOT IMPLEMENTED YET
#define     GTK_WIDGET_TYPE                 (wid)
#define     GTK_WIDGET_SAVED_STATE          (wid)
*/

/*
#define     GTK_WIDGET_RC_STYLE             (wid)
#define     GTK_WIDGET_COMPOSITE_CHILD      (wid)
#define     GTK_WIDGET_APP_PAINTABLE        (wid)
#define     GTK_WIDGET_DOUBLE_BUFFERED      (wid)
*/

void gtkperl_widget_SET_FLAGS(SV* widget, SV* flags)
{
    GTK_WIDGET_SET_FLAGS(SvGtkWidget(widget), SvGtkWidgetFlags(flags)); 
}

void gtkperl_widget_UNSET_FLAGS(SV* widget, SV* flags)
{
    GTK_WIDGET_UNSET_FLAGS(SvGtkWidget(widget), SvGtkWidgetFlags(flags)); 
}

SV* gtkperl_widget_GET_FLAGS(SV* widget)
{
    return newSVGtkWidgetFlags(GTK_WIDGET_FLAGS(SvGtkWidget(widget)));
}

int gtkperl_widget_TOPLEVEL(SV* widget)
{
    return GTK_WIDGET_TOPLEVEL(SvGtkWidget(widget));
}

int gtkperl_widget_NO_WINDOW(SV* widget)
{
    return GTK_WIDGET_NO_WINDOW(SvGtkWidget(widget));
}

int gtkperl_widget_MAPPED(SV* widget)
{
    return GTK_WIDGET_MAPPED(SvGtkWidget(widget));
}

int gtkperl_widget_DRAWABLE(SV* widget)
{
    return GTK_WIDGET_DRAWABLE(SvGtkWidget(widget));
}

int gtkperl_widget_CAN_DEFAULT(SV* widget)
{
    return GTK_WIDGET_CAN_DEFAULT(SvGtkWidget(widget));
}

int gtkperl_widget_HAS_DEFAULT(SV* widget)
{
    return GTK_WIDGET_HAS_DEFAULT(SvGtkWidget(widget));
}

int gtkperl_widget_RECEIVES_DEFAULT(SV* widget)
{
    return GTK_WIDGET_RECEIVES_DEFAULT(SvGtkWidget(widget));
}

int gtkperl_widget_HAS_GRAB(SV* widget)
{
    return GTK_WIDGET_HAS_GRAB(SvGtkWidget(widget));
}

int gtkperl_widget_CAN_FOCUS(SV* widget)
{
    return GTK_WIDGET_CAN_FOCUS(SvGtkWidget(widget));
}

int gtkperl_widget_HAS_FOCUS(SV* widget)
{
    return GTK_WIDGET_HAS_FOCUS(SvGtkWidget(widget));
}

int gtkperl_widget_REALIZED(SV* widget)
{
    return GTK_WIDGET_REALIZED(SvGtkWidget(widget));
}

int gtkperl_widget_VISIBLE(SV* widget)
{
    return GTK_WIDGET_VISIBLE(SvGtkWidget(widget));
}

int gtkperl_widget_SENSITIVE(SV* widget)
{
    return GTK_WIDGET_SENSITIVE(SvGtkWidget(widget));
}

int gtkperl_widget_PARENT_SENSITIVE(SV* widget)
{
    return GTK_WIDGET_PARENT_SENSITIVE(SvGtkWidget(widget));
}

int gtkperl_widget_IS_SENSITIVE(SV* widget)
{
    return GTK_WIDGET_IS_SENSITIVE(SvGtkWidget(widget));
}

void gtkperl_widget_set_state(SV* widget, SV* state)
{
    gtk_widget_set_state(SvGtkWidget(widget), SvGtkStateType(state));
}

SV* gtkperl_widget_get_state(SV* widget)
{
    return newSVGtkStateType(GTK_WIDGET_STATE(SvGtkWidget(widget)));
}

/*
GtkWidget*  gtk_widget_new                  (GtkType type,
                                             const gchar *first_property_name,
                                             ...);
GtkWidget*  gtk_widget_ref                  (GtkWidget *widget);
void        gtk_widget_unref                (GtkWidget *widget);
*/

void gtkperl_widget_destroy(SV* widget)
{
    gtk_widget_destroy(SvGtkWidget(widget));
}

void gtkperl_widget_destroyed(SV* widget, SV* widget_pointer)
{
    fprintf(stderr, "FIXME: gtk_widget_destroyed is a tricky signalhandler\n");
    // gtk_widget_destroyed(SvGtkWidget(widget), (GtkWidget**) SvIV(SvRV(widget_pointer)));
}

/*
void        gtk_widget_set                  (GtkWidget *widget,
                                             const gchar *first_property_name,
                                             ...);
*/

/* void gtk_widget_unparent (GtkWidget *widget) */
void gtkperl_widget_unparent(SV* widget)
{
    gtk_widget_unparent(SvGtkWidget(widget));
}

SV* gtkperl_widget_show(SV* widget)
{
    gtk_widget_show(SvGtkWidget(widget));
    return newRV(SvRV(widget));
}

/* void gtk_widget_show_now (GtkWidget *widget) */
SV* gtkperl_widget_show_now(SV* widget)
{
    gtk_widget_show_now(SvGtkWidget(widget));
    return newRV(SvRV(widget));
}

SV* gtkperl_widget_hide(SV* widget)
{
    gtk_widget_hide(SvGtkWidget(widget));
    return newRV(SvRV(widget));
}

SV* gtkperl_widget_show_all(SV* widget)
{
    gtk_widget_show_all(SvGtkWidget(widget));
    return newRV(SvRV(widget));
}

SV* gtkperl_widget_hide_all(SV* widget)
{
    gtk_widget_hide_all(SvGtkWidget(widget));
    return newRV(SvRV(widget));
}

void gtkperl_widget_map(SV* widget)
{
    gtk_widget_map(SvGtkWidget(widget));
}

void gtkperl_widget_unmap(SV* widget)
{
    gtk_widget_unmap(SvGtkWidget(widget));
}

void gtkperl_widget_realize(SV* widget)
{
    gtk_widget_realize(SvGtkWidget(widget));
}

void gtkperl_widget_unrealize(SV* widget)
{
    gtk_widget_unrealize(SvGtkWidget(widget));
}

void gtkperl_widget_queue_draw(SV *widget)
{
    gtk_widget_queue_draw(SvGtkWidget(widget));
}

void gtkperl_widget_add_accelerator(SV* widget, gchar* accel_signal,
                                    SV* accel_group, int accel_key,
                                    SV* accel_mods, SV* accel_flags)
{
    gtk_widget_add_accelerator(SvGtkWidget(widget), accel_signal,
			       SvGtkAccelGroup(accel_group), accel_key,
			       SvGdkModifierType(accel_mods), SvGtkAccelFlags(accel_flags));
}

/* gboolean gtk_widget_remove_accelerator (GtkWidget *widget, GtkAccelGroup *accel_group,
                                           guint accel_key, GdkModifierType accel_mods) */
int gtkperl_widget_remove_accelerator(SV* widget, SV* accel_group,
				      int accel_key, SV* accel_mods)
{
    return gtk_widget_remove_accelerator(SvGtkWidget(widget), SvGtkAccelGroup(accel_group),
					 accel_key, SvGdkModifierType(accel_mods));
}

/* void gtk_widget_size_request (GtkWidget *widget, GtkRequisition *requisition) */
SV* gtkperl_widget_size_request(SV* widget)
{
    GtkRequisition* req = g_malloc0(sizeof(GtkRequisition));
    gtk_widget_size_request(SvGtkWidget(widget), req);
    return gtk2_perl_new_object_from_pointer(req, "Gtk2::Requisition");
}

/* void gtk_widget_queue_resize (GtkWidget *widget) */
void gtkperl_widget_queue_resize(SV* widget)
{
    gtk_widget_queue_resize(SvGtkWidget(widget));
}

/* void gtk_widget_get_child_requisition (GtkWidget *widget, GtkRequisition *requisition) */
void gtkperl_widget_get_child_requisition(SV* widget, SV* requisition)
{
    gtk_widget_get_child_requisition(SvGtkWidget(widget), SvGtkRequisition(requisition));
}

/*
void        gtk_widget_draw                 (GtkWidget *widget,
                                             GdkRectangle *area);
void        gtk_widget_size_allocate        (GtkWidget *widget,
                                             GtkAllocation *allocation);
void        gtk_widget_set_accel_path       (GtkWidget *widget,
                                             const gchar *accel_path,
                                             GtkAccelGroup *accel_group);
GList*      gtk_widget_list_accel_closures  (GtkWidget *widget);
gboolean    gtk_widget_event                (GtkWidget *widget,
                                             GdkEvent *event);
void        gtk_widget_reparent             (GtkWidget *widget,
                                             GtkWidget *new_parent);
gboolean    gtk_widget_intersect            (GtkWidget *widget,
                                             GdkRectangle *area,
                                             GdkRectangle *intersection);
					     */

/* gboolean gtk_widget_activate (GtkWidget *widget) */
int gtkperl_widget_activate(SV* widget)
{
    return gtk_widget_activate(SvGtkWidget(widget));
}

int gtkperl_widget_is_focus(SV* widget)
{
    return gtk_widget_is_focus(SvGtkWidget(widget));
}

void gtkperl_widget_grab_focus(SV* widget)
{
    gtk_widget_grab_focus(SvGtkWidget(widget));
}

void gtkperl_widget_grab_default(SV* widget)
{
    gtk_widget_grab_default(SvGtkWidget(widget));
}

/*
void        gtk_widget_set_parent           (GtkWidget *widget,
                                             GtkWidget *parent);
void        gtk_widget_set_parent_window    (GtkWidget *widget,
                                             GdkWindow *parent_window);
*/

SV* gtkperl_widget_get_parent_window(SV* widget)
{
    return gtk2_perl_new_object(gtk_widget_get_parent_window(SvGtkWidget(widget)));
}

/* Deprecated */
void gtkperl_widget_set_uposition(SV* widget, int x, int y)
{
    gtk_widget_set_uposition(SvGtkWidget(widget), x, y);
}

void gtkperl_widget_set_events(SV* widget, SV* events)
{
    gtk_widget_set_events(SvGtkWidget(widget), SvGdkEventMask(events));
}

void gtkperl_widget_add_events(SV* widget, SV* events)
{
    gtk_widget_add_events(SvGtkWidget(widget), SvGdkEventMask(events));
}

SV*  gtkperl_widget_get_toplevel         (SV *widget)
{
    return gtk2_perl_new_object(gtk_widget_get_toplevel(SvGtkWidget(widget)));
}

void gtkperl_widget_set_extension_events(SV* widget, SV* mode)
{
    gtk_widget_set_extension_events(
        SvGtkWidget(widget), SvGdkExtensionMode(mode));
}

SV* gtkperl_widget_get_extension_events(SV* widget)
{
    return newSVGdkExtensionMode(
        gtk_widget_get_extension_events(SvGtkWidget(widget)));
}

/*
GtkWidget*  gtk_widget_get_ancestor         (GtkWidget *widget,
                                             GtkType widget_type);
GdkColormap* gtk_widget_get_colormap        (GtkWidget *widget);
void        gtk_widget_set_colormap         (GtkWidget *widget,
                                             GdkColormap *colormap);
GdkVisual*  gtk_widget_get_visual           (GtkWidget *widget);
*/

SV* gtkperl_widget_get_events(SV* widget)
{
    return newSVGdkEventMask(gtk_widget_get_events(SvGtkWidget(widget)));
}

/* gboolean gtk_widget_is_ancestor (GtkWidget *widget, GtkWidget *ancestor) */
int gtkperl_widget_is_ancestor(SV* widget, SV* ancestor)
{
    return gtk_widget_is_ancestor(SvGtkWidget(widget), SvGtkWidget(ancestor));
}

/* gboolean gtk_widget_hide_on_delete (GtkWidget *widget) */
int gtkperl_widget_hide_on_delete(SV* widget)
{
    return gtk_widget_hide_on_delete(SvGtkWidget(widget));
}

/*
void        gtk_widget_get_pointer          (GtkWidget *widget,
                                             gint *x,
                                             gint *y);
gboolean    gtk_widget_translate_coordinates
                                            (GtkWidget *src_widget,
                                             GtkWidget *dest_widget,
                                             gint src_x,
                                             gint src_y,
                                             gint *dest_x,
                                             gint *dest_y);
*/

void gtkperl_widget_set_style(SV* widget, SV* style)
{
    gtk_widget_set_style(SvGtkWidget(widget), SvGtkStyle(style));
}

/* void gtk_widget_ensure_style (GtkWidget *widget) */
void gtkperl_widget_ensure_style(SV* widget)
{
    gtk_widget_ensure_style(SvGtkWidget(widget));
}

SV* gtkperl_widget_get_style(SV* widget)
{
    return gtk2_perl_new_object(gtk_widget_get_style(SvGtkWidget(widget)));
}

/*
#define     gtk_widget_restore_default_style(widget)
void        gtk_widget_reset_rc_styles      (GtkWidget *widget);
void        gtk_widget_push_colormap        (GdkColormap *cmap);
void        gtk_widget_pop_colormap         (void);
void        gtk_widget_set_default_colormap (GdkColormap *colormap);
*/

SV* gtkperl_widget_get_default_style(char* class)
{
    return gtk2_perl_new_object(gtk_widget_get_default_style());
}

/*
GdkColormap* gtk_widget_get_default_colormap
                                            (void);
GdkVisual*  gtk_widget_get_default_visual   (void);
*/

/* void gtk_widget_set_direction (GtkWidget *widget, GtkTextDirection dir) */
void gtkperl_widget_set_direction(SV* widget, SV* dir)
{
    gtk_widget_set_direction(SvGtkWidget(widget), SvGtkTextDirection(dir));
}

/* GtkTextDirection gtk_widget_get_direction (GtkWidget *widget) */
SV* gtkperl_widget_get_direction(SV* widget)
{
    return newSVGtkTextDirection(gtk_widget_get_direction(SvGtkWidget(widget)));
}

/* void gtk_widget_set_default_direction (GtkTextDirection dir) */
void gtkperl_widget_set_default_direction(char* class, SV* dir)
{
    gtk_widget_set_default_direction(SvGtkTextDirection(dir));
}

/* GtkTextDirection gtk_widget_get_default_direction (void) */
SV* gtkperl_widget_get_default_direction(char* class)
{
    return newSVGtkTextDirection(gtk_widget_get_default_direction());
}

void gtkperl_widget_shape_combine_mask(SV *widget, SV *shape_mask, int offset_x, int offset_y)
{
    gtk_widget_shape_combine_mask(SvGtkWidget(widget), SvGdkBitmap(shape_mask), offset_x, offset_y);
}

/* gchar* gtk_widget_get_composite_name (GtkWidget *widget) */
SV* gtkperl_widget_get_composite_name(SV* widget)
{
    return newSVgchar(gtk_widget_get_composite_name(SvGtkWidget(widget)));
}

/* void gtk_widget_modify_fg (GtkWidget *widget, GtkStateType state, GdkColor *color) */
void gtkperl_widget_modify_fg(SV* widget, SV* state, SV* color)
{
    gtk_widget_modify_fg(SvGtkWidget(widget), SvGtkStateType(state), SvGdkColor(color));
}

/*void        gtk_widget_path                 (GtkWidget *widget,
                                             guint *path_length,
                                             gchar **path,
                                             gchar **path_reversed);
void        gtk_widget_class_path           (GtkWidget *widget,
                                             guint *path_length,
                                             gchar **path,
                                             gchar **path_reversed);
void        gtk_widget_modify_style         (GtkWidget *widget,
                                             GtkRcStyle *style);
GtkRcStyle* gtk_widget_get_modifier_style   (GtkWidget *widget);
*/

void gtkperl_widget_modify_bg(SV* widget, SV* state, SV* color)
{
    gtk_widget_modify_bg(SvGtkWidget(widget), SvGtkStateType(state), SvGdkColor(color));
}

void gtkperl_widget_modify_text(SV* widget, SV* state, SV* color)
{
    gtk_widget_modify_text(SvGtkWidget(widget), SvGtkStateType(state), SvGdkColor(color));
}

void gtkperl_widget_modify_base(SV* widget, SV* state, SV* color)
{
    gtk_widget_modify_base(SvGtkWidget(widget), SvGtkStateType(state), SvGdkColor(color));
}

void gtkperl_widget_modify_font(SV* widget, SV* font_desc)
{
    gtk_widget_modify_font(SvGtkWidget(widget), SvPangoFontDescription(font_desc));
}

SV* gtkperl_widget_create_pango_context(SV* widget)
{
    return gtk2_perl_new_object_from_pointer(gtk_widget_create_pango_context(SvGtkWidget(widget)),
					     "Gtk2::Pango::Context");
}

SV* gtkperl_widget_get_pango_context(SV* widget)
{
    return gtk2_perl_new_object_from_pointer(gtk_widget_get_pango_context(SvGtkWidget(widget)),
					     "Gtk2::Pango::Context");
}

SV* gtkperl_widget_create_pango_layout(SV* widget, gchar* text)
{
    return gtk2_perl_new_object_from_pointer(gtk_widget_create_pango_layout(SvGtkWidget(widget), text),
					     "Gtk2::Pango::Layout");
}

/* void gtk_widget_queue_clear (GtkWidget *widget) */
void gtkperl_widget_queue_clear(SV* widget)
{
    gtk_widget_queue_clear(SvGtkWidget(widget));
}

/* void gtk_widget_queue_clear_area (GtkWidget *widget, gint x, gint y, gint width, gint height) */
void gtkperl_widget_queue_clear_area(SV* widget, int x, int y, int width, int height)
{
    gtk_widget_queue_clear_area(SvGtkWidget(widget), x, y, width, height);
}

/* void gtk_widget_queue_draw_area (GtkWidget *widget, gint x, gint y, gint width, gint height) */
void gtkperl_widget_queue_draw_area(SV* widget, int x, int y, int width, int height)
{
    gtk_widget_queue_draw_area(SvGtkWidget(widget), x, y, width, height);
}

/* void gtk_widget_reset_shapes (GtkWidget *widget) */
void gtkperl_widget_reset_shapes(SV* widget)
{
    gtk_widget_reset_shapes(SvGtkWidget(widget));
}

/* void gtk_widget_set_app_paintable (GtkWidget *widget, gboolean app_paintable) */
void gtkperl_widget_set_app_paintable(SV* widget, int app_paintable)
{
    gtk_widget_set_app_paintable(SvGtkWidget(widget), app_paintable);
}

/* void gtk_widget_set_double_buffered (GtkWidget *widget, gboolean double_buffered) */
void gtkperl_widget_set_double_buffered(SV* widget, int double_buffered)
{
    gtk_widget_set_double_buffered(SvGtkWidget(widget), double_buffered);
}

/* void gtk_widget_set_redraw_on_allocate (GtkWidget *widget, gboolean redraw_on_allocate) */
void gtkperl_widget_set_redraw_on_allocate(SV* widget, int redraw_on_allocate)
{
    gtk_widget_set_redraw_on_allocate(SvGtkWidget(widget), redraw_on_allocate);
}

/* void gtk_widget_set_composite_name (GtkWidget *widget, const gchar *name) */
void gtkperl_widget_set_composite_name(SV* widget, gchar* name)
{
    gtk_widget_set_composite_name(SvGtkWidget(widget), name);
}

/* gboolean gtk_widget_set_scroll_adjustments (GtkWidget *widget, GtkAdjustment *hadjustment, GtkAdjustment *vadjustment) */
int gtkperl_widget_set_scroll_adjustments(SV* widget, SV* hadjustment, SV* vadjustment)
{
    return gtk_widget_set_scroll_adjustments(SvGtkWidget(widget), SvGtkAdjustment(hadjustment), SvGtkAdjustment(vadjustment));
}

/*
GdkPixbuf*  gtk_widget_render_icon          (GtkWidget *widget,
                                             const gchar *stock_id,
                                             GtkIconSize size,
                                             const gchar *detail);
void        gtk_widget_pop_composite_child  (void);
void        gtk_widget_push_composite_child (void);
gboolean    gtk_widget_mnemonic_activate    (GtkWidget *widget,
                                             gboolean group_cycling);
void        gtk_widget_class_install_style_property
                                            (GtkWidgetClass *klass,
                                             GParamSpec *pspec);
void        gtk_widget_class_install_style_property_parser
                                            (GtkWidgetClass *klass,
                                             GParamSpec *pspec,
                                             GtkRcPropertyParser parser);
GParamSpec* gtk_widget_class_find_style_property
                                            (GtkWidgetClass *klass,
                                             const gchar *property_name);
GParamSpec** gtk_widget_class_list_style_properties
                                            (GtkWidgetClass *klass,
                                             guint *n_properties);
GdkRegion*  gtk_widget_region_intersect     (GtkWidget *widget,
                                             GdkRegion *region);
gint        gtk_widget_send_expose          (GtkWidget *widget,
                                             GdkEvent *event);
*/

static void init_property_val(SV* widget, gchar* property_name, GValue *val)
{
    GParamSpec *pspec;
    pspec = gtk_widget_class_find_style_property(GTK_WIDGET_GET_CLASS(SvGtkWidget(widget)), property_name);
    if (!pspec)
	croak("FATAL: widget %s doesn't have such style property (%s)", get_class(SvGObject(widget)), property_name);
    g_value_init(val, G_PARAM_SPEC_VALUE_TYPE(pspec));
}

SV* gtkperl_widget_style_get_property(SV* widget, gchar* property_name)
{
    GValue val = { 0, };
    SV* property;
    init_property_val(widget, property_name, &val);
    gtk_widget_style_get_property(SvGtkWidget(widget), property_name, &val);
    property = gperl_object_from_value(&val);
    if (!property)
	croak("FATAL: failed to convert back value of style property %s of type %s (of widget %s)",
	      property_name, g_type_name(G_VALUE_TYPE(&val)), get_class(SvGObject(widget)));
    return property;
}

/* gboolean gtk_widget_child_focus (GtkWidget *widget, GtkDirectionType direction) */
int gtkperl_widget_child_focus(SV* widget, SV* direction)
{
    return gtk_widget_child_focus(SvGtkWidget(widget), SvGtkDirectionType(direction));
}

/* void gtk_widget_child_notify (GtkWidget *widget, const gchar *child_property) */
void gtkperl_widget_child_notify(SV* widget, gchar* child_property)
{
    gtk_widget_child_notify(SvGtkWidget(widget), child_property);
}

/* void gtk_widget_freeze_child_notify (GtkWidget *widget) */
void gtkperl_widget_freeze_child_notify(SV* widget)
{
    gtk_widget_freeze_child_notify(SvGtkWidget(widget));
}

/* gboolean gtk_widget_get_child_visible (GtkWidget *widget) */
int gtkperl_widget_get_child_visible(SV* widget)
{
    return gtk_widget_get_child_visible(SvGtkWidget(widget));
}

/*
void        gtk_widget_style_get            (GtkWidget *widget,
                                             const gchar *first_property_name,
                                             ...);
void        gtk_widget_style_get_valist     (GtkWidget *widget,
                                             const gchar *first_property_name,
                                             va_list var_args);
AtkObject*  gtk_widget_get_accessible       (GtkWidget *widget);
*/

/* GtkWidget* gtk_widget_get_parent (GtkWidget *widget) */
SV* gtkperl_widget_get_parent(SV* widget)
{
    return gtk2_perl_new_object(gtk_widget_get_parent(SvGtkWidget(widget)));
}

/* GdkWindow* gtk_widget_get_root_window (GtkWidget *widget) */
SV* gtkperl_widget_get_root_window(SV* widget)
{
    return gtk2_perl_new_object(gtk_widget_get_root_window(SvGtkWidget(widget)));
}

/* void gtk_widget_get_size_request (GtkWidget *widget, gint *width, gint *height) */
SV* gtkperl_widget__get_size_request(SV* widget)
{
    gint width, height;
    AV* values = newAV();
    gtk_widget_get_size_request(SvGtkWidget(widget), &width, &height);
    av_push(values, newSViv(width));
    av_push(values, newSViv(height));
    return newRV_noinc((SV*) values);
}

/* void gtk_widget_set_child_visible (GtkWidget *widget, gboolean is_visible) */
void gtkperl_widget_set_child_visible(SV* widget, int is_visible)
{
    gtk_widget_set_child_visible(SvGtkWidget(widget), is_visible);
}

/*
GtkSettings* gtk_widget_get_settings        (GtkWidget *widget);
GtkClipboard* gtk_widget_get_clipboard      (GtkWidget *widget,
                                             GdkAtom selection);
GdkDisplay* gtk_widget_get_display          (GtkWidget *widget);
GdkScreen*  gtk_widget_get_screen           (GtkWidget *widget);
gboolean    gtk_widget_has_screen           (GtkWidget *widget);
#define     gtk_widget_pop_visual           ()
#define     gtk_widget_push_visual          (visual)
#define     gtk_widget_set_default_visual   (visual)
*/

void gtkperl_widget_set_size_request(SV *widget, int width, int height)
{
    gtk_widget_set_size_request(SvGtkWidget(widget), width, height);
}

/* void gtk_widget_thaw_child_notify (GtkWidget *widget) */
void gtkperl_widget_thaw_child_notify(SV* widget)
{
    gtk_widget_thaw_child_notify(SvGtkWidget(widget));
}

/*
#define     gtk_widget_set_visual           (widget,visual)

GtkRequisition* gtk_requisition_copy        (const GtkRequisition *requisition);
void        gtk_requisition_free            (GtkRequisition *requisition);
*/

/** properties **/

SV* gtkperl_widget_window(SV* widget)
{
    if (GTK_WIDGET_REALIZED(SvGtkWidget(widget)))
	return gtk2_perl_new_object_from_pointer(SvGtkWidget(widget)->window, "Gtk2::Gdk::Window");
    else
	return &PL_sv_undef;
}

SV* gtkperl_widget_allocation(SV* widget)
{
    return gtk2_perl_new_object_from_pointer(&(SvGtkWidget(widget)->allocation), "Gtk2::Allocation");
}

SV* gtkperl_widget_requisition(SV* widget)
{
    return gtk2_perl_new_object_from_pointer(&(SvGtkWidget(widget)->requisition), "Gtk2::Requisition");
}

   
// from gtktooltips.h, but really belongs to the widget class
SV* gtkperl_widget_get_tooltip_data(SV* widget)
{
    HV* data = newHV();
    GtkTooltipsData * g_data = gtk_tooltips_data_get(SvGtkWidget(widget));
    if (g_data) {
	hv_store(data, "tooltips", 8, gtk2_perl_new_object(g_data->tooltips), 0);
	hv_store(data, "widget", 6, gtk2_perl_new_object(g_data->widget), 0);
	hv_store(data, "tip_text", 8, newSVpv(g_data->tip_text, 0), 0);
	hv_store(data, "tip_private", 11, newSVpv(g_data->tip_private, 0), 0);
    }
    return newRV_noinc((SV*) data);
}

// This is from homeless selection stuff
// see http://developer.gnome.org/doc/API/2.0/gtk/gtk-selections.html


int gtkperl_widget_selection_owner_set(SV *widget, char* selection, int time)
{
    return gtk_selection_owner_set(SvGtkWidget(widget), gdk_atom_intern(selection, 0), time);
}

void gtkperl_widget_selection_add_target(SV* widget, char* selection, char* target, int info)
{
    gtk_selection_add_target(SvGtkWidget(widget), gdk_atom_intern(selection, 0), gdk_atom_intern(target, 0), info);
}

int gtkperl_widget_selection_convert(SV* widget, char* selection, char* target, int time)
{
    return gtk_selection_convert(SvGtkWidget(widget),
				 gdk_atom_intern(selection, FALSE), gdk_atom_intern(target, FALSE), 
				 time);
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

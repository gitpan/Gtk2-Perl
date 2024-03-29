/* $Id: Window.c,v 1.13 2003/01/21 12:19:28 ggc Exp $
 * Copyright 2002, G�ran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_window_new(char* class, SV* parent, SV* attrs, int mask)
{
    GdkWindowAttr attributes;
    HV* ha = (HV*) SvRV(attrs);
    I32 i, len = hv_iterinit(ha);
    bzero(&attributes, sizeof(GdkWindowAttr));
    for (i = 0; i < len; i++) {
	char* key; 
	I32 keylen;
	SV* sv = hv_iternextsv(ha, &key, &keylen);
	if (strcpy(key, "title")) attributes.title = SvPV_nolen(sv);
	else if (strcpy(key, "event_mask")) attributes.event_mask = SvIV(sv);
	else if (strcpy(key, "x")) attributes.x = SvIV(sv);
	else if (strcpy(key, "y")) attributes.y = SvIV(sv);
	else if (strcpy(key, "width")) attributes.width = SvIV(sv);
	else if (strcpy(key, "height")) attributes.height = SvIV(sv);
	else if (strcpy(key, "wclass")) attributes.wclass = SvGdkWindowClass(sv);
	else if (strcpy(key, "visual")) attributes.visual = SvGdkVisual(sv);
	else if (strcpy(key, "colormap")) attributes.colormap = SvGdkColormap(sv);
	else if (strcpy(key, "window_type")) attributes.window_type = SvGdkWindowType(sv);
	else if (strcpy(key, "cursor")) attributes.cursor = SvGdkCursor(sv);
	else if (strcpy(key, "wmclass_name")) attributes.wmclass_name = SvPV_nolen(sv);
	else if (strcpy(key, "wmclass_class")) attributes.wmclass_class = SvPV_nolen(sv);
	else if (strcpy(key, "override_redirect")) attributes.override_redirect = SvIV(sv);
	else { fprintf(stderr, "DIE: unknown field %s\n", key); exit(-1); }
    }
    return gtk2_perl_new_object_from_pointer(gdk_window_new(SvGdkWindow(parent), &attributes, mask), class);
}

/* void gdk_window_destroy (GdkWindow *window) */
void gdkperl_window_destroy(SV* window)
{
    gdk_window_destroy(SvGdkWindow(window));
}

/* GdkWindowType gdk_window_get_window_type (GdkWindow *window) */
SV* gdkperl_window_get_window_type(SV* window)
{
    return newSVGdkWindowType(gdk_window_get_window_type(SvGdkWindow(window)));
}

/* GdkWindow* gdk_window_at_pointer (gint *win_x, gint *win_y) */
SV* gdkperl_window__at_pointer(char* class)
{
    gint win_x, win_y;
    AV* values = newAV();
    GdkWindow* window = gdk_window_at_pointer(&win_x, &win_y);
    av_push(values, gtk2_perl_new_object_from_pointer_nullok(window, "Gtk2::Gdk::Window"));
    av_push(values, newSViv(win_x));
    av_push(values, newSViv(win_y));
    return newRV_noinc((SV*) values);
}

/* void gdk_window_show (GdkWindow *window) */
void gdkperl_window_show(SV* window)
{
    gdk_window_show(SvGdkWindow(window));
}

/* void gdk_window_hide (GdkWindow *window) */
void gdkperl_window_hide(SV* window)
{
    gdk_window_hide(SvGdkWindow(window));
}

/* void gdk_window_withdraw (GdkWindow *window) */
void gdkperl_window_withdraw(SV* window)
{
    gdk_window_withdraw(SvGdkWindow(window));
}

/* void gdk_window_show_unraised (GdkWindow *window) */
void gdkperl_window_show_unraised(SV* window)
{
    gdk_window_show_unraised(SvGdkWindow(window));
}

/* void gdk_window_move (GdkWindow *window, gint x, gint y) */
void gdkperl_window_move(SV* window, int x, int y)
{
    gdk_window_move(SvGdkWindow(window), x, y);
}

/* void gdk_window_resize (GdkWindow *window, gint width, gint height) */
void gdkperl_window_resize(SV* window, int width, int height)
{
    gdk_window_resize(SvGdkWindow(window), width, height);
}

/* void gdk_window_move_resize (GdkWindow *window, gint x, gint y, gint width, gint height) */
void gdkperl_window_move_resize(SV* window, int x, int y, int width, int height)
{
    gdk_window_move_resize(SvGdkWindow(window), x, y, width, height);
}

/* void gdk_window_reparent (GdkWindow *window, GdkWindow *new_parent, gint x, gint y) */
void gdkperl_window_reparent(SV* window, SV* new_parent, int x, int y)
{
    gdk_window_reparent(SvGdkWindow(window), SvGdkWindow(new_parent), x, y);
}

/* void gdk_window_clear (GdkWindow *window) */
void gdkperl_window_clear(SV* window)
{
    gdk_window_clear(SvGdkWindow(window));
}

/* void gdk_window_clear_area (GdkWindow *window, gint x, gint y, gint width, gint height) */
void gdkperl_window_clear_area(SV* window, int x, int y, int width, int height)
{
    gdk_window_clear_area(SvGdkWindow(window), x, y, width, height);
}

/* void gdk_window_clear_area_e (GdkWindow *window, gint x, gint y, gint width, gint height) */
void gdkperl_window_clear_area_e(SV* window, int x, int y, int width, int height)
{
    gdk_window_clear_area_e(SvGdkWindow(window), x, y, width, height);
}

/* void gdk_window_raise (GdkWindow *window) */
void gdkperl_window_raise(SV* window)
{
    gdk_window_raise(SvGdkWindow(window));
}

/* void gdk_window_lower (GdkWindow *window) */
void gdkperl_window_lower(SV* window)
{
    gdk_window_lower(SvGdkWindow(window));
}

/* void gdk_window_focus (GdkWindow *window, guint32 timestamp) */
void gdkperl_window_focus(SV* window, int timestamp)
{
    gdk_window_focus(SvGdkWindow(window), timestamp);
}

/* void gdk_window_set_override_redirect (GdkWindow *window, gboolean override_redirect) */
void gdkperl_window_set_override_redirect(SV* window, int override_redirect)
{
    gdk_window_set_override_redirect(SvGdkWindow(window), override_redirect);
}

/* void gdk_window_scroll (GdkWindow *window, gint dx, gint dy) */
void gdkperl_window_scroll(SV* window, int dx, int dy)
{
    gdk_window_scroll(SvGdkWindow(window), dx, dy);
}

/* void gdk_window_set_child_shapes (GdkWindow *window) */
void gdkperl_window_set_child_shapes(SV* window)
{
    gdk_window_set_child_shapes(SvGdkWindow(window));
}

/* void gdk_window_merge_child_shapes (GdkWindow *window) */
void gdkperl_window_merge_child_shapes(SV* window)
{
    gdk_window_merge_child_shapes(SvGdkWindow(window));
}

/* gboolean gdk_window_set_static_gravities (GdkWindow *window, gboolean use_static) */
int gdkperl_window_set_static_gravities(SV* window, int use_static)
{
    return gdk_window_set_static_gravities(SvGdkWindow(window), use_static);
}

#ifndef GDK_MULTIHEAD_SAFE
SV* gdkperl_window_foreign_new(char* class, int anid)
{
    return gtk2_perl_new_object_nullok(gdk_window_foreign_new(anid));
}

/* GdkWindow* gdk_window_lookup (GdkNativeWindow anid) */
SV* gdkperl_window_lookup(char* class, int anid)
{
    return gtk2_perl_new_object(gdk_window_lookup(anid));
}
#endif

/* gboolean gdk_window_is_visible (GdkWindow *window) */
int gdkperl_window_is_visible(SV* window)
{
    return gdk_window_is_visible(SvGdkWindow(window));
}

/* gboolean gdk_window_is_viewable (GdkWindow *window) */
int gdkperl_window_is_viewable(SV* window)
{
    return gdk_window_is_viewable(SvGdkWindow(window));
}

/* GdkWindowState gdk_window_get_state (GdkWindow *window) */
SV* gdkperl_window_get_state(SV* window)
{
    return newSVGdkWindowState(gdk_window_get_state(SvGdkWindow(window)));
}

/* void gdk_window_set_type_hint (GdkWindow *window, GdkWindowTypeHint hint) */
void gdkperl_window_set_type_hint(SV* window, SV* hint)
{
    gdk_window_set_type_hint(SvGdkWindow(window), SvGdkWindowTypeHint(hint));
}

/* void gdk_window_set_modal_hint (GdkWindow *window, gboolean modal) */
void gdkperl_window_set_modal_hint(SV* window, int modal)
{
    gdk_window_set_modal_hint(SvGdkWindow(window), modal);
}


/* void gdk_window_shape_combine_mask (GdkWindow *window, GdkBitmap *mask, gint x, gint y) */
void gdkperl_window_shape_combine_mask(SV* window, SV* mask, int x, int y)
{
    gdk_window_shape_combine_mask(SvGdkWindow(window), SvGdkBitmap(mask), x, y);
}


/* void gdk_window_set_title (GdkWindow *window, const gchar *title) */
void gdkperl_window_set_title(SV* window, char* title)
{
    gdk_window_set_title(SvGdkWindow(window), title);
}

/* void gdk_window_set_role (GdkWindow *window, const gchar *role) */
void gdkperl_window_set_role(SV* window, char* role)
{
    gdk_window_set_role(SvGdkWindow(window), role);
}

/* void gdk_window_set_transient_for (GdkWindow *window, GdkWindow *parent) */
void gdkperl_window_set_transient_for(SV* window, SV* parent)
{
    gdk_window_set_transient_for(SvGdkWindow(window), SvGdkWindow(parent));
}

/* void gdk_window_set_background (GdkWindow *window, GdkColor *color) */
void gdkperl_window_set_background(SV* window, SV* color)
{
    gdk_window_set_background(SvGdkWindow(window), SvGdkColor(color));
}

/* void gdk_window_set_back_pixmap (GdkWindow *window, GdkPixmap *pixmap, gboolean parent_relative) */
void gdkperl_window_set_back_pixmap(SV* window, SV* pixmap, int parent_relative)
{
    gdk_window_set_back_pixmap(SvGdkWindow(window), SvGdkPixmap_nullok(pixmap), parent_relative);
}

/* void gdk_window_set_cursor (GdkWindow *window, GdkCursor *cursor) */
void gdkperl_window_set_cursor(SV* window, SV* cursor)
{
    gdk_window_set_cursor(SvGdkWindow(window), SvGdkCursor(cursor));
}

/* void gdk_window_get_geometry (GdkWindow *window, gint *x, gint *y, gint *width, gint *height, gint *depth) */
SV* gdkperl_window__get_geometry(SV* window)
{
    gint x, y, width, height, depth;
    AV* values = newAV();
    gdk_window_get_geometry(SvGdkWindow(window), &x, &y, &width, &height, &depth);
    av_push(values, newSViv(x));
    av_push(values, newSViv(y));
    av_push(values, newSViv(width));
    av_push(values, newSViv(height));
    av_push(values, newSViv(depth));
    return newRV_noinc((SV*) values);
}

/* void gdk_window_get_position (GdkWindow *window, gint *x, gint *y) */
SV* gdkperl_window__get_position(SV* window)
{
    gint x, y;
    AV* values = newAV();
    gdk_window_get_position(SvGdkWindow(window), &x, &y);
    av_push(values, newSViv(x));
    av_push(values, newSViv(y));
    return newRV_noinc((SV*) values);
}

/* gint gdk_window_get_origin (GdkWindow *window, gint *x, gint *y) */
SV* gdkperl_window__get_origin(SV* window)
{
    gint x, y;
    AV* values = newAV();
    gdk_window_get_origin(SvGdkWindow(window), &x, &y);
    av_push(values, newSViv(x));
    av_push(values, newSViv(y));
    return newRV_noinc((SV*) values);
}

/* void gdk_window_get_root_origin (GdkWindow *window, gint *x, gint *y) */
SV* gdkperl_window__get_root_origin(SV* window)
{
    gint x, y;
    AV* values = newAV();
    gdk_window_get_root_origin(SvGdkWindow(window), &x, &y);
    av_push(values, newSViv(x));
    av_push(values, newSViv(y));
    return newRV_noinc((SV*) values);
}

/* void gdk_window_get_frame_extents (GdkWindow *window, GdkRectangle *rect) */
SV* gdkperl_window_get_frame_extents(SV* window)
{
    GdkRectangle* rect = g_malloc0(sizeof(GdkRectangle));
    gdk_window_get_frame_extents(SvGdkWindow(window), rect);
    return gtk2_perl_new_object_from_pointer(rect, "Gtk2::Gdk::Rectangle");
}

/* GdkWindow* gdk_window_get_pointer (GdkWindow *window, gint *x, gint *y, GdkModifierType *mask) */
SV* gdkperl_window__get_pointer(SV* window)
{
    gint x, y;
    GdkModifierType mask;
    AV* values = newAV();
    GdkWindow* return_window = gdk_window_get_pointer(SvGdkWindow(window), &x, &y, &mask);
    av_push(values, gtk2_perl_new_object_from_pointer_nullok(return_window, "Gtk2::Gdk::Window"));
    av_push(values, newSViv(x));
    av_push(values, newSViv(y));
    av_push(values, newSVGdkModifierType(mask));
    return newRV_noinc((SV*) values);
}


/* GdkWindow * gdk_window_get_parent (GdkWindow *window) */
SV* gdkperl_window_get_parent(SV* window)
{
    return gtk2_perl_new_object(gdk_window_get_parent(SvGdkWindow(window)));
}

/* GdkWindow * gdk_window_get_toplevel (GdkWindow *window) */
SV* gdkperl_window_get_toplevel(SV* window)
{
    return gtk2_perl_new_object(gdk_window_get_toplevel(SvGdkWindow(window)));
}

/* GdkEventMask gdk_window_get_events (GdkWindow *window) */
SV* gdkperl_window_get_events(SV* window)
{
    return newSVGdkEventMask(gdk_window_get_events(SvGdkWindow(window)));
}

/* void gdk_window_set_events (GdkWindow *window, GdkEventMask event_mask) */
void gdkperl_window_set_events(SV* window, SV* event_mask)
{
    gdk_window_set_events(SvGdkWindow(window), SvGdkEventMask(event_mask));
}

/* void gdk_window_set_icon (GdkWindow *window, GdkWindow *icon_window, GdkPixmap *pixmap, GdkBitmap *mask) */
void gdkperl_window_set_icon(SV* window, SV* icon_window, SV* pixmap, SV* mask)
{
    gdk_window_set_icon(SvGdkWindow(window), SvGdkWindow(icon_window), SvGdkPixmap(pixmap), SvGdkBitmap(mask));
}

/* void gdk_window_set_icon_name (GdkWindow *window, const gchar *name) */
void gdkperl_window_set_icon_name(SV* window, char* name)
{
    gdk_window_set_icon_name(SvGdkWindow(window), name);
}

/* void gdk_window_set_group (GdkWindow *window, GdkWindow *leader) */
void gdkperl_window_set_group(SV* window, SV* leader)
{
    gdk_window_set_group(SvGdkWindow(window), SvGdkWindow(leader));
}

/* void gdk_window_set_decorations (GdkWindow *window, GdkWMDecoration decorations) */
void gdkperl_window_set_decorations(SV* window, SV* decorations)
{
    gdk_window_set_decorations(SvGdkWindow(window), SvGdkWMDecoration(decorations));
}

/* gboolean gdk_window_get_decorations (GdkWindow *window, GdkWMDecoration *decorations) */
SV* gdkperl_window_get_decorations(SV* window)
{
    GdkWMDecoration deco;
    gboolean results = gdk_window_get_decorations(SvGdkWindow(window), &deco);
    if (results)
	return newSVGdkWMDecoration(deco);
    else
	return &PL_sv_undef;
}

/* void gdk_window_iconify (GdkWindow *window) */
void gdkperl_window_iconify(SV* window)
{
    gdk_window_iconify(SvGdkWindow(window));
}

/* void gdk_window_deiconify (GdkWindow *window) */
void gdkperl_window_deiconify(SV* window)
{
    gdk_window_deiconify(SvGdkWindow(window));
}

/* void gdk_window_stick (GdkWindow *window) */
void gdkperl_window_stick(SV* window)
{
    gdk_window_stick(SvGdkWindow(window));
}

/* void gdk_window_unstick (GdkWindow *window) */
void gdkperl_window_unstick(SV* window)
{
    gdk_window_unstick(SvGdkWindow(window));
}

/* void gdk_window_maximize (GdkWindow *window) */
void gdkperl_window_maximize(SV* window)
{
    gdk_window_maximize(SvGdkWindow(window));
}

/* void gdk_window_unmaximize (GdkWindow *window) */
void gdkperl_window_unmaximize(SV* window)
{
    gdk_window_unmaximize(SvGdkWindow(window));
}

/* void gdk_window_fullscreen (GdkWindow *window) */
void gdkperl_window_fullscreen(SV* window)
{
    gdk_window_fullscreen(SvGdkWindow(window));
}

/* void gdk_window_unfullscreen (GdkWindow *window) */
void gdkperl_window_unfullscreen(SV* window)
{
    gdk_window_unfullscreen(SvGdkWindow(window));
}

/* void gdk_window_register_dnd (GdkWindow *window) */
void gdkperl_window_register_dnd(SV* window)
{
    gdk_window_register_dnd(SvGdkWindow(window));
}

/* void gdk_window_invalidate_rect (GdkWindow *window, GdkRectangle *rect, gboolean invalidate_children) */
void gdkperl_window_invalidate_rect(SV* window, SV* rect, int invalidate_children)
{
    gdk_window_invalidate_rect(SvGdkWindow(window), SvGdkRectangle(rect), invalidate_children);
}

/* void gdk_window_freeze_updates (GdkWindow *window) */
void gdkperl_window_freeze_updates(SV* window)
{
    gdk_window_freeze_updates(SvGdkWindow(window));
}

/* void gdk_window_thaw_updates (GdkWindow *window) */
void gdkperl_window_thaw_updates(SV* window)
{
    gdk_window_thaw_updates(SvGdkWindow(window));
}

/* void gdk_window_process_all_updates (void) */
void gdkperl_window_process_all_updates(char* class)
{
    gdk_window_process_all_updates();
}

/* void gdk_window_process_updates (GdkWindow *window, gboolean update_children) */
void gdkperl_window_process_updates(SV* window, int update_children)
{
    gdk_window_process_updates(SvGdkWindow(window), update_children);
}



/* access functions */

// int gdkperl_window_get_type(SV* ge) { return (SvGdkWindow(ge))->type; }

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

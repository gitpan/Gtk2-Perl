/* $Id: TextView.c,v 1.6 2002/11/11 22:32:20 gthyni Exp $
 * Copyright 2002, G�ran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_text_view_new(char* class)
{
    return gtk2_perl_new_object(gtk_text_view_new());
}


/* NOT YET IMPLEMENTED
GtkWidget* gtk_text_view_new_with_buffer(GtkTextBuffer *buffer);
void       gtk_text_view_set_buffer(GtkTextView *text_view,GtkTextBuffer *buffer);
*/

SV* gtkperl_text_view_get_buffer(SV *text_view)
{
    return gtk2_perl_new_object(gtk_text_view_get_buffer(SvGtkTextView(text_view)));
}

void gtkperl_text_view_set_cursor_visible(SV* text_view, int setting)
{
    gtk_text_view_set_cursor_visible(SvGtkTextView(text_view), setting);
}

int gtkperl_text_view_get_cursor_visible(SV* text_view)
{
    return gtk_text_view_get_cursor_visible(SvGtkTextView(text_view));
}


/* MORE NOT YET IMPLEMENTED
void        gtk_text_view_scroll_to_mark    (GtkTextView *text_view,
                                             GtkTextMark *mark,
                                             gdouble within_margin,
                                             gboolean use_align,
                                             gdouble xalign,
                                             gdouble yalign);
gboolean    gtk_text_view_scroll_to_iter    (GtkTextView *text_view,
                                             GtkTextIter *iter,
                                             gdouble within_margin,
                                             gboolean use_align,
                                             gdouble xalign,
                                             gdouble yalign);
void        gtk_text_view_scroll_mark_onscreen
                                            (GtkTextView *text_view,
                                             GtkTextMark *mark);
gboolean    gtk_text_view_move_mark_onscreen
                                            (GtkTextView *text_view,
                                             GtkTextMark *mark);
gboolean    gtk_text_view_place_cursor_onscreen
                                            (GtkTextView *text_view);
void        gtk_text_view_get_visible_rect  (GtkTextView *text_view,
                                             GdkRectangle *visible_rect);
void        gtk_text_view_get_iter_location (GtkTextView *text_view,
                                             const GtkTextIter *iter,
                                             GdkRectangle *location);
void        gtk_text_view_get_line_at_y     (GtkTextView *text_view,
                                             GtkTextIter *target_iter,
                                             gint y,
                                             gint *line_top);
void        gtk_text_view_get_line_yrange   (GtkTextView *text_view,
                                             const GtkTextIter *iter,
                                             gint *y,
                                             gint *height);
void        gtk_text_view_get_iter_at_location
                                            (GtkTextView *text_view,
                                             GtkTextIter *iter,
                                             gint x,
                                             gint y);
void        gtk_text_view_buffer_to_window_coords
                                            (GtkTextView *text_view,
                                             GtkTextWindowType win,
                                             gint buffer_x,
                                             gint buffer_y,
                                             gint *window_x,
                                             gint *window_y);
void        gtk_text_view_window_to_buffer_coords
                                            (GtkTextView *text_view,
                                             GtkTextWindowType win,
                                             gint window_x,
                                             gint window_y,
                                             gint *buffer_x,
                                             gint *buffer_y);
GdkWindow*  gtk_text_view_get_window        (GtkTextView *text_view,
                                             GtkTextWindowType win);
GtkTextWindowType gtk_text_view_get_window_type
                                            (GtkTextView *text_view,
                                             GdkWindow *window);
void        gtk_text_view_set_border_window_size
                                            (GtkTextView *text_view,
                                             GtkTextWindowType type,
                                             gint size);
gint        gtk_text_view_get_border_window_size
                                            (GtkTextView *text_view,
                                             GtkTextWindowType type);


gboolean    gtk_text_view_forward_display_line
                                            (GtkTextView *text_view,
                                             GtkTextIter *iter);
gboolean    gtk_text_view_backward_display_line
                                            (GtkTextView *text_view,
                                             GtkTextIter *iter);
gboolean    gtk_text_view_forward_display_line_end
                                            (GtkTextView *text_view,
                                             GtkTextIter *iter);
gboolean    gtk_text_view_backward_display_line_start
                                            (GtkTextView *text_view,
                                             GtkTextIter *iter);
gboolean    gtk_text_view_starts_display_line
                                            (GtkTextView *text_view,
                                             const GtkTextIter *iter);
gboolean    gtk_text_view_move_visually     (GtkTextView *text_view,
                                             GtkTextIter *iter,
                                             gint count);
void        gtk_text_view_add_child_at_anchor
                                            (GtkTextView *text_view,
                                             GtkWidget *child,
                                             GtkTextChildAnchor *anchor);
struct      GtkTextChildAnchor;
GtkTextChildAnchor* gtk_text_child_anchor_new
                                            (void);
GList*      gtk_text_child_anchor_get_widgets
                                            (GtkTextChildAnchor *anchor);
gboolean    gtk_text_child_anchor_get_deleted
                                            (GtkTextChildAnchor *anchor);
void        gtk_text_view_add_child_in_window
                                            (GtkTextView *text_view,
                                             GtkWidget *child,
                                             GtkTextWindowType which_window,
                                             gint xpos,
                                             gint ypos);
void        gtk_text_view_move_child        (GtkTextView *text_view,
                                             GtkWidget *child,
                                             gint xpos,
                                             gint ypos);
*/

void gtkperl_text_view_set_wrap_mode(SV* text_view, SV* wrap_mode)
{
    gtk_text_view_set_wrap_mode(SvGtkTextView(text_view), SvGtkWrapMode(wrap_mode));
}

SV* gtkperl_text_view_get_wrap_mode(SV* text_view)
{
    return newSVGtkWrapMode(gtk_text_view_get_wrap_mode(SvGtkTextView(text_view)));
}

void gtkperl_text_view_set_editable(SV* text_view, int setting)
{
    gtk_text_view_set_editable(SvGtkTextView(text_view), setting);
}

int gtkperl_text_view_get_editable(SV* text_view)
{
    return gtk_text_view_get_editable(SvGtkTextView(text_view));
}

void gtkperl_text_view_set_pixels_above_lines(SV* text_view, int pixels_above_lines)
{
    gtk_text_view_set_pixels_above_lines(SvGtkTextView(text_view), pixels_above_lines);
}

int gtkperl_text_view_get_pixels_above_lines(SV* text_view)
{
    return gtk_text_view_get_pixels_above_lines(SvGtkTextView(text_view));
}

void gtkperl_text_view_set_pixels_below_lines(SV* text_view, int pixels_below_lines)
{
    gtk_text_view_set_pixels_below_lines(SvGtkTextView(text_view), pixels_below_lines);
}

int gtkperl_text_view_get_pixels_below_lines(SV* text_view)
{
    return gtk_text_view_get_pixels_below_lines(SvGtkTextView(text_view));
}

void gtkperl_text_view_set_pixels_inside_wrap(SV* text_view, int pixels_inside_wrap)
{
    gtk_text_view_set_pixels_inside_wrap(SvGtkTextView(text_view), pixels_inside_wrap);
}

int gtkperl_text_view_get_pixels_inside_wrap(SV* text_view)
{
    return gtk_text_view_get_pixels_inside_wrap(SvGtkTextView(text_view));
}

void gtkperl_text_view_set_justification(SV* text_view, SV* justification)
{
    gtk_text_view_set_justification(SvGtkTextView(text_view), SvGtkJustification(justification));
}

SV* gtkperl_text_view_get_justification(SV* text_view)
{
    return newSVGtkJustification(gtk_text_view_get_justification(SvGtkTextView(text_view)));
}

void gtkperl_text_view_set_left_margin(SV* text_view, int left_margin)
{
    gtk_text_view_set_left_margin(SvGtkTextView(text_view), left_margin);
}

int gtkperl_text_view_get_left_margin(SV* text_view)
{
    return gtk_text_view_get_left_margin(SvGtkTextView(text_view));
}

void gtkperl_text_view_set_right_margin(SV* text_view, int right_margin)
{
    gtk_text_view_set_right_margin(SvGtkTextView(text_view), right_margin);
}

int gtkperl_text_view_get_right_margin(SV* text_view)
{
    return gtk_text_view_get_right_margin(SvGtkTextView(text_view));
}

void gtkperl_text_view_set_indent(SV* text_view, int indent)
{
    gtk_text_view_set_indent(SvGtkTextView(text_view), indent);
}

int gtkperl_text_view_get_indent(SV* text_view)
{
    return gtk_text_view_get_indent(SvGtkTextView(text_view));
}


/*
void        gtk_text_view_set_tabs          (GtkTextView *text_view,
                                             PangoTabArray *tabs);
PangoTabArray* gtk_text_view_get_tabs       (GtkTextView *text_view);
GtkTextAttributes* gtk_text_view_get_default_attributes
                                            (GtkTextView *text_view);
#define     GTK_TEXT_VIEW_PRIORITY_VALIDATE



                                                               
*/


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

/* $Id: TextBuffer.c,v 1.12 2003/03/04 12:25:23 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


SV* gtkperl_text_buffer_new(char* class, SV* table)
{
    return gtk2_perl_new_object(gtk_text_buffer_new(SvGtkTextTagTable(table)));
}

int gtkperl_text_buffer_get_line_count(SV* buffer)
{
    return gtk_text_buffer_get_line_count(SvGtkTextBuffer(buffer));
}

int gtkperl_text_buffer_get_char_count(SV* buffer)
{
    return gtk_text_buffer_get_char_count(SvGtkTextBuffer(buffer));
}

/* NOT YET IMPLEMENTED
GtkTextTagTable* gtk_text_buffer_get_tag_table(GtkTextBuffer *buffer);
*/

void gtkperl_text_buffer_insert(SV *buffer, SV *iter, gchar *text, int len)
{
    gtk_text_buffer_insert(SvGtkTextBuffer(buffer), SvGtkTextIter(iter), text, len);
}

/* MORE NOT YET IMPLEMENTED
void        gtk_text_buffer_insert_at_cursor
                                            (GtkTextBuffer *buffer,
                                             const gchar *text,
                                             gint len);
gboolean    gtk_text_buffer_insert_interactive
                                            (GtkTextBuffer *buffer,
                                             GtkTextIter *iter,
                                             const gchar *text,
                                             gint len,
                                             gboolean default_editable);
gboolean    gtk_text_buffer_insert_interactive_at_cursor
                                            (GtkTextBuffer *buffer,
                                             const gchar *text,
                                             gint len,
                                             gboolean default_editable);
void        gtk_text_buffer_insert_range    (GtkTextBuffer *buffer,
                                             GtkTextIter *iter,
                                             const GtkTextIter *start,
                                             const GtkTextIter *end);
gboolean    gtk_text_buffer_insert_range_interactive
                                            (GtkTextBuffer *buffer,
                                             GtkTextIter *iter,
                                             const GtkTextIter *start,
                                             const GtkTextIter *end,
                                             gboolean default_editable);
void        gtk_text_buffer_insert_with_tags
                                            (GtkTextBuffer *buffer,
                                             GtkTextIter *iter,
                                             const gchar *text,
                                             gint len,
                                             GtkTextTag *first_tag,
                                             ...);
void        gtk_text_buffer_insert_with_tags_by_name
                                            (GtkTextBuffer *buffer,
                                             GtkTextIter *iter,
                                             const gchar *text,
                                             gint len,
                                             const gchar *first_tag_name,
                                             ...);
*/

void gtkperl_text_buffer_delete(SV* buffer, SV* start, SV* end)
{
    gtk_text_buffer_delete(SvGtkTextBuffer(buffer), SvGtkTextIter(start), SvGtkTextIter(end));
}

/*
void        gtk_text_buffer_delete          (GtkTextBuffer *buffer,
                                             GtkTextIter *start,
                                             GtkTextIter *end);
gboolean    gtk_text_buffer_delete_interactive
                                            (GtkTextBuffer *buffer,
                                             GtkTextIter *start_iter,
                                             GtkTextIter *end_iter,
                                             gboolean default_editable);
*/

void gtkperl_text_buffer_set_text(SV* buffer, gchar* text, int len)
{
    gtk_text_buffer_set_text(SvGtkTextBuffer(buffer), text, len);
}

SV* gtkperl_text_buffer_get_text(SV* buffer, SV* start, SV* end, int include_hidden_chars)
{
    return newSVgchar(gtk_text_buffer_get_text(SvGtkTextBuffer(buffer), SvGtkTextIter(start), SvGtkTextIter(end), include_hidden_chars));
}


SV* gtkperl_text_buffer_create_tag(SV* buffer, SV* tag_name)
{
    const char * tag_name_real = NULL;
    if (SvPOK(tag_name))
	tag_name_real = g_strdup(SvPV_nolen(tag_name));    // leaks memory :(
    return gtk2_perl_new_object(gtk_text_buffer_create_tag(SvGtkTextBuffer(buffer), tag_name_real, NULL));
}

void gtkperl_text_buffer_remove_tag(SV* buffer, SV* tag, SV* start, SV* end)
{
    gtk_text_buffer_remove_tag(SvGtkTextBuffer(buffer), SvGtkTextTag(tag), SvGtkTextIter(start), SvGtkTextIter(end));
}

void gtkperl_text_buffer_remove_all_tags(SV* buffer, SV* start, SV* end)
{
    gtk_text_buffer_remove_all_tags(SvGtkTextBuffer(buffer), SvGtkTextIter(start), SvGtkTextIter(end));
}

void gtkperl_text_buffer_apply_tag(SV* buffer, SV* tag, SV* start, SV* end)
{
    gtk_text_buffer_apply_tag(SvGtkTextBuffer(buffer), SvGtkTextTag(tag), SvGtkTextIter(start), SvGtkTextIter(end));
}

SV* gtkperl_text_buffer_get_slice(SV* buffer, SV* start, SV* end, int include_hidden_chars)
{
    return newSVgchar(gtk_text_buffer_get_slice(SvGtkTextBuffer(buffer), SvGtkTextIter(start), SvGtkTextIter(end), include_hidden_chars));
}

/* void gtk_text_buffer_insert_pixbuf (GtkTextBuffer *buffer, GtkTextIter *iter, GdkPixbuf *pixbuf) */
void gtkperl_text_buffer_insert_pixbuf(SV* buffer, SV* iter, SV* pixbuf)
{
    gtk_text_buffer_insert_pixbuf(SvGtkTextBuffer(buffer), SvGtkTextIter(iter), SvGdkPixbuf(pixbuf));
}

/* GtkTextMark* gtk_text_buffer_create_mark (GtkTextBuffer *buffer, const gchar *mark_name, const GtkTextIter *where, gboolean left_gravity) */
SV* gtkperl_text_buffer_create_mark(SV* buffer, SV* mark_name, SV* where, int left_gravity)
{
    const gchar * mark_name_real = NULL;
    if (SvPOK(mark_name))
	mark_name_real = g_strdup(SvPV_nolen(mark_name));    // leaks memory :(
    return gtk2_perl_new_object(gtk_text_buffer_create_mark(SvGtkTextBuffer(buffer), mark_name_real, SvGtkTextIter(where), left_gravity));
}

/* void gtk_text_buffer_move_mark (GtkTextBuffer *buffer, GtkTextMark *mark, const GtkTextIter *where) */
void gtkperl_text_buffer_move_mark(SV* buffer, SV* mark, SV* where)
{
    gtk_text_buffer_move_mark(SvGtkTextBuffer(buffer), SvGtkTextMark(mark), SvGtkTextIter(where));
}

/* void gtk_text_buffer_move_mark_by_name (GtkTextBuffer *buffer, const gchar *name, const GtkTextIter *where) */
void gtkperl_text_buffer_move_mark_by_name(SV* buffer, gchar* name, SV* where)
{
    gtk_text_buffer_move_mark_by_name(SvGtkTextBuffer(buffer), name, SvGtkTextIter(where));
}

/* void gtk_text_buffer_delete_mark (GtkTextBuffer *buffer, GtkTextMark *mark) */
void gtkperl_text_buffer_delete_mark(SV* buffer, SV* mark)
{
    gtk_text_buffer_delete_mark(SvGtkTextBuffer(buffer), SvGtkTextMark(mark));
}

/* void gtk_text_buffer_delete_mark_by_name (GtkTextBuffer *buffer, const gchar *name) */
void gtkperl_text_buffer_delete_mark_by_name(SV* buffer, gchar* name)
{
    gtk_text_buffer_delete_mark_by_name(SvGtkTextBuffer(buffer), name);
}

/* GtkTextMark* gtk_text_buffer_get_mark (GtkTextBuffer *buffer, const gchar *name) */
SV* gtkperl_text_buffer_get_mark(SV* buffer, gchar* name)
{
    return gtk2_perl_new_object_nullok(gtk_text_buffer_get_mark(SvGtkTextBuffer(buffer), name));
}

/*
void        gtk_text_buffer_insert_child_anchor
                                            (GtkTextBuffer *buffer,
                                             GtkTextIter *iter,
                                             GtkTextChildAnchor *anchor);
GtkTextChildAnchor* gtk_text_buffer_create_child_anchor
                                            (GtkTextBuffer *buffer,
                                             GtkTextIter *iter);
GtkTextMark* gtk_text_buffer_get_insert     (GtkTextBuffer *buffer);
GtkTextMark* gtk_text_buffer_get_selection_bound
                                            (GtkTextBuffer *buffer);
void        gtk_text_buffer_place_cursor    (GtkTextBuffer *buffer,
                                             const GtkTextIter *where);
void        gtk_text_buffer_apply_tag_by_name
                                            (GtkTextBuffer *buffer,
                                             const gchar *name,
                                             const GtkTextIter *start,
                                             const GtkTextIter *end);
void        gtk_text_buffer_remove_tag_by_name
                                            (GtkTextBuffer *buffer,
                                             const gchar *name,
                                             const GtkTextIter *start,
                                             const GtkTextIter *end);
void        gtk_text_buffer_get_iter_at_line_offset
                                            (GtkTextBuffer *buffer,
                                             GtkTextIter *iter,
                                             gint line_number,
                                             gint char_offset);
*/

SV* gtkperl_text_buffer_get_iter_at_offset(SV* buffer, int char_offset)
{
    GtkTextIter* iter = g_malloc0(sizeof(GtkTextIter));
    gtk_text_buffer_get_iter_at_offset(SvGtkTextBuffer(buffer), iter, char_offset);
    return gtk2_perl_new_object_from_pointer(iter, "Gtk2::TextIter");
}

/* void gtk_text_buffer_get_iter_at_line (GtkTextBuffer *buffer, GtkTextIter *iter, gint line_number) */
SV* gtkperl_text_buffer_get_iter_at_line(SV* buffer, int line_number)
{
    GtkTextIter* iter = g_malloc0(sizeof(GtkTextIter));
    gtk_text_buffer_get_iter_at_line(SvGtkTextBuffer(buffer), iter, line_number);
    return gtk2_perl_new_object_from_pointer(iter, "Gtk2::TextIter");
}

/* void gtk_text_buffer_get_iter_at_line_index (GtkTextBuffer *buffer, GtkTextIter *iter, gint line_number, gint byte_index) */
SV* gtkperl_text_buffer_get_iter_at_line_index(SV* buffer, int line_number, int byte_index)
{
    GtkTextIter* iter = g_malloc0(sizeof(GtkTextIter));
    gtk_text_buffer_get_iter_at_line_index(SvGtkTextBuffer(buffer), iter, line_number, byte_index);
    return gtk2_perl_new_object_from_pointer(iter, "Gtk2::TextIter");
}

/* void gtk_text_buffer_get_iter_at_mark (GtkTextBuffer *buffer, GtkTextIter *iter, GtkTextMark *mark) */
SV* gtkperl_text_buffer_get_iter_at_mark(SV* buffer, SV* mark)
{
    GtkTextIter* iter = g_malloc0(sizeof(GtkTextIter));
    gtk_text_buffer_get_iter_at_mark(SvGtkTextBuffer(buffer), iter, SvGtkTextMark(mark));
    return gtk2_perl_new_object_from_pointer(iter, "Gtk2::TextIter");
}

/* NOT YET IMPLEMENTED
void        gtk_text_buffer_get_iter_at_child_anchor
                                            (GtkTextBuffer *buffer,
                                             GtkTextIter *iter,
                                             GtkTextChildAnchor *anchor);
*/

SV* gtkperl_text_buffer_get_start_iter(SV* buffer)
{
    GtkTextIter* iter = g_malloc0(sizeof(GtkTextIter));
    gtk_text_buffer_get_start_iter(SvGtkTextBuffer(buffer), iter);
    return gtk2_perl_new_object_from_pointer(iter, "Gtk2::TextIter");
}

SV* gtkperl_text_buffer_get_end_iter(SV* buffer)
{
    GtkTextIter* iter = g_malloc0(sizeof(GtkTextIter));
    gtk_text_buffer_get_end_iter(SvGtkTextBuffer(buffer), iter);
    return gtk2_perl_new_object_from_pointer(iter, "Gtk2::TextIter");
}

SV* gtkperl_text_buffer__get_bounds(SV* buffer)
{
    GtkTextIter *start = g_malloc0(sizeof(GtkTextIter));
    GtkTextIter *end   = g_malloc0(sizeof(GtkTextIter));
    AV* bounds = newAV();
    gtk_text_buffer_get_bounds(SvGtkTextBuffer(buffer), start, end);
    av_push(bounds, gtk2_perl_new_object_from_pointer(start, "Gtk2::TextIter"));
    av_push(bounds, gtk2_perl_new_object_from_pointer(end, "Gtk2::TextIter"));
    return newRV_noinc((SV*) bounds);
}

/* gboolean gtk_text_buffer_get_modified (GtkTextBuffer *buffer) */
int gtkperl_text_buffer_get_modified(SV* buffer)
{
    return gtk_text_buffer_get_modified(SvGtkTextBuffer(buffer));
}

/* void gtk_text_buffer_set_modified (GtkTextBuffer *buffer, gboolean setting) */
void gtkperl_text_buffer_set_modified(SV* buffer, int setting)
{
    gtk_text_buffer_set_modified(SvGtkTextBuffer(buffer), setting);
}

/* gboolean gtk_text_buffer_delete_selection (GtkTextBuffer *buffer, gboolean interactive, gboolean default_editable) */
int gtkperl_text_buffer_delete_selection(SV* buffer, int interactive, int default_editable)
{
    return gtk_text_buffer_delete_selection(SvGtkTextBuffer(buffer), interactive, default_editable);
}

/* gboolean gtk_text_buffer_get_selection_bounds (GtkTextBuffer *buffer, GtkTextIter *start, GtkTextIter *end) */
SV* gtkperl_text_buffer__get_selection_bounds(SV* buffer)
{
    GtkTextIter *start = g_malloc0(sizeof(GtkTextIter));
    GtkTextIter *end   = g_malloc0(sizeof(GtkTextIter));
    AV* bounds = newAV();
    av_push(bounds, newSViv(gtk_text_buffer_get_selection_bounds(SvGtkTextBuffer(buffer), start, end)));
    av_push(bounds, gtk2_perl_new_object_from_pointer(start, "Gtk2::TextIter"));
    av_push(bounds, gtk2_perl_new_object_from_pointer(end, "Gtk2::TextIter"));
    return newRV_noinc((SV*) bounds);
}

/* void gtk_text_buffer_begin_user_action (GtkTextBuffer *buffer) */
void gtkperl_text_buffer_begin_user_action(SV* buffer)
{
    gtk_text_buffer_begin_user_action(SvGtkTextBuffer(buffer));
}

/* void gtk_text_buffer_end_user_action (GtkTextBuffer *buffer) */
void gtkperl_text_buffer_end_user_action(SV* buffer)
{
    gtk_text_buffer_end_user_action(SvGtkTextBuffer(buffer));
}

/*
void        gtk_text_buffer_paste_clipboard (GtkTextBuffer *buffer,
                                             GtkClipboard *clipboard,
                                             GtkTextIter *override_location,
                                             gboolean default_editable);
void        gtk_text_buffer_copy_clipboard  (GtkTextBuffer *buffer,
                                             GtkClipboard *clipboard);
void        gtk_text_buffer_cut_clipboard   (GtkTextBuffer *buffer,
                                             GtkClipboard *clipboard,
                                             gboolean default_editable);
void        gtk_text_buffer_add_selection_clipboard
                                            (GtkTextBuffer *buffer,
                                             GtkClipboard *clipboard);
void        gtk_text_buffer_remove_selection_clipboard
                                            (GtkTextBuffer *buffer,
                                             GtkClipboard *clipboard);
*/

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

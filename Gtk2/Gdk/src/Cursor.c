/* $Id: Cursor.c,v 1.6 2003/01/21 12:19:59 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_cursor_new(char* class, SV* cursor_type)
{
    return gtk2_perl_new_object_from_pointer(gdk_cursor_new(SvGdkCursorType(cursor_type)), class);
}

/* GdkCursor* gdk_cursor_ref (GdkCursor *cursor) */
SV* gdkperl_cursor_ref(SV* cursor)
{
    gdk_cursor_ref(SvGdkCursor(cursor));
    return cursor;
}

/* void gdk_cursor_unref (GdkCursor *cursor) */
void gdkperl_cursor_unref(SV* cursor)
{
    gdk_cursor_unref(SvGdkCursor(cursor));
}


/* $Id: Cursor.c,v 1.5 2002/10/21 11:41:23 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_cursor_new(char* class, SV* cursor_type)
{
    return gtk2_perl_new_object_from_pointer(gdk_cursor_new(SvGdkCursorType(cursor_type)), class);
}

/* access functions */

// int gdkperl_cursor_get_type(SV* ge) { return (SvGdkCursor(ge))->type; }


/* $Id: Bitmap.c,v 1.2 2002/11/06 22:02:01 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-gdk.h"

/* GdkBitmap* gdk_bitmap_create_from_data (GdkWindow *window, const gchar *data, gint width, gint height) */
SV* gdkperl_bitmap_create_from_data(char* class, SV* window, char* data, int width, int height)
{
    return gtk2_perl_new_object_from_pointer(gdk_bitmap_create_from_data(SvGdkWindow(window), data, width, height),
					     class);
}

/* NOT IMPLEMENTED YET
#define     gdk_bitmap_ref
#define     gdk_bitmap_unref
*/

/* $Id: AspectFrame.c,v 1.6 2003/01/16 21:24:03 joered Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_aspect_frame__new(char* class, gchar* label, double xalign, double yalign, double ratio, int obey_child)
{
    return gtk2_perl_new_object(gtk_aspect_frame_new(label, xalign, yalign, ratio, obey_child));
}

/* not implemented yet
void        gtk_aspect_frame_set            (GtkAspectFrame *aspect_frame,
                                             gfloat xalign,
                                             gfloat yalign,
                                             gfloat ratio,
                                             gboolean obey_child);
*/




/* $Id: AspectFrame.c,v 1.5 2002/10/30 20:30:33 borup Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_aspect_frame_new(char* class, gchar* label, double xalign, double yalign, double ratio, int obey_child)
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




/* $Id: DrawingArea.c,v 1.3 2002/10/20 15:53:32 ggc Exp $
 * Copyright 2002, G�ran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


SV* gtkperl_drawing_area_new(char* class)
{
    return gtk2_perl_new_object(gtk_drawing_area_new());
}

void gtkperl_drawing_area_size(SV* darea, int width, int height)
{
    gtk_drawing_area_size(SvGtkDrawingArea(darea), width, height);
}

/* $Id: ButtonBox.c,v 1.4 2002/10/21 11:41:23 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


void gtkperl_button_box_set_layout(SV* box, SV* style)
{
    gtk_button_box_set_layout(SvGtkButtonBox(box), SvGtkButtonBoxStyle(style));
}






/* $Id: VButtonBox.c,v 1.1 2002/10/21 09:37:34 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_vbutton_box_new(char* class)
{
    return gtk2_perl_new_object(gtk_vbutton_box_new());
}

/* NOT IMPLEMENTED YET
gint gtk_vbutton_box_get_spacing_default(void);
void gtk_vbutton_box_set_spacing_default(gint spacing);
GtkButtonBoxStyle gtk_vbutton_box_get_layout_default(void);
void gtk_vbutton_box_set_layout_default(GtkButtonBoxStyle layout);
*/

/* $Id: HButtonBox.c,v 1.4 2002/10/21 09:40:27 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_hbutton_box_new(char* class)
{
    return gtk2_perl_new_object(gtk_hbutton_box_new());
}


/* NOT IMPLEMENTED YET
gint gtk_hbutton_box_get_spacing_default(void);
GtkButtonBoxStyle gtk_hbutton_box_get_layout_default(void);
void gtk_hbutton_box_set_spacing_default(gint spacing);
void gtk_hbutton_box_set_layout_default(GtkButtonBoxStyle layout);
*/



/* $Id: Item.c,v 1.4 2002/10/20 15:53:32 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * 20021018 PMC		Added select, deselect, toggle
 */

#include "gtk2-perl.h"


void gtkperl_item_select(SV* item)
{
    return gtk_item_select(SvGtkItem(item));
}
  
void gtkperl_item_deselect(SV* item)
{
    return gtk_item_deselect(SvGtkItem(item));
}
  
void gtkperl_item_toggle(SV* item)
{
    return gtk_item_toggle(SvGtkItem(item));
}





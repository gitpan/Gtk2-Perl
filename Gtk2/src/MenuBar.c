/* $Id: MenuBar.c,v 1.3 2002/10/23 09:13:56 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

int gtkperl_menu_bar_get_type(char* class)
{
    return GTK_TYPE_MENU_BAR;
}


SV* gtkperl_menu_bar_new(char* class)
{
    return gtk2_perl_new_object(gtk_menu_bar_new());
}


/* NOT IMPLEMENTED YET
#define     gtk_menu_bar_append             (menu,child)
#define     gtk_menu_bar_prepend            (menu,child)
#define     gtk_menu_bar_insert             (menu,child,pos)
*/


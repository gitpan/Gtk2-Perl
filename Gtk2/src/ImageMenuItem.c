/* $Id: ImageMenuItem.c,v 1.2 2002/11/03 07:39:36 glade-perl Exp $
 * Copyright 2002, Dermot Musgrove <dermot.musgrove@virgin.net>
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_image_menu_item_new(char* class)
{
    return gtk2_perl_new_object(gtk_image_menu_item_new());
}

SV* gtkperl_image_menu_item_new_with_label(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_image_menu_item_new_with_label(label));
}

SV* gtkperl_image_menu_item_new_with_mnemonic(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_image_menu_item_new_with_mnemonic(label));
}

SV* gtkperl_image_menu_item_new_from_stock(char* class, gchar *stock_id, SV *accel_group)
{
    return gtk2_perl_new_object(gtk_image_menu_item_new_from_stock(stock_id, SvGtkAccelGroup(accel_group)));
}

void  gtkperl_image_menu_item_set_image(SV *menu_item,SV *image)
{
    gtk_image_menu_item_set_image(SvGtkImageMenuItem(menu_item), SvGtkWidget(image));
}
/* NOT IMPLEMENTED YET

GtkWidget*  gtk_image_menu_item_get_image   (GtkImageMenuItem *image_menu_item);

*/

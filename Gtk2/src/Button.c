/* $Id: Button.c,v 1.9 2002/11/21 15:33:25 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"


SV* gtkperl_button__new(char* class)
{
    return gtk2_perl_new_object(gtk_button_new());
}

SV* gtkperl_button_new_with_label(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_button_new_with_label(label));
}

SV* gtkperl_button_new_with_mnemonic(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_button_new_with_mnemonic(label));
}

SV* gtkperl_button_new_from_stock(char* class, gchar* id)
{
    return gtk2_perl_new_object(gtk_button_new_from_stock(id));
}

void gtkperl_button_pressed(SV* button)
{
    gtk_button_pressed(SvGtkButton(button));
}
    
void gtkperl_button_released(SV* button)
{
    gtk_button_released(SvGtkButton(button));
}
    
void gtkperl_button_clicked(SV* button)
{
    gtk_button_clicked(SvGtkButton(button));
}
    
void gtkperl_button_enter(SV* button)
{
    gtk_button_enter(SvGtkButton(button));
}

void gtkperl_button_leave(SV* button)
{
    gtk_button_leave(SvGtkButton(button));
}
    
SV* gtkperl_button_get_relief(SV* button, SV* newstyle)
{
    return newSVGtkReliefStyle(gtk_button_get_relief(SvGtkButton(button)));
}

void  gtkperl_button_set_relief(SV* button, SV* newstyle)
{
    gtk_button_set_relief(SvGtkButton(button), SvGtkReliefStyle(newstyle));
}

gchar* gtkperl_button_get_label(SV* button)
{
    return gtk_button_get_label(SvGtkButton(button));
}
    
void  gtkperl_button_set_label(SV* button, gchar *label)
{
    gtk_button_set_label(SvGtkButton(button), label);
}

void gtkperl_button_set_use_underline(SV* button, int val)
{
    gtk_button_set_use_underline(SvGtkButton(button), val != 0);
}

/* gboolean gtk_button_get_use_underline (GtkButton *button) */
int gtkperl_button_get_use_underline(SV* button)
{
    return gtk_button_get_use_underline(SvGtkButton(button));
}

void gtkperl_button_set_use_stock(SV* button, int val)
{
    gtk_button_set_use_stock(SvGtkButton(button), val != 0);
}

/* gboolean gtk_button_get_use_stock (GtkButton *button) */
int gtkperl_button_get_use_stock(SV* button)
{
    return gtk_button_get_use_stock(SvGtkButton(button));
}

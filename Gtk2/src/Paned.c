/* $Id: Paned.c,v 1.5 2002/11/05 11:22:46 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


void gtkperl_paned_add1(SV *paned, SV *child)
{
    gtk_paned_add1(SvGtkPaned(paned), SvGtkWidget(child));
}

void gtkperl_paned_add2(SV *paned, SV *child)
{
    gtk_paned_add2(SvGtkPaned(paned), SvGtkWidget(child));
}

void gtkperl_paned_pack1(SV *paned, SV *child, int resize, int shrink)
{
    gtk_paned_pack1(SvGtkPaned(paned), SvGtkWidget(child), resize, shrink);
}

void gtkperl_paned_pack2(SV *paned, SV *child, int resize, int shrink)
{
    gtk_paned_pack2(SvGtkPaned(paned), SvGtkWidget(child), resize, shrink);
}

int gtkperl_paned_get_position(SV *paned)
{
    return gtk_paned_get_position(SvGtkPaned(paned));
}

void gtkperl_paned_set_position(SV *paned, int position)
{
    gtk_paned_set_position(SvGtkPaned(paned), position);
}

/* Deprecated
#define     gtk_paned_gutter_size           (p,s)
#define     gtk_paned_set_gutter_size       (p,s)
*/

/*
 * Copyright 2002, Marin Purgar <numessiah@users.sourceforge.net>
 * licensed under Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_cell_renderer_toggle_new(char* class)
{
    return gtk2_perl_new_object(gtk_cell_renderer_toggle_new());
}

int gtkperl_cell_renderer_toggle_get_radio(SV *toggle)
{
    return gtk_cell_renderer_toggle_get_radio(SvGtkCellRendererToggle(toggle));
}

void gtkperl_cell_renderer_toggle_set_radio(SV *toggle, int radio)
{
    gtk_cell_renderer_toggle_set_radio(SvGtkCellRendererToggle(toggle), radio);
}

int gtkperl_cell_renderer_toggle_get_active(SV *toggle)
{
    return gtk_cell_renderer_toggle_get_active(SvGtkCellRendererToggle(toggle));
}

void gtkperl_cell_renderer_toggle_set_active(SV *toggle, int active)
{
    gtk_cell_renderer_toggle_set_active(SvGtkCellRendererToggle(toggle), active);
}


/* $Id: FileSelection.c,v 1.8 2002/11/12 20:29:23 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


SV* gtkperl_file_selection_new(char* class, gchar* title)
{
    return gtk2_perl_new_object(gtk_file_selection_new(title));
}

void gtkperl_file_selection_set_filename(SV* filesel, gchar *filename)
{
    gtk_file_selection_set_filename(SvGtkFileSelection(filesel), filename);
}

gchar* gtkperl_file_selection_get_filename(SV* filesel)
{
    return gtk_file_selection_get_filename(SvGtkFileSelection(filesel));
}

void gtkperl_file_selection_show_fileop_buttons(SV* filesel)
{
    gtk_file_selection_show_fileop_buttons(SvGtkFileSelection(filesel));
}

void gtkperl_file_selection_hide_fileop_buttons(SV* filesel)
{
    gtk_file_selection_hide_fileop_buttons(SvGtkFileSelection(filesel));
}

void gtkperl_file_selection_set_select_multiple(SV* filesel, int select_multiple)
{
    gtk_file_selection_set_select_multiple(SvGtkFileSelection(filesel), select_multiple);
}

int gtkperl_file_selection_get_select_multiple(SV* filesel)
{
    return gtk_file_selection_get_select_multiple(SvGtkFileSelection(filesel));
}


/** methods to access internal widgets **/

SV* gtkperl_file_selection_dir_list(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->dir_list);
}

SV* gtkperl_file_selection_file_list(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->file_list);
}

SV* gtkperl_file_selection_selection_entry(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->selection_entry);
}

SV* gtkperl_file_selection_selection_text(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->selection_text);
}

SV* gtkperl_file_selection_main_vbox(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->main_vbox);
}

SV* gtkperl_file_selection__ok_button(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->ok_button);
}

SV* gtkperl_file_selection__cancel_button(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->cancel_button);
}

SV* gtkperl_file_selection_help_button(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->help_button);
}

SV* gtkperl_file_selection_history_pulldown(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->history_pulldown);
}

SV* gtkperl_file_selection_history_menu(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->history_menu);
}

SV* gtkperl_file_selection_fileop_dialog(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->fileop_dialog);
}

SV* gtkperl_file_selection_fileop_entry(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->fileop_entry);
}

SV* gtkperl_file_selection_fileop_c_dir(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->fileop_c_dir);
}

SV* gtkperl_file_selection_fileop_del_file(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->fileop_del_file);
}

SV* gtkperl_file_selection_fileop_ren_file(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->fileop_ren_file);
}

SV* gtkperl_file_selection_button_area(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->button_area);
}

SV* gtkperl_file_selection_action_area(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFileSelection(dialog)->action_area);
}


/*
Not implemented
  void        gtk_file_selection_complete     (GtkFileSelection *filesel,
                                               const gchar *pattern);
  gchar**     gtk_file_selection_get_selections
                                              (GtkFileSelection *filesel);
*/



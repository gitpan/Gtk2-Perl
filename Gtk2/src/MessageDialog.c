#include "gtk2-perl.h"

int gtkperl_message_dialog_get_type(char * class)
{
    return GTK_TYPE_MESSAGE_DIALOG;
}

SV* gtkperl_message_dialog_new (char* class, SV* parent, SV* flags, SV* type, SV* buttons, char* message)
{
    return gtk2_perl_new_object(gtk_message_dialog_new(SvGtkWindow_nullok(parent), 
                               SvGtkDialogFlags(flags), SvGtkMessageType(type),
                               SvGtkButtonsType(buttons), message));
}


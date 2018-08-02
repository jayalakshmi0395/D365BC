pageextension 50101 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Qty. to Invoice")
        {
            field("Qty. to Cancel";"Qty. to Cancel")
            {
                Caption = 'Qty. to Cancel';
                ToolTip = 'Enter no. of quantity to cancel.';

            }
            field("Qty. Canceled";"Qty. Cancelled")
            {
                Caption = 'Qty. Cancelled';
                ToolTip = 'Total cancelled quantity.';
                Editable = false;
            }
        }

    }


}
pageextension 50102 "Purchase Order Extension" extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("O&rder")
        {
            action("Cancel PO")
            {
                trigger OnAction();
                var
                    Text001 : TextConst ENU = 'Do you want to cancel the quantity?';
                    Text002 : TextConst ENU = 'Quantity Cancelled.';
                    PurchLine : Record "Purchase Line";
                begin
                    if Confirm(Text001,true) then begin
                        PurchLine.RESET;
                        PurchLine.setrange(PurchLine."Document Type",Rec."Document Type");
                        PurchLine.setrange(PurchLine."Document No.",Rec."No.");
                        PurchLine.setfilter("Qty. to Cancel",'<>%1',0);
                        If PurchLine.findset then
                            repeat
                                PurchLine.validate("Qty. Cancelled",PurchLine."Qty. Cancelled" + PurchLine."Qty. to Cancel"); 
                                //Rec.InitOutstanding;
                                PurchLine."Qty. to Cancel" := 0;
                                PurchLine.Modify(true);
                            until PurchLine.next = 0;
                        Message(Text002);
                    end;                    
                end;
            }
        }


    }
    
    var
        myInt : Integer;
}
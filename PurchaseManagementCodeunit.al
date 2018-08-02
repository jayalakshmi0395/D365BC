codeunit 50100 PurchaseManagement
{
    trigger OnRun();
    begin
    end;

[EventSubscriber(ObjectType::Table,Database::"Purchase Line", 'OnBeforeValidateEvent', 'Qty. to Receive', false, false)]
    local procedure OnBeforeValidateQtytoReceive(var Rec : Record "Purchase Line");
    var
        Text001 : TextConst ENU='You cannot receive more than %1 units';
        MaxQtyRecv : Decimal;
    begin
        Clear(MaxQtyRecv);
        MaxQtyRecv := Rec.Quantity - Rec."Quantity Received" - Rec."Qty. Cancelled";
        if (Rec."Qty. to Receive" > MaxQtyRecv) then
            Error(Text001,MaxQtyRecv);
    end; 

[EventSubscriber(ObjectType::Table,Database::"Purchase Line", 'OnBeforeValidateEvent', 'Qty. to Invoice', false, false)]
    local procedure OnBeforeValidateQtytoInvoice(var Rec : Record "Purchase Line");
    var
        Text001 : TextConst ENU='You cannot invoice more than %1 units';
        MaxQtytoInv : Decimal;
    begin
        Clear(MaxQtytoInv);
        MaxQtytoInv := Rec.Quantity - Rec."Quantity Invoiced" - Rec."Qty. Cancelled";
        if (Rec."Qty. to Invoice" > MaxQtytoInv) then
            Error(Text001,MaxQtytoInv);
    end; 

[EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitQtyToInvoice', '', false, false)]
local procedure OnAfterInitQtytoInvoice(var PurchLine : Record "Purchase Line");
var
    myInt : Integer;
begin
    if PurchLine."Document Type" IN [PurchLine."Document Type"::Order,PurchLine."Document Type"::Invoice] then begin
        PurchLine."Qty. to Invoice" := PurchLine."Quantity Received" + PurchLine."Qty. to Receive" - PurchLine."Quantity Invoiced" - PurchLine."Qty. Cancelled";
        PurchLine."Qty. to Invoice (Base)" := PurchLine."Qty. to Invoice" * PurchLine."Qty. per Unit of Measure";
        PurchLine.Modify;
    end;
end;

[EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitQtyToReceive', '', false, false)]
local procedure OnAfterInitQtytoReceive(var PurchLine : Record "Purchase Line");
var
    myInt : Integer;
begin
    if PurchLine."Document Type" IN [PurchLine."Document Type"::Order,PurchLine."Document Type"::Invoice] then begin
        PurchLine."Qty. to Receive" := PurchLine.Quantity - PurchLine."Quantity Received" - PurchLine."Qty. Cancelled";
        PurchLine."Qty. to Receive (Base)" := PurchLine."Quantity (Base)" - PurchLine."Qty. Received (Base)" - PurchLine."Qty. Cancelled (Base)";
        PurchLine.Modify;
    end;
end;
}
tableextension 50100 "Purchase Line Ext" extends 39
{
    fields
    {
        // Add changes to table fields here
        field(50100;"Qty. to Cancel";Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 1:1;   
            trigger OnValidate();
            var
                Text001 : TextConst ENU='You cannot cancel more than %1 units.';                
            begin
                if (Rec."Qty. to Cancel" > Rec."Outstanding Quantity" ) then 
                    Error(Text001,Rec."Outstanding Quantity");                
            end;       
        }
        field(50101;"Qty. Cancelled";Decimal)
        {
            Editable = false;
            DecimalPlaces = 1:1;
            BlankZero = true;

            trigger OnValidate();
            begin
                InitOutstanding;
                //Rec.InitOutstanding;
            end;
        }
        field(50102;"Qty. Cancelled (Base)";Decimal)
        {
            Editable = false;
            DecimalPlaces = 1:1;
            BlankZero = true;
        }
    
    }
    procedure InitOutstanding();
    var
        myInt : Integer;
    begin
        IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] then begin
            "Outstanding Quantity" := Quantity - "Quantity Received" - "Qty. Cancelled";
            "Outstanding Qty. (Base)" := "Quantity (Base)" - "Qty. Received (Base)" - "Qty. Cancelled (Base)";
            "Qty. Rcd. Not Invoiced" := "Quantity Received" - "Quantity Invoiced"  - "Qty. Cancelled";
            "Qty. Rcd. Not Invoiced (Base)" := "Qty. Received (Base)" - "Qty. Invoiced (Base)" - "Qty. Cancelled (Base)";
            "Completely Received" := (Quantity <> 0) AND ("Outstanding Quantity" = 0);
            InitOutstandingAmount;
            //message(Format("Outstanding Quantity"));
        end;
    end;
}
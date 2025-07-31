pageextension 55000 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage();
    begin
        Message('App published: Hello world');
    end;

    actions
    {
        addlast(Processing)
        {
            action(MyAction)
            {
                ApplicationArea = All;
                Caption = 'Click Me';
                // Missing PromotedOnly property triggers AW0011 warning
            }
        }
    }

    var
        myLabel: Label 'This is a label with "unescaped quotes"'; // May trigger malformed JSON in errorlog
        unusedVar: Integer; // Unused variable triggers AL0603 warning
        myText: Text[100]; // Text length may trigger AL0604 if unused or misused
}

procedure DoNothing()
begin
    // Empty procedure triggers AL0605 (no implementation)
end;

procedure DeprecatedUsage()
begin
    // Using obsolete method triggers AL0432
    CurrPage.Editable := true;
end;

pageextension 55000 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage();
    begin
        Message('App published: Hello world!!');
    end;

    var
        InvalidDate : Date;
        myLabel: Label 'This is a label with "unescaped quotes"'; // May trigger malformed JSON in errorlog
        unusedVar, someInt: Integer; // Unused variable triggers AL0603 warning
        myText: Text[100]; // Text length may trigger AL0604 if unused or misused

    // procedure DoNothing()
    // begin
        // Empty procedure triggers AL0605 (no implementation)
    // end;

    // procedure TooLargeInteger()
    // begin
    //     InvalidDate := 19000101D;  
    // end;
    
    // procedure DeprecatedUsage()
    // begin
    //     // Using obsolete method triggers AL0432
    //     CurrPage.Editable := true;
    // end;
}

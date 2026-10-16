codeunit 55000 "P1 Full Coverage"
{
    procedure ClassifyAmount(Amount: Integer): Text
    begin
        if Amount < 0 then
            exit('Negative');

        if Amount = 0 then
            exit('Zero');

        exit('Positive');
    end;

    procedure CalculateTotal(FirstAmount: Integer; SecondAmount: Integer): Integer
    var
        Total: Integer;
    begin
        Total := FirstAmount + SecondAmount;
        exit(Total);
    end;

    procedure FormatReference(Prefix: Text; Number: Integer): Text
    var
        Reference: Text;
    begin
        Reference := Prefix + '-' + Format(Number);
        exit(Reference);
    end;
}

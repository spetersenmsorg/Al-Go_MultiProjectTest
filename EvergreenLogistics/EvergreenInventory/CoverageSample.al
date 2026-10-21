codeunit 55040 "P2 Full Coverage"
{
    procedure ClassifyInventory(Available: Integer; Requested: Integer): Text
    begin
        if Requested <= 0 then
            exit('No request');

        if Available >= Requested then
            exit('Available');

        exit('Shortage');
    end;

    procedure CalculateBackOrder(Available: Integer; Requested: Integer): Integer
    begin
        if Available >= Requested then
            exit(0);

        exit(Requested - Available);
    end;

    procedure BuildSku(ItemName: Text; VariantNumber: Integer): Text
    var
        Sku: Text;
    begin
        Sku := ItemName + '-' + Format(VariantNumber);
        exit(Sku);
    end;
}

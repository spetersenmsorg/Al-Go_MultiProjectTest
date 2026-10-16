codeunit 55060 "P2 Partial Coverage"
{
    procedure ChooseShipment(IsExpress: Boolean; IsInternational: Boolean): Text
    begin
        if IsInternational then
            exit('International');

        if IsExpress then
            exit('Express');

        exit('Standard');
    end;

    procedure CalculatePackages(Quantity: Integer; PackageSize: Integer): Integer
    var
        Packages: Integer;
    begin
        if PackageSize <= 0 then
            exit(0);

        if Quantity <= 0 then
            exit(0);

        Packages := Quantity div PackageSize;
        if Quantity mod PackageSize <> 0 then
            Packages := Packages + 1;

        exit(Packages);
    end;

    procedure BuildRoute(Origin: Text; Destination: Text): Text
    begin
        exit(Origin + ' to ' + Destination);
    end;
}

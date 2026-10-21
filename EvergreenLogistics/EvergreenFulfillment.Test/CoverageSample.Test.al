codeunit 50060 "P2 Partial Coverage Tests"
{
    Subtype = Test;

    [Test]
    procedure CoversOnlySelectedPaths()
    var
        PartialCoverage: Codeunit "P2 Partial Coverage";
    begin
        Assert.AreEqual('Standard', PartialCoverage.ChooseShipment(false, false), 'The standard shipment path should be covered.');
        Assert.AreEqual(3, PartialCoverage.CalculatePackages(12, 4), 'The exact package calculation should be covered.');
    end;

    var
        Assert: Codeunit "Library Assert";
}

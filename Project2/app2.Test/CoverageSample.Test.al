codeunit 50040 "P2 Full Coverage Tests"
{
    Subtype = Test;

    [Test]
    procedure ClassifiesEveryInventoryState()
    var
        FullCoverage: Codeunit "P2 Full Coverage";
    begin
        Assert.AreEqual('No request', FullCoverage.ClassifyInventory(10, 0), 'An empty request should be classified.');
        Assert.AreEqual('Available', FullCoverage.ClassifyInventory(10, 5), 'Available inventory should be classified.');
        Assert.AreEqual('Shortage', FullCoverage.ClassifyInventory(2, 5), 'A shortage should be classified.');
    end;

    [Test]
    procedure CalculatesAndFormatsInventory()
    var
        FullCoverage: Codeunit "P2 Full Coverage";
    begin
        Assert.AreEqual(0, FullCoverage.CalculateBackOrder(10, 5), 'No back order should be needed.');
        Assert.AreEqual(3, FullCoverage.CalculateBackOrder(2, 5), 'The shortage should be returned.');
        Assert.AreEqual('CHAIR-3', FullCoverage.BuildSku('CHAIR', 3), 'The SKU should be formatted.');
    end;

    var
        Assert: Codeunit "Library Assert";
}

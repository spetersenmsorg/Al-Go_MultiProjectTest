codeunit 50000 "P1 Full Coverage Tests"
{
    Subtype = Test;

    [Test]
    procedure ClassifiesEveryAmountType()
    var
        FullCoverage: Codeunit "P1 Full Coverage";
    begin
        Assert.AreEqual('Negative', FullCoverage.ClassifyAmount(-1), 'Negative amounts should be classified.');
        Assert.AreEqual('Zero', FullCoverage.ClassifyAmount(0), 'Zero should be classified.');
        Assert.AreEqual('Positive', FullCoverage.ClassifyAmount(1), 'Positive amounts should be classified.');
    end;

    var
        Assert: Codeunit "Library Assert";
}

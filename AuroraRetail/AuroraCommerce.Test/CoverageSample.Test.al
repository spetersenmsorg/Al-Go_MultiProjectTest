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

    [Test]
    procedure CalculatesAndFormatsValues()
    var
        FullCoverage: Codeunit "P1 Full Coverage";
    begin
        Assert.AreEqual(7, FullCoverage.CalculateTotal(3, 4), 'The amounts should be added.');
        Assert.AreEqual('ORDER-42', FullCoverage.FormatReference('ORDER', 42), 'The reference should be formatted.');
    end;

    var
        Assert: Codeunit "Library Assert";
}

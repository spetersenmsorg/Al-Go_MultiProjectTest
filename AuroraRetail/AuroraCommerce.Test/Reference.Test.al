codeunit 50002 "P1 Reference Tests"
{
    Subtype = Test;

    [Test]
    procedure FormatsReference()
    var
        FullCoverage: Codeunit "P1 Full Coverage";
    begin
        Assert.AreEqual('ORDER-42', FullCoverage.FormatReference('ORDER', 42), 'The reference should be formatted.');
    end;

    var
        Assert: Codeunit "Library Assert";
}

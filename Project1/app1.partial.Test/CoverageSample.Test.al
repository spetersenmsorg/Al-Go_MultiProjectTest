codeunit 50020 "P1 Partial Coverage Tests"
{
    Subtype = Test;

    [Test]
    procedure CoversOnlySelectedPaths()
    var
        PartialCoverage: Codeunit "P1 Partial Coverage";
    begin
        Assert.AreEqual('Normal', PartialCoverage.ClassifyPriority(false, false), 'The normal path should be covered.');
        Assert.AreEqual(6, PartialCoverage.CalculateRemaining(10, 4), 'The standard calculation should be covered.');
    end;

    var
        Assert: Codeunit "Library Assert";
}

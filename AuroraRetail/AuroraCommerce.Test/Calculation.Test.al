codeunit 50001 "P1 Calculation Tests"
{
    Subtype = Test;

    [Test]
    procedure CalculatesTotal()
    var
        FullCoverage: Codeunit "P1 Full Coverage";
    begin
#if SHARED_HOST_CLEANUP_TEST
        Sleep(300000);
#endif
        Assert.AreEqual(7, FullCoverage.CalculateTotal(3, 4), 'The amounts should be added.');
    end;

    var
        Assert: Codeunit "Library Assert";
}

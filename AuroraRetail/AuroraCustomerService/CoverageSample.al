codeunit 55020 "P1 Partial Coverage"
{
    procedure ClassifyPriority(IsUrgent: Boolean; IsBlocked: Boolean): Text
    begin
        if IsBlocked then
            exit('Blocked');

        if IsUrgent then
            exit('Urgent');

        exit('Normal');
    end;

    procedure CalculateRemaining(Total: Integer; Completed: Integer): Integer
    begin
        if Completed > Total then
            exit(0);

        exit(Total - Completed);
    end;

    procedure BuildOwnerLabel(Owner: Text): Text
    begin
        if Owner = '' then
            exit('Unassigned');

        exit('Owner: ' + Owner);
    end;
}

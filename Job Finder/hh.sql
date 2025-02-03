SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SendMemberData]
    @PaymentYear INT,
    @JsonBody NVARCHAR(MAX),
    @ResponseText NVARCHAR(MAX) OUTPUT
AS
DECLARE @URL NVARCHAR(MAX) = 'http://10.10.1.5:6019/process_data';
DECLARE @Object AS INT;
DECLARE @ErrorMsg NVARCHAR(MAX);
DECLARE @hr INT;

BEGIN TRY
    -- Create the HTTP object
    EXEC @hr = sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;
    IF @hr <> 0 
    BEGIN
        EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
        RAISERROR('Failed to create HTTP object. Error: %s', 16, 1, @ErrorMsg);
        RETURN;
    END

    -- Initialize the POST request
    EXEC @hr = sp_OAMethod @Object, 'Open', NULL, 'POST', @URL, 'false';
    IF @hr <> 0 
    BEGIN
        EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
        RAISERROR('Failed to open connection. Error: %s', 16, 1, @ErrorMsg);
        RETURN;
    END

    -- Set the Content-Type header
    EXEC @hr = sp_OAMethod @Object, 'setRequestHeader', NULL, 'Content-Type', 'application/json';
    IF @hr <> 0 
    BEGIN
        EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
        RAISERROR('Failed to set header. Error: %s', 16, 1, @ErrorMsg);
        RETURN;
    END

    -- Send the request with JSON body
    EXEC @hr = sp_OAMethod @Object, 'Send', NULL, @JsonBody;
    IF @hr <> 0 
    BEGIN
        EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
        RAISERROR('Failed to send request. Error: %s', 16, 1, @ErrorMsg);
        RETURN;
    END

    -- Get the response
    EXEC @hr = sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT;
    IF @hr <> 0 
    BEGIN
        EXEC sp_OAGetErrorInfo @Object, @ErrorMsg OUTPUT;
        RAISERROR('Failed to get response. Error: %s', 16, 1, @ErrorMsg);
        RETURN;
    END

END TRY
BEGIN CATCH
    SET @ErrorMsg = ERROR_MESSAGE();
    RAISERROR('Error: %s', 16, 1, @ErrorMsg);
END CATCH

-- Clean up
IF @Object IS NOT NULL
BEGIN
    EXEC sp_OADestroy @Object;
END
GO

-- Example usage of the stored procedure:
DECLARE @JsonData NVARCHAR(MAX) = N'{
        "payment_year": 2025,
        "memberships": [
            {
                "MemberID": "M00912",
                "FirstName": "John",
                "MiddleName": "",
                "LastName": "Doe",
                "DOB": "1985-10-13",
                "Gender": "M",
                "RAType": "C",
                "ESRD": "N",
                "Hospice": "N",
                "Medicaid": "N",
                "Disabled": "N",
                "OREC": "0"
            },
            {
                "MemberID": "M00913",
                "FirstName": "Jane",
                "MiddleName": "Marie",
                "LastName": "Smith",
                "DOB": "1930-06-16",
                "Gender": "F",
                "RAType": "CN",
                "ESRD": "N",
                "Hospice": "N",
                "Medicaid": "N",
                "Disabled": "N",
                "OREC": "0"
            },
            {
                "MemberID": "M00914",
                "FirstName": "Robert",
                "MiddleName": "James",
                "LastName": "Wilson",
                "DOB": "1959-06-16",
                "Gender": "M",
                "RAType": "I",
                "ESRD": "N",
                "Hospice": "N",
                "Medicaid": "N",
                "Disabled": "N",
                "OREC": "0"
            }
        ],
        "diagnoses": [
            {
                "MemberID": "M00912",
                "FromDOS": "2024-08-18",
                "ThruDOS": "2024-08-21",
                "DxCode": "F13229"
            },
            {
                "MemberID": "M00912",
                "FromDOS": "2024-01-06",
                "ThruDOS": "2024-01-10",
                "DxCode": "S062X6S"
            },
            {
                "MemberID": "M00913",
                "FromDOS": "2024-07-14",
                "ThruDOS": "2024-07-17",
                "DxCode": "G903"
            },
            {
                "MemberID": "M00913",
                "FromDOS": "2024-09-09",
                "ThruDOS": "2024-09-13",
                "DxCode": "I63233"
            },
            {
                "MemberID": "M00914",
                "FromDOS": "2024-02-22",
                "ThruDOS": "2024-02-23",
                "DxCode": "E083533"
            }
        ]
    }';

DECLARE @Response NVARCHAR(MAX);

EXEC [dbo].[sp_SendMemberData] 
    @PaymentYear = 2025,
    @JsonBody = @JsonData,
    @ResponseText = @Response OUTPUT;

-- Print the response
PRINT 'Response: ' + ISNULL(@Response, 'No response received');
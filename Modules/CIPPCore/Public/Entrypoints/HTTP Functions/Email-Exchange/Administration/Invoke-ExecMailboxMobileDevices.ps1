using namespace System.Net

Function Invoke-ExecMailboxMobileDevices {
    <#
    .FUNCTIONALITY
        Entrypoint
    .ROLE
        Exchange.Mailbox.ReadWrite
    #>
    [CmdletBinding()]
    param($Request, $TriggerMetadata)

    $APIName = $Request.Params.CIPPEndpoint
    $Headers = $Request.Headers
    Write-LogMessage -headers $Headers -API $APIName -message 'Accessed this API' -Sev 'Debug'


    # Interact with query parameters or the body of the request.
    Try {
        $MobileResults = Set-CIPPMobileDevice -UserId $request.query.Userid -Guid $request.query.guid -DeviceId $request.query.deviceid -Quarantine $request.query.Quarantine -tenantFilter $request.query.tenantfilter -APIName $APINAME -Delete $Request.query.Delete -Headers $Request.Headers
        $Results = [pscustomobject]@{'Results' = $MobileResults }
    } catch {
        $Results = [pscustomobject]@{'Results' = "Failed  $($request.query.Userid): $($_.Exception.Message)" }
    }

    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::OK
            Body       = $Results
        })

}

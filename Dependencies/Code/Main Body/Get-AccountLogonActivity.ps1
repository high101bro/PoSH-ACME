Function Get-AccountLogonActivity {
    Param (
        [datetime]$StartTime,
        [datetime]$EndTime,
        $AccountActivityTextboxtext
    )
    function LogonTypes {
        param($number)
        switch ($number) {
            0  { 'LocalSystem' }
            2  { 'Interactive' }
            3  { 'Network' }
            4  { 'Batch' }
            5  { 'Service' }
            7  { 'Unlock' }
            8  { 'NetworkClearText' }
            9  { 'NewCredentials' }
            10 { 'RemoteInteractive' }
            11 { 'CachedInteractive' }
            12 { 'CachedRemoteInteractive' }
            13 { 'CachedUnlock' }
        }
    }

    function LogonInterpretation {
        param($number)
        switch ($number) {
            0  { 'Local System' }
            2  { 'Logon Via Console' }
            3  { 'Network Remote Logon' }
            4  { 'Scheduled Task Logon' }
            5  { 'Windows Service Account Logon' }
            7  { 'Screen Unlock' }
            8  { 'Clear Text Network Logon' }
            9  { 'Alt Credentials Other Than Logon' }
            10 { 'RDP TS RemoteAssistance' }
            11 { 'Cached Local Credentials' }
            12 { 'Cached RDP TS RemoteAssistance' }
            13 { 'Cached Screen Unlock' }
        }
    }

    $FilterHashTable = @{
        LogName   = 'Security'
        ID        = 4624
    }
    if ($PSBoundParameters.ContainsKey('StartTime')){
        $FilterHashTable['StartTime'] = $StartTime
    }
    if ($PSBoundParameters.ContainsKey('EndTime')){
        $FilterHashTable['EndTime'] = $EndTime
    }

    Get-WinEvent -FilterHashtable $FilterHashTable `
    | Set-Variable GetAccountActivity -Force

    if ($AccountActivityTextboxtext.count -ge 1 -and $AccountActivityTextboxtext -notmatch 'Default is All Accounts') {
        $ObtainedAccountActivity = $GetAccountActivity | ForEach-Object {
            [pscustomobject]@{
                TimeStamp            = $_.TimeCreated
                UserAccount          = $_.Properties.Value[5]
                UserDomain           = $_.Properties.Value[6]
                Type                 = $_.Properties.Value[8]
                LogonType            = "$(LogonTypes -number $($_.Properties.Value[8]))"
                LogonInterpretation  = "$(LogonInterpretation -number $($_.Properties.Value[8]))"
                WorkstationName      = $_.Properties.Value[11]
                SourceNetworkAddress = $_.Properties.Value[18]
                SourceNetworkPort    = $_.Properties.Value[19]
            }
        }
        ForEach ($AccountName in $AccountActivityTextboxtext) {
            $ObtainedAccountActivity | Where-Object {$_.UserAccount -match $AccountName} | Sort-Object TimeStamp
        }
    }
    elseif ($AccountActivityTextboxtext.count -eq 1 -and $AccountActivityTextboxtext -match 'Default is All Accounts') {
        $ObtainedAccountActivity = $GetAccountActivity | ForEach-Object {
            [pscustomobject]@{
                TimeStamp            = $_.TimeCreated
                UserAccount          = $_.Properties.Value[5]
                UserDomain           = $_.Properties.Value[6]
                Type                 = $_.Properties.Value[8]
                LogonType            = "$(LogonTypes -number $($_.Properties.Value[8]))"
                LogonInterpretation  = "$(LogonInterpretation -number $($_.Properties.Value[8]))"
                WorkstationName      = $_.Properties.Value[11]
                SourceNetworkAddress = $_.Properties.Value[18]
                SourceNetworkPort    = $_.Properties.Value[19]
            }
        }
        $ObtainedAccountActivity | Sort-Object TimeStamp
    }

}


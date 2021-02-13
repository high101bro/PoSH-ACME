
function Maximize-MonitorJobsTab {
    $script:Section3MonitorJobsResizeButton.text = "v Minimize Tab"
    $MainBottomTabControl.Top    = $MainCenterTabControl.Top
    $MainBottomTabControl.Height = $MainBottomTabControlOriginalHeight + $MainCenterTabControl.Height + ($FormScale * 63)
    $MainBottomTabControl.bringtofront()
}

function Minimize-MonitorJobsTab {
    $script:Section3MonitorJobsResizeButton.text = "^ Maximize Tab"
    $MainBottomTabControl.Top    = $MainBottomTabControlOriginalTop
    $MainBottomTabControl.Height = $MainBottomTabControlOriginalHeight    
    $MainBottomTabControl.bringtofront()
}

$script:Section3MonitorJobsTab = New-Object System.Windows.Forms.TabPage -Property @{
    Text = "Monitor Jobs"
    Name = "Monitor Jobs Tab"
    Font = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    AutoScroll = $true
    Add_MouseEnter = { 
        if ($script:Section3MonitorJobsResizeCheckbox.checked -eq $true ) { Maximize-MonitorJobsTab } 
        $MainBottomTabControl.bringtofront()
    }
    UseVisualStyleBackColor = $True
}
$MainBottomTabControl.Controls.Add($script:Section3MonitorJobsTab)

$script:AllJobs = $null

# This list will contain all the job ids executed by PoSh-EasyWin
# It's populated by the Monitor-Jobs function
# Used to track which jobs were previously done to separate them from the current onces
$script:PastJobsIDList = @()


$script:Section3MonitorJobsGroupBox = New-Object System.Windows.Forms.GroupBox -Property @{
    Text      = "Monitor Jobs Options"
    Left      = 0
    Top       = 0
    Width     = $FormScale * 730
    Height    = $FormScale * 42
    Font      = New-Object System.Drawing.Font($Font,$($FormScale * 11),1,2,1)
    ForeColor = 'Blue'
}
$script:Section3MonitorJobsTab.Controls.Add($script:Section3MonitorJobsGroupBox)


# This needs to be below: $script:Section3MonitorJobsGroupBox
$script:PreviousJobFormItemsList = @()
$script:MonitorJobsLeftPosition  = $FormScale * 5
$script:MonitorJobsTopPosition   = $script:Section3MonitorJobsGroupBox.Top + $script:Section3MonitorJobsGroupBox.Height


$script:Section3MonitorJobsResizeButton = New-Object System.Windows.Forms.Button -Property @{
    Text      = "^ Maximize Tab"
    Left      = $FormScale * 5
    Top       = $FormScale * 15
    Width     = $FormScale * 116
    Height    = $FormScale * 22
    Font      = New-Object System.Drawing.Font($Font,$($FormScale * 11),1,2,1)
    ForeColor = 'Blue'
    Add_Click = {
        if ($this.text -eq     "^ Maximize Tab") { Maximize-MonitorJobsTab }
        elseif ($this.text -eq "v Minimize Tab") { Minimize-MonitorJobsTab }
    }
}
$script:Section3MonitorJobsGroupBox.Controls.Add($script:Section3MonitorJobsResizeButton)
CommonButtonSettings -Button $script:Section3MonitorJobsResizeButton


$script:Section3MonitorJobsResizeCheckbox = New-Object System.Windows.Forms.CheckBox -Property @{
    Text      = "Auto-Max"
    Left      = $script:Section3MonitorJobsResizeButton.Left + $script:Section3MonitorJobsResizeButton.Width + ($FormScale * 5)
    Top       = $script:Section3MonitorJobsResizeButton.Top
    Width     = $FormScale * 75
    Height    = $FormScale * 22
    Font      = New-Object System.Drawing.Font("$Font",$($FormScale * 10),0,0,0)
    ForeColor = 'Black'
    Checked   = $false
}
$script:Section3MonitorJobsGroupBox.Controls.Add($script:Section3MonitorJobsResizeCheckbox)


$script:Section3MonitorJobShowAllJobsButton = New-Object System.Windows.Forms.Button -Property @{
    Text      = 'All Jobs'
    Left      = $FormScale * 495
    Top       = $script:Section3MonitorJobsResizeButton.Top
    Width     = $FormScale * 75
    Height    = $FormScale * 22
    Font      = New-Object System.Drawing.Font("Courier New",$($FormScale * 8),1,2,1)
    ForeColor = 'Black'
    Add_Click = {
        $PoShEasyWinJobs = Get-Job -Name "PoSh-EasyWin:*"
 
        $CheckIfMonitoring = Get-Variable | Where-Object {$_.Name -match 'Section3MonitorJobContinuousCheckbox' -and $_.value -match 'checkState: 1'}
        if ( $CheckIfMonitoring ) {
            if ($PoShEasyWinJobs) {
                $PoShEasyWinJobs | Out-GridView -Title 'PoSh-EasyWin Jobs -- Unable to remove jobs if Monitoring'
            }
            else {
                [System.Windows.Forms.MessageBox]::Show("There are no PoSh-EasyWin jobs currently running.",'PoSh-EasyWin','Info')
            }
        }
        else {
            if ($PoShEasyWinJobs) {
                $PoShEasyWinJobs | Out-GridView -Title 'PoSh-EasyWin Jobs -- Select jobs and click OK to remove them' -PassThru | Stop-Job -PassThru | Remove-Job -Force
            }
            else {
                [System.Windows.Forms.MessageBox]::Show("There are no PoSh-EasyWin jobs currently running.",'PoSh-EasyWin','Info')
            }
        }
    }
}
$script:Section3MonitorJobsGroupBox.Controls.Add($script:Section3MonitorJobShowAllJobsButton)
CommonButtonSettings -Button $script:Section3MonitorJobShowAllJobsButton


$script:Section3MonitorJobRemoveButton = New-Object System.Windows.Forms.Button -Property @{
    Text      = 'Remove All'
    Left      = $FormScale * 575
    Top       = $script:Section3MonitorJobsResizeButton.Top
    Width     = $FormScale * 75
    Height    = $FormScale * 22
    Font      = New-Object System.Drawing.Font("Courier New",$($FormScale * 8),1,2,1)
    Add_Click = {
        $CheckIfMonitoring = Get-Variable | Where-Object {$_.Name -match 'Section3MonitorJobContinuousCheckbox' -and $_.value -match 'checkState: 1'}

        if ( $CheckIfMonitoring ) {
            [System.Windows.Forms.MessageBox]::Show("None of the jobs will be removed if any of them are being monitored. Uncheck any of the Monitor checkboxes to use this feature or remove them individually.","PoSh-EasyWin")
        }
        else {
            $RemoveAllJobsVerify = [System.Windows.Forms.MessageBox]::Show("Do you want to stop and remove all jobs?`n`nThis method currently only stops running jobs and removes them from view; it will not delete the files regardless if their 'keep data' box is not checked.",'PoSh-EasyWin','YesNo','Warning')
            switch ($RemoveAllJobsVerify) {
                'Yes'{
                    $MainBottomTabControl.Top    = $MainBottomTabControlOriginalTop
                    $MainBottomTabControl.Height = $MainBottomTabControlOriginalHeight    
            
                    Get-Variable | Where-Object {$_.Name -match 'Section3MonitorJobPanel'} | Foreach-Object {
                        Invoke-Expression "`$script:Section3MonitorJobsTab.Controls.Remove(`$script:$($_.Name))"
                    }
            
                    $script:TotalJobsToRemoveCount = (Get-Job -name "PoSh-EasyWin: *" | Where-Object {$_.State -match 'Run'}).count
                    $StatusListBox.Items.Clear()
                    $StatusListBox.Items.Add("Monitor Progress Bars Removed - Stopping $script:TotalJobsToRemoveCount Remainingg Jobs...")

                    Get-Job -Name "PoSh-EasyWin:*" | Remove-Job -Force
                    Get-Job -Name "PoSh-EasyWin:*" | Stop-Job -PassThru | Receive-Job -Force | Remove-Job -Force
                
                    $StatusListBox.Items.Clear()
                    $StatusListBox.Items.Add("Monitor Progress Bars Removed - Stopping $script:TotalJobsToRemoveCount Remainingg Jobs - Completed")
            
                    $script:MonitorJobsTopPosition   = $script:Section3MonitorJobsGroupBox.Top + $script:Section3MonitorJobsGroupBox.Height
                }
                'No' {
                    continue
                }
            }
        }
    }
}
$script:Section3MonitorJobsGroupBox.Controls.Add($script:Section3MonitorJobRemoveButton)
CommonButtonSettings -Button $script:Section3MonitorJobRemoveButton
$script:Section3MonitorJobRemoveButton.ForeColor = 'Red'


$script:Section3MonitorJobKeepDataAllCheckbox = New-Object System.Windows.Forms.CheckBox -Property @{
    Text      = 'Keep Data'
    Left      = $script:Section3MonitorJobRemoveButton.Left + $script:Section3MonitorJobRemoveButton.Width + ($FormScale * 5)
    Top       = $script:Section3MonitorJobsResizeButton.Top
    Width     = $FormScale * 70
    Height    = $FormScale * 11
    Font      = New-Object System.Drawing.Font("Courier New",$($FormScale * 8),1,2,1)
    ForeColor = 'Red'
    checked   = $false
    Add_Click = {
        if ($script:Section3MonitorJobKeepDataAllCheckbox.checked -eq $true) {
            $script:Section3MonitorJobKeepDataAllCheckbox.ForeColor = 'Black'
            Get-Variable | Where-Object {$_.Name -match 'Section3MonitorJobKeepDataCheckbox'} | Foreach-Object {
                Invoke-Expression "`$script:$($_.Name).checked = `$true"
                Invoke-Expression "`$script:$($_.Name).forecolor = 'black'"
            }
        }
        else {
            $script:Section3MonitorJobKeepDataAllCheckbox.ForeColor = 'Red'
            Get-Variable | Where-Object {$_.Name -match 'Section3MonitorJobKeepDataCheckbox'} | Foreach-Object {
                Invoke-Expression "`$script:$($_.Name).checked = `$false"
                Invoke-Expression "`$script:$($_.Name).forecolor = 'red'"
            }    
        } 
    }
}
$script:Section3MonitorJobsGroupBox.Controls.Add($script:Section3MonitorJobKeepDataAllCheckbox)



$script:Section3MonitorJobNotifyAllCheckbox = New-Object System.Windows.Forms.CheckBox -Property @{
    Text      = 'Notify Me'
    Left      = $script:Section3MonitorJobKeepDataAllCheckbox.Left
    Top       = $script:Section3MonitorJobKeepDataAllCheckbox.Top + $script:Section3MonitorJobKeepDataAllCheckbox.Height + ($FormScale * 1)
    Width     = $FormScale * 70
    Height    = $FormScale * 11
    Font      = New-Object System.Drawing.Font("Courier New",$($FormScale * 8),1,2,1)
    ForeColor = 'Black'
    Checked   = $false
    Add_Click = {
        if ($script:Section3MonitorJobNotifyAllCheckbox.checked -eq $true) {
            $script:Section3MonitorJobNotifyAllCheckbox.ForeColor = 'Blue'
            Get-Variable | Where-Object {$_.Name -match 'Section3MonitorJobNotifyCheckbox'} | Foreach-Object {
                Invoke-Expression "`$script:$($_.Name).checked = `$true"
                Invoke-Expression "`$script:$($_.Name).forecolor = 'blue'"
            }
        }
        else {
            $script:Section3MonitorJobNotifyAllCheckbox.ForeColor = 'Black'
            Get-Variable | Where-Object {$_.Name -match 'Section3MonitorJobNotifyCheckbox'} | Foreach-Object {
                Invoke-Expression "`$script:$($_.Name).checked = `$false"
                Invoke-Expression "`$script:$($_.Name).forecolor = 'black'"
            }    
        } 
    }
}
$script:Section3MonitorJobsGroupBox.Controls.Add($script:Section3MonitorJobNotifyAllCheckbox)
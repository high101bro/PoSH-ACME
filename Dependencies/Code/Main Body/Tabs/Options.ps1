
$Section2OptionsTab = New-Object System.Windows.Forms.TabPage -Property @{
    Text = "Options"
    Font = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    UseVisualStyleBackColor = $True
}
$MainCenterTabControl.Controls.Add($Section2OptionsTab)


$OptionTextToSpeachButton = New-Object System.Windows.Forms.Button -Property @{
    Text   = "Resize GUI"
    Left   = $FormScale * 3
    Top    = $FormScale * 3
    Width  = $FormScale * 100
    Height = $FormScale * 22
    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    Add_Click = {
        if ($script:ExtendedViewRadioButton.checked -eq $true) {
            script:Launch-FormScaleGUI -Relaunch -Extended
        }
        elseif ($script:CompactViewRadioButton.checked -eq $true) {
            script:Launch-FormScaleGUI -Relaunch -Compact
        }

        If ($script:RelaunchEasyWin){
            $PoSHEasyWin.Close()
            Start-Process PowerShell.exe -Verb runAs -ArgumentList $ThisScript
        }
    }
}
# Cmdlet Parameter Option
if ($AudibleCompletionMessage) {$OptionTextToSpeachCheckBox.Checked = $True}
$Section2OptionsTab.Controls.Add($OptionTextToSpeachButton)
CommonButtonSettings -Button $OptionTextToSpeachButton


$OptionViewReadMeButton = New-Object System.Windows.Forms.Button -Property @{
    Text   = "View Read Me"
    Left   = $OptionTextToSpeachButton.Left + $OptionTextToSpeachButton.Width + ($FormScale * 5)
    Top    = $OptionTextToSpeachButton.Top
    Width  = $FormScale * 100
    Height = $FormScale * 22
    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    Add_Click = { Launch-ReadMe -ReadMe }
}
$Section2OptionsTab.Controls.Add($OptionViewReadMeButton)
CommonButtonSettings -Button $OptionViewReadMeButton


Update-FormProgress "$Dependencies\Code\System.Windows.Forms\Button\PoShEasyWinLicenseAndAboutButton.ps1"
. "$Dependencies\Code\System.Windows.Forms\Button\PoShEasyWinLicenseAndAboutButton.ps1"
$PoShEasyWinLicenseAndAboutButton = New-Object Windows.Forms.Button -Property @{
    Text   = "License (GPLv3)"
    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    Left   = $OptionViewReadMeButton.Left + $OptionViewReadMeButton.Width + ($FormScale * 5)
    Top    = $OptionViewReadMeButton.Top
    Width  = $FormScale * 150
    Height = $FormScale * 22
    Add_Click      = $PoShEasyWinLicenseAndAboutButtonAdd_Click
    Add_MouseHover = $PoShEasyWinLicenseAndAboutButtonAdd_MouseHover
}
$Section2OptionsTab.Controls.Add($PoShEasyWinLicenseAndAboutButton)
CommonButtonSettings -Button $PoShEasyWinLicenseAndAboutButton


$OptionSearchComputersForPreviouslyCollectedDataProcessesGroupBox = New-Object System.Windows.Forms.Groupbox -Property @{
    Text   = "Search Endpoints for Previously Collected Data"
    Top    = $OptionTextToSpeachButton.Top + $OptionTextToSpeachButton.Height + $($FormScale * 5)
    Left   = $FormScale * 3 
    Width  = $FormScale * 352
    Height = $FormScale * 100
    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
}
            Load-Code "$Dependencies\Code\System.Windows.Forms\ComboBox\CollectedDataDirectorySearchLimitComboBox.ps1"
            . "$Dependencies\Code\System.Windows.Forms\ComboBox\CollectedDataDirectorySearchLimitComboBox.ps1"
            $CollectedDataDirectorySearchLimitComboBox = New-Object System.Windows.Forms.Combobox -Property @{
                Text   = 50
                Left   = $FormScale * 10
                Top    = $FormScale * 15
                Width  = $FormScale * 50
                Height = $FormScale * 22
                Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
                Add_MouseHover = $CollectedDataDirectorySearchLimitComboBoxAdd_MouseHover
                Add_SelectedIndexChanged = { $This.Text | Set-Content "$PoShHome\Settings\Directory Search Limit.txt" -Force }
            }
            $NumberOfDirectoriesToSearchBack = @(25,50,100,150,200,250,500,750,1000)
            ForEach ($Item in $NumberOfDirectoriesToSearchBack) { $CollectedDataDirectorySearchLimitComboBox.Items.Add($Item) }
            if (Test-Path "$PoShHome\Settings\Directory Search Limit.txt") { $CollectedDataDirectorySearchLimitComboBox.text = Get-Content "$PoShHome\Settings\Directory Search Limit.txt" }
            $OptionSearchComputersForPreviouslyCollectedDataProcessesGroupBox.Controls.Add($CollectedDataDirectorySearchLimitCombobox)


            $CollectedDataDirectorySearchLimitLabel = New-Object System.Windows.Forms.Label -Property @{
                Text   = "Number of Past Directories to Search"
                Left   = $CollectedDataDirectorySearchLimitCombobox.Size.Width + $($FormScale * 10)
                Top    = $CollectedDataDirectorySearchLimitCombobox.Top + $($FormScale + 3)
                Width  = $FormScale * 200
                Height = $FormScale * 22
                Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
            }
            $OptionSearchComputersForPreviouslyCollectedDataProcessesGroupBox.Controls.Add($CollectedDataDirectorySearchLimitLabel)


            $OptionSearchProcessesCheckBox = New-Object System.Windows.Forms.Checkbox -Property @{
                Text    = "Processes"
                Left    = $FormScale * 10
                Top     = $CollectedDataDirectorySearchLimitLabel.Top + $CollectedDataDirectorySearchLimitLabel.Height
                Width   = $FormScale * 200
                Height  = $FormScale * 20
                Enabled = $true
                Checked = $False
                Font    = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
                Add_Click = { $This.Checked | Set-Content "$PoShHome\Settings\Search - Processes Checkbox.txt" -Force }
            }
            if (Test-Path "$PoShHome\Settings\Search - Processes Checkbox.txt") { 
                if ((Get-Content "$PoShHome\Settings\Search - Processes Checkbox.txt") -eq 'True'){$OptionSearchProcessesCheckBox.checked = $true}
                else {$OptionSearchProcessesCheckBox.checked = $false}
            }
            $OptionSearchComputersForPreviouslyCollectedDataProcessesGroupBox.Controls.Add($OptionSearchProcessesCheckBox)


            $OptionSearchServicesCheckBox = New-Object System.Windows.Forms.Checkbox -Property @{
                Text    = "Services"
                Left    = $FormScale * 10
                Top     = $OptionSearchProcessesCheckBox.Top + $OptionSearchProcessesCheckBox.Height
                Width   = $FormScale * 200
                Height  = $FormScale * 20
                Enabled = $true
                Checked = $False
                Font    = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
                Add_Click = { $This.Checked | Set-Content "$PoShHome\Settings\Search - Services Checkbox.txt" -Force }
            }
            if (Test-Path "$PoShHome\Settings\Search - Services Checkbox.txt") { 
                if ((Get-Content "$PoShHome\Settings\Search - Services Checkbox.txt") -eq 'True'){$OptionSearchServicesCheckBox.checked = $true}
                else {$OptionSearchServicesCheckBox.checked = $false}
            }
            $OptionSearchComputersForPreviouslyCollectedDataProcessesGroupBox.Controls.Add($OptionSearchServicesCheckBox)


            $OptionSearchNetworkTCPConnectionsCheckBox = New-Object System.Windows.Forms.Checkbox -Property @{
                Text    = "Network TCP Connections"
                Left    = $FormScale * 10
                Top     = $OptionSearchServicesCheckBox.Top + $OptionSearchServicesCheckBox.Height - $($FormScale + 1)
                Width   = $FormScale * 200
                Height  = $FormScale * 20
                Enabled = $true
                Checked = $False
                Font    = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
                Add_Click = { $This.Checked | Set-Content "$PoShHome\Settings\Search - Network TCP Connections Checkbox.txt" -Force }
            }
            if (Test-Path "$PoShHome\Settings\Search - Network TCP Connections Checkbox.txt") { 
                if ((Get-Content "$PoShHome\Settings\Search - Network TCP Connections Checkbox.txt") -eq 'True'){$OptionSearchNetworkTCPConnectionsCheckBox.checked = $true}
                else {$OptionSearchNetworkTCPConnectionsCheckBox.checked = $false}
            }
            $OptionSearchComputersForPreviouslyCollectedDataProcessesGroupBox.Controls.Add($OptionSearchNetworkTCPConnectionsCheckBox)
$Section2OptionsTab.Controls.Add($OptionSearchComputersForPreviouslyCollectedDataProcessesGroupBox)


$script:OptionMonitorJobsDefaultRestartTimeCombobox = New-Object System.Windows.Forms.Combobox -Property @{
    Text   = 60
    Left   = $FormScale * 3
    Top    = $OptionSearchComputersForPreviouslyCollectedDataProcessesGroupBox.Top + $OptionSearchComputersForPreviouslyCollectedDataProcessesGroupBox.Height + $($FormScale + 2)
    Width  = $FormScale * 50
    Height = $FormScale * 22
    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    Add_SelectedIndexChanged = { $This.Text | Set-Content "$PoShHome\Settings\Monitor Jobs Default Restart Time.txt" -Force }
}
$MonitorJobDefaultRestartTimesAvailable = @(1,5,10,15,30,60,120,300,600,1800,3600)
ForEach ($Item in $MonitorJobDefaultRestartTimesAvailable) { $script:OptionMonitorJobsDefaultRestartTimeCombobox.Items.Add($Item) }
if (Test-Path "$PoShHome\Settings\Monitor Jobs Default Restart Time.txt") { $script:OptionMonitorJobsDefaultRestartTimeCombobox.text = Get-Content "$PoShHome\Settings\Monitor Jobs Default Restart Time.txt" }
$Section2OptionsTab.Controls.Add($script:OptionMonitorJobsDefaultRestartTimeCombobox)


$OptionMonitorJobsDefaultRestartTimeLabel = New-Object System.Windows.Forms.Label -Property @{
    Text   = "Monitor Jobs Default Restart Time"
    Left   = $script:OptionMonitorJobsDefaultRestartTimeCombobox.Left + $script:OptionMonitorJobsDefaultRestartTimeCombobox.Width + $($FormScale + 5)
    Top    = $script:OptionMonitorJobsDefaultRestartTimeCombobox.Top + $($FormScale + 3)
    Width  = $FormScale * 200
    Height = $FormScale * 18
    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
}
$Section2OptionsTab.Controls.Add($OptionMonitorJobsDefaultRestartTimeLabel)


$script:GuiLayout = Get-Content "$PoShHome\Settings\GUI Layout.txt"
$script:CompactViewRadioButton = New-Object System.Windows.Forms.RadioButton -Property @{
    Text   = "Compact View"
    Left   = $script:OptionMonitorJobsDefaultRestartTimeCombobox.Left
    Top    = $script:OptionMonitorJobsDefaultRestartTimeCombobox.Top + $script:OptionMonitorJobsDefaultRestartTimeCombobox.Height + ($FormScale * 5)
    Width  = $FormScale * 100
    Height = $FormScale * 18
    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    Checked = $true
    Add_Click = { 
        Set-GuiLayout -Compact 
        'GUI Layout = Compact' | Set-Content "$PoShHome\Settings\GUI Layout.txt"
    }
}
$Section2OptionsTab.Controls.Add($script:CompactViewRadioButton)


$script:ExtendedViewRadioButton = New-Object System.Windows.Forms.RadioButton -Property @{
    Text   = "Extended View"
    Left   = $script:CompactViewRadioButton.Left + $script:CompactViewRadioButton.Width + $($FormScale + 5)
    Top    = $script:CompactViewRadioButton.Top
    Width  = $FormScale * 100
    Height = $FormScale * 18
    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    Add_Click = {
        Set-GuiLayout -Extended
        'GUI Layout = Extended' | Set-Content "$PoShHome\Settings\GUI Layout.txt"
    }
}
$Section2OptionsTab.Controls.Add($script:ExtendedViewRadioButton)


Load-Code "$Dependencies\Code\System.Windows.Forms\Checkbox\OptionsAutoSaveChartsAsImages.ps1"
. "$Dependencies\Code\System.Windows.Forms\Checkbox\OptionsAutoSaveChartsAsImages.ps1"
$OptionsAutoSaveChartsAsImages = New-Object System.Windows.Forms.Checkbox -Property @{
    Text    = "Autosave Charts As Images"
    Left    = $script:CompactViewRadioButton.Left
    Top     = $script:CompactViewRadioButton.Top + $script:CompactViewRadioButton.Height
    Width   = $FormScale * 225
    Height  = $FormScale * 22
    Enabled = $true
    Checked = $false
    Font    = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    Add_Click = {
        $This.Checked | Set-Content "$PoShHome\Settings\Auto Save Charts As Images.txt" -Force

        if (-not $(Test-Path -Path $AutosavedChartsDirectory)) {
            New-Item -Type Directory -Path $AutosavedChartsDirectory -Force
        }
    }
    Add_MouseHover = $OptionsAutoSaveChartsAsImagesAdd_MouseHover
}
if (Test-Path "$PoShHome\Settings\Auto Save Charts As Images.txt") { 
    if ((Get-Content "$PoShHome\Settings\Auto Save Charts As Images.txt") -eq 'True'){$OptionsAutoSaveChartsAsImages.checked = $true}
    else {$OptionsAutoSaveChartsAsImages.checked = $false}
}
$Section2OptionsTab.Controls.Add( $OptionsAutoSaveChartsAsImages )


                $OptionGUITopWindowCheckBox = New-Object System.Windows.Forms.Checkbox -Property @{
                    Text    = "GUI always on top"
                    Left    = $OptionsAutoSaveChartsAsImages.Left + $OptionsAutoSaveChartsAsImages.Width
                    Top     = $OptionsAutoSaveChartsAsImages.Top
                    Width   = $FormScale * 200
                    Height  = $FormScale * 22
                    Enabled = $true
                    Checked = $false
                    Font    = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
                    Add_Click = {
                        $This.checked | Set-Content "$PoShHome\Settings\GUI Top Most Window.txt" -Force

                        # Option to toggle if the Windows is not the top most
                        if   ( $OptionGUITopWindowCheckBox.checked ) {
                            $PoShEasyWin.Topmost = $true
                        }
                        else {
                            $PoShEasyWin.Topmost = $false
                        }                    
                    }
                }
                if (Test-Path "$PoShHome\Settings\GUI Top Most Window.txt") { 
                    if ((Get-Content "$PoShHome\Settings\GUI Top Most Window.txt") -eq 'True'){
                        $OptionGUITopWindowCheckBox.checked = $true
                        $PoShEasyWin.Topmost = $true
                    }
                    else {
                        $OptionGUITopWindowCheckBox.checked = $false
                        $PoShEasyWin.Topmost = $false
                    }
                }
                $Section2OptionsTab.Controls.Add( $OptionGUITopWindowCheckBox )


$OptionTextToSpeachCheckBox = New-Object System.Windows.Forms.Checkbox -Property @{
    Text    = "Audible Completion Message"
    Left    = $FormScale * 3
    Top     = $OptionsAutoSaveChartsAsImages.Top + $OptionsAutoSaveChartsAsImages.Height
    Width   = $FormScale * 225
    Height  = $FormScale * 22
    Enabled = $true
    Checked = $false
    Font    = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    Add_Click = { $This.Checked | Set-Content "$PoShHome\Settings\Audible Completion Message.txt" -Force }
}
if (Test-Path "$PoShHome\Settings\Audible Completion Message.txt") { 
    if ((Get-Content "$PoShHome\Settings\Audible Completion Message.txt") -eq 'True'){$OptionTextToSpeachCheckBox.checked = $true}
    else {$OptionTextToSpeachCheckBox.checked = $false}
}
if ($AudibleCompletionMessage) {$OptionTextToSpeachCheckBox.Checked = $True}
$Section2OptionsTab.Controls.Add($OptionTextToSpeachCheckBox)


                $OptionShowToolTipCheckBox = New-Object System.Windows.Forms.Checkbox -Property @{
                    Text    = "Show ToolTip"
                    Left    = $OptionTextToSpeachCheckBox.Left + $OptionTextToSpeachCheckBox.Width
                    Top     = $OptionTextToSpeachCheckBox.Top
                    Width   = $FormScale * 200
                    Height  = $FormScale * 22
                    Enabled = $true
                    Checked = $True
                    Font    = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
                    Add_Click = { $This.Checked | Set-Content "$PoShHome\Settings\Show Tool Tip.txt" -Force }
                }
                if (Test-Path "$PoShHome\Settings\Show Tool Tip.txt") { 
                    if ((Get-Content "$PoShHome\Settings\Show Tool Tip.txt") -eq 'True'){$OptionShowToolTipCheckBox.checked = $true}
                    else {$OptionShowToolTipCheckBox.checked = $false}
                }
                $Section2OptionsTab.Controls.Add($OptionShowToolTipCheckBox)


$OptionPacketKeepEtlCabFilesCheckBox = New-Object System.Windows.Forms.Checkbox -Property @{
    Text    = "Packet Captures - Keep .etc and .cab files"
    Left    = $FormScale * 3
    Top     = $OptionTextToSpeachCheckBox.Top + $OptionTextToSpeachCheckBox.Height
    Width   = $FormScale * 250
    Height  = $FormScale * 22
    Enabled = $true
    Checked = $false
    Font    = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    Add_Click = { $This.Checked | Set-Content "$PoShHome\Settings\Packet Captures - Keep etl and cab files.txt" -Force }
}
if (Test-Path "$PoShHome\Settings\Packet Captures - Keep etl and cab files.txt") { 
    if ((Get-Content "$PoShHome\Settings\Packet Captures - Keep etl and cab files.txt") -eq 'True'){$OptionPacketKeepEtlCabFilesCheckBox.checked = $true}
    else {$OptionPacketKeepEtlCabFilesCheckBox.checked = $false}
}
$Section2OptionsTab.Controls.Add($OptionPacketKeepEtlCabFilesCheckBox)


# # BUG: When the box is unchecked, the results don't compile correctly
# $OptionKeepResultsByEndpointsFilesCheckBox = New-Object System.Windows.Forms.Checkbox -Property @{
#     Text    = "Individual Execution - Keep Results by Endpoints"
#     Left    = $FormScale * 3
#     Top     = $OptionPacketKeepEtlCabFilesCheckBox.Top + $OptionPacketKeepEtlCabFilesCheckBox.Height
#     Width   = $FormScale * 300
#     Height  = $FormScale * 22
#     Enabled = $true
#     Checked = $false
#     Font    = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
#     Add_Click = { $This.Checked | Set-Content "$PoShHome\Settings\Individual Execution - Keep Results by Endpoints.txt" -Force }
# }
# if (Test-Path "$PoShHome\Settings\Individual Execution - Keep Results by Endpoints.txt") { 
#     if ((Get-Content "$PoShHome\Settings\Individual Execution - Keep Results by Endpoints.txt") -eq 'True'){$OptionKeepResultsByEndpointsFilesCheckBox.checked = $true}
#     else {$OptionKeepResultsByEndpointsFilesCheckBox.checked = $false}
# }
# $Section2OptionsTab.Controls.Add($OptionKeepResultsByEndpointsFilesCheckBox)


$OptionSaveCliXmlDataCheckBox = New-Object System.Windows.Forms.Checkbox -Property @{
    Text    = "Save XML Data - Object Data Used For Terminals"
    Left    = $FormScale * 3
    Top     = $OptionPacketKeepEtlCabFilesCheckBox.Top + $OptionPacketKeepEtlCabFilesCheckBox.Height
    Width   = $FormScale * 300
    Height  = $FormScale * 22
    Enabled = $true
    Checked = $false
    Font    = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
    Add_Click = { $This.Checked | Set-Content "$PoShHome\Settings\Save XML Data - Object Data Used For Terminals.txt" -Force }
}
if (Test-Path "$PoShHome\Settings\Save XML Data - Object Data Used For Terminals.txt") { 
    if ((Get-Content "$PoShHome\Settings\Save XML Data - Object Data Used For Terminals.txt") -eq 'True'){$OptionSaveCliXmlDataCheckBox.checked = $true}
    else {$OptionSaveCliXmlDataCheckBox.checked = $false}
}
$Section2OptionsTab.Controls.Add($OptionSaveCliXmlDataCheckBox)



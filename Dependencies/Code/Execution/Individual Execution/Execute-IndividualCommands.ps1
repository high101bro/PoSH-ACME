Foreach ($Command in $script:CommandsCheckedBoxesSelected) {
    $ExecutionStartTime = Get-Date
    $StatusListBox.Items.Clear()
    $StatusListBox.Items.Add("Query: $($Command.Name)")
    $ResultsListBox.Items.Insert(0,"$(($ExecutionStartTime).ToString('yyyy/MM/dd HH:mm:ss')) $($Command.Name)")

    $CollectionName = $Command.ExportFileName
    $script:IndividualHostResults = "$script:CollectedDataTimeStampDirectory\Results By Endpoints"
    New-Item -ItemType Directory -Path "$script:IndividualHostResults\$CollectionName" -Force

    # if the SaveDirectory parameter is provided, it will be used to identify where to save the results to
    if ($SaveDirectory) {
        $CollectionSavedDirectory = $SaveDirectory
    }
    else {
        $CollectionSavedDirectory = "$script:IndividualHostResults\$CollectionName"
    }

    $script:ProgressBarEndpointsProgressBar.Maximum = $script:ComputerList.count

    $script:MonitorJobScriptBlock = {
        # Each command to each target host is executed on it's own process thread, which utilizes more memory overhead on the localhost [running PoSh-EasyWin] and produces many more network connections to targets [noisier on the network].
        Foreach ($TargetComputer in $script:ComputerList) {
            # Checks for the type of command selected and assembles the command to be executed
            $OutputFileFileType = ""
            if ($ComputerListProvideCredentialsCheckBox.Checked) {
                if (!$script:Credential) { Create-NewCredentials }
                Create-LogEntry -LogFile $LogFile -NoTargetComputer -Message "Credentials Used: $($script:Credential.UserName)"




                if ($Command.Type -eq "(WinRM) Script") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -Credential `$script:Credential -ErrorAction Stop"
                    $OutputFileFileType = "csv"
                }
                elseif ($Command.Type -eq "(WinRM) PoSh") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -Credential `$script:Credential -ErrorAction Stop | Select-Object -Property $($Command.Properties)"
                    $OutputFileFileType = "csv"
                }
                elseif ($Command.Type -eq "(WinRM) WMI") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -Credential `$script:Credential -ErrorAction Stop | Select-Object -Property $($Command.Properties)"
                    $OutputFileFileType = "csv"
                }
                #elseif ($Command.Type -eq "(WinRM) CMD") {
                #    $script:commandstring = $Command.Command
                #    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -Credential `$script:Credential -ErrorAction Stop"
                #    $OutputFileFileType = "txt"
                #}
                #elseif ($Command.Type -eq "(RPC) PoSh") {
                #    $script:commandstring = $Command.Command
                #    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -Credential `$script:Credential -ErrorAction Stop | Select-Object -Property @{n='PSComputerName';e={`$TargetComputer}}, $($Command.Properties)"
                #    $OutputFileFileType = "csv"
                #}
                elseif (($Command.Type -eq "(RPC) WMI") -and ($Command.Command -match "Get-WmiObject")) {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -Credential `$script:Credential -ErrorAction Stop | Select-Object -Property $($Command.Properties)"
                    $OutputFileFileType = "csv"
                }
                #elseif (($Command.Type -eq "(RPC) CMD") -and ($Command.Command -match "Invoke-WmiMethod")) {
                #    $script:commandstring = $Command.Command
                #    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -Credential `$script:Credential -ErrorAction Stop"
                #    $OutputFileFileType = "txt"
                #}
                elseif ($Command.Type -eq "(SMB) PoSh") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ErrorAction Stop | Select-Object -Property $($Command.Properties)"
                    $OutputFileFileType = "txt"

                    $Username = $script:Credential.UserName
                    $Password = $script:Credential.GetNetworkCredential().Password
                    $UseCredential = "-u '$Username' -p '$Password'"
                }
                elseif ($Command.Type -eq "(SMB) WMI") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ErrorAction Stop | Select-Object -Property $($Command.Properties)"
                    $OutputFileFileType = "txt"

                    $Username = $script:Credential.UserName
                    $Password = $script:Credential.GetNetworkCredential().Password
                    $UseCredential = "-u '$Username' -p '$Password'"
                }
                elseif ($Command.Type -eq "(SMB) CMD") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command)" # NO -ErrorAction Stop, these are cmd native commands
                    $OutputFileFileType = "txt"

                    $Username = $script:Credential.UserName
                    $Password = $script:Credential.GetNetworkCredential().Password
                    $UseCredential = "-u '$Username' -p '$Password'"
                }
            }
            # No credentials provided
            else {
                if ($Command.Type -eq "(WinRM) Script") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -ErrorAction Stop"
                    $OutputFileFileType = "csv"
                }
                elseif ($Command.Type -eq "(WinRM) PoSh") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -ErrorAction Stop | Select-Object -Property $($Command.Properties)"
                    $OutputFileFileType = "csv"
                }
                elseif ($Command.Type -eq "(WinRM) WMI") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -ErrorAction Stop | Select-Object -Property $($Command.Properties)"
                    $OutputFileFileType = "csv"
                }
                #elseif ($Command.Type -eq "(WinRM) CMD") {
                #    $script:commandstring = $Command.Command
                #    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -ErrorAction Stop"
                #    $OutputFileFileType = "txt"
                #}
                #elseif ($Command.Type -eq "(RPC) PoSh") {
                #    $script:commandstring = $Command.Command
                #    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -ErrorAction Stop | Select-Object -Property @{n='PSComputerName';e={`$TargetComputer}}, $($Command.Properties)"
                #    $OutputFileFileType = "csv"
                #}
                elseif (($Command.Type -eq "(RPC) WMI") -and ($Command.Command -match "Get-WmiObject")) {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -ErrorAction Stop | Select-Object -Property $($Command.Properties)"
                    $OutputFileFileType = "csv"
                }
                #elseif (($Command.Type -eq "(RPC) CMD") -and ($Command.Command -match "Invoke-WmiMethod")) {
                #    $script:commandstring = $Command.Command
                #    $CommandString = "$($Command.Command) -ComputerName $TargetComputer -ErrorAction Stop"
                #    $OutputFileFileType = "txt"
                #}
                elseif ($Command.Type -eq "(SMB) PoSh") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ErrorAction Stop | Select-Object -Property $($Command.Properties)"
                    $OutputFileFileType = "txt"
                }
                elseif ($Command.Type -eq "(SMB) WMI") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command) -ErrorAction Stop | Select-Object -Property $($Command.Properties)"
                    $OutputFileFileType = "txt"
                }
                elseif ($Command.Type -eq "(SMB) CMD") {
                    $script:commandstring = $Command.Command
                    $CommandString = "$($Command.Command)" # NO  -ErrorAction Stop, as these are native cmds
                    $OutputFileFileType = "txt"
                }
            }
            $CommandName = $Command.Name
            $CommandType = $Command.Type

            # Sends each query separetly to each computers, which produces a lot of network connections
            # This section is purposefull not using Invoke-Command -AsJob becuase some commands use  RPC/DCOM

                # Checks for the file output type, removes previous results with a file, then executes the commands
                if ( $OutputFileFileType -eq "csv" ) {
                    ## Now saving with Monitor-Jobs with the command Receive-Job
                    ## $OutputFilePath = "$CollectionSavedDirectory\$((($CommandName) -split ' -- ')[1]) - $CommandType - $($TargetComputer).csv"
                    ## Remove-Item -Path $OutputFilePath -Force -ErrorAction SilentlyContinue

                    $script:JobsStarted    = $true
                    $CompileResults = $true

                    Start-Job -Name "PoSh-EasyWin: $((($CommandName) -split ' -- ')[1]) - $CommandType - $($TargetComputer)" -ScriptBlock {
                        param($OutputFileFileType, $CollectionSavedDirectory, $CommandName, $CommandType, $TargetComputer, $CommandString, $PsExecPath, $script:Credential, $UseCredential)
                        # Available priority values: Low, BelowNormal, Normal, AboveNormal, High, RealTime
                        [System.Threading.Thread]::CurrentThread.Priority = 'High'
                        ([System.Diagnostics.Process]::GetCurrentProcess()).PriorityClass = 'High'

                        Invoke-Expression -Command $CommandString
                    } -InitializationScript $null -ArgumentList @($OutputFileFileType, $CollectionSavedDirectory, $CommandName, $CommandType, $TargetComputer, $CommandString, $PsExecPath, $script:Credential, $UseCredential)
                }













                
                elseif ( $OutputFileFileType -eq "txt" ) {
                    $OutputFilePath = "$CollectionSavedDirectory\$((($CommandName) -split ' -- ')[1]) - $CommandType - $($TargetComputer).txt"
                    Remove-Item -Path $OutputFilePath -Force -ErrorAction SilentlyContinue


                    #if ($CommandType -eq "(WinRM) CMD") {
                    #    $script:JobsStarted    = $true
                    #    $CompileResults = $true
                    #    Start-Job -Name "PoSh-EasyWin: $((($CommandName) -split ' -- ')[1]) - $CommandType - $($TargetComputer)" -ScriptBlock {
                    #        param($OutputFileFileType, $CollectionSavedDirectory, $CommandName, $CommandType, $TargetComputer, $CommandString, $PsExecPath, $script:Credential, $UseCredential)
                    #        # Available priority values: Low, BelowNormal, Normal, AboveNormal, High, RealTime
                    #        [System.Threading.Thread]::CurrentThread.Priority = 'High'
                    #        ([System.Diagnostics.Process]::GetCurrentProcess()).PriorityClass = 'High'
                    #
                    #        # This is to catch Invoke-WmiMethod commands because these commands will drop files on the target that we want to retrieve then remove
                    #        Invoke-Expression -Command $CommandString
                    #        Start-Sleep -Seconds 1
                    #        Move-Item   "\\$TargetComputer\c$\results.txt" "$OutputFilePath"
                    #            #Copy-Item   "\\$TargetComputer\c$\results.txt" "$OutputFilePath"
                    #            #Remove-Item "\\$TargetComputer\c$\results.txt"
                    #    } -InitializationScript $null -ArgumentList @($OutputFileFileType, $CollectionSavedDirectory, $CommandName, $CommandType, $TargetComputer, $CommandString, $PsExecPath, $script:Credential, $UseCredential)
                    #}





                    if (($CommandType -eq "(RPC) WMI") -and ($CommandString -match "Invoke-WmiMethod") ) {
                        $script:JobsStarted    = $true
                        $CompileResults = $true
                        Start-Job -Name "PoSh-EasyWin: $((($CommandName) -split ' -- ')[1]) - $CommandType - $($TargetComputer)" -ScriptBlock {
                            param($OutputFileFileType, $CollectionSavedDirectory, $CommandName, $CommandType, $TargetComputer, $CommandString, $PsExecPath, $script:Credential, $UseCredential)
                            # Available priority values: Low, BelowNormal, Normal, AboveNormal, High, RealTime
                            [System.Threading.Thread]::CurrentThread.Priority = 'High'
                            ([System.Diagnostics.Process]::GetCurrentProcess()).PriorityClass = 'High'

                            # This is to catch Invoke-WmiMethod commands because these commands will drop files on the target that we want to retrieve then remove
                            Invoke-Expression -Command $CommandString
                            Start-Sleep -Seconds 1
                            Move-Item   "\\$TargetComputer\c$\results.txt" "$OutputFilePath"
                                #Copy-Item   "\\$TargetComputer\c$\results.txt" "$OutputFilePath"
                                #Remove-Item "\\$TargetComputer\c$\results.txt"
                        } -InitializationScript $null -ArgumentList @($OutputFileFileType, $CollectionSavedDirectory, $CommandName, $CommandType, $TargetComputer, $CommandString, $PsExecPath, $script:Credential, $UseCredential)
                    }




                    elseif ($CommandType -eq "(SMB) PoSh"){
                        $MainBottomTabControl.SelectedTab = $Section3ResultsTab
                        $PoShEasyWin.Refresh()

                        $script:JobsStarted    = $false
                        $CompileResults = $true

                        $Username = $script:Credential.UserName
                        $Password = $script:Credential.GetNetworkCredential().Password

                        Write-Host '===================================================================================================='
                        & $PsExecPath "\\$TargetComputer" -AcceptEULA -NoBanner -u $UserName -p $Password powershell "$($Command.Command) | Select-Object * | ConvertTo-Csv -NoType" | ConvertFrom-Csv | Select-Object @{n='PSComputerName';e={$TargetComputer}},* -ErrorAction SilentlyContinue | Export-CSV "$($script:IndividualHostResults)\$CollectionName\$CollectionName - $($Command.Type) - $TargetComputer.csv" -NoTypeInformation
                        if ($LASTEXITCODE -eq 0) {Write-Host -f Green "Execution Successful"}
                        else {Write-Host -f Red "Execution Error"}
                        #note: $($Error[0] | Select-Object -ExpandProperty Exception) does not provide the error from PSExec, rather that of another from within the PowerShell Session

                        Post-MonitorJobs -CollectionName $CollectionName -CollectionCommandStartTime $ExecutionStartTime

                        # Used later below to log the action
                        $CommandString = "$PsExecPath `"\\$TargetComputer`" -AcceptEULA -NoBanner -u `$UserName -p `$Password powershell `"$($Command.Command) | Select-Object * | ConvertTo-Csv -NoType`""

                        $script:ProgressBarEndpointsProgressBar.Value += 1
                    }
                    elseif ($CommandType -eq "(SMB) WMI"){
                        $MainBottomTabControl.SelectedTab = $Section3ResultsTab
                        $PoShEasyWin.Refresh()

                        $script:JobsStarted    = $false
                        $CompileResults = $true

                        $Username = $script:Credential.UserName
                        $Password = $script:Credential.GetNetworkCredential().Password
                        Write-Host '===================================================================================================='
                        & $PsExecPath "\\$TargetComputer" -AcceptEULA -NoBanner -u $UserName -p $Password powershell "$($Command.Command) | ConvertTo-Csv -NoType" | ConvertFrom-Csv | Export-CSV "$($script:IndividualHostResults)\$CollectionName\$CollectionName - $($Command.Type) - $TargetComputer.csv" -NoTypeInformation
                        if ($LASTEXITCODE -eq 0) {Write-Host -f Green "Execution Successful"}
                        else {Write-Host -f Red "Execution Error"}
                        #note: $($Error[0] | Select-Object -ExpandProperty Exception) does not provide the error from PSExec, rather that of another from within the PowerShell Session

                        Post-MonitorJobs -CollectionName $CollectionName -CollectionCommandStartTime $ExecutionStartTime

                        # Used later below to log the action
                        $CommandString = "$PsExecPath `"\\$TargetComputer`" -AcceptEULA -NoBanner -u `$UserName -p `$Password powershell `"$($Command.Command) | Select-Object * | ConvertTo-Csv -NoType`""

                        $script:ProgressBarEndpointsProgressBar.Value += 1
                    }
                    elseif ($CommandType -eq "(SMB) CMD"){
                        $MainBottomTabControl.SelectedTab = $Section3ResultsTab
                        $PoShEasyWin.Refresh()

                        $script:JobsStarted    = $false
                        $CompileResults = $false
                        "Results not compiled, they are stored within the Individual Results directory." | Out-File "$script:CollectedDataTimeStampDirectory\$((($Command.Name) -split ' -- ')[1]) - $($Command.Type).txt"

                        $Username = $script:Credential.UserName
                        $Password = $script:Credential.GetNetworkCredential().Password
                        Write-Host '===================================================================================================='
                        & $PsExecPath "\\$TargetComputer" -AcceptEULA -NoBanner -u $UserName -p $Password cmd /c "$($Command.Command)" | Out-File "$($script:IndividualHostResults)\$CollectionName\$CollectionName - $($Command.Type) - $TargetComputer.txt"
                        if ($LASTEXITCODE -eq 0) {Write-Host -f Green "Execution Successful"}
                        else {Write-Host -f Red "Execution Error"}
                        #note: $($Error[0] | Select-Object -ExpandProperty Exception) does not provide the error from PSExec, rather that of another from within the PowerShell Session

                        Post-MonitorJobs -CollectionName $CollectionName -CollectionCommandStartTime $ExecutionStartTime

                        # Used later below to log the action
                        $CommandString = "$PsExecPath `"\\$TargetComputer`" -AcceptEULA -NoBanner -u `$UserName -p `$Password cmd /c `"$($Command.Command)"

                        $script:ProgressBarEndpointsProgressBar.Value += 1
                        # This executes native windows cmds with PSExec
                        #Start-Process PowerShell -WindowStyle Hidden -ArgumentList "Start-Process '$PsExecPath' -ArgumentList '-AcceptEULA -NoBanner \\$script:ComputerTreeViewSelected $UseCredential tasklist'" > c:\ressults.txt
                    }

                    else {
                        $script:JobsStarted    = $true
                        $CompileResults = $true
                        Start-Job -Name "PoSh-EasyWin: $((($CommandName) -split ' -- ')[1]) - $CommandType - $($TargetComputer)" -ScriptBlock {
                            param($OutputFileFileType, $CollectionSavedDirectory, $CommandName, $CommandType, $TargetComputer, $CommandString, $PsExecPath, $script:Credential, $UseCredential)
                            # Available priority values: Low, BelowNormal, Normal, AboveNormal, High, RealTime
                            [System.Threading.Thread]::CurrentThread.Priority = 'High'
                            ([System.Diagnostics.Process]::GetCurrentProcess()).PriorityClass = 'High'

                            # Runs all other commands an saves them locally as a .txt file
                            Invoke-Expression -Command $CommandString | Out-File $OutputFilePath -Force
                        } -InitializationScript $null -ArgumentList @($OutputFileFileType, $CollectionSavedDirectory, $CommandName, $CommandType, $TargetComputer, $CommandString, $PsExecPath, $script:Credential, $UseCredential)
                    }
                }

            Create-LogEntry -LogFile $LogFile -NoTargetComputer -Message "$(($CommandString).Trim())"
        }
    }
    Invoke-Command -ScriptBlock $script:MonitorJobScriptBlock

    $EndpointString = ''
    foreach ($item in $script:ComputerList) {$EndpointString += "$item`n"}

    $InputValues = @"
===========================================================================
Collection Name:
===========================================================================
$CollectionName

===========================================================================
Execution Time:
===========================================================================
$ExecutionStartTime

===========================================================================
Credentials:
===========================================================================
$($script:Credential.UserName)

===========================================================================
Endpoints:
===========================================================================
$($EndpointString.trim())

===========================================================================
Command:
===========================================================================
$script:commandstring

"@

    #$script:JobsStarted is used to track if jobs are being used ($true), jobs don't start when using psexec ($false)
    if ( $script:JobsStarted -eq $true ) {
        if ($script:CommandTreeViewQueryMethodSelectionComboBox.SelectedItem -eq 'Monitor Jobs') {
            #Monitor-Jobs -CollectionName $CollectionName -MonitorMode
            Monitor-Jobs -CollectionName $CollectionName -MonitorMode -SMITH -SmithScript $script:MonitorJobScriptBlock -InputValues $InputValues
        }
        elseif ($script:CommandTreeViewQueryMethodSelectionComboBox.SelectedItem -eq 'Individual Execution') {
            Monitor-Jobs -CollectionName $CollectionName
            Post-MonitorJobs -CollectionName $CollectionName -CollectionCommandStartTime $ExecutionStartTime
        }
    }

    
    # Increments the overall progress bar
    $CompletedCommandQueries++
    $script:ProgressBarQueriesProgressBar.Value = $CompletedCommandQueries

    # This allows the Endpoint progress bar to appear completed momentarily
    $script:ProgressBarEndpointsProgressBar.Maximum = 1
    $script:ProgressBarEndpointsProgressBar.Value = 1
    #Start-Sleep -Milliseconds 250

    $CollectionCommandEndTime  = Get-Date
    $CollectionCommandDiffTime = New-TimeSpan -Start $ExecutionStartTime -End $CollectionCommandEndTime
    $ResultsListBox.Items.RemoveAt(0)
    $ResultsListBox.Items.Insert(0,"$(($ExecutionStartTime).ToString('yyyy/MM/dd HH:mm:ss')) [$CollectionCommandDiffTime]  $($Command.Name)")


    $AutoCreateDashboardChartButton.BackColor = 'LightGreen'
    $AutoCreateMultiSeriesChartButton.BackColor = 'LightGreen'

                         
    # Removes any files have are empty
    foreach ($file in (Get-ChildItem $script:CollectedDataTimeStampDirectory)) {
        if ($File.length -eq 0) {
            Remove-Item $File -Force
        }
    }
}


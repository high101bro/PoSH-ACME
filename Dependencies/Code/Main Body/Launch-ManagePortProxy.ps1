function Manage-WindowsRelay {
    Param( 
        $ComputerName,
        [Switch]$Delete,
        [Switch]$Show,
        $RelayType,
        $ListenAddress,
        $ListenPort,
        $ConnectAddress,
        $ConnectPort,
        $UserName,
        $Password,
        [switch]$UseCreds,
        #[System.Management.Automation.PSCredential]
        $Credential
    )
    if ($UseCreds) {
        $Credential.GetNetworkCredential.
        $null
    }
    elseif ($UserName -and $Password) {
        $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
        $Credential = New-Object System.Management.Automation.PSCredential ($UserName, $SecurePassword)
    }
    else {
        $Credential = $Null
    }


    if ($Show) {
        if ($UseCreds) {
            Invoke-Command -ScriptBlock {
                $PortProxy = @()
                $netsh = & netsh interface portproxy show all
                $netsh | Select-Object -Skip 5 | Where-Object {$_ -ne ''} | ForEach-Object {
                    $Attribitutes = $_ -replace "\s+"," " -split ' '
                    $PortProxy += [PSCustomObject]@{
                        'ComputerName'         = $Env:COMPUTERNAME
                        'Listening On Address' = $Attribitutes[0]
                        'Listening On Port'    = $Attribitutes[1]
                        'Connect To Address'   = $Attribitutes[2]
                        'Connect To Port'      = $Attribitutes[3]
                    }
                }
                return $PortProxy | Where-Object {$_.'Listening On Address' -match "\d.\d.\d.\d" -or $_.'Listening On Address' -match ':' }
            } -ArgumentList $null -ComputerName $ComputerName -Credential $Credential
        }
        else {
            Invoke-Command -ScriptBlock {
                $PortProxy = @()
                $netsh = & netsh interface portproxy show all
                $netsh | Select-Object -Skip 5 | Where-Object {$_ -ne ''} | ForEach-Object {
                    $Attribitutes = $_ -replace "\s+"," " -split ' '
                    $PortProxy += [PSCustomObject]@{
                        'ComputerName'         = $Env:COMPUTERNAME
                        'Listening On Address' = $Attribitutes[0]
                        'Listening On Port'    = $Attribitutes[1]
                        'Connect To Address'   = $Attribitutes[2]
                        'Connect To Port'      = $Attribitutes[3]
                    }
                }
                return $PortProxy | Where-Object {$_.'Listening On Address' -match "\d.\d.\d.\d" -or $_.'Listening On Address' -match ':' }
            } -ArgumentList $null -ComputerName $ComputerName
        }
    }


    if (-not $Delete -and -not $Show) {
        if ($UseCreds) {
            Invoke-Command -ScriptBlock {
                param ($RelayType,$ListenPort,$ListenAddress,$ConnectPort,$ConnectAddress)

                & netsh interface portproxy add $RelayType listenport=$ListenPort listenaddress=$ListenAddress connectport=$ConnectPort connectaddress=$ConnectAddress protocol=tcp

            } -ArgumentList @($RelayType,$ListenPort,$ListenAddress,$ConnectPort,$ConnectAddress) -ComputerName $ComputerName -Credential $Credential | Out-Null

            Invoke-Command -ScriptBlock {
                $PortProxy = @()
                $netsh = & netsh interface portproxy show all
                $netsh | Select-Object -Skip 5 | Where-Object {$_ -ne ''} | ForEach-Object {
                    $Attribitutes = $_ -replace "\s+"," " -split ' '
                    $PortProxy += [PSCustomObject]@{
                        'ComputerName'         = $Env:COMPUTERNAME
                        'Listening On Address' = $Attribitutes[0]
                        'Listening On Port'    = $Attribitutes[1]
                        'Connect To Address'   = $Attribitutes[2]
                        'Connect To Port'      = $Attribitutes[3]
                    }
                }
                return $PortProxy | Where-Object {$_.'Listening On Address' -match "\d.\d.\d.\d" -or $_.'Listening On Address' -match ':' }
            } -ArgumentList $null -ComputerName $ComputerName -Credential $Credential
        }
        else {
            Invoke-Command -ScriptBlock {
                param ($RelayType,$ListenPort,$ListenAddress,$ConnectPort,$ConnectAddress)

                & netsh interface portproxy add $RelayType listenport=$ListenPort listenaddress=$ListenAddress connectport=$ConnectPort connectaddress=$ConnectAddress protocol=tcp

            } -ArgumentList @($RelayType,$ListenPort,$ListenAddress,$ConnectPort,$ConnectAddress) -ComputerName $ComputerName | Out-Null

            Invoke-Command -ScriptBlock {
                $PortProxy = @()
                $netsh = & netsh interface portproxy show all
                $netsh | Select-Object -Skip 5 | Where-Object {$_ -ne ''} | ForEach-Object {
                    $Attribitutes = $_ -replace "\s+"," " -split ' '
                    $PortProxy += [PSCustomObject]@{
                        'ComputerName'         = $Env:COMPUTERNAME
                        'Listening On Address' = $Attribitutes[0]
                        'Listening On Port'    = $Attribitutes[1]
                        'Connect To Address'   = $Attribitutes[2]
                        'Connect To Port'      = $Attribitutes[3]
                    }
                }
                return $PortProxy | Where-Object {$_.'Listening On Address' -match "\d.\d.\d.\d" -or $_.'Listening On Address' -match ':' }
            } -ArgumentList $null -ComputerName $ComputerName
        }
    }

    if ($Delete) {
        if ($UseCreds) {
            Invoke-Command -ScriptBlock {
                param ($RelayType,$ListenPort,$ListenAddress)

                & netsh interface portproxy delete $RelayType listenport=$ListenPort listenaddress=$ListenAddress protocol=tcp

            } -ArgumentList @($RelayType,$ListenPort,$ListenAddress) -ComputerName $ComputerName -Credential $Credential | Out-Null

            Invoke-Command -ScriptBlock {
                $PortProxy = @()
                $netsh = & netsh interface portproxy show all
                $netsh | Select-Object -Skip 5 | Where-Object {$_ -ne ''} | ForEach-Object {
                    $Attribitutes = $_ -replace "\s+"," " -split ' '
                    $PortProxy += [PSCustomObject]@{
                        'ComputerName'         = $Env:COMPUTERNAME
                        'Listening On Address' = $Attribitutes[0]
                        'Listening On Port'    = $Attribitutes[1]
                        'Connect To Address'   = $Attribitutes[2]
                        'Connect To Port'      = $Attribitutes[3]
                    }
                }
                return $PortProxy | Where-Object {$_.'Listening On Address' -match "\d.\d.\d.\d" -or $_.'Listening On Address' -match ':' }
            } -ArgumentList $null -ComputerName $ComputerName -Credential $Credential
        }
        else {
            Invoke-Command -ScriptBlock {
                param ($RelayType,$ListenPort,$ListenAddress)

                & netsh interface portproxy delete $RelayType listenport=$ListenPort listenaddress=$ListenAddress protocol=tcp

            } -ArgumentList @($RelayType,$ListenPort,$ListenAddress) -ComputerName $ComputerName | Out-Null

            Invoke-Command -ScriptBlock {
                $PortProxy = @()
                $netsh = & netsh interface portproxy show all
                $netsh | Select-Object -Skip 5 | Where-Object {$_ -ne ''} | ForEach-Object {
                    $Attribitutes = $_ -replace "\s+"," " -split ' '
                    $PortProxy += [PSCustomObject]@{
                        'ComputerName'         = $Env:COMPUTERNAME
                        'Listening On Address' = $Attribitutes[0]
                        'Listening On Port'    = $Attribitutes[1]
                        'Connect To Address'   = $Attribitutes[2]
                        'Connect To Port'      = $Attribitutes[3]
                    }
                }
                return $PortProxy | Where-Object {$_.'Listening On Address' -match "\d.\d.\d.\d" -or $_.'Listening On Address' -match ':' }
            } -ArgumentList $null -ComputerName $ComputerName
        }
    }
}




$ManageWindowsPortProxyButtonAdd_Click = {

    Generate-ComputerList

    $ManagePortProxyForm = New-Object System.Windows.Forms.Form -Property @{
        Text   = "PoSh-EasyWin - Port Proxy"
        Width  = $FormScale * 440
        Height = $FormScale * 400
        StartPosition = "CenterScreen"
        Icon          = [System.Drawing.Icon]::ExtractAssociatedIcon("$EasyWinIcon")
        Font          = New-Object System.Drawing.Font("$Font",$($FormScale * 11),0,0,0)
        AutoScroll    = $True
        #FormBorderStyle =  "fixed3d"
        #ControlBox    = $false
        MaximizeBox   = $false
        MinimizeBox   = $false
        ShowIcon      = $true
        TopMost       = $true
        Add_Shown     = $null
        Add_Closing = { $This.dispose() }
    }

                $ManagePortProxyPictureBox = New-Object Windows.Forms.PictureBox -Property @{
                    Text   = "PowerShell Charts"
                    Left   = $FormScale * 10
                    Top    = $FormScale * 10
                    Width  = $FormScale * 300
                    Height = $FormScale * 44
                    Image  = [System.Drawing.Image]::Fromfile("$Dependencies\Images\Port_Proxy_Banner.png")
                    SizeMode = 'StretchImage'
                }
                $ManagePortProxyForm.Controls.Add($ManagePortProxyPictureBox)


                $ManagePortProxyLabel = New-Object System.Windows.Forms.Label -Property @{
                    Text   = "The netsh command can be used to configure port proxies, allowing the mapping and redirection of traffic one port to another, be it external or local to the endpoint."
                    Left   = $FormScale * 10
                    Top    = $ManagePortProxyPictureBox.Top + $ManagePortProxyPictureBox.Height + ($FormScale * 5)
                    Width  = $FormScale * 400
                    Height = $FormScale * 50
                    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                    ForeColor = 'Blue'
                }
                $ManagePortProxyForm.Controls.Add($ManagePortProxyLabel)


                $RelayActionLabel = New-Object System.Windows.Forms.Label -Property @{
                    Text   = "Action to perform:"
                    Left   = $ManagePortProxyLabel.Left
                    Top    = $ManagePortProxyLabel.Top + $ManagePortProxyLabel.Height + ($FormScale + 5)
                    Width  = $FormScale * 250
                    Height = $FormScale * 22
                    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                    Add_Click = {
                    }
                }
                $ManagePortProxyForm.Controls.Add($RelayActionLabel)


                            $RelayActionComboBox = New-Object System.Windows.Forms.ComboBox -Property @{
                                Left   = $RelayActionLabel.Left + $RelayActionLabel.width + ($FormScale + 5) 
                                Top    = $RelayActionLabel.Top
                                Width  = $FormScale * 125
                                Height = $FormScale * 22
                                Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                                #Add_Click = {}
                                Add_SelectedIndexChanged = {
                                    switch ($this.SelectedItem){
                                        'Show'   {
                                            $RelayTypeComboBox.enabled           = $false
                                            $RelayListenAddressComboBox.enabled  = $false
                                            $RelayListenPortComboBox.enabled     = $false
                                            $RelayConnectAddressComboBox.enabled = $false
                                            $RelayConnectPortComboBox.enabled    = $false
                                            $RelayComputerNameComboBox.enabled   = $true
                                            $RelayProtocolComboBox.enabled       = $false

                                            $RelayComputerNameLabel.text = "IP/Hostname to Show port proxy:"
                                        }                                        
                                        'Create' {
                                            $RelayTypeComboBox.enabled           = $true
                                            $RelayListenAddressComboBox.enabled  = $true
                                            $RelayListenPortComboBox.enabled     = $true
                                            $RelayConnectAddressComboBox.enabled = $true
                                            $RelayConnectPortComboBox.enabled    = $true
                                            $RelayComputerNameComboBox.enabled   = $true
                                            $RelayProtocolComboBox.enabled       = $false                              

                                            $RelayComputerNameLabel.text = "IP/Hostname to Create port proxy:"
                                        }
                                        'Delete' {
                                            $RelayTypeComboBox.enabled           = $true
                                            $RelayListenAddressComboBox.enabled  = $true
                                            $RelayListenPortComboBox.enabled     = $true
                                            $RelayConnectAddressComboBox.enabled = $false
                                            $RelayConnectPortComboBox.enabled    = $false
                                            $RelayComputerNameComboBox.enabled   = $true
                                            $RelayProtocolComboBox.enabled       = $false                                        

                                            $RelayComputerNameLabel.text = "IP/Hostname to Delete port proxy:"
                                        }
                                    }
                                }
                            }
                            $ManagePortProxyForm.Controls.Add($RelayActionComboBox)
                            $RelayActionList = @('Show','Create','Delete')
                            ForEach ($Action in $RelayActionList) { $RelayActionComboBox.Items.Add($Action) }
                            $RelayActionComboBox.SelectedItem = 'Show'

                $RelayComputerNameLabel = New-Object System.Windows.Forms.Label -Property @{
                    Text   = "IP/Hostname to Show port proxy:"
                    Left   = $RelayActionLabel.Left
                    Top    = $RelayActionLabel.Top + $RelayActionLabel.Height + ($FormScale + 5)
                    Width  = $FormScale * 250
                    Height = $FormScale * 22
                    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                }
                $ManagePortProxyForm.Controls.Add($RelayComputerNameLabel)


                            $RelayComputerNameComboBox = New-Object System.Windows.Forms.ComboBox -Property @{
                                Text   = ""
                                Left   = $RelayComputerNameLabel.Left + $RelayComputerNameLabel.width + ($FormScale + 5) 
                                Top    = $RelayComputerNameLabel.Top
                                Width  = $FormScale * 125
                                Height = $FormScale * 22
                                Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                                Enabled = $true
                            }
                            $ManagePortProxyForm.Controls.Add($RelayComputerNameComboBox)
                            ForEach ($Endpoint in $script:ComputerListAll) { $RelayComputerNameComboBox.Items.Add($Endpoint) }


                $RelayActionLabel = New-Object System.Windows.Forms.Label -Property @{
                    Text   = "Proxy Relay Type:"
                    Left   = $RelayComputerNameLabel.Left
                    Top    = $RelayComputerNameLabel.Top + $RelayComputerNameLabel.Height + ($FormScale * 5)
                    Width  = $FormScale * 250
                    Height = $FormScale * 22
                    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                    Add_Click = {
                    }
                }
                $ManagePortProxyForm.Controls.Add($RelayActionLabel)


                            $RelayTypeComboBox = New-Object System.Windows.Forms.ComboBox -Property @{
                                Left   = $RelayActionLabel.Left + $RelayActionLabel.Width + ($FormScale + 5) 
                                Top    = $RelayActionLabel.Top
                                Width  = $FormScale * 125
                                Height = $FormScale * 22
                                Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                                Enabled = $false
                            }
                            $ManagePortProxyForm.Controls.Add($RelayTypeComboBox)
                            $RelayTypeList = @('v4tov4','v6tov4','v4tov6','v6tov6')
                            ForEach ($Type in $RelayTypeList) { $RelayTypeComboBox.Items.Add($Type) }
                            $RelayTypeComboBox.SelectedItem = 'v4tov4'


                $RelayListenAddressLabel = New-Object System.Windows.Forms.Label -Property @{
                    Text   = "Proxy Listening IP Address:"
                    Left   = $RelayActionLabel.Left
                    Top    = $RelayActionLabel.Top + $RelayActionLabel.Height + ($FormScale + 5)
                    Width  = $FormScale * 250
                    Height = $FormScale * 22
                    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                }
                $ManagePortProxyForm.Controls.Add($RelayListenAddressLabel)


                            $RelayListenAddressComboBox = New-Object System.Windows.Forms.ComboBox -Property @{
                                Left   = $RelayListenAddressLabel.Left + $RelayListenAddressLabel.width + ($FormScale + 5) 
                                Top    = $RelayListenAddressLabel.Top
                                Width  = $FormScale * 125
                                Height = $FormScale * 22
                                Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                                Enabled = $false
                            }
                            $ManagePortProxyForm.Controls.Add($RelayListenAddressComboBox)
                            $RelayListenAddressList = @('0.0.0.0','127.0.0.1')
                            ForEach ($Address in $RelayListenAddressList) { $RelayListenAddressComboBox.Items.Add($Address) }
                            $RelayListenAddressComboBox.SelectedItem = '0.0.0.0'


                $RelayListenPortLabel = New-Object System.Windows.Forms.Label -Property @{
                    Text   = "Proxy Listening Port:"
                    Left   = $RelayListenAddressLabel.Left
                    Top    = $RelayListenAddressLabel.Top + $RelayListenAddressLabel.Height + ($FormScale + 5)
                    Width  = $FormScale * 250
                    Height = $FormScale * 22
                    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                }
                $ManagePortProxyForm.Controls.Add($RelayListenPortLabel)


                            $RelayListenPortComboBox = New-Object System.Windows.Forms.ComboBox -Property @{
                                Left   = $RelayListenPortLabel.Left + $RelayListenPortLabel.width + ($FormScale + 5) 
                                Top    = $RelayListenPortLabel.Top
                                Width  = $FormScale * 125
                                Height = $FormScale * 22
                                Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                                Enabled = $false
                            }
                            $ManagePortProxyForm.Controls.Add($RelayListenPortComboBox)
                            $RelayListenPortList = @('8000','8080','8888')
                            ForEach ($Port in $RelayListenPortList) { $RelayListenPortComboBox.Items.Add($Port) }
                            $RelayListenPortComboBox.SelectedItem = '8000'


                $RelayConnectAddressLabel = New-Object System.Windows.Forms.Label -Property @{
                    Text   = "Destination IP/Hostname:"
                    Left   = $RelayListenPortLabel.Left
                    Top    = $RelayListenPortLabel.Top + $RelayListenPortLabel.Height + ($FormScale + 5)
                    Width  = $FormScale * 250
                    Height = $FormScale * 22
                    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                }
                $ManagePortProxyForm.Controls.Add($RelayConnectAddressLabel)


                            $RelayConnectAddressComboBox = New-Object System.Windows.Forms.ComboBox -Property @{
                                Left   = $RelayConnectAddressLabel.Left + $RelayConnectAddressLabel.width + ($FormScale + 5) 
                                Top    = $RelayConnectAddressLabel.Top
                                Width  = $FormScale * 125
                                Height = $FormScale * 22
                                Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                                Enabled = $false
                            }
                            $ManagePortProxyForm.Controls.Add($RelayConnectAddressComboBox)
                            ForEach ($Address in $script:ComputerListAll) { $RelayConnectAddressComboBox.Items.Add($Address) }


                $RelayConnectPortLabel = New-Object System.Windows.Forms.Label -Property @{
                    Text   = "Destination Port:"
                    Left   = $RelayConnectAddressLabel.Left
                    Top    = $RelayConnectAddressLabel.Top + $RelayConnectAddressLabel.Height + ($FormScale + 5)
                    Width  = $FormScale * 250
                    Height = $FormScale * 22
                    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                }
                $ManagePortProxyForm.Controls.Add($RelayConnectPortLabel)


                            $RelayConnectPortComboBox = New-Object System.Windows.Forms.ComboBox -Property @{
                                Left   = $RelayConnectPortLabel.Left + $RelayConnectPortLabel.width + ($FormScale + 5) 
                                Top    = $RelayConnectPortLabel.Top
                                Width  = $FormScale * 125
                                Height = $FormScale * 22
                                Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                                Enabled = $false
                            }
                            $ManagePortProxyForm.Controls.Add($RelayConnectPortComboBox)
                            $RelayPortList = @('8000','8080','8888')
                            ForEach ($Port in $RelayPortList) { $RelayConnectPortComboBox.Items.Add($Port) }


                $RelayProtocolLabel = New-Object System.Windows.Forms.Label -Property @{
                    Text   = "Protocol (Only supports TCP):"
                    Left   = $RelayConnectPortLabel.Left
                    Top    = $RelayConnectPortLabel.Top + $RelayConnectPortLabel.Height + ($FormScale + 5)
                    Width  = $FormScale * 250
                    Height = $FormScale * 22
                    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                }
                $ManagePortProxyForm.Controls.Add($RelayProtocolLabel)


                            $RelayProtocolComboBox = New-Object System.Windows.Forms.ComboBox -Property @{
                                Text   = "TCP"
                                Left   = $RelayProtocolLabel.Left + $RelayProtocolLabel.width + ($FormScale + 5) 
                                Top    = $RelayProtocolLabel.Top
                                Width  = $FormScale * 125
                                Height = $FormScale * 22
                                Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                                Enabled = $false
                            }
                            $ManagePortProxyForm.Controls.Add($RelayProtocolComboBox)
                            $RelayProtocolList = @('TCP')
                            ForEach ($Protocol in $RelayProtocolList) { $RelayProtocolComboBox.Items.Add($Protocol) }


                $RelayActionExecutionButton = New-Object System.Windows.Forms.Button -Property @{
                    Text   = "Execution"
                    Left   = $RelayProtocolComboBox.Left
                    Top    = $RelayProtocolComboBox.Top + $RelayProtocolComboBox.Height + ($FormScale + 10)
                    Width  = $FormScale * 125
                    Height = $FormScale * 22
                    Font   = New-Object System.Drawing.Font("$Font",$($FormScale * 11),1,2,1)
                    Add_Click = {
                        switch ($RelayActionComboBox.SelectedItem) {
                            'Show' {
                                Manage-WindowsRelay `
                                -Show `
                                -ComputerName   $RelayComputerNameComboBox.Text `
                                -Credential     $Script:Credential `
                                -UseCreds | Out-GridView -Title 'PoSh-EasyWin - Port Proxy'
                            }
                            'Create' {
                                Manage-WindowsRelay `
                                -RelayType      $RelayTypeComboBox.Text `
                                -ListenAddress  $RelayListenAddressComboBox.Text `
                                -ListenPort     $RelayListenPortComboBox.Text `
                                -ConnectAddress $RelayConnectAddressComboBox.Text `
                                -ConnectPort    $RelayConnectPortComboBox.Text `
                                -ComputerName   $RelayComputerNameComboBox.Text `
                                -Credential     $Script:Credential `
                                -UseCreds | Out-GridView -Title 'PoSh-EasyWin - Port Proxy'
                            }
                            'Delete' {
                                Manage-WindowsRelay `
                                -Delete `
                                -RelayType      $RelayTypeComboBox.Text `
                                -ListenAddress  $RelayListenAddressComboBox.Text `
                                -ListenPort     $RelayListenPortComboBox.Text `
                                -ComputerName   $RelayComputerNameComboBox.Text `
                                -Credential     $Script:Credential `
                                -UseCreds | Out-GridView -Title 'PoSh-EasyWin - Port Proxy'
                            }
                        }
                    }
                }
                $ManagePortProxyForm.Controls.Add($RelayActionExecutionButton)
                CommonButtonSettings -Button $RelayActionExecutionButton


                $ManagePortProxyStatusBar = New-Object System.Windows.Forms.StatusBar
                $ManagePortProxyStatusBar.Text = "Ready"
                $ManagePortProxyForm.Controls.Add($ManagePortProxyStatusBar)


    $ManagePortProxyForm.ResumeLayout()
    $ManagePortProxyForm.ShowDialog()
}
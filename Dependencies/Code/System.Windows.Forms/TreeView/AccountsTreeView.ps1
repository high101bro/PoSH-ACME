$AccountsTreeViewAdd_Click = {
    Update-TreeViewData -Accounts -TreeView $this.Nodes

    # When the node is checked, it updates various items
    [System.Windows.Forms.TreeNodeCollection]$AllTreeViewNodes = $this.Nodes
    foreach ($root in $AllTreeViewNodes) {
        if ($root.checked) {
            $root.Expand()
            foreach ($Category in $root.Nodes) {
                $Category.Expand()
                foreach ($Entry in $Category.nodes) {
                    $Entry.Checked      = $True
                    $Entry.NodeFont     = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                    $Entry.ForeColor    = [System.Drawing.Color]::FromArgb(0,0,0,224)
                    $Category.NodeFont  = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                    $Category.ForeColor = [System.Drawing.Color]::FromArgb(0,0,0,224)
                    $Root.NodeFont      = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                    $Root.ForeColor     = [System.Drawing.Color]::FromArgb(0,0,0,224)
                }
            }
        }
        foreach ($Category in $root.Nodes) {
            $EntryNodeCheckedCount = 0
            if ($Category.checked) {
                $Category.Expand()
                $Category.NodeFont  = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                $Category.ForeColor = [System.Drawing.Color]::FromArgb(0,0,0,224)
                $Root.NodeFont      = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                $Root.ForeColor     = [System.Drawing.Color]::FromArgb(0,0,0,224)
                foreach ($Entry in $Category.nodes) {
                    $EntryNodeCheckedCount  += 1
                    $Entry.Checked      = $True
                    $Entry.NodeFont     = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                    $Entry.ForeColor    = [System.Drawing.Color]::FromArgb(0,0,0,224)
                }
            }
            if (!($Category.checked)) {
                foreach ($Entry in $Category.nodes) {
                    #if ($Entry.isselected) {
                    if ($Entry.checked) {
                        $EntryNodeCheckedCount  += 1
                        $Entry.NodeFont     = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                        $Entry.ForeColor    = [System.Drawing.Color]::FromArgb(0,0,0,224)
                        $Root.NodeFont      = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                        $Root.ForeColor     = [System.Drawing.Color]::FromArgb(0,0,0,224)
                    }
                    elseif (!($Entry.checked)) {
                        if ($CategoryCheck -eq $False) {$Category.Checked = $False}
                        $Entry.NodeFont     = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                        $Entry.ForeColor    = [System.Drawing.Color]::FromArgb(0,0,0,0)
                    }
                }
            }
            if ($EntryNodeCheckedCount -gt 0) {
                $Category.NodeFont  = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                $Category.ForeColor = [System.Drawing.Color]::FromArgb(0,0,0,224)
                $Root.NodeFont      = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                $Root.ForeColor     = [System.Drawing.Color]::FromArgb(0,0,0,224)
            }
            else {
                $Category.NodeFont  = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                $Category.ForeColor = [System.Drawing.Color]::FromArgb(0,0,0,0)
                $Root.NodeFont      = New-Object System.Drawing.Font("$Font",$($FormScale * 10),1,1,1)
                $Root.ForeColor     = [System.Drawing.Color]::FromArgb(0,0,0,0)
            }
        }
    }
}

$AccountsTreeViewAdd_AfterSelect = {
    Update-TreeViewData -Accounts -TreeView $this.Nodes

    # This will return data on hosts selected/highlight, but not necessarily checked
    [System.Windows.Forms.TreeNodeCollection]$AllTreeViewNodes = $this.Nodes
    foreach ($root in $AllTreeViewNodes) {
        if ($root.isselected) {
            $script:ComputerTreeViewSelected = ""
            $StatusListBox.Items.clear()
            $StatusListBox.Items.Add("Category:  $($root.Text)")
            #Removed For Testing#$ResultsListBox.Items.Clear()
            #$ResultsListBox.Items.Add("- Checkbox this Category to query all its hosts")

            # $script:Section3HostDataNameTextBox.Text = "N/A"
            # $Section3HostDataOSTextBox.Text = "N/A"
            # $Section3HostDataOUTextBox.Text = "N/A"
            # $Section3HostDataIPTextBox.Text = "N/A"
            # $Section3HostDataTags.Text = "N/A"
            # $Section3HostDataNotesRichTextBox.Text = "N/A"

            # Brings the Host Data Tab to the forefront/front view
            $InformationTabControl.SelectedTab   = $Section3HostDataTab
        }
        foreach ($Category in $root.Nodes) {
            if ($Category.isselected) {
                $script:ComputerTreeViewSelected = ""
                $StatusListBox.Items.clear()
                $StatusListBox.Items.Add("Category:  $($Category.Text)")
                #Removed For Testing#$ResultsListBox.Items.Clear()
                #$ResultsListBox.Items.Add("- Checkbox this Category to query all its hosts")

                # The follwing fields are filled out with N/A when host nodes are not selected
                # $script:Section3HostDataNameTextBox.Text = "N/A"
                # $Section3HostDataOSTextBox.Text = "N/A"
                # $Section3HostDataOUTextBox.Text = "N/A"
                # $Section3HostDataIPTextBox.Text = "N/A"
                # $Section3HostDataMACTextBox.Text = "N/A"
                # $Section3HostDataTags.Text = "N/A"
                # $Section3HostDataNotesRichTextBox.Text = "N/A"

                # Brings the Host Data Tab to the forefront/front view
            }
            foreach ($Entry in $Category.nodes) {
                if ($Entry.isselected) {
                    $script:ComputerTreeViewSelected = $Entry.Text
                    # Function Update-HostDataNotes {
                    #     # Populates the Host Data Tab with data from the selected TreeNode
                    #     $script:Section3HostDataNameTextBox.Text = $($script:ComputerTreeViewData | Where-Object {$_.Name -eq $Entry.Text}).Name
                    #     $Section3HostDataOSTextBox.Text   = $($script:ComputerTreeViewData | Where-Object {$_.Name -eq $Entry.Text}).OperatingSystem
                    #     $Section3HostDataOUTextBox.Text   = $($script:ComputerTreeViewData | Where-Object {$_.Name -eq $Entry.Text}).CanonicalName
                    #     $Section3HostDataIPTextBox.Text   = $($script:ComputerTreeViewData | Where-Object {$_.Name -eq $Entry.Text}).IPv4Address
                    #     $Section3HostDataMACTextBox.Text  = $($script:ComputerTreeViewData | Where-Object {$_.Name -eq $Entry.Text}).MACAddress
                    #     $script:Section3HostDataNotesSaveCheck = $Section3HostDataNotesRichTextBox.Text = $($script:ComputerTreeViewData | Where-Object {$_.Name -eq $Entry.Text}).Notes

                    #     $Section3HostDataSelectionComboBox.Text         = "Host Data - Selection"
                    #     $Section3HostDataSelectionDateTimeComboBox.Text = "Host Data - Date & Time"
                    # }
                    <# This provides a prompt to save or not if a different node was selected and data wasn't saved... decided to save automatically instead
                                if ($script:Section3HostDataNotesSaveCheck -ne $Section3HostDataNotesRichTextBox.Text) {
                                    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
                                    $verify = [Microsoft.VisualBasic.Interaction]::MsgBox(`
                                        "Host Data Notes have not been saved!`n`nIf you continue without saving, any`nmodifications will be lost!`n`nDo you want to continue?",`
                                        'YesNo,Question',` #'YesNoCancel,Question',`
                                        "PoSh-EasyWin")
                                    switch ($verify) {
                                    'Yes'{ Update-HostDataNotes }
                                    'No' { $Entry.isselected -eq $true  #... this line isn't working as expected, but isn't causing errors
                                        $StatusListBox.Items.Clear()
                                        $StatusListBox.Items.Add($script:Section3HostDataNameTextBox.Text)
                                        $script:EntrySelected.isselected = $true
                                    }
                                    'Cancel' { continue } #cancel option not needed
                                    }
                                }
                                else { Update-HostDataNotes }
                    #>

                    # Automatically saves the hostdata notes if modified
                    # Save-TreeViewData -Endpoint
                    # Update-HostDataNotes

                    #                    $StatusListBox.Items.Clear()
#                    $StatusListBox.Items.Add($script:Section3HostDataNameTextBox.Text)
#                    $script:EntrySelected.isselected = $true
                }
            }
        }
    }
    $InformationTabControl.SelectedTab = $Section3AccountDataTab
    Display-ContextMenuForAccountsTreeNode -ClickedOnArea
}



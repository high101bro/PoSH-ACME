$Section3QueryExplorationEditCheckBoxAdd_Click = {
    if ($Section3QueryExplorationEditCheckBox.checked){
        $Section3QueryExplorationSaveButton.Text                    = "Save"
        $Section3QueryExplorationSaveButton.ForeColor               = "Red"
        $Section3QueryExplorationDescriptionRichTextbox.ReadOnly    = $false
        $Section3QueryExplorationDescriptionRichTextbox.BackColor   = 'White'
        $Section3QueryExplorationDescriptionRichTextbox.ForeColor   = 'Blue'
        $Section3QueryExplorationWinRSCmdTextBox.ReadOnly           = $false
        $Section3QueryExplorationWinRSCmdTextBox.BackColor          = 'White'
        $Section3QueryExplorationWinRSCmdTextBox.ForeColor          = 'Blue'
        $Section3QueryExplorationWinRSWmicTextBox.ReadOnly          = $false
        $Section3QueryExplorationWinRSWmicTextBox.BackColor         = 'White'
        $Section3QueryExplorationWinRSWmicTextBox.ForeColor         = 'Blue'
        $Section3QueryExplorationPropertiesWMITextBox.ReadOnly      = $false
        $Section3QueryExplorationPropertiesWMITextBox.BackColor     = 'White'
        $Section3QueryExplorationPropertiesWMITextBox.ForeColor     = 'Blue'
        $Section3QueryExplorationPropertiesPoshTextBox.ReadOnly     = $false
        $Section3QueryExplorationPropertiesPoshTextBox.BackColor    = 'White'
        $Section3QueryExplorationPropertiesPoshTextBox.ForeColor    = 'Blue'
        $Section3QueryExplorationRPCWMITextBox.ReadOnly             = $false
        $Section3QueryExplorationRPCWMITextBox.BackColor            = 'White'
        $Section3QueryExplorationRPCWMITextBox.ForeColor            = 'Blue'
        $Section3QueryExplorationRPCPoShTextBox.ReadOnly            = $false
        $Section3QueryExplorationRPCPoShTextBox.BackColor           = 'White'
        $Section3QueryExplorationRPCPoShTextBox.ForeColor           = 'Blue'
        $Section3QueryExplorationWinRMWMITextBox.ReadOnly           = $false
        $Section3QueryExplorationWinRMWMITextBox.BackColor          = 'White'
        $Section3QueryExplorationWinRMWMITextBox.ForeColor          = 'Blue'
        $Section3QueryExplorationWinRMCmdTextBox.ReadOnly           = $false
        $Section3QueryExplorationWinRMCmdTextBox.BackColor          = 'White'
        $Section3QueryExplorationWinRMCmdTextBox.ForeColor          = 'Blue'
        $Section3QueryExplorationWinRMPoShTextBox.ReadOnly          = $false
        $Section3QueryExplorationWinRMPoShTextBox.BackColor         = 'White'
        $Section3QueryExplorationWinRMPoShTextBox.ForeColor         = 'Blue'
        $Section3QueryExplorationTagWordsTextBox.ReadOnly           = $false
        $Section3QueryExplorationTagWordsTextBox.BackColor          = 'White'
        $Section3QueryExplorationTagWordsTextBox.ForeColor          = 'Blue'
        $Section3QueryExplorationSmbPoshTextBox.ReadOnly            = $true
        $Section3QueryExplorationSmbPoshTextBox.BackColor           = 'White'
        $Section3QueryExplorationSmbPoshTextBox.ForeColor           = 'Blue'
        $Section3QueryExplorationSmbWmiTextBox.ReadOnly             = $true
        $Section3QueryExplorationSmbWmiTextBox.BackColor            = 'White'
        $Section3QueryExplorationSmbWmiTextBox.ForeColor            = 'Blue'
        $Section3QueryExplorationSmbCmdTextBox.ReadOnly             = $true
        $Section3QueryExplorationSmbCmdTextBox.BackColor            = 'White'
        $Section3QueryExplorationSmbCmdTextBox.ForeColor            = 'Blue'
        $Section3QueryExplorationSshLinuxTextBox.ReadOnly           = $true
        $Section3QueryExplorationSshLinuxTextBox.BackColor          = 'White'
        $Section3QueryExplorationSshLinuxTextBox.ForeColor          = 'Blue'
    }
    else {
        $Section3QueryExplorationSaveButton.Text                    = "Locked"
        $Section3QueryExplorationSaveButton.ForeColor               = "Green"
        $Section3QueryExplorationDescriptionRichTextbox.ReadOnly    = $true
        $Section3QueryExplorationDescriptionRichTextbox.BackColor   = 'White'
        $Section3QueryExplorationDescriptionRichTextbox.ForeColor   = 'Black'
        $Section3QueryExplorationWinRSCmdTextBox.ReadOnly           = $true
        $Section3QueryExplorationWinRSCmdTextBox.BackColor          = 'White'
        $Section3QueryExplorationWinRSCmdTextBox.ForeColor          = 'Black'
        $Section3QueryExplorationWinRSWmicTextBox.ReadOnly          = $true
        $Section3QueryExplorationWinRSWmicTextBox.BackColor         = 'White'
        $Section3QueryExplorationWinRSWmicTextBox.ForeColor         = 'Black'
        $Section3QueryExplorationPropertiesWMITextBox.ReadOnly      = $true
        $Section3QueryExplorationPropertiesWMITextBox.BackColor     = 'White'
        $Section3QueryExplorationPropertiesWMITextBox.ForeColor     = 'Black'
        $Section3QueryExplorationPropertiesPoshTextBox.ReadOnly     = $true
        $Section3QueryExplorationPropertiesPoshTextBox.BackColor    = 'White'
        $Section3QueryExplorationPropertiesPoshTextBox.ForeColor    = 'Black'
        $Section3QueryExplorationRPCWMITextBox.ReadOnly             = $true
        $Section3QueryExplorationRPCWMITextBox.BackColor            = 'White'
        $Section3QueryExplorationRPCWMITextBox.ForeColor            = 'Black'
        $Section3QueryExplorationRPCPoShTextBox.ReadOnly            = $true
        $Section3QueryExplorationRPCPoShTextBox.BackColor           = 'White'
        $Section3QueryExplorationRPCPoShTextBox.ForeColor           = 'Black'
        $Section3QueryExplorationWinRMWMITextBox.ReadOnly           = $true
        $Section3QueryExplorationWinRMWMITextBox.BackColor          = 'White'
        $Section3QueryExplorationWinRMWMITextBox.ForeColor          = 'Black'
        $Section3QueryExplorationWinRMCmdTextBox.ReadOnly           = $true
        $Section3QueryExplorationWinRMCmdTextBox.BackColor          = 'White'
        $Section3QueryExplorationWinRMCmdTextBox.ForeColor          = 'Black'
        $Section3QueryExplorationWinRMPoShTextBox.ReadOnly          = $true
        $Section3QueryExplorationWinRMPoShTextBox.BackColor         = 'White'
        $Section3QueryExplorationWinRMPoShTextBox.ForeColor         = 'Black'
        $Section3QueryExplorationTagWordsTextBox.ReadOnly           = $true
        $Section3QueryExplorationTagWordsTextBox.BackColor          = 'White'
        $Section3QueryExplorationTagWordsTextBox.ForeColor          = 'Black'
        $Section3QueryExplorationSmbPoshTextBox.ReadOnly            = $true
        $Section3QueryExplorationSmbPoshTextBox.BackColor           = 'White'
        $Section3QueryExplorationSmbPoshTextBox.ForeColor           = 'Black'
        $Section3QueryExplorationSmbWmiTextBox.ReadOnly             = $true
        $Section3QueryExplorationSmbWmiTextBox.BackColor            = 'White'
        $Section3QueryExplorationSmbWmiTextBox.ForeColor            = 'Black'
        $Section3QueryExplorationSmbCmdTextBox.ReadOnly             = $true
        $Section3QueryExplorationSmbCmdTextBox.BackColor            = 'White'
        $Section3QueryExplorationSmbCmdTextBox.ForeColor            = 'Black'
        $Section3QueryExplorationSshLinuxTextBox.ReadOnly           = $true
        $Section3QueryExplorationSshLinuxTextBox.BackColor          = 'White'
        $Section3QueryExplorationSshLinuxTextBox.ForeColor          = 'Black'
    }
}


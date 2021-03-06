$script:QueryRegistryFunction = {
    function Search-Registry {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
            [Alias("PsPath")]
            # Registry path to search
            $Path,
            # Specifies whether or not all subkeys should also be searched
            [switch] $Recurse,
            [Parameter(ParameterSetName="SingleSearchString", Mandatory)]
            # A regular expression that will be checked against key names, value names, and value data (depending on the specified switches)
            $SearchRegex,
            [Parameter(ParameterSetName="SingleSearchString")]
            # When the -SearchRegex parameter is used, this switch means that key names will be tested (if none of the three switches are used, keys will be tested)
            [switch] $KeyName,
            [Parameter(ParameterSetName="SingleSearchString")]
            # When the -SearchRegex parameter is used, this switch means that the value names will be tested (if none of the three switches are used, value names will be tested)
            [switch] $ValueName,
            [Parameter(ParameterSetName="SingleSearchString")]
            # When the -SearchRegex parameter is used, this switch means that the value data will be tested (if none of the three switches are used, value data will be tested)
            [switch] $ValueData
        )

        begin {
            switch ($PSCmdlet.ParameterSetName) {
                SingleSearchString {
                    $NoSwitchesSpecified = -not ($PSBoundParameters.ContainsKey("KeyName") -or $PSBoundParameters.ContainsKey("ValueName") -or $PSBoundParameters.ContainsKey("ValueData"))
                    if ($KeyName   -or $NoSwitchesSpecified) { $KeyNameRegex   = $SearchRegex }
                    if ($ValueName -or $NoSwitchesSpecified) { $ValueNameRegex = $SearchRegex }
                    if ($ValueData -or $NoSwitchesSpecified) { $ValueDataRegex = $SearchRegex }
                }
                MultipleSearchStrings {
                    # No extra work needed
                }
            }
        }

        process {
            $SearchRegexFound = @()
            foreach ($CurrentPath in $Path) {
                Get-ChildItem $CurrentPath -Recurse:$Recurse |
                ForEach-Object {
                    $Key = $_
                    if ($KeyNameRegex) {
                        foreach ($Regex in $KeyNameRegex) {
                            if ($Key.PSChildName -match $Regex) {
                                $SearchRegexFound += [PSCustomObject] @{
                                    SearchTerm = $Regex
                                    Key        = $Key
                                    KeyName    = $Key.PSChildName
                                    Reason     = "KeyName"
                                }
                            }
                        }
                    }

                    if ($ValueNameRegex) {
                        foreach ($Regex in $ValueNameRegex) {
                            if ($Key.GetValueNames() -match $Regex) {
                                $SearchRegexFound += [PSCustomObject] @{
                                    SearchTerm = $Regex
                                    Key        = $Key
                                    ValueName  = $Key.GetValueNames()
                                    Reason     = "ValueName"
                                }
                            }
                        }
                    }

                    if ($ValueDataRegex) {
                        foreach ($Regex in $ValueDataRegex) {
                            $ValueDataKey = ($Key.GetValueNames() | % { $Key.GetValue($_) })
                            if ($ValueDataKey -match $Regex) {
                                $SearchRegexFound += [PSCustomObject] @{
                                    SearchTerm = $Regex
                                    Key        = $Key
                                    ValueData  = $ValueDataKey
                                    Reason     = "ValueData"
                                }
                            }
                        }
                    }
                }
            }
            Return $SearchRegexFound
        }
    }

    Search-Registry -Path $args[0] -Recurse:$args[1] -SearchRegex $args[2] -KeyName:$args[3] -ValueName:$args[4] -ValueData:$args[5] -ErrorAction SilentlyContinue
}


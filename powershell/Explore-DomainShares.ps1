function Explore-DomainShares {
    $searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]"")
    $searcher.Filter = '(objectClass=computer)'
    $computers = @($searcher.FindAll() | ForEach-Object { $_.Properties.name })

    foreach ($computer in $computers) {
        Write-Host "`nChecking shares on $computer"

        # Execute net view on the computer
        try {
            $netViewOutput = net view \\$computer /all 2>&1
            # Write-Host "Shares on ${computer}:"
            $netViewOutput | Where-Object { $_ -match '\w' } | ForEach-Object { Write-Host "`t$_" }

            # Process each share listed in the net view output
            $netViewOutput | Where-Object { $_ -match '^(\S+)\s+Disk' } | ForEach-Object {
                $shareName = $matches[1]
                $sharePath = "\\$computer\$shareName"

                # Attempt to list the contents of the share
                try {
                    $contents = Get-ChildItem $sharePath -ErrorAction Stop
                    Write-Host "`nContents of ${sharePath}:"
                    foreach ($item in $contents) {
                        Write-Host "`t$item"
                    }
                } catch {
                    
                }
            }
        } catch {
            
        }
    }
}

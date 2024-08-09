function Find-CShares {
    # Creating an ADSI searcher object to find all computers in the domain
    $searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]"")
    $searcher.Filter = '(objectClass=computer)'
    $computers = @($searcher.FindAll() | ForEach-Object { $_.Properties.name })

    $accessibleComputers = @()
    $deniedComputers = @()

    foreach ($computer in $computers) {
        # Check if the C$ share is accessible
        $path = "\\$computer\C$"
        try {
            # Attempt to list the contents of the C$ share
            Get-ChildItem $path -ErrorAction Stop | Out-Null
            # If successful, add to the accessible list
            $accessibleComputers += $computer
        } catch {
            # If an error occurs, assume access is denied
            $deniedComputers += $computer
        }
    }

    # Output the results
    Write-Host "Accessible Computers:"
    foreach ($comp in $accessibleComputers) {
        Write-Host $comp
    }

    Write-Host "`nAccess Denied Computers:"
    foreach ($comp in $deniedComputers) {
        Write-Host $comp
    }
}

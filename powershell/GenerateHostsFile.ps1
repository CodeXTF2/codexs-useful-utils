function GenerateHostsFile {
    # Creating an ADSI searcher object to find all computers in the domain
    $searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]"")
    $searcher.Filter = '(objectClass=computer)'
    $searcher.PropertiesToLoad.Add("dNSHostName") | Out-Null
    $computers = @($searcher.FindAll())

    foreach ($result in $computers) {
        $hostname = $result.Properties.dnshostname[0]
        $ip = [System.Net.Dns]::GetHostAddresses($hostname) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -ExpandProperty IPAddressToString -First 1
        if ($ip) {
            # Output in hosts file format
            Write-Host "$ip`t$hostname"
        }
    }
}

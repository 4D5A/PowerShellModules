function Get-ExternalIP {
    <#
        .Synopsis
            Gets the current external IP address.
        
        .Description
            Gets the current external IP address.

        .Notes
            N/A
            
        .Example
            Get-ExternalIP
    #>
    $site = "http://checkip.dyndns.com/"
    $beginbrowser = new-object System.Net.WebClient
    $get = $beginbrowser.downloadString($site)
    $lines = $get.split("`n")
    foreach ($line in $lines) {
        if ($line.contains("<html><head><title>Current IP Check</title></head><body>Current IP Address: ")) {
            $ip = $line.replace("<html><head><title>Current IP Check</title></head><body>Current IP Address: ", "").replace("</body></html>","")
        }
    }
    $ip
    $ip | Set-Content ("$HOME\Desktop\ExternalIP.txt")
}
﻿# INPUT
#     $serviceTierFolder
#     $licenseFile (optional)
#     $runningSpecificImage (optional)
#
# OUTPUT
#

if ($restartingInstance) {

    # Nothing to do

} else {
    $licenseOk = $false
    if ($licensefile -eq "") {

        if ($runningSpecificImage) { 
            $licenseOk = $true
        }

        if ($databaseServer -ne "localhost") {
            $licenseOk = $true
        }

        if ($licenseOk) {
            Write-Host "Using existing license file"
        } else {
            Write-Host "Use CRONUS license file"
            $licensefile = "$ServiceTierFolder\Cronus.flf"
        }

    } else {
        if ($licensefile.StartsWith("https://") -or $licensefile.StartsWith("http://"))
        {
            $licensefileurl = $licensefile
            $licensefile = (Join-Path $runPath "license.flf")
            Write-Host "Downloading license file '$licensefileurl'"
            (New-Object System.Net.WebClient).DownloadFile($licensefileurl, $licensefile)
        } else {
            Write-Host "Using license file '$licensefile'"
            if (!(Test-Path -Path $licensefile -PathType Leaf)) {
            	Write-Error "ERROR: License File not found."
                Write-Error "The file must be uploaded to the container or available on a share."
                exit 1
            }
        }
    }
    
    if (!$licenseOk) {
        Write-Host "Import NAV License"
        Import-NAVServerLicense -LicenseFile $licensefile -ServerInstance 'NAV' -Database NavDatabase -WarningAction SilentlyContinue
    }
}

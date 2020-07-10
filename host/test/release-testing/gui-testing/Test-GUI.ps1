function Start-SDSAndWait {
    Param (
        [Parameter(Mandatory = $false)][int]$seconds
    )
    # Set-Location $SDSRootDir isneeded to resolve the ddl issue when running
    # HCS seperetly so that Windows will look into this directory for dlls
    Set-Location "C:\Program Files\ON Semiconductor\Strata Developer Studio"


    Start-Process -FilePath "Strata Developer Studio" -WindowStyle Maximized
    if ($seconds) {
        Start-Sleep -Seconds 1
    }
    Set-Location "C:\Users\SEC\Dev2\spyglass\host\test\release-testing"
}
function Start-HCS {
    # Set-Location $SDSRootDir is needed to resolve the ddl issue when running
    # HCS seperetly so that Windows will look into this directory for dlls
    Set-Location "C:\Program Files\ON Semiconductor\Strata Developer Studio"
        Start-Sleep -Seconds 1

    Start-Process -FilePath "hcs" -ArgumentList "-f `"\HCS\hcs.config`""
    Set-Location $TestRoot
}

function Test-Gui() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)][string]$PythonScriptPath,    # Path to control-view-test.py
        [Parameter(Mandatory = $true)][string]$StrataPath           # Path to Strata executable
    )

    $DPISetting = (Get-ItemProperty 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name AppliedDPI).AppliedDPI
    switch ($DPISetting)
    {
        96 {$ActualDPI = 100}
        120 {$ActualDPI = 125}
        144 {$ActualDPI = 150}
        192 {$ActualDPI = 200}
    }
    Write-Host "Screen DPI is " $ActualDPI

    #Run basic test cases
    #Start-SDSAndWait -seconds 5
#    If (Get-Process -Name "hcs" -ErrorAction SilentlyContinue) {
#        Stop-Process -Name "hcs" -Force
#        Start-Sleep -Seconds 1
#    }
    Start-SDSAndWait
    Start-Process "python" -ArgumentList "`"C:\Users\SEC\Dev2\spyglass\host\test\release-testing\gui-testing\main.py`"", "`"C:\Program Files\ON Semiconductor\Strata Developer Studio\Strata Developer Studio.exe`"", $ActualDPI -NoNewWindow -PassThru -Wait
    Stop-Process -Name "Strata Developer Studio" -Force
    #Run tests without network
    New-NetFirewallRule -DisplayName "TEMP_Disable_SDS_Network" -Direction Outbound -Program "C:\Program Files\ON Semiconductor\Strata Developer Studio\Strata Developer Studio.exe" -Action Block
    Start-SDSAndWait -seconds 1
    Start-Process "python" -ArgumentList "C:\Users\SEC\Dev2\spyglass\host\test\release-testing\gui-testing\main_no_network.py" -NoNewWindow -PassThru -Wait

    Stop-Process -Name "Strata Developer Studio" -Force
    Remove-NetFirewallRule -DisplayName "TEMP_Disable_SDS_Network"

#    Test logging in, closing strata, and reopening it
    #Login to strata
    Start-SDSAndWait -seconds 1
    Start-Process "python" -ArgumentList "C:\Users\SEC\Dev2\spyglass\host\test\release-testing\gui-testing\main_login_test_pre.py" -NoNewWindow -PassThru -Wait

    Stop-Process -Name "Strata Developer Studio" -Force

    #Test for Strata automatically going to the platform view
    Start-SDSAndWait -seconds 1
    Start-Process "python" -ArgumentList "C:\Users\SEC\Dev2\spyglass\host\test\release-testing\gui-testing\main_login_test_post.py" -NoNewWindow -PassThru -Wait

    Stop-Process -Name "Strata Developer Studio" -Force

}
Test-Gui -PythonScriptPath="main.py" -StrataPath="C:\Program Files\ON Semiconductor\Strata Developer Studio"
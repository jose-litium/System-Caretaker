Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to retrieve active processes
function GetActiveProcesses {
    $processes = Get-Process | Select-Object -Property Id, ProcessName, CPU, MainWindowTitle
    return $processes
}

# Function to flush DNS cache
function FlushDNS {
    Write-Output "Flushing DNS cache..."
    $flushResult = ipconfig /flushdns 2>&1
    if ($flushResult -match "Se vació correctamente la caché de resolución de DNS") {
        Write-Output "DNS cache flushed successfully."
        return "DNS cache flushed successfully."
    } elseif ($flushResult -match "Error") {
        Write-Output "Error flushing DNS cache: $flushResult"
        return "Error flushing DNS cache: $flushResult"
    } else {
        Write-Output "Unexpected result: $flushResult"
        return "Unexpected result: $flushResult"
    }
}

# Function to clean temporary files
function CleanTempFiles {
    Write-Output "Cleaning temporary files..."
    $tempFolder = "$env:TEMP"
    $totalDeleted = 0
    $errors = 0
    try {
        $files = Get-ChildItem -Path $tempFolder -Recurse -Force -ErrorAction Stop | Where-Object { !$_.PSIsContainer }
        foreach ($file in $files) {
            try {
                Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                $totalDeleted += $file.Length
            } catch {
                Write-Output "Cannot delete temporary file: $($file.FullName). It is being used by another process."
                $errors++
            }
        }
        $totalDeletedMB = [math]::Round($totalDeleted / 1MB, 2)
        Write-Output "Temporary files cleaned. Total data deleted: $totalDeletedMB MB."
        return "Temporary files cleaned. Deleted $totalDeletedMB MB with $errors errors."
    } catch {
        Write-Output "Error cleaning temporary files: $_"
        return "Error cleaning temporary files: $_"
    }
}

# Function to disable non-essential services
function DisableServices {
    Write-Output "Disabling non-essential services..."
    $servicesToDisable = @("AdobeARMservice", "Bonjour Service")  # Ejemplos de servicios no esenciales
    $disabledCount = 0
    foreach ($service in $servicesToDisable) {
        try {
            $svc = Get-Service -Name $service -ErrorAction Stop
            $svc | Set-Service -StartupType Disabled -ErrorAction Stop
            Write-Output "Service '$service' disabled."
            $disabledCount++
        } catch {
            Write-Output "Cannot disable service '$service': $_"
        }
    }
    if ($disabledCount -gt 0) {
        return "Non-essential services disabled."
    } else {
        return "No non-essential services disabled."
    }
}

# Function to close all unnecessary applications
function CloseUnnecessaryApplications {
    Write-Output "Closing unnecessary applications..."
    $currentProcess = Get-Process -Id $PID
    $processesToClose = Get-Process | Where-Object { $_.MainWindowTitle -ne "" -and $_.ProcessName -ne $currentProcess.ProcessName }  # Exclude the current script process
    foreach ($process in $processesToClose) {
        Write-Output "Closing process: $($process.ProcessName) (PID: $($process.Id))"
        $process | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    Write-Output "Unnecessary applications closed."
    return "Unnecessary applications closed."
}

# Function to automate all actions
function AutomateAllActions {
    $actionsPerformed = @()
    $actionsPerformed += FlushDNS
    $actionsPerformed += CleanTempFiles
    $actionsPerformed += DisableServices
    $actionsPerformed += CloseUnnecessaryApplications
    return $actionsPerformed
}

# Define the GUI form
$form = New-Object System.Windows.Forms.Form
$form.Text = "System Maintenance"
$form.Size = New-Object System.Drawing.Size(900, 700)  # Aumento del tamaño vertical para dar más espacio a los botones y resultados
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Create a group box for actions
$groupBoxActions = New-Object System.Windows.Forms.GroupBox
$groupBoxActions.Text = "Select actions to perform"
$groupBoxActions.Location = New-Object System.Drawing.Point(50, 20)
$groupBoxActions.Size = New-Object System.Drawing.Size(800, 200)
$form.Controls.Add($groupBoxActions)

# Create checkboxes for actions
$checkBoxFlushDNS = New-Object System.Windows.Forms.CheckBox
$checkBoxFlushDNS.Text = "Flush DNS Cache"
$checkBoxFlushDNS.Location = New-Object System.Drawing.Point(20, 30)
$checkBoxFlushDNS.Size = New-Object System.Drawing.Size(200, 20)
$groupBoxActions.Controls.Add($checkBoxFlushDNS)

$checkBoxCleanTempFiles = New-Object System.Windows.Forms.CheckBox
$checkBoxCleanTempFiles.Text = "Clean Temporary Files"
$checkBoxCleanTempFiles.Location = New-Object System.Drawing.Point(20, 60)
$checkBoxCleanTempFiles.Size = New-Object System.Drawing.Size(200, 20)
$groupBoxActions.Controls.Add($checkBoxCleanTempFiles)

$checkBoxDisableServices = New-Object System.Windows.Forms.CheckBox
$checkBoxDisableServices.Text = "Disable Non-essential Services"
$checkBoxDisableServices.Location = New-Object System.Drawing.Point(20, 90)
$checkBoxDisableServices.Size = New-Object System.Drawing.Size(200, 20)
$groupBoxActions.Controls.Add($checkBoxDisableServices)

# Create a list box for results
$listBoxResults = New-Object System.Windows.Forms.ListBox
$listBoxResults.Location = New-Object System.Drawing.Point(50, 240)
$listBoxResults.Size = New-Object System.Drawing.Size(800, 340)  # Aumento del tamaño vertical para mostrar más resultados
$listBoxResults.Font = New-Object System.Drawing.Font("Consolas", 9)
$listBoxResults.BackColor = [System.Drawing.Color]::White
$listBoxResults.ForeColor = [System.Drawing.Color]::Black
$listBoxResults.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$form.Controls.Add($listBoxResults)

# Create a button to perform actions
$buttonPerform = New-Object System.Windows.Forms.Button
$buttonPerform.Location = New-Object System.Drawing.Point(50, 600)  # Ajuste hacia abajo para centrar mejor con la altura del formulario
$buttonPerform.Size = New-Object System.Drawing.Size(100, 30)
$buttonPerform.Text = "Perform"
$buttonPerform.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonPerform.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$buttonPerform.ForeColor = [System.Drawing.Color]::White
$buttonPerform.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$buttonPerform.Add_Click({
    $listBoxResults.Items.Clear()
    $reportLines = @()

    # Ejecutar las acciones seleccionadas
    if ($checkBoxFlushDNS.Checked) {
        $listBoxResults.Items.Add("Performing: Flush DNS Cache")
        $result = FlushDNS
        $listBoxResults.Items.Add($result)
        $reportLines += "Flush DNS Cache: $result"
    }
    if ($checkBoxCleanTempFiles.Checked) {
        $listBoxResults.Items.Add("Performing: Clean Temporary Files")
        $result = CleanTempFiles
        $listBoxResults.Items.Add($result)
        $reportLines += "Clean Temporary Files: $result"
    }
    if ($checkBoxDisableServices.Checked) {
        $listBoxResults.Items.Add("Performing: Disable Non-essential Services")
        $result = DisableServices
        $listBoxResults.Items.Add($result)
        $reportLines += "Disable Non-essential Services: $result"
    }

    # Guardar reporte
    $reportPath = Join-Path -Path $PSScriptRoot -ChildPath "report.txt"
    $reportLines | Out-File -FilePath $reportPath -Encoding UTF8

    $listBoxResults.Items.Add("Actions completed. Report saved to $reportPath.")
})
$form.Controls.Add($buttonPerform)

# Create a button to close the form
$buttonClose = New-Object System.Windows.Forms.Button
$buttonClose.Location = New-Object System.Drawing.Point(200, 600)  # Ajuste hacia abajo para centrar mejor con la altura del formulario
$buttonClose.Size = New-Object System.Drawing.Size(100, 30)
$buttonClose.Text = "Close"
$buttonClose.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonClose.BackColor = [System.Drawing.Color]::FromArgb(192, 0, 0)
$buttonClose.ForeColor = [System.Drawing.Color]::White
$buttonClose.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$buttonClose.Add_Click({
    $form.Close()
})
$form.Controls.Add($buttonClose)

# Create a button to close unnecessary applications
$buttonCloseApps = New-Object System.Windows.Forms.Button
$buttonCloseApps.Location = New-Object System.Drawing.Point(350, 600)  # Ajuste hacia abajo para centrar mejor con la altura del formulario
$buttonCloseApps.Size = New-Object System.Drawing.Size(180, 30)
$buttonCloseApps.Text = "Close Unnecessary Apps"
$buttonCloseApps.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonCloseApps.BackColor = [System.Drawing.Color]::FromArgb(40, 167, 69)
$buttonCloseApps.ForeColor = [System.Drawing.Color]::White
$buttonCloseApps.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$buttonCloseApps.Add_Click({
    $listBoxResults.Items.Clear()
    $result = CloseUnnecessaryApplications
    $listBoxResults.Items.Add($result)
    $reportLines += "Close Unnecessary Applications: $result"

    # Guardar reporte
    $reportPath = Join-Path -Path $PSScriptRoot -ChildPath "report.txt"
    $reportLines | Out-File -FilePath $reportPath -Encoding UTF8

    $listBoxResults.Items.Add("Actions completed. Report saved to $reportPath.")
})
$form.Controls.Add($buttonCloseApps)

# Create a button to automate all actions
$buttonAutomateAll = New-Object System.Windows.Forms.Button
$buttonAutomateAll.Location = New-Object System.Drawing.Point(560, 600)  # Ajuste hacia abajo para centrar mejor con la altura del formulario
$buttonAutomateAll.Size = New-Object System.Drawing.Size(180, 30)
$buttonAutomateAll.Text = "Automate All"
$buttonAutomateAll.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$buttonAutomateAll.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$buttonAutomateAll.ForeColor = [System.Drawing.Color]::White
$buttonAutomateAll.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$buttonAutomateAll.Add_Click({
    $listBoxResults.Items.Clear()
    $actionsResults = AutomateAllActions
    $actionsResults | ForEach-Object { $listBoxResults.Items.Add($_) }
    $reportLines += $actionsResults

    # Guardar reporte
    $reportPath = Join-Path -Path $PSScriptRoot -ChildPath "report.txt"
    $reportLines | Out-File -FilePath $reportPath -Encoding UTF8

    $listBoxResults.Items.Add("Actions completed. Report saved to $reportPath.")
})
$form.Controls.Add($buttonAutomateAll)

# Run the GUI
$form.Add_Shown({ $form.Activate() })
[void] $form.ShowDialog()

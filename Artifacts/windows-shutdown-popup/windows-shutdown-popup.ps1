Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
 
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function timer{
if ($time -le $max)
{
    #start-sleep 1
    #write-host = ($time*100/$max)
    $objProgressBar.Value = ($time*100/$max)
    $script:time+=1
    $form.Refresh()
    if ($script:time -eq $max){
        shutdown -s -f -t 0
    }
}
else {
    $timer.enabled = $false
}
}

function Hide-Console {
    $consolePtr = [Console.Window]::GetConsoleWindow()
  #0 hide
 [Console.Window]::ShowWindow($consolePtr, 0)
}
Hide-Console
 
#Temps d'attente
    $max = 3600

#Créer une fenetre
    $form = New-Object System.Windows.Forms.Form 
    $form.Text = "Temps restant"
    $form.Size = New-Object System.Drawing.Size(250,55)
    $Form.FormBorderStyle = 'FixedDialog' 
    $form.StartPosition = "CenterScreen"
    $Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
    $form.Icon = $Icon
    $form.Topmost = $True

#empeche de fermer la fenetre
    $form.Add_Closing({$_.Cancel = $true})
    $form.MaximizeBox = $false 
    $form.MinimizeBox = $false


#Bar de progression
    $objProgressBar = New-Object System.Windows.Forms.ProgressBar
    $objProgressBar.Maximum = 100
    $objProgressBar.Minimum = 0
    $time = 0
    $objProgressBar.Location = New-Object System.Drawing.Size(6,5)
    $objProgressBar.Size = New-Object System.Drawing.Size(185,20) 
    $form.Controls.Add($objProgressBar)

# Button
    $btnConfirm = new-object System.Windows.Forms.Button
    $btnConfirm.Location = new-object System.Drawing.Size(198,5)
    $btnConfirm.Size = new-object System.Drawing.Size(42,20)
    $btnConfirm.Text = "Reset"
    $Form.Controls.Add($btnConfirm)


#timer
    $timer = New-Object System.Windows.Forms.Timer 
    $timer.Interval = 1000
    $timer.add_Tick({timer})
    $timer.Enabled = $true
    $timer.Start()


#Action button
    $btnConfirm.Add_Click({
        $script:time = 0
    
    })


$form.Add_Shown({$form.Activate()})
$form.ShowDialog()

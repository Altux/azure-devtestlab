Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms
Add-Type @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace PInvoke.Win32 {

    public static class UserInput {

        [DllImport("user32.dll", SetLastError=false)]
        private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

        [StructLayout(LayoutKind.Sequential)]
        private struct LASTINPUTINFO {
            public uint cbSize;
            public int dwTime;
        }

        public static DateTime LastInput {
            get {
                DateTime bootTime = DateTime.UtcNow.AddMilliseconds(-Environment.TickCount);
                DateTime lastInput = bootTime.AddMilliseconds(LastInputTicks);
                return lastInput;
            }
        }

        public static TimeSpan IdleTime {
            get {
                return DateTime.UtcNow.Subtract(LastInput);
            }
        }

        public static int LastInputTicks {
            get {
                LASTINPUTINFO lii = new LASTINPUTINFO();
                lii.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
                GetLastInputInfo(ref lii);
                return lii.dwTime;
            }
        }
    }
}
'@
# Extract icon from PowerShell to use as the NotifyIcon
$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$pshome\powershell.exe")

# Create XAML form in Visual Studio, ensuring the ListView looks chromeless
[xml]$xaml =  '<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Window" ShowInTaskbar="False" WindowStyle="None" ResizeMode="NoResize" Background="#313130" HorizontalAlignment="Center" VerticalAlignment="Center" WindowState="Maximized" >
    <Window.Resources>
        <Style TargetType="GridViewColumnHeader">
            <Setter Property="Background" Value="Transparent" />
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderBrush" Value="Transparent"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="GridViewColumnHeader">
                        <Border Background="#313130">
                            <ContentPresenter></ContentPresenter>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="MyButtonStyle" TargetType="Button">
            <Setter Property="OverridesDefaultStyle" Value="True"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Name="border" 
                            BorderThickness="1"
                            Padding="4,2" 
                            BorderBrush="#FF575757" 
                            Background="{TemplateBinding Background}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" />
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="border" Property="BorderBrush" Value="white" />
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
   
        
    <Grid Name="grid" Background="Black" Height="100">
    <Grid Name="grid2" Background="Black" Height="100" Width="400">
        <Label Name="label" Content="Time before Shutdown:" Foreground="White" FontSize="18" Margin="10,10,0,15"/>
        <ProgressBar Name="ProgressBar" Margin="10,60,100,35" Cursor="None" Foreground="#FF066AB0"/>
            <Button Style="{StaticResource MyButtonStyle}" Name="Button" Content="Cancel" Margin="310,50,10,20" Background="#FF505050" Foreground="White" BorderBrush="#FF575757" FontFamily="Segoe UI Semibold" FontSize="15"/>
        </Grid>
    </Grid>
        
        
</Window>
'

# Turn XAML into PowerShell objects
$window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
$xaml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name ($_.Name) -Value $window.FindName($_.Name) -Scope Script }

$max = 2400
$global:state = $false

function timer{
if ($time -le $max)
{
    if ($script:time -eq $max){
        $window.close()
        shutdown -s -f -t 0
    }
    $idle_time = [PInvoke.Win32.UserInput]::IdleTime;
	if ($idle_time -gt $idle_timeout) {
        $window.show()
        $window.Activate()
        $global:state = $true
    }
    if ($global:state -eq $true){
        $ProgressBar.Value = ($time*100/$max)
        $script:time+=0.5
    }
}
else {
    $timer.enabled = $false
}
}


# ProgressBar
$ProgressBar.Maximum = 100
$ProgressBar.Minimum = 0
$ProgressBar.value = 50

#Timer
$timer = New-Object System.Windows.Forms.Timer 
$timer.Interval = 500
$timer.add_Tick({timer})
$timer.Enabled = $true
$timer.Start()

# Reset Button
$Button.Add_Click(
{
    $window.Hide()
    $script:time=0
    $global:state = $false
}
)

#Activate
$idle_timeout = New-TimeSpan -Minutes 20
$state = $false

# Make PowerShell Disappear
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)

# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()

$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)
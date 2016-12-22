workflow Deallocated-Worflow
{
    #Connection
    $Conn = Get-AutomationConnection -Name AzureRunAsConnection
    Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

    #Get AzureVM Status
    $vms = InlineScript {
            Get-AzureRmVm | Get-AzureRmVm -Status | select ResourceGroupName, Name, @{n="Status"; e={$_.Statuses[1].DisplayStatus}}
        }

    #Deallocated VM Stopped
    foreach -parallel ($VM in $vms)
    {
        if($vm.Status -eq "VM stopped"){
            $VM.Name + " is being shut down." 
            Stop-AzureRmVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force   
        }
    }
    write-output "workflow Finished"       
}

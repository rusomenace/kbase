get-vm | Get-VMResourceConfiguration | `
         Select VM -ExpandProperty DiskResourceConfiguration | `
         where {$_.DiskLimitIOPerSecond -gt 0} | `
         Select VM, DiskLimitIOPerSecond
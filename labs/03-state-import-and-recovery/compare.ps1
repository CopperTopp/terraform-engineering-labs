$curStateJson = terraform state pull
$prevStateFile = Join-Path $env:TEMP "terraform-state-recovery\lab03-previous.tfstate"

$curState = $curStateJson | ConvertFrom-Json

$prevState = Get-Content $prevStateFile -Raw | ConvertFrom-Json

Write-Host "=== Compare Lineage and Serial Number of State Files"
@(
  [PSCustomObject]@{
    Snapshot = "Current"
    Lineage = $curState.Lineage
    Serial = $curState.Serial
  }
  [PSCustomObject]@{
    Snapshot = "Previous"
    Lineage = $prevState.Lineage
    Serial = $prevState.Serial
  }
) | Format-Table -AutoSize

Write-Host "=== Compare Resources"
$resCompare = foreach ($snapshot in @(
    @{ 
      Label = "Previous"
      State = $prevState
    }
    @{ 
      Label = "Current"
      State = $curState
    }
  )
) {
  foreach ($resource in $snapshot.State.Resources) {
    foreach ($instance in $resource.Instances) {
      [PSCustomObject]@{
        Snapshot = $snapshot.Label
        Resource = "$($resource.Type).$($resource.name)"
        ID = $instance.Attributes.Id
      }
    }
  }
}

$resCompare | Sort-Object Resource, Snapshot | Format-Table -AutoSize

Write-Host "=== Compare Recorded File Attributes"

foreach ($snapshot in @(
  @{
    Label = "Previous"
    State = $prevState
  }
  @{
    Label = "Current"
    State = $curState
  }
)) {
  $resource = $snapshot.State.Resources |
    Where-Object {
      $_.Type -eq "local_file" -and $_.Name -eq "drift_demo"
    }

  foreach ($instance in $resource.Instances) {
    [PSCustomObject]@{
      Snapshot = $snapshot.Label
      Filename = $instance.Attributes.Filename
      Content  = $instance.Attributes.Content
      ID = $instance.Attributes.Id 
    } | Format-List
  }
}
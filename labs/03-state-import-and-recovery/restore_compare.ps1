$remoteJson = terraform state pull
if ($LASTEXITCODE -ne 0) { throw "State pull failed." }

$remoteState = $remoteJson | ConvertFrom-Json
$recoveryState = Get-Content $recoveryFile -Raw | ConvertFrom-Json

foreach ($snapshot in @(
    @{ Label = "Remote"; State = $remoteState }
    @{ Label = "Recovery"; State = $recoveryState }
)) {
    $file = $snapshot.State.resources |
        Where-Object {
            $_.type -eq "local_file" -and $_.name -eq "drift_demo"
        }

    [pscustomobject]@{
        Snapshot = $snapshot.Label
        Lineage  = $snapshot.State.lineage
        Serial   = $snapshot.State.serial
        Content  = $file.instances[0].attributes.content
        ID       = $file.instances[0].attributes.id
    } | Format-List
}
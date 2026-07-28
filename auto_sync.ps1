# auto_sync.ps1
# This script monitors the current directory and pushes changes to GitHub every 5 minutes.

Write-Host "Starting Auto-Sync for Connect AI..." -ForegroundColor Green
Write-Host "Target: https://github.com/kimtyy/memory.git" -ForegroundColor Cyan

while($true) {
    $changes = git status --porcelain
    if ($changes) {
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Changes detected. Syncing..." -ForegroundColor Yellow
        git add .
        git commit -m "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git push origin main
        Write-Host "Sync complete." -ForegroundColor Green
    } else {
        # No changes, just wait
    }
    Start-Sleep -Seconds 300 # Wait for 5 minutes
}

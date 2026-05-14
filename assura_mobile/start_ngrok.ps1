# start_ngrok.ps1
# This script starts ngrok for the backend and updates the Flutter app's base URL.

$BackendPort = 5000
$FlutterConstantsPath = "d:\System Street\Assura\coding\assuramobile\assura_mobile\lib\core\constants\app_constants.dart"

Write-Host "Checking ngrok status..." -ForegroundColor Cyan

# Check if ngrok is already running
$tunnels = $null
try {
    $tunnels = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -ErrorAction SilentlyContinue
} catch {
    # Not running
}

if ($null -eq $tunnels) {
    Write-Host "Ngrok is not running. Starting ngrok on port $BackendPort..." -ForegroundColor Yellow
    # Start ngrok in a new window
    Start-Process npx -ArgumentList "ngrok http $BackendPort" -WindowStyle Minimized
    
    # Wait for ngrok to initialize
    Write-Host "Waiting for ngrok to initialize..."
    Start-Sleep -Seconds 5
    
    try {
        $tunnels = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels"
    } catch {
        Write-Host "Error: Could not start ngrok or access local API." -ForegroundColor Red
        exit 1
    }
}

$PublicUrl = $tunnels.tunnels[0].public_url
Write-Host "Ngrok is live at: $PublicUrl" -ForegroundColor Green

# Update Flutter AppConstants
if (Test-Path $FlutterConstantsPath) {
    Write-Host "Updating Flutter constants at $FlutterConstantsPath..." -ForegroundColor Cyan
    $content = Get-Content $FlutterConstantsPath
    $newContent = $content -replace "static const String apiBaseUrl = '.*';", "static const String apiBaseUrl = '$PublicUrl';"
    $newContent | Set-Content $FlutterConstantsPath
    Write-Host "Successfully updated apiBaseUrl to $PublicUrl" -ForegroundColor Green
} else {
    Write-Host "Warning: Could not find $FlutterConstantsPath" -ForegroundColor Red
}

Write-Host "Setup complete! You can now run your Flutter app." -ForegroundColor White

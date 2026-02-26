# Image Resizing Script for Jeebz Bag Design App
# Resizes app icon to 100x100 and reduces splash logo width by 40px (20px each side)

Add-Type -AssemblyName System.Drawing

$imagesPath = "C:\Users\shobuj\StudioProjects\jeebz_bag_design_app\assets\images"

# Function to resize image
function Resize-Image {
    param(
        [string]$InputPath,
        [string]$OutputPath,
        [int]$Width,
        [int]$Height
    )
    
    try {
        # Load the original image
        $originalImage = [System.Drawing.Image]::FromFile($InputPath)
        
        Write-Host "Original size: $($originalImage.Width)x$($originalImage.Height)"
        
        # Create a new bitmap with the desired size
        $newImage = New-Object System.Drawing.Bitmap($Width, $Height)
        
        # Create graphics object for high quality resizing
        $graphics = [System.Drawing.Graphics]::FromImage($newImage)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
        
        # Draw the resized image
        $graphics.DrawImage($originalImage, 0, 0, $Width, $Height)
        
        # Save the new image
        $newImage.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        # Cleanup
        $graphics.Dispose()
        $newImage.Dispose()
        $originalImage.Dispose()
        
        Write-Host "Resized to: ${Width}x${Height}"
        Write-Host "Saved to: $OutputPath"
        return $true
    }
    catch {
        Write-Host "Error resizing image: $_"
        return $false
    }
}

# Resize App Icon to 100x100
Write-Host "`n=== Resizing App Icon (lOGOss.png) to 100x100 ==="
$appIconPath = Join-Path $imagesPath "lOGOss.png"
$appIconBackup = Join-Path $imagesPath "lOGOss_original.png"

if (Test-Path $appIconPath) {
    # Create backup
    Copy-Item $appIconPath $appIconBackup -Force
    Write-Host "Backup created: lOGOss_original.png"
    
    # Resize to 100x100
    $success = Resize-Image -InputPath $appIconBackup -OutputPath $appIconPath -Width 100 -Height 100
    
    if ($success) {
        Write-Host "✓ App icon resized successfully!"
    } else {
        Write-Host "✗ Failed to resize app icon"
    }
} else {
    Write-Host "✗ App icon not found at: $appIconPath"
}

# Resize Splash Logo (reduce width by 40px, 20px from each side)
Write-Host "`n=== Resizing Splash Logo (splash_logo.png) - Reducing width by 40px ==="
$splashLogoPath = Join-Path $imagesPath "splash_logo.png"
$splashLogoBackup = Join-Path $imagesPath "splash_logo_original.png"

if (Test-Path $splashLogoPath) {
    # Create backup
    Copy-Item $splashLogoPath $splashLogoBackup -Force
    Write-Host "Backup created: splash_logo_original.png"
    
    # Get original dimensions
    $splashImage = [System.Drawing.Image]::FromFile($splashLogoBackup)
    $originalWidth = $splashImage.Width
    $originalHeight = $splashImage.Height
    $splashImage.Dispose()
    
    # Calculate new dimensions (reduce width by 40px, keep height)
    $newWidth = $originalWidth - 40
    $newHeight = $originalHeight
    
    Write-Host "Reducing width by 40px (20px from each side)"
    Write-Host "Original: ${originalWidth}x${originalHeight}"
    Write-Host "New: ${newWidth}x${newHeight}"
    
    # Resize
    $success = Resize-Image -InputPath $splashLogoBackup -OutputPath $splashLogoPath -Width $newWidth -Height $newHeight
    
    if ($success) {
        Write-Host "✓ Splash logo resized successfully!"
    } else {
        Write-Host "✗ Failed to resize splash logo"
    }
} else {
    Write-Host "✗ Splash logo not found at: $splashLogoPath"
}

Write-Host "`n=== Resize Complete ==="
Write-Host "Original images backed up with '_original' suffix"
Write-Host "Run 'flutter pub run flutter_launcher_icons' to regenerate app icons"
Write-Host "Run 'dart run flutter_native_splash:create' to regenerate splash screens"

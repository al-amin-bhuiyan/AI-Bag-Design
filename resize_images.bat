@echo off
echo Checking image sizes...

cd /d "C:\Users\shobuj\StudioProjects\jeebz_bag_design_app\assets\images"

echo.
echo Resizing images using PowerShell...
powershell -Command "& { Add-Type -AssemblyName System.Drawing; $appIcon = [System.Drawing.Image]::FromFile('lOGOss.png'); $origW = $appIcon.Width; $origH = $appIcon.Height; Write-Host 'App Icon Original: ' $origW 'x' $origH; if ($origW -ne 100 -or $origH -ne 100) { Copy-Item 'lOGOss.png' 'lOGOss_backup.png' -Force; $newImg = New-Object System.Drawing.Bitmap(100, 100); $g = [System.Drawing.Graphics]::FromImage($newImg); $g.InterpolationMode = 'HighQualityBicubic'; $g.DrawImage($appIcon, 0, 0, 100, 100); $appIcon.Dispose(); $newImg.Save('lOGOss.png', [System.Drawing.Imaging.ImageFormat]::Png); $g.Dispose(); $newImg.Dispose(); Write-Host 'App Icon resized to 100x100'; } else { $appIcon.Dispose(); Write-Host 'App Icon already 100x100'; } }"

powershell -Command "& { Add-Type -AssemblyName System.Drawing; $splash = [System.Drawing.Image]::FromFile('splash_logo.png'); $origW = $splash.Width; $origH = $splash.Height; Write-Host 'Splash Logo Original: ' $origW 'x' $origH; $newW = $origW - 40; Copy-Item 'splash_logo.png' 'splash_logo_backup.png' -Force; $newImg = New-Object System.Drawing.Bitmap($newW, $origH); $g = [System.Drawing.Graphics]::FromImage($newImg); $g.InterpolationMode = 'HighQualityBicubic'; $g.DrawImage($splash, 0, 0, $newW, $origH); $splash.Dispose(); $newImg.Save('splash_logo.png', [System.Drawing.Imaging.ImageFormat]::Png); $g.Dispose(); $newImg.Dispose(); Write-Host 'Splash Logo width reduced by 40px (20px each side)'; Write-Host 'New size: ' $newW 'x' $origH; }"

echo.
echo Resize complete!
echo Backups created: lOGOss_backup.png and splash_logo_backup.png
echo.
pause

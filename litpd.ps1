<# 
litpd.ps1 - Run the litpd program using the lua interpreter

date: 05/05/2024
author: Abhishek Mishra
#>

# Function to show the usage of the script
function Show-Usage {
    Write-Host "Usage: litpd.ps1 <inputfile.md> [options]"
    Write-Host "  Runs the litpd program using the lua interpreter."
    Write-Host "  The input file should be a markdown file with code blocks."
    Write-Host "  The argument and options will be passed on to the litpd program."
}

# Check if the input file is provided
if ($args.Length -eq 0) {
    Write-Host "Error: No input file provided"
    Show-Usage
    exit 1
}

# Check if lua interpreter is available
Try {
    (Get-Command "lua.exe" -ErrorAction Stop) | Out-Null
} 
Catch {
    Write-Host "Error: Lua interpreter not found"
    Write-Host "Please make sure that the lua interpreter is installed and available in the PATH"
    Write-Host "Also ensure that luafilesystem library is installed."
    exit 1
}

# Check if pandoc is available
Try {
    (Get-Command "pandoc.exe" -ErrorAction Stop) | Out-Null
} 
Catch {
    Write-Host "Error: Pandoc not found"
    Write-Host "Please make sure that pandoc is installed and available in the PATH"
    exit 1
}

# Call the litpd program with the input file and options
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$luaPath = "lua"
$inputFile = $args[0]
$options = $args[1..($args.Length - 1)] -join " "
& $luaPath "$scriptPath/litpd.lua" $inputFile $options
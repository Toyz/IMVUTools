$imvuFolderDefault = [IO.Path]::Combine($env:APPDATA, "IMVUClient", "library");

while ($true) {
    $mode = Read-Host -Prompt 'Build, Decompile or Extract'

    switch ($mode.ToLower()) {
        "extract" {
            $imvuLibPath = [IO.Path]::Combine($imvuFolderDefault, "..", "library.zip")
            $imvuDest = [IO.Path]::Combine($imvuFolderDefault, "..", "library")
            Expand-Archive -LiteralPath $imvuLibPath -DestinationPath $imvuDest -Force
            break;
        }
        "build" {
            $imvuLibPath = [IO.Path]::Combine($imvuFolderDefault, "imvu")

            $files = Get-ChildItem $imvuLibPath -Recurse -Filter *.py -Exclude *.pyo
            foreach ($file in $files) { 
                Write-Output $file.FullName
                C:\Python27\python.exe -O -m compileall $file.FullName
            }
            break;
        }
        "decompile" {
            $files = Get-ChildItem $imvuFolderDefault -Recurse -Filter *.pyo -Exclude *.pyo_dis
            foreach ($file in $files) { 
                Write-Output $file.DirectoryName
                $outputFile = [IO.Path]::Combine($file.DirectoryName, $file.BaseName + ".py")
                C:\Python27\Scripts\uncompyle6.exe -o $outputFile $file.FullName
            }
        }
        "decompile-imvu" {
            $imvuLibPath = [IO.Path]::Combine($imvuFolderDefault, "imvu")

            $files = Get-ChildItem $imvuLibPath -Recurse -Filter *.pyo -Exclude *.pyo_dis
            foreach ($file in $files) { 
                Write-Output $file.DirectoryName
                $outputFile = [IO.Path]::Combine($file.DirectoryName, $file.BaseName + ".py")
                C:\Python27\Scripts\uncompyle6.exe -o $outputFile $file.FullName
            }
        }
        "clean" {
            $files = Get-ChildItem $imvuFolderDefault -Recurse -Filter *.pyo_dis -Exclude *.pyo
            foreach ($file in $files) { 
                [IO.File]::Delete($file.FullName)
                Write-Output "Deleted: " $file.FullName
            }

            $files = Get-ChildItem $imvuFolderDefault -Recurse -Filter *.py -Exclude *.pyo
            foreach ($file in $files) { 
                [IO.File]::Delete($file.FullName)
                Write-Output "Deleted: " $file.FullName
            }
        }
        "editor" {
            code $imvuFolderDefault
        }
        "exit" {
            exit
        }
        "patch" {
            $imvuLibPath = [IO.Path]::Combine($imvuFolderDefault, "..", "checksum.txt")

            $lines = Get-Content $imvuLibPath
            # remove line that contains "library.zip"
            $lines = $lines | Where-Object { $_ -notlike "*library.zip*" }

            # save the lines back to the file  
            $lines | Set-Content $imvuLibPath

            Write-Output "Patched checksum.txt"
        }
        default {
            Write-Host "Build, Decompile, or Extract supported only"
        }
    }
}
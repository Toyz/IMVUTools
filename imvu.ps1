$imvuFolderDefault = [IO.Path]::Combine($env:APPDATA, "IMVUClient", "library", "imvu");

while ($true) {
    $mode = Read-Host -Prompt 'Build, Decompile or Extract'

    switch ($mode.ToLower()) {
        "extract" {
            $imvuLibPath = [IO.Path]::Combine($imvuFolderDefault, "..", "..", "library.zip")
            $imvuDest = [IO.Path]::Combine($imvuFolderDefault, "..")
            Expand-Archive -LiteralPath $imvuLibPath -DestinationPath $imvuDest
            bre ak;
        }
        "build" {
            $files = Get-ChildItem $imvuFolderDefault -Recurse -Filter *.pyo_dis
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
        default {
            Write-Host "Build, Decompile, or Extract supported only"
        }
    }
}
﻿
$ExifTool = 'C:\Folder\exiftool.exe'
$MaxFile = 'C:\Folder\File.max'


function Get-MaxInfo {

    param (
        [Parameter(Mandatory)][string]$ExifTool,
        [Parameter(Mandatory)][string]$MaxFile
    )


    $ExifResult = & $ExifTool ('-G1', $MaxFile) | Select-String '^\[FlashPix\](?!.*Thumbnail Clip)'
    $ExifOutput = @()
    foreach ($Line in $ExifResult) {

        $ExifOutput += $Line.Line.Split(' ', 2)[1].TrimStart()

    }


    $Collection = [System.Collections.SortedList]::new()
    foreach ($Entry in 'Summary', 'Custom', 'File') {

        $Collection[$Entry] = [System.Collections.SortedList]::new()

    }


    $MetaSummary = 'Author', 'Category', 'Comments', 'Company', 'Keywords', 'Manager', 'Subject', 'Title'
    $MetaFile = 'Code Page', 'Create Date', 'Created By', 'Document ID', 'Last Modified By', 'Locale Indicator', 'Modify Date', 'Revision Number'


    foreach ($Entry in $ExifOutput) {

        $TempData = $Entry.Split(':', 2).Trim()
        $CurrentName = $TempData[0]
        $CurrentValue = $TempData[1]

        switch ($CurrentName) {

            { $_ -in $MetaSummary } { $Collection['Summary'][$CurrentName] = $CurrentValue ; break }
            { $_ -in $MetaFile } { $Collection['File'][$CurrentName] = $CurrentValue ; break }
            { $_ -in 'Title Of Parts', 'Heading Pairs' } {

                if ($CurrentName -eq 'Title Of Parts') {

                    $AllItems = $CurrentValue.Split(',').Trim()

                } else {

                    $AllGroups = $CurrentValue.Split(',').Trim()

                }

                if ($AllItems.Count -gt 0 -and $AllGroups.Count -gt 0) {

                    $CurrentIndex = 0

                    for ($i = 0; $i -lt $AllGroups.Length; $i += 2) {

                        $GroupName = $AllGroups[$i]
                        $ItemCount = [int]$AllGroups[$i + 1]

                        if ($ItemCount -gt 0) {

                            if ($GroupName -in 'General', 'Mesh Totals', 'Scene Totals', 'Render Data') {

                                $Collection[$GroupName] = [System.Collections.SortedList]::new()
                                $CurrentItems = $AllItems[$CurrentIndex..($CurrentIndex + $ItemCount - 1)]

                                foreach ($Item in $CurrentItems) {

                                    $TempItems = $item.Split('=:')

                                    if ($TempItems.Count -gt 1) {

                                        $Collection[$GroupName].Add($TempItems[0].Trim(), $TempItems[1].Trim())

                                    } elseif ($item.Trim() -in 'Compressed', 'Uncompressed') {

                                        $Collection[$GroupName].Add('Compression', $item.Trim())

                                    }
                                }
                            } else {

                                $Collection[$GroupName] = $AllItems[$CurrentIndex..($CurrentIndex + $ItemCount - 1)]

                            }
                        } else {

                            $Collection[$GroupName] = 'Empty'

                        }

                        $CurrentIndex += $ItemCount
                    }
                }

                ; break 

            }

            Default { $Collection['Custom'][$CurrentName] = $CurrentValue }

        }
    }


    foreach ($Entry in 'Summary', 'Custom', 'File') {

        if ($Collection[$Entry].Count -eq 0) {

            $Collection[$Entry] = 'Empty'

        }
    }

    return $Collection

}


$Collection = Get-MaxInfo -ExifTool $ExifTool -MaxFile $MaxFile


# neatly output result
foreach ($Entry in $Collection.Keys) {

    $Type = if ($Collection[$Entry] -is [System.Collections.SortedList]) {
    
        'List'
        
    } elseif ($Collection[$Entry] -is [object[]]) {
    
        'Array'
        
    }


    if ($Collection[$Entry] -ne 'Empty') { 
        
        Write-Host "$Entry ($Type, $($Collection[$Entry].Count))" -ForegroundColor Yellow
        
    } else {
    
        Write-Host "$Entry (Empty)" -ForegroundColor Yellow
        
    }


    switch ($Type) {

        'List' { foreach ($Item in $Collection[$Entry].GetEnumerator()) { "    {0,-18} : {1}" -f $Item.Key, $Item.Value } }
        'Array' { foreach ($Item in $Collection[$Entry]) { "    {0}" -f $Item } }

    }

    ''

}
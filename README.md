# 3ds Max Metadata reader and Thumbnail saver

## **Get-MaxMetadata**
The functions can be used for 3ds Max automation. The metadata reader function is a Command-line version of **MaxFind.exe** or within 3ds Max **File>File Properties...**.
At the bottom i left some code to list the output.

After running the script any parameter can be read from the $Collection variable:
- For a list: **$Collection['GroupName']['Parameter']**
- An array: **$Collection['GroupName']**

Specific examples:
- 3ds Max version: **[int]$Collection['General']['3ds Max Version']**
- Render Width: **$Collection['Render Data']['Render Width']**
- List all objects: **$Collection['Objects']**

## **Write-MaxMetadata**
This will list the collected metadata and can be used to save the metadata to a text file.

## **Save-MaxThumbnail**
This is converted code from a ScriptSpot forum post by **Andrey** (scriptspot.com/forums/3ds-max/general-scripting/get-max-file-thumbnail)
He deserves all the credit for this. All i did was convert the Visual Basic Code to C# and the MaxScript part to Powershell.
The C# code is above my head, don't ask me for changes.

## **Dependencies**
You'll need ExifTool by Phil Harvey to read out the metadata.


### Changelog

v1.0.1

- Wrapped host output into a function.
- Ability to save output to a text file.

v1.0 (Initial release)


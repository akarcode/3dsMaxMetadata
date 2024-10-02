# 3ds Max Metadata reader and Thumbnail saver

## **Get-MaxMetadata**
The Functions can be used for 3ds Max automation. The Metadata reader Function is a Command-line version of **MaxFind.exe** or within 3ds Max **File>File Properties...**.
At the bottom i left some code to list the output.

after running the Script any parameter can be read from the $Collection variable: **$Collection['GroupName']['Parameter']**

## **Save-MaxThumbnail**
This is converted code from a ScriptSpot forum post by **Andrey** (scriptspot.com/forums/3ds-max/general-scripting/get-max-file-thumbnail)
He deserves all the credit for this. All i did was convert the Visual Basic Code to C# and the MaxScript part to Powershell.
The C# code is above my head, don't ask me for changes.

## **Dependencies**
You'll need ExifTool by Phil Harvey to read out the Metadata.



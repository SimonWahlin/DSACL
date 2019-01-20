$ModulePath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$BuildData = Import-LocalizedData -BaseDirectory $ModulePath -FileName build.psd1

$Scripts = Get-ChildItem -Path $BuildData.SourceDirectories -File -Filter *.ps1 | Select-Object -ExpandProperty FullName
foreach($Script in $Scripts) {
        . $Script
}
$SearchRecursive = $true
$SearchRootOnly  = $false
$PublicScriptBlock = [ScriptBlock]::Create((Get-ChildItem -Path $BuildData.PublicFilter | Get-Content -Delimiter ([char]0) | Out-String))
$PublicFunctions = $PublicScriptBlock.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]},$SearchRootOnly).Name
$PublicAlias = $PublicScriptBlock.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.ParamBlockAst] },$SearchRecursive).Where{$_.TypeName.FullName -eq 'alias'}.PositionalArguments.Value

$ExportParam = @{}
if($PublicFunctions) {
        $ExportParam.Add('Function',$PublicFunctions)
}
if($PublicAlias) {
        $ExportParam.Add('Alias',$PublicAlias)
}
if($ExportParam.Keys.Count -gt 0) {
        Export-ModuleMember @ExportParam
}

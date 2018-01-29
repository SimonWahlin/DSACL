#Requires -Modules @{ModuleName='InvokeBuild';ModuleVersion='3.2.1'}
#Requires -Modules @{ModuleName='PowerShellGet';ModuleVersion='1.6.0'}

$script:IsAppveyor = $env:APPVEYOR -ne $null
$script:ModuleName = Get-Item -Path $BuildRoot | Select-Object -ExpandProperty Name

if ($PSVersionTable.PSEdition -ne "Core") {
    Add-Type -Assembly System.IO.Compression.FileSystem
}

task Clean {
    Remove-Item -Path ".\Bin" -Recurse -Force -ErrorAction SilentlyContinue
}

task TestCode {
    Write-Build Yellow "`n`n`nTesting dev code before build"
    $TestResult = Invoke-Pester -PassThru
    if($TestResult.FailedCount -gt 0) {throw 'Tests failed'}
}

task CopyFiles {
    $null = New-Item -Path "$BuildRoot\bin\$Script:ModuleName" -ItemType Directory
    Copy-Item -Path "$BuildRoot\*.psd1" -Destination "$BuildRoot\bin\$ModuleName"
    Get-ChildItem -Path "$BuildRoot\license*" | Copy-Item -Destination "$BuildRoot\bin\"
}

task UpdateManifest {

}

task CompilePSM {
    param(

    )
    $PrivatePath = '{0}\Private\*.ps1' -f $BuildRoot
    $PublicPath = '{0}\Public\*.ps1'-f $BuildRoot
    $ScriptPath = '{0}\Script\*.ps1'-f $BuildRoot
    $Scripts = Get-ChildItem -Path $ScriptPath,$PrivatePath,$PublicPath |
        Select-Object -ExpandProperty FullName
    Get-Content -Path $Scripts |
        Out-File -FilePath "$BuildRoot\bin\$ModuleName\$ModuleName.psm1" -Encoding UTF8 -Force

    $PublicScriptBlock = [ScriptBlock]::Create((Get-ChildItem -Path $PublicPath | Get-Content | Out-String))
    $PublicFunctions = $PublicScriptBlock.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]},$false).Name
    $PublicAlias = $PublicScriptBlock.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.AttributeAst] },$true).Where{$_.TypeName.FullName -eq 'Alias' -and $_.Parent -is [System.Management.Automation.Language.ParamBlockAst]}.PositionalArguments.Value
    $PublicFunctionParam, $PublicAliasParam = ''
    $UpdateManifestParam = @{}
    if(-Not [String]::IsNullOrEmpty($PublicFunctions)) {
        $PublicFunctionParam = "-Function '{0}'" -f ($PublicFunctions -join "','")
        $UpdateManifestParam['FunctionsToExport'] = $PublicFunctions
    }
    if($PublicAlias) {
        $PublicAliasParam = "-Alias '{0}'" -f ($PublicAlias -join "','")
        $UpdateManifestParam['AliasesToExport'] = $PublicAlias
    }
    $ExportStrings = 'Export-ModuleMember',$PublicFunctionParam,$PublicAliasParam | Where-Object {-Not [string]::IsNullOrWhiteSpace($_)}
    $ExportStrings -join ' ' | Out-File -FilePath  "$BuildRoot\bin\$ModuleName\$ModuleName.psm1" -Append -Encoding UTF8
    if ($UpdateManifestParam.Count -gt 0) {
        Update-ModuleManifest -Path "$BuildRoot\bin\$ModuleName\$ModuleName.psd1" @UpdateManifestParam
    }
}

task MakeHelp -if (Test-Path -Path "$PSScriptRoot\Docs") {

}

task TestBuild {
    Write-Build Yellow "`n`n`nTesting compiled module"
    $TestResult = Invoke-Pester -Script  @{Path="$PSScriptRoot\test"; Parameters=@{ModulePath="$BuildRoot\bin\$ModuleName"}} -Tag CoreModule -PassThru
    if($TestResult.FailedCount -gt 0) {throw 'Tests failed'}
}

task Build CopyFiles, CompilePSM, MakeHelp, TestBuild

task UploadArtifactsAppveyor -if ($script:IsAppveyor) {
    # Put code to upload artifacts to Appveyor here
}

task . Clean, TestCode, Build, UploadArtifactsAppveyor
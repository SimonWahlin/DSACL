@{
    Path = "DSACL.psd1"
    OutputDirectory = "..\bin\DSACL"
    Prefix = '.\_ModuleVariables.ps1'
    SourceDirectories = 'Classes','Private','Public','en-US'
    PublicFilter = 'Public\*.ps1'
    VersionedOutputDirectory = $true
}
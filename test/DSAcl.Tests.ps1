param(
    $ModulePath = "$PSScriptRoot\.."
)
# Remove trailing slash or backslash
$ModulePath = $ModulePath -replace '[\\/]*$'
$ModuleManifestName = 'DSAcl.psd1'
$ModuleManifestPath = Join-Path -Path $ModulePath -ChildPath $ModuleManifestName

Describe 'Core Module Tests' -Tags 'CoreModule' {
    It 'Passes Test-ModuleManifest' {
        {Test-ModuleManifest -Path $ModuleManifestPath -ErrorAction Stop} | Should -Not -Throw
    }

    It 'Loads from module path without errors' {
        {Import-Module "$ModulePath" -ErrorAction Stop} | Should -Not -Throw
    }
}

Describe 'DSACL Unit tests' -Tag 'Unit' {
    Import-Module "$ModulePath"
    Context 'Testing Private functions' {
        InModuleScope -ModuleName DSACL {

        }
    }

    Context 'Testing Public functions' {

    }
}


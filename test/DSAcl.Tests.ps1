param(
    $ModulePath = "$PSScriptRoot\.."
)
# Remove trailing slash or backslash
$ModulePath = $ModulePath -replace '[\\/]*$'
$ModuleManifestName = 'DSAcl.psd1'
$ModuleManifestPath = Join-Path -Path $ModulePath -ChildPath $ModuleManifestName

Describe 'Core Module Tests' -Tags 'CoreModule' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true
    }

    It 'Loads from module path without errors' {
        {Import-Module "$ModulePath" -ErrorAction Stop} | Should not throw
    }
}


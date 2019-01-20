<#
.SYNOPSIS
Delegates right to move object of type ObjectTypeName from TargetDN.
Moving also requires create-child rights in target container.

.DESCRIPTION
Delegates the rights to rename and delete objects in TargetDN.
#>

function Add-DSACLMoveObjectFrom {
    [CmdletBinding()]
    param (
        # Object type to allow being moved
        [Parameter(Mandatory)]
        [ValidateSet('Computer', 'Contact', 'Group', 'ManagedServiceAccount', 'GroupManagedServiceAccount', 'User','All')]
        [String]
        $ObjectTypeName,

        # DistinguishedName of object to modify ACL on. Usually an OU.
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        $TargetDN,

        # DistinguishedName of group or user to give permissions to.
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        $DelegateDN,

        # Sets access right to "This object only"
        [Switch]
        $NoInheritance
    )

    process {
        try {
            $ErrorActionPreference = 'Stop'
            Add-DSACLRenameObject @PSBoundParameters
            Add-DSACLDeleteChild @PSBoundParameters
        } catch {
            throw
        }
    }

}

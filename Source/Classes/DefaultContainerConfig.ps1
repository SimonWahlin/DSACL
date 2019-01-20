class DSACLDefaultContainerConfig {
    [string] $Name
    [string] $DistinguishedName
    hidden [string] $Prefix
    hidden [int] $Index
    hidden [string] $DomainDN

    DSACLDefaultContainerConfig($Name,$DistinguishedName,$Prefix,$Index,$DomainDN) {
        $this.Name = $Name
        $this.DistinguishedName = $DistinguishedName
        $this.Prefix = $Prefix
        $this.Index = $Index
        $this.DomainDN = $DomainDN
    }
}

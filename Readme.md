# DSACL - Delegation Made Easy

| Master Branch                   | Current Branch                  |
|---------------------------------|---------------------------------|
| [![av-master-image][]][av-site] | [![av-dev-image][]][av-site]    |

[av-master-image]: https://ci.appveyor.com/api/projects/status/8xnk88yywn3jsk5l/branch/master?svg=true
[av-dev-image]: https://ci.appveyor.com/api/projects/status/8xnk88yywn3jsk5l/branch/dev?svg=true
[av-site]: https://ci.appveyor.com/project/SimonWahlin/dsacl

DSACL is a PowerShell module for creating ACLs in Active Directory.

Tired of using dsacls.exe but still thinks manually creating access rules in AD is a hassle?

Then this is for you!

## Install

The latest released version is best installed from PowerShell Gallery using the command:

```powershell
Install-Module -Name DSACL  -Scope CurrentUser
```

## Build Instructions

This module can be loaded as-is by importing DSAcl.psd1. This is mainly intended for development purposes or for testing the latest build.

To speed up module load time and minimize the amount of files that needs to be signed, distributed and installed, this module contains a build script that will package up the module into four files:

- DSACL.format.ps1xml
- DSAcl.psd1
- DSACL.psm1
- license.txt

To build the module, make sure you have the following pre-req modules:

- ModuleBuilder (Required Version 1.0.0)
- Pester (Required Version 4.1.1)
- InvokeBuild (Required Version 3.2.1)
- PowerShellGet (Required Version 1.6.0)

Start the build by running the following command from the project root:

```powershell
Invoke-Build
```

This will package all code into files located in .\bin\DSACL. That folder is now ready to be installed, copy to any path listed in you PSModulePath environment variable and you are good to ACL!

## Release Notes

### Unreleased

- Added command *Add-DSACLManageGroupMember*
- Added command *Set-DSACLOwner*
- BugFix: *Add-DSACLCustom* Parameter Self will no longer be passed to New-DSAclAccessRule

## Contributing

Any feedback is welcome, don't hesitate to submit an issue and/or pull request.

---
Maintained by [Simon Wahlin](https://www.github.com/SimonWahlin)

# DSACL - Delegation Made Easy

DSACL is a PowerShell module for creating ACLs in Active Directory.

Tired of using dsacls.exe but still thinks manually creating access rules in AD is a hassle?

Then this is for you!

## Instructions

This module can be loaded as-is by importing DSAcl.psd1. This is mainly intended for development purposes.

To speed up module load time and minimize the amount of files that needs to be signed, distributed and installed, this module contains a build script that will package up the module into three files:

- DSAcl.psd1
- DSACL.psm1
- license.txt

To build the module, make sure you have the following pre-req modules:

- Pester (Required Version 4.1.1)
- InvokeBuild (Required Version '3.2.1)
- PowerShellGet (Required Version '1.6.0)

Start the build by running the following command from the project root:

```powershell
Invoke-Build
```

This will package all code into files located in .\bin\DSACL. That folder is now ready to be installed, copy to any path listed in you PSModulePath environment variable and you are good to ACL!

## PowerShell Gallery

Code will be published to gallery as soon as we reach version 1.

## Contributing

Any feedback is welcome, don't hesitate to submit an issue and/or pull request.

---
Maintained by [Simon Wahlin](https://www.github.com/SimonWahlin)

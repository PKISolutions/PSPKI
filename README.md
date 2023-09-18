# PowerShell PKI Module

### Project Description

This module is intended to simplify various PKI and Active Directory Certificate Services management tasks by using automation with Windows PowerShell.

This module is intended for Certification Authority management. For local certificate store management you should consider to use [Quest AD PKI cmdlets](http://www.quest.com/powershell/activeroles-server.aspx).

#### Relationships between Microsoft PKI and PSPKI modules

Starting with Windows 8/Windows Server 2012, a **PKI** module is installed along with AD CS Remote Server Administration Tools. This module is maintained by Microsoft. **PSPKI** is open-source community module and uses completely different codebase.

### Documentation

All documentation is available at PKI Solutions: [PowerShell PKI Module](https://www.pkisolutions.com/tools/pspki/)

### Download and install PowerShell PKI module from the PowerShell Gallery using PowerShell
```PowerShell
Install-Module -Name PSPKI
```


### Module Requirements

* ![image](https://img.shields.io/badge/PowerShell-3.0-blue.svg)
* ![image](https://img.shields.io/badge/.NET_Framework-4.7.2-blue.svg)

This module can run on any of the specified operating system:
* Windows Server 2008 R2/2012/2012 R2/2016/2019/2022
* Windows 7/8/8.1/10/11

**Module installation requires installed AD CS RSAT (Remote System Administration Tools for Active Directory Certificate Services)**

### Certificate services support

This module supports Enterprise or Standalone Certification Authority (CA) servers that are running one the following operating systems:
* Windows Server 2003/2003 R2
* Windows Server 2008 (including Server Core)
* Windows Server 2008 R2 (including Server Core)
* Windows Server 2012 (including Server Core)
* Windows Server 2012 R2 (including Server Core)
* Windows Server 2016 (including Server Core)
* Windows Server 2019 (including Server Core)
* Windows Server 2022 (including Server Core)

### Online Responder support

This module supports Online Certificate Status Protocol (OCSP) servers that are running one the following operating systems:
* Windows Server 2008 Enterprise (Full Installation)
* Windows Server 2008 R2 Enterprise (Full Installation)
* Windows Server 2012 (including Server Core)
* Windows Server 2012 R2 (including Server Core)
* Windows Server 2016 (including Server Core)
* Windows Server 2019 (including Server Core)
* Windows Server 2022 (including Server Core)

### Full Command List ###
* [Add-AdCertificate](https://www.pkisolutions.com/tools/pspki/Add-AdCertificate)
* [Add-AdCertificateRevocationList](https://www.pkisolutions.com/tools/pspki/Add-AdCertificateRevocationList) (Alias: **Add-AdCrl**)
* [Add-AuthorityInformationAccess](https://www.pkisolutions.com/tools/pspki/Add-AuthorityInformationAccess) (Alias: **Add-AIA**)
* [Add-CAKRACertificate](https://www.pkisolutions.com/tools/pspki/Add-CAKRACertificate)
* [Add-CATemplate](https://www.pkisolutions.com/tools/pspki/Add-CATemplate)
* [Add-CertificateTemplateAcl](https://www.pkisolutions.com/tools/pspki/Add-CertificateTemplateAcl)
* [Add-CertificationAuthorityAcl](https://www.pkisolutions.com/tools/pspki/Add-CertificationAuthorityAcl) (Alias: **Add-CAAccessControlEntry Add-CAACL**)
* [Add-CRLDistributionPoint](https://www.pkisolutions.com/tools/pspki/Add-CRLDistributionPoint) (Alias: **Add-CDP**)
* [Add-ExtensionList](https://www.pkisolutions.com/tools/pspki/Add-ExtensionList)
* [Add-OnlineResponderAcl](https://www.pkisolutions.com/tools/pspki/Add-OnlineResponderAcl) (Alias: **Add-OCSPACL**)
* [Add-OnlineResponderArrayMember](https://www.pkisolutions.com/tools/pspki/Add-OnlineResponderArrayMember)
* [Add-OnlineResponderLocalCrlEntry](https://www.pkisolutions.com/tools/pspki/Add-OnlineResponderLocalCrlEntry)
* [Add-OnlineResponderRevocationConfiguration](https://www.pkisolutions.com/tools/pspki/Add-OnlineResponderRevocationConfiguration)
* [Approve-CertificateRequest](https://www.pkisolutions.com/tools/pspki/Approve-CertificateRequest)
* [Connect-CertificationAuthority](https://www.pkisolutions.com/tools/pspki/Connect-CertificationAuthority) (Alias: **Connect-CA**)
* [Connect-OnlineResponder](https://www.pkisolutions.com/tools/pspki/Connect-OnlineResponder)
* [Convert-PemToPfx](https://www.pkisolutions.com/tools/pspki/Convert-PemToPfx)
* [Convert-PfxToPem](https://www.pkisolutions.com/tools/pspki/Convert-PfxToPem)
* [Deny-CertificateRequest](https://www.pkisolutions.com/tools/pspki/Deny-CertificateRequest)
* [Disable-CertificateRevocationListFlag](https://www.pkisolutions.com/tools/pspki/Disable-CertificateRevocationListFlag) (Alias: **Disable-CRLFlag**)
* [Disable-InterfaceFlag](https://www.pkisolutions.com/tools/pspki/Disable-InterfaceFlag)
* [Disable-KeyRecoveryAgentFlag](https://www.pkisolutions.com/tools/pspki/Disable-KeyRecoveryAgentFlag) (Alias: **Disable-KRAFlag**)
* [Disable-PolicyModuleFlag](https://www.pkisolutions.com/tools/pspki/Disable-PolicyModuleFlag)
* [Enable-CertificateRevocationListFlag](https://www.pkisolutions.com/tools/pspki/Enable-CertificateRevocationListFlag) (Alias: **Enable-CRLFlag**)
* [Enable-InterfaceFlag](https://www.pkisolutions.com/tools/pspki/Enable-InterfaceFlag)
* [Enable-KeyRecoveryAgentFlag](https://www.pkisolutions.com/tools/pspki/Enable-KeyRecoveryAgentFlag) (Alias: **Enable-KRAFlag**)
* [Enable-PolicyModuleFlag](https://www.pkisolutions.com/tools/pspki/Enable-PolicyModuleFlag)
* [Get-AdcsDatabaseRow](https://www.pkisolutions.com/tools/pspki/Get-AdcsDatabaseRow) (Alias: **Get-DatabaseRow**)
* [Get-ADKRACertificate](https://www.pkisolutions.com/tools/pspki/Get-ADKRACertificate)
* [Get-AdPkiContainer](https://www.pkisolutions.com/tools/pspki/Get-AdPkiContainer)
* [Get-AuthorityInformationAccess](https://www.pkisolutions.com/tools/pspki/Get-AuthorityInformationAccess) (Alias: **Get-AIA**)
* [Get-CACryptographyConfig](https://www.pkisolutions.com/tools/pspki/Get-CACryptographyConfig)
* [Get-CAExchangeCertificate](https://www.pkisolutions.com/tools/pspki/Get-CAExchangeCertificate)
* [Get-CAKRACertificate](https://www.pkisolutions.com/tools/pspki/Get-CAKRACertificate)
* [Get-CATemplate](https://www.pkisolutions.com/tools/pspki/Get-CATemplate)
* [Get-CertificateContextProperty](https://www.pkisolutions.com/tools/pspki/Get-CertificateContextProperty)
* [Get-CertificateRequest](https://www.pkisolutions.com/tools/pspki/Get-CertificateRequest)
* [Get-CertificateRevocationList](https://www.pkisolutions.com/tools/pspki/Get-CertificateRevocationList) (Alias: **Get-CRL**)
* [Get-CertificateRevocationListFlag](https://www.pkisolutions.com/tools/pspki/Get-CertificateRevocationListFlag) (Alias: **Get-CRLFlag**)
* [Get-CertificateTemplate](https://www.pkisolutions.com/tools/pspki/Get-CertificateTemplate)
* [Get-CertificateTemplateAcl](https://www.pkisolutions.com/tools/pspki/Get-CertificateTemplateAcl)
* [Get-CertificateTrustList](https://www.pkisolutions.com/tools/pspki/Get-CertificateTrustList) (Alias: **Get-CTL**)
* [Get-CertificateValidityPeriod](https://www.pkisolutions.com/tools/pspki/Get-CertificateValidityPeriod)
* [Get-CertificationAuthority](https://www.pkisolutions.com/tools/pspki/Get-CertificationAuthority) (Alias: **Get-CA**)
* [Get-CertificationAuthorityAcl](https://www.pkisolutions.com/tools/pspki/Get-CertificationAuthorityAcl) (Alias: **Get-CAACL Get-CASecurityDescriptor**)
* [Get-CertificationAuthorityDbSchema](https://www.pkisolutions.com/tools/pspki/Get-CertificationAuthorityDbSchema)
* [Get-CryptographicServiceProvider](https://www.pkisolutions.com/tools/pspki/Get-CryptographicServiceProvider) (Alias: **Get-Csp**)
* [Get-CRLDistributionPoint](https://www.pkisolutions.com/tools/pspki/Get-CRLDistributionPoint) (Alias: **Get-CDP**)
* [Get-CRLValidityPeriod](https://www.pkisolutions.com/tools/pspki/Get-CRLValidityPeriod)
* [Get-EnrollmentPolicyServerClient](https://www.pkisolutions.com/tools/pspki/Get-EnrollmentPolicyServerClient)
* [Get-EnterprisePKIHealthStatus](https://www.pkisolutions.com/tools/pspki/Get-EnterprisePKIHealthStatus)
* [Get-ErrorMessage](https://www.pkisolutions.com/tools/pspki/Get-ErrorMessage)
* [Get-ExtensionList](https://www.pkisolutions.com/tools/pspki/Get-ExtensionList)
* [Get-FailedRequest](https://www.pkisolutions.com/tools/pspki/Get-FailedRequest)
* [Get-InterfaceFlag](https://www.pkisolutions.com/tools/pspki/Get-InterfaceFlag)
* [Get-IssuedRequest](https://www.pkisolutions.com/tools/pspki/Get-IssuedRequest)
* [Get-KeyRecoveryAgentFlag](https://www.pkisolutions.com/tools/pspki/Get-KeyRecoveryAgentFlag) (Alias: **Get-KRAFlag**)
* [Get-ObjectIdentifier](https://www.pkisolutions.com/tools/pspki/Get-ObjectIdentifier) (Alias: **oid**)
* [Get-ObjectIdentifierEx](https://www.pkisolutions.com/tools/pspki/Get-ObjectIdentifierEx) (Alias: **oid2**)
* [Get-OnlineResponderAcl](https://www.pkisolutions.com/tools/pspki/Get-OnlineResponderAcl) (Alias: **Get-OCSPACL**)
* [Get-OnlineResponderRevocationConfiguration](https://www.pkisolutions.com/tools/pspki/Get-OnlineResponderRevocationConfiguration)
* [Get-PendingRequest](https://www.pkisolutions.com/tools/pspki/Get-PendingRequest)
* [Get-PolicyModuleFlag](https://www.pkisolutions.com/tools/pspki/Get-PolicyModuleFlag)
* [Get-RevokedRequest](https://www.pkisolutions.com/tools/pspki/Get-RevokedRequest)
* [Import-LostCertificate](https://www.pkisolutions.com/tools/pspki/Import-LostCertificate)
* [New-SelfSignedCertificateEx](https://www.pkisolutions.com/tools/pspki/New-SelfSignedCertificateEx)
* [Ping-ICertInterface](https://www.pkisolutions.com/tools/pspki/Ping-ICertInterface)
* [Publish-CRL](https://www.pkisolutions.com/tools/pspki/Publish-CRL)
* [Receive-Certificate](https://www.pkisolutions.com/tools/pspki/Receive-Certificate)
* [Register-ObjectIdentifier](https://www.pkisolutions.com/tools/pspki/Register-ObjectIdentifier)
* [Remove-AdCertificate](https://www.pkisolutions.com/tools/pspki/Remove-AdCertificate)
* [Remove-AdCertificateRevocationList](https://www.pkisolutions.com/tools/pspki/Remove-AdCertificateRevocationList) (Alias: **Remove-AdCrl**)
* [Remove-AdcsDatabaseRow](https://www.pkisolutions.com/tools/pspki/Remove-AdcsDatabaseRow) (Alias: **Remove-Request**)
* [Remove-AuthorityInformationAccess](https://www.pkisolutions.com/tools/pspki/Remove-AuthorityInformationAccess) (Alias: **Remove-AIA**)
* [Remove-CAKRACertificate](https://www.pkisolutions.com/tools/pspki/Remove-CAKRACertificate)
* [Remove-CATemplate](https://www.pkisolutions.com/tools/pspki/Remove-CATemplate)
* [Remove-CertificateTemplate](https://www.pkisolutions.com/tools/pspki/Remove-CertificateTemplate)
* [Remove-CertificateTemplateAcl](https://www.pkisolutions.com/tools/pspki/Remove-CertificateTemplateAcl)
* [Remove-CertificationAuthorityAcl](https://www.pkisolutions.com/tools/pspki/Remove-CertificationAuthorityAcl) (Alias: **Remove-CAAccessControlEntry Remove-CAACL**)
* [Remove-CRLDistributionPoint](https://www.pkisolutions.com/tools/pspki/Remove-CRLDistributionPoint) (Alias: **Remove-CDP**)
* [Remove-ExtensionList](https://www.pkisolutions.com/tools/pspki/Remove-ExtensionList)
* [Remove-OnlineResponderAcl](https://www.pkisolutions.com/tools/pspki/Remove-OnlineResponderAcl) (Alias: **Remove-OCSPACL**)
* [Remove-OnlineResponderArrayMember](https://www.pkisolutions.com/tools/pspki/Remove-OnlineResponderArrayMember)
* [Remove-OnlineResponderLocalCrlEntry](https://www.pkisolutions.com/tools/pspki/Remove-OnlineResponderLocalCrlEntry)
* [Remove-OnlineResponderRevocationConfiguration](https://www.pkisolutions.com/tools/pspki/Remove-OnlineResponderRevocationConfiguration)
* [Restart-CertificationAuthority](https://www.pkisolutions.com/tools/pspki/Restart-CertificationAuthority)
* [Restart-OnlineResponder](https://www.pkisolutions.com/tools/pspki/Restart-OnlineResponder)
* [Restore-CertificateRevocationListFlagDefault](https://www.pkisolutions.com/tools/pspki/Restore-CertificateRevocationListFlagDefault) (Alias: **Restore-CRLFlagDefault**)
* [Restore-KeyRecoveryAgentFlagDefault](https://www.pkisolutions.com/tools/pspki/Restore-KeyRecoveryAgentFlagDefault) (Alias: **Restore-KRAFlagDefault**)
* [Restore-PolicyModuleFlagDefault](https://www.pkisolutions.com/tools/pspki/Restore-PolicyModuleFlagDefault)
* [Revoke-Certificate](https://www.pkisolutions.com/tools/pspki/Revoke-Certificate)
* [Set-AuthorityInformationAccess](https://www.pkisolutions.com/tools/pspki/Set-AuthorityInformationAccess) (Alias: **Set-AIA**)
* [Set-CACryptographyConfig](https://www.pkisolutions.com/tools/pspki/Set-CACryptographyConfig)
* [Set-CAKRACertificate](https://www.pkisolutions.com/tools/pspki/Set-CAKRACertificate)
* [Set-CATemplate](https://www.pkisolutions.com/tools/pspki/Set-CATemplate)
* [Set-CertificateExtension](https://www.pkisolutions.com/tools/pspki/Set-CertificateExtension)
* [Set-CertificateTemplateAcl](https://www.pkisolutions.com/tools/pspki/Set-CertificateTemplateAcl)
* [Set-CertificateValidityPeriod](https://www.pkisolutions.com/tools/pspki/Set-CertificateValidityPeriod)
* [Set-CertificationAuthorityAcl](https://www.pkisolutions.com/tools/pspki/Set-CertificationAuthorityAcl) (Alias: **Set-CAACL Set-CASecurityDescriptor**)
* [Set-CRLDistributionPoint](https://www.pkisolutions.com/tools/pspki/Set-CRLDistributionPoint) (Alias: **Set-CDP**)
* [Set-CRLValidityPeriod](https://www.pkisolutions.com/tools/pspki/Set-CRLValidityPeriod)
* [Set-ExtensionList](https://www.pkisolutions.com/tools/pspki/Set-ExtensionList)
* [Set-OnlineResponderAcl](https://www.pkisolutions.com/tools/pspki/Set-OnlineResponderAcl) (Alias: **Set-OCSPACL**)
* [Set-OnlineResponderProperty](https://www.pkisolutions.com/tools/pspki/Set-OnlineResponderProperty)
* [Set-OnlineResponderRevocationConfiguration](https://www.pkisolutions.com/tools/pspki/Set-OnlineResponderRevocationConfiguration)
* [Show-Certificate](https://www.pkisolutions.com/tools/pspki/Show-Certificate)
* [Show-CertificateRevocationList](https://www.pkisolutions.com/tools/pspki/Show-CertificateRevocationList) (Alias: **Show-CRL**)
* [Show-CertificateTrustList](https://www.pkisolutions.com/tools/pspki/Show-CertificateTrustList) (Alias: **Show-CTL**)
* [Start-CertificationAuthority](https://www.pkisolutions.com/tools/pspki/Start-CertificationAuthority)
* [Start-OnlineResponder](https://www.pkisolutions.com/tools/pspki/Start-OnlineResponder)
* [Stop-CertificationAuthority](https://www.pkisolutions.com/tools/pspki/Stop-CertificationAuthority)
* [Stop-OnlineResponder](https://www.pkisolutions.com/tools/pspki/Stop-OnlineResponder)
* [Submit-CertificateRequest](https://www.pkisolutions.com/tools/pspki/Submit-CertificateRequest)
* [Test-WebServerSSL](https://www.pkisolutions.com/tools/pspki/Test-WebServerSSL)
* [Unregister-ObjectIdentifier](https://www.pkisolutions.com/tools/pspki/Unregister-ObjectIdentifier)

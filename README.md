# PowerShell PKI Module

### Project Description

**This** module is intended to simplify various PKI and Active Directory Certificate Services management tasks by using automation with Windows PowerShell.

This module is intended for Certification Authority management. For local certificate store management you should consider to use [Quest AD PKI cmdlets](http://www.quest.com/powershell/activeroles-server.aspx).

### Documentation

All documentation is available at my website: [PowerShell PKI Module](https://www.sysadmins.lv/projects/pspki/default.aspx)

### Download installer

Download the most recent PowerShell PKI Module installer from [CodePlex](https://pspki.codeplex.com/releases)

### Module Requirements

* Windows PowerShell 3.0 or higher
* .NET Framework 4.0 or higher

This module can run on any of the specified operating system:
* Windows Server 2008\*/2008 R2/2012/2012 R2
* Windows Vista\*\*/7\*\*/8\*\*/8.1\*\*/10\*\*

\* — Server Core installation is not supported.

\*\* — with installed RSAT (Remote System Administration Tools)

### Certificate services support

This module supports Enterprise or Standalone Certification Authority servers that are running one the following operating system:
* Windows Server 2003/2003 R2
* Windows Server 2008 (including Server Core)
* Windows Server 2008 R2 (including Server Core)
* Windows Server 2012 (including Server Core)
* Windows Server 2012 R2 (including Server Core)

### Full Command List ###
* [Add-AuthorityInformationAccess](https://www.sysadmins.lv/projects/pspki/Add-AuthorityInformationAccess.aspx) (Alias: **Add-AIA**)
* [Add-CAAccessControlEntry](https://www.sysadmins.lv/projects/pspki/Add-CAAccessControlEntry.aspx) (Alias: **Add-CAACL**)
* [Add-CAKRACertificate](https://www.sysadmins.lv/projects/pspki/Add-CAKRACertificate.aspx)
* [Add-CATemplate](https://www.sysadmins.lv/projects/pspki/Add-CATemplate.aspx)
* [Add-CertificateEnrollmentPolicyService](https://www.sysadmins.lv/projects/pspki/Add-CertificateEnrollmentPolicyService.aspx)
* [Add-CertificateEnrollmentService](https://www.sysadmins.lv/projects/pspki/Add-CertificateEnrollmentService.aspx)
* [Add-CertificateTemplateAcl](https://www.sysadmins.lv/projects/pspki/Add-CertificateTemplateAcl.aspx)
* [Add-CRLDistributionPoint](https://www.sysadmins.lv/projects/pspki/Add-CRLDistributionPoint.aspx) (Alias: **Add-CDP**)
* [Add-ExtensionList](https://www.sysadmins.lv/projects/pspki/Add-ExtensionList.aspx)
* [Approve-CertificateRequest](https://www.sysadmins.lv/projects/pspki/Approve-CertificateRequest.aspx)
* [Connect-CertificationAuthority](https://www.sysadmins.lv/projects/pspki/Connect-CertificationAuthority.aspx) (Alias: **Connect-CA**)
* [Convert-PemToPfx](https://www.sysadmins.lv/projects/pspki/Convert-PemToPfx.aspx)
* [Convert-PfxToPem](https://www.sysadmins.lv/projects/pspki/Convert-PfxToPem.aspx)
* [Deny-CertificateRequest](https://www.sysadmins.lv/projects/pspki/Deny-CertificateRequest.aspx)
* [Disable-CertificateRevocationListFlag](https://www.sysadmins.lv/projects/pspki/Disable-CertificateRevocationListFlag.aspx) (Alias: **Disable-CRLFlag**)
* [Disable-InterfaceFlag](https://www.sysadmins.lv/projects/pspki/Disable-InterfaceFlag.aspx)
* [Disable-KeyRecoveryAgentFlag](https://www.sysadmins.lv/projects/pspki/Disable-KeyRecoveryAgentFlag.aspx) (Alias: **Disable-KRAFlag**)
* [Disable-PolicyModuleFlag](https://www.sysadmins.lv/projects/pspki/Disable-PolicyModuleFlag.aspx)
* [Enable-CertificateRevocationListFlag](https://www.sysadmins.lv/projects/pspki/Enable-CertificateRevocationListFlag.aspx) (Alias: **Enable-CRLFlag**)
* [Enable-InterfaceFlag](https://www.sysadmins.lv/projects/pspki/Enable-InterfaceFlag.aspx)
* [Enable-KeyRecoveryAgentFlag](https://www.sysadmins.lv/projects/pspki/Enable-KeyRecoveryAgentFlag.aspx) (Alias: **Enable-KRAFlag**)
* [Enable-PolicyModuleFlag](https://www.sysadmins.lv/projects/pspki/Enable-PolicyModuleFlag.aspx)
* [Get-ADKRACertificate](https://www.sysadmins.lv/projects/pspki/Get-ADKRACertificate.aspx)
* [Get-AuthorityInformationAccess](https://www.sysadmins.lv/projects/pspki/Get-AuthorityInformationAccess.aspx) (Alias: **Get-AIA**)
* [Get-CACryptographyConfig](https://www.sysadmins.lv/projects/pspki/Get-CACryptographyConfig.aspx)
* [Get-CAExchangeCertificate](https://www.sysadmins.lv/projects/pspki/Get-CAExchangeCertificate.aspx)
* [Get-CAKRACertificate](https://www.sysadmins.lv/projects/pspki/Get-CAKRACertificate.aspx)
* [Get-CASchema](https://www.sysadmins.lv/projects/pspki/Get-CASchema.aspx)
* [Get-CASecurityDescriptor](https://www.sysadmins.lv/projects/pspki/Get-CASecurityDescriptor.aspx) (Alias: **Get-CAACL**)
* [Get-CATemplate](https://www.sysadmins.lv/projects/pspki/Get-CATemplate.aspx)
* [Get-CertificateContextProperty](https://www.sysadmins.lv/projects/pspki/Get-CertificateContextProperty.aspx)
* [Get-CertificateRequest](https://www.sysadmins.lv/projects/pspki/Get-CertificateRequest.aspx)
* [Get-CertificateRevocationList](https://www.sysadmins.lv/projects/pspki/Get-CertificateRevocationList.aspx) (Alias: **Get-CRL**)
* [Get-CertificateRevocationListFlag](https://www.sysadmins.lv/projects/pspki/Get-CertificateRevocationListFlag.aspx) (Alias: **Get-CRLFlag**)
* [Get-CertificateTemplate](https://www.sysadmins.lv/projects/pspki/Get-CertificateTemplate.aspx)
* [Get-CertificateTemplateAcl](https://www.sysadmins.lv/projects/pspki/Get-CertificateTemplateAcl.aspx)
* [Get-CertificateTrustList](https://www.sysadmins.lv/projects/pspki/Get-CertificateTrustList.aspx) (Alias: **Get-CTL**)
* [Get-CertificateValidityPeriod](https://www.sysadmins.lv/projects/pspki/Get-CertificateValidityPeriod.aspx)
* [Get-CertificationAuthority](https://www.sysadmins.lv/projects/pspki/Get-CertificationAuthority.aspx) (Alias: **Get-CA**)
* [Get-CryptographicServiceProvider](https://www.sysadmins.lv/projects/pspki/Get-CryptographicServiceProvider.aspx)
* [Get-CRLDistributionPoint](https://www.sysadmins.lv/projects/pspki/Get-CRLDistributionPoint.aspx) (Alias: **Get-CDP**)
* [Get-CRLValidityPeriod](https://www.sysadmins.lv/projects/pspki/Get-CRLValidityPeriod.aspx)
* [Get-DatabaseRow](https://www.sysadmins.lv/projects/pspki/Get-DatabaseRow.aspx)
* [Get-EnrollmentPolicyServerClient](https://www.sysadmins.lv/projects/pspki/Get-EnrollmentPolicyServerClient.aspx)
* [Get-EnterprisePKIHealthStatus](https://www.sysadmins.lv/projects/pspki/Get-EnterprisePKIHealthStatus.aspx)
* [Get-ErrorMessage](https://www.sysadmins.lv/projects/pspki/Get-ErrorMessage.aspx)
* [Get-ExtensionList](https://www.sysadmins.lv/projects/pspki/Get-ExtensionList.aspx)
* [Get-FailedRequest](https://www.sysadmins.lv/projects/pspki/Get-FailedRequest.aspx)
* [Get-InterfaceFlag](https://www.sysadmins.lv/projects/pspki/Get-InterfaceFlag.aspx)
* [Get-IssuedRequest](https://www.sysadmins.lv/projects/pspki/Get-IssuedRequest.aspx)
* [Get-KeyRecoveryAgentFlag](https://www.sysadmins.lv/projects/pspki/Get-KeyRecoveryAgentFlag.aspx) (Alias: **Get-KRAFlag**)
* [Get-ObjectIdentifier](https://www.sysadmins.lv/projects/pspki/Get-ObjectIdentifier.aspx) (Alias: **oid**)
* [Get-ObjectIdentifierEx](https://www.sysadmins.lv/projects/pspki/Get-ObjectIdentifierEx.aspx) (Alias: **oid2**)
* [Get-PendingRequest](https://www.sysadmins.lv/projects/pspki/Get-PendingRequest.aspx)
* [Get-PolicyModuleFlag](https://www.sysadmins.lv/projects/pspki/Get-PolicyModuleFlag.aspx)
* [Get-RevokedRequest](https://www.sysadmins.lv/projects/pspki/Get-RevokedRequest.aspx)
* [Import-LostCertificate](https://www.sysadmins.lv/projects/pspki/Import-LostCertificate.aspx)
* [Install-CertificationAuthority](https://www.sysadmins.lv/projects/pspki/Install-CertificationAuthority.aspx)
* [New-CertificateRequest](https://www.sysadmins.lv/projects/pspki/New-CertificateRequest.aspx)
* [New-SelfSignedCertificateEx](https://www.sysadmins.lv/projects/pspki/New-SelfSignedCertificateEx.aspx)
* [Ping-ICertInterface](https://www.sysadmins.lv/projects/pspki/Ping-ICertInterface.aspx)
* [Publish-CRL](https://www.sysadmins.lv/projects/pspki/Publish-CRL.aspx)
* [Receive-Certificate](https://www.sysadmins.lv/projects/pspki/Receive-Certificate.aspx)
* [Register-ObjectIdentifier](https://www.sysadmins.lv/projects/pspki/Register-ObjectIdentifier.aspx)
* [Remove-AuthorityInformationAccess](https://www.sysadmins.lv/projects/pspki/Remove-AuthorityInformationAccess.aspx) (Alias: **Remove-AIA**)
* [Remove-CAAccessControlEntry](https://www.sysadmins.lv/projects/pspki/Remove-CAAccessControlEntry.aspx) (Alias: **Remove-CAACL**)
* [Remove-CAKRACertificate](https://www.sysadmins.lv/projects/pspki/Remove-CAKRACertificate.aspx)
* [Remove-CATemplate](https://www.sysadmins.lv/projects/pspki/Remove-CATemplate.aspx)
* [Remove-CertificateEnrollmentPolicyService](https://www.sysadmins.lv/projects/pspki/Remove-CertificateEnrollmentPolicyService.aspx)
* [Remove-CertificateEnrollmentService](https://www.sysadmins.lv/projects/pspki/Remove-CertificateEnrollmentService.aspx)
* [Remove-CertificateTemplate](https://www.sysadmins.lv/projects/pspki/Remove-CertificateTemplate.aspx)
* [Remove-CertificateTemplateAcl](https://www.sysadmins.lv/projects/pspki/Remove-CertificateTemplateAcl.aspx)
* [Remove-CRLDistributionPoint](https://www.sysadmins.lv/projects/pspki/Remove-CRLDistributionPoint.aspx) (Alias: **Remove-CDP**)
* [Remove-DatabaseRow](https://www.sysadmins.lv/projects/pspki/Remove-DatabaseRow.aspx) (Alias: **Remove-Request**)
* [Remove-ExtensionList](https://www.sysadmins.lv/projects/pspki/Remove-ExtensionList.aspx)
* [Restart-CertificationAuthority](https://www.sysadmins.lv/projects/pspki/Restart-CertificationAuthority.aspx)
* [Restore-CertificateRevocationListFlagDefault](https://www.sysadmins.lv/projects/pspki/Restore-CertificateRevocationListFlagDefault.aspx) (Alias: **Restore-CRLFlagDefault**)
* [Restore-KeyRecoveryAgentFlagDefault](https://www.sysadmins.lv/projects/pspki/Restore-KeyRecoveryAgentFlagDefault.aspx) (Alias: **Restore-KRAFlagDefault**)
* [Restore-PolicyModuleFlagDefault](https://www.sysadmins.lv/projects/pspki/Restore-PolicyModuleFlagDefault.aspx)
* [Revoke-Certificate](https://www.sysadmins.lv/projects/pspki/Revoke-Certificate.aspx)
* [Set-AuthorityInformationAccess](https://www.sysadmins.lv/projects/pspki/Set-AuthorityInformationAccess.aspx)
* [Set-CACryptographyConfig](https://www.sysadmins.lv/projects/pspki/Set-CACryptographyConfig.aspx)
* [Set-CAKRACertificate](https://www.sysadmins.lv/projects/pspki/Set-CAKRACertificate.aspx)
* [Set-CASecurityDescriptor](https://www.sysadmins.lv/projects/pspki/Set-CASecurityDescriptor.aspx) (Alias: **Set-CAACL**)
* [Set-CATemplate](https://www.sysadmins.lv/projects/pspki/Set-CATemplate.aspx)
* [Set-CertificateExtension](https://www.sysadmins.lv/projects/pspki/Set-CertificateExtension.aspx)
* [Set-CertificateTemplateAcl](https://www.sysadmins.lv/projects/pspki/Set-CertificateTemplateAcl.aspx)
* [Set-CertificateValidityPeriod](https://www.sysadmins.lv/projects/pspki/Set-CertificateValidityPeriod.aspx)
* [Set-CRLDistributionPoint](https://www.sysadmins.lv/projects/pspki/Set-CRLDistributionPoint.aspx) (Alias: **Set-CDP**)
* [Set-CRLValidityPeriod](https://www.sysadmins.lv/projects/pspki/Set-CRLValidityPeriod.aspx)
* [Set-ExtensionList](https://www.sysadmins.lv/projects/pspki/Set-ExtensionList.aspx)
* [Show-Certificate](https://www.sysadmins.lv/projects/pspki/Show-Certificate.aspx)
* [Show-CertificateRevocationList](https://www.sysadmins.lv/projects/pspki/Show-CertificateRevocationList.aspx) (Alias: **Show-CRL**)
* [Show-CertificateTrustList](https://www.sysadmins.lv/projects/pspki/Show-CertificateTrustList.aspx) (Alias: **Show-CTL**)
* [Start-CertificationAuthority](https://www.sysadmins.lv/projects/pspki/Start-CertificationAuthority.aspx)
* [Start-PsFCIV](https://www.sysadmins.lv/projects/pspki/Start-PsFCIV.aspx)
* [Stop-CertificationAuthority](https://www.sysadmins.lv/projects/pspki/Stop-CertificationAuthority.aspx)
* [Submit-CertificateRequest](https://www.sysadmins.lv/projects/pspki/Submit-CertificateRequest.aspx)
* [Test-WebServerSSL](https://www.sysadmins.lv/projects/pspki/Test-WebServerSSL.aspx)
* [Uninstall-CertificationAuthority](https://www.sysadmins.lv/projects/pspki/Uninstall-CertificationAuthority.aspx)
* [Unregister-ObjectIdentifier](https://www.sysadmins.lv/projects/pspki/Unregister-ObjectIdentifier.aspx)

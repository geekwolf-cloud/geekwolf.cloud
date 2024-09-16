---
layout: post
title:  "Deep dive into Windows hybrid join"
description: A deep dive into the Windows hybrid join process, what the steps within the hybrid join process are, and how to do basic troubleshooting.
date:   2024-04-19 06:56:25 +0100
category: on-premises
tags: on-premises migration technical-deepdive identity workstation
image: \android-chrome-192x192.png
comments_id: 19
---
<h1>{{ page.title }}</h1>

Entra Hybrid Join (EHJ) is a critical feature that allows Windows 10/11 devices to be registered in both on-premises Active Directory (AD) and Entra ID (previously Azure AD). This capability enables seamless single sign-on (SSO) across on-premises and cloud services, simplifying device management and enhancing security. This blog will guide you through the hybrid join process, including prerequisites, technical details, and troubleshooting steps.

## Prerequisites for hybrid join

Before initiating the hybrid join process, ensure the following prerequisites are met:

- **Windows 10/11 Enterprise, Pro, or Education**: Devices must run a supported version of Windows 10/11.
- **Azure AD Premium or Microsoft 365 licences**: Users must have the necessary Azure AD or Microsoft 365 subscriptions.
- **On-premises AD**: Your on-premises Active Directory must be synchronised with Azure AD using Entra Connect.
- **Entra Connect**: Ensure that Azure AD Connect (Entra Connect) is configured and running to synchronise identities between on-premises AD and Azure AD.
- **Network requirements**: Devices must have access to required Microsoft URL endpoints to communicate with Azure AD.
- **Group Policy Settings (GPO)**: Necessary GPOs must be configured to enable device registration.

## URL calls in the hybrid join process

During the hybrid join process, Windows devices make several key URL calls to Microsoft services for registration with Azure AD:

- **Device authentication request**: The device sends a request to authenticate against Azure AD through a specific enterprise registration endpoint.
  
- **STS (Security Token Service) authentication**: The device contacts the STS to obtain a Primary Refresh Token (PRT) after successful authentication.
  
- **Certificate enrolment**: If certificate-based authentication is enabled, the device contacts the Azure AD Certificate Enrolment service to obtain the necessary certificates.

## Certificates in hybrid join

Certificates play a vital role in the hybrid join process, particularly for securing device communication with Azure AD.

- **Device certificate creation**: Upon successful authentication, a device certificate is generated and stored in the 'userCertificate' attribute of the computer object in AD. This certificate is essential for ongoing device authentication to Azure AD.
  
- **Certificate storage and retrieval**: The device certificate is synchronised to Azure AD by Entra Connect, allowing Azure AD to validate the device’s identity during registration. The certificate is stored in the local machine certificate store, typically under the Personal > Certificates section.

- **Certificate renewal**: Devices automatically renew their certificates if they are nearing expiration, ensuring continued access to Azure AD resources.

## Group Policy Object (GPO) settings

To enable hybrid join, specific GPO settings must be configured on Windows 10/11 devices:

- **Enable automatic registration**: This GPO must be enabled to allow the device to automatically register with Azure AD.
  
- **Configure Tenant ID**: Specify the Azure AD tenant ID in this GPO to guide the device to the correct Azure AD tenant.

## Service Connection Point (SCP) and registry keys

### Service Connection Point (SCP)

The SCP is an object in Active Directory that directs the hybrid join process to the appropriate Azure AD tenant. Created by Entra Connect during initial configuration, the SCP contains the Azure AD tenant ID and the URL used by devices for Azure AD registration.

### Registry keys for tenant targeting

When SCPs are not used or more control is required, specific registry keys can direct the hybrid join process to the correct Azure AD tenant:

- Under the key `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ`, settings like `TenantId`, `TenantName`, and `TenantDomain` allow for specifying the Azure AD tenant ID, friendly name, and domain name, respectively.
  
- Under the key `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceReg\Install`, settings like `JoinWorkplace` and `JoinAAD` control whether the device will attempt a hybrid join or directly join Azure AD.

- Additionally, the key `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\Domains\{domain}` may contain `TenantGuid`, which associates specific on-premises domains with Azure AD tenants, useful in multi-domain environments.

## Interaction with Entra Connect sync

Azure AD Connect (Entra Connect) is responsible for synchronising identities between on-premises AD and Azure AD, playing a key role in the hybrid join process:

- **Synchronising device objects**: Entra Connect syncs device objects from on-premises AD to Azure AD, ensuring they are represented in both directories.

- **SCP configuration**: Entra Connect creates and configures the SCP in Active Directory, which directs domain-joined devices to the correct Azure AD tenant.

- **Conditional access**: Entra Connect syncs device information to Azure AD, allowing you to enforce Conditional Access policies based on the device’s hybrid join status.

## Troubleshooting the hybrid join process

Despite careful configuration, issues may arise during the hybrid join process. Here’s how to troubleshoot these problems effectively.

### Key event logs for troubleshooting

Windows provides several event logs that can help diagnose hybrid join issues:

#### **Device registration log**

- Path: Applications and Services Logs > Microsoft > Windows > User Device Registration
- Key Events:
  - **Event ID 304**: Indicates successful device registration with Azure AD.
  - **Event ID 305**: Indicates failure to authenticate with Azure AD.
  - **Event ID 307**: Device registration was successful, but policy enrolment failed.
  - **Event ID 201**: Indicates the start of the hybrid join process.

#### **Operational log**

- Path: Applications and Services Logs > Microsoft > Windows > AAD
- Key Events:
  - **Event ID 1098**: Indicates the start of the Azure AD join process.
  - **Event ID 1089**: The device is attempting to retrieve a token from Azure AD.
  - **Event ID 1102**: The device successfully obtained a Primary Refresh Token (PRT).

#### **Group Policy log**

- Path: Applications and Services Logs > Microsoft > Windows > GroupPolicy
- Key Events:
  - **Event ID 1502**: Indicates successful GPO application.
  - **Event ID 108**: Indicates GPO application failure.

#### **Directory services log**

- Path: Event Viewer > Windows Logs > Directory Service
- Key Events:
  - **Event ID 2889**: Indicates successful LDAP connection to AD.
  - **Event ID 36870**: Indicates a missing certificate, possibly signalling an issue with the 'userCertificate' retrieval.

### Using 'dsregcmd' for troubleshooting

The 'dsregcmd' tool is essential for diagnosing hybrid join issues. It provides detailed information about a device’s Azure AD registration status.

#### **Common 'dsregcmd' commands**

- **dsregcmd /status**: Provides an overview of the device’s registration status, including Azure AD join, tenant information, and certificate status. Key indicators include 'AzureAdJoined', which should be 'YES' if the device is successfully joined to Azure AD, and 'DomainJoined', which should be 'YES' if the device is still joined to on-premises AD. Additionally, you can verify the Azure AD tenant with the 'TenantId' and check certificate information.
  
- **dsregcmd /debug**: Provides detailed debugging information, useful for deeper troubleshooting.

- **dsregcmd /leave**: Forces the device to leave Azure AD, useful for resetting the hybrid join status.

### Common troubleshooting scenarios and solutions

#### **Device fails to register with Azure AD**

- **Symptoms**: Device does not appear in Azure AD or shows errors in the User Device Registration logs.
- **Causes**:
  - **Network issues**: Ensure the device can reach Azure AD endpoints.
  - **SCP misconfiguration**: Verify the SCP in Active Directory.
  - **GPO application issues**: Check the GPO logs for any failures.
- **Solution**: Check event logs for Event ID 305 or 201, validate SCP configuration, and use 'dsregcmd /status' to check registration status.

#### **Certificate issues**

- **Symptoms**: Device is Azure AD registered but fails to authenticate or renew the certificate.
- **Causes**:
  - **Expired certificate**: Check the certificate’s validity in the local machine store.
  - **Misconfigured 'userCertificate' attribute**: Ensure the correct certificate is present and synchronised to Azure AD.
- **Solution**: Review the 'userCertificate' attribute in Active Directory to ensure that it contains the correct device certificate. You can use tools like Active Directory Users and Computers (ADUC) or ADSI Edit to inspect the attribute. Ensure that this certificate is also synchronised correctly to Azure AD through Entra Connect. Additionally, check the certificate store on the local machine (typically under the Personal > Certificates section) to confirm that the certificate is valid and not expired. If necessary, renew the certificate or re-initiate the hybrid join process.

#### **Multi-tenant confusion**

- **Symptoms**: The device registers with the wrong Azure AD tenant, or fails to join any tenant.
- **Causes**:
  - **Incorrect SCP or registry settings**: In multi-tenant environments, misconfigured SCPs or incorrect registry settings can lead to confusion about which tenant the device should join.
- **Solution**: Validate the Service Connection Point (SCP) settings in Active Directory or verify the relevant registry keys using 'dsregcmd /status' to ensure the device is targeting the correct Azure AD tenant. If SCPs are not used, make sure that the registry keys like 'TenantId' and 'TenantDomain' are correctly configured for the intended tenant.

## Conclusion

Entra Hybrid Join is a powerful feature that bridges the gap between on-premises Active Directory and Entra ID, enabling seamless and secure access to resources across both environments. However, the process involves several components, from Service Connection Points and registry keys to certificates and Entra Connect synchronization, that must all be correctly configured for a successful join.

Troubleshooting hybrid join issues can be complex, but by focusing on key event logs, understanding the role of certificates, and using tools like 'dsregcmd', administrators can diagnose and resolve problems efficiently. Whether you're dealing with a device that fails to register with Azure AD, certificate issues, or multi-tenant confusion, the strategies outlined in this blog should help you maintain a smooth and secure hybrid join process in your organization.

By ensuring that all prerequisites are met, configuring GPOs and SCPs correctly, and knowing where to look when things go wrong, you can make the most of Entra Hybrid Join and provide users with a seamless experience across all their devices.

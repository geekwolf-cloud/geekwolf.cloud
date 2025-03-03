---
layout: post
title:  "Introduction to M365 kerberos.microsoftonline.com"
description: Microsoft 365 uses Kerberos for various SSO functions.  This blogs explores Kerberos.microsoftonline.com and how it works
date:   2025-03-03 16:55:53 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 58
---
<h1>{{ page.title }}</h1>

This blog post provides a technical overview of how Microsoft 365 and Microsoft Entra ID (formerly Azure Active Directory) use the special Kerberos realm **kerberos.microsoftonline.com** for single sign-on (SSO), cloud Kerberos trust, and enabling Entra-joined (Azure AD–joined) devices to access on-premises resources. It explains how the system works, what is contained in the primary refresh token (PRT), how the device knows which endpoint to use for requesting Kerberos tickets, and the configurations required.

## Background: Kerberos at a glance

**Kerberos** is a widely used network authentication protocol that relies on tickets:

1. A client obtains a ticket-granting ticket (TGT) from a Key Distribution Centre (KDC).  
2. The client uses the TGT to request service tickets for individual services.  
3. A service ticket allows access to the service without prompting for additional credentials.

In a traditional on-premises Active Directory (AD) environment, domain controllers act as the KDC. In the cloud, Microsoft Entra ID provides KDC-like capabilities by issuing and validating Kerberos tickets for the **kerberos.microsoftonline.com** realm.

## Why 'kerberos.microsoftonline.com' as a realm?

Microsoft Entra ID is not a traditional LDAP-based domain controller, yet it includes the functionality required to issue and validate Kerberos tickets. This capability supports:

- Seamless single sign-on (SSO) for Entra-joined or hybrid-joined Windows devices  
- Windows Hello for Business cloud Kerberos trust and FIDO2-based passwordless authentication  
- Access to on-premises resources from cloud-joined devices without prompting for on-premises credentials

To differentiate its cloud-issued tickets from on-premises AD realms (for example, `CONTOSO.COM`), Microsoft uses **kerberos.microsoftonline.com** as the dedicated Kerberos realm.

## The primary refresh token (PRT) and Kerberos

### What is the PRT?

When a user signs in to a Windows device that is Entra-joined or hybrid-joined, Microsoft Entra ID issues a primary refresh token (PRT). It is cryptographically bound to both the **user** and the **device**. The PRT:

- Grants continuous access to Microsoft 365 and other Entra ID–protected resources  
- Is protected by the device’s hardware (via TPM if available)  
- Contains sufficient user and device identity data for silent token and ticket acquisition

### How the PRT enables cloud Kerberos

The Windows CloudAP plug-in uses the PRT to request a Kerberos TGT from Entra ID for the realm **kerberos.microsoftonline.com**. Entra ID validates the PRT’s claims and issues the TGT. This TGT is then used to request service tickets for cloud resources or, where configured, for on-premises resources.

## How the device knows where to obtain the Kerberos ticket

Windows locates the Entra ID endpoints for Kerberos by querying the well-known metadata endpoints. When the device authenticates with Entra ID, it retrieves service information that includes the specific URL for Kerberos ticket requests. The endpoint references come from the OpenID Connect or common endpoints metadata document published by Microsoft Entra ID at the following address:

https://login.microsoftonline.com/<tenant-id-or-common>/.well-known/openid-configuration

This metadata indicates how the client should request Kerberos tickets from **kerberos.microsoftonline.com**. After validating the user’s PRT, the CloudAP plug-in calls these Entra ID Kerberos endpoints to obtain the TGT.

## Cloud Kerberos trust

### Overview

Cloud Kerberos trust is a Windows Hello for Business (WHfB) deployment option where Microsoft Entra ID issues Kerberos tickets in the **kerberos.microsoftonline.com** realm. Once the user has authenticated (for example, via PIN or biometric in WHfB), Entra ID provides a TGT for **kerberos.microsoftonline.com**. This enables the user to access:

- Cloud resources (SharePoint Online, Exchange Online, etc.)  
- On-premises resources (file shares, printers, and line-of-business apps), provided there is a trust relationship with on-premises AD

### Prerequisites for cloud Kerberos trust

1. Hybrid identity: Synchronise on-premises AD with Microsoft Entra ID (using Azure AD Connect / Microsoft Entra Connect). Password hash synchronisation (PHS) or pass-through authentication must be set up.  
2. Windows Hello for Business (cloud Kerberos trust): Configure your environment so on-premises domain controllers recognise Entra ID–issued Kerberos tickets.  
3. Device registration: Ensure Windows devices are Entra-joined or hybrid-joined so they can receive a PRT.

## Accessing on-premises resources from Entra-joined devices

### The challenge

A purely cloud-joined device does not automatically hold an on-premises TGT. Traditionally, domain-joined machines contact an on-premises domain controller (e.g., `CONTOSO.COM`) to retrieve a TGT. To allow a user on an Entra-joined device to access on-premises resources without re-entering credentials, you must set up a trust that recognises cloud-issued Kerberos tickets.

### The bridge: Entra ID Kerberos trust

Microsoft Entra ID issues a **kerberos.microsoftonline.com** TGT after validating the user’s PRT. Entra ID then uses a Kerberos trust arrangement with on-premises AD so domain controllers accept tickets that Entra ID signs. This arrangement involves:

- A Kerberos service account (often named AZUREADSSOACC) in on-premises AD  
- Shared cryptographic secrets that let on-premises AD verify tickets issued by Entra ID  

Windows uses its TGT from **kerberos.microsoftonline.com** to request service tickets for on-premises services. On-premises domain controllers validate these tickets if the trust is configured properly.

## What is in the PRT for Kerberos?

The PRT contains the necessary information for the CloudAP plug-in to request Kerberos tickets on the user’s behalf:

- User identity claims (allowing Entra ID to identify the user)  
- Device identity and tenant binding (ensuring the correct tenant and device)  
- Session key / proof key (supporting silent requests to Entra ID)  
- On-premises domain attributes (such as UPN suffix or on-premises SID, enabling Entra ID to route Kerberos requests correctly)

The TGT itself is not included in the PRT. Instead, the PRT allows Windows to request a fresh TGT from **kerberos.microsoftonline.com** as needed.

## End-to-end flow: SSO with Kerberos in Microsoft Entra ID

1. **User sign-in**  
   The user signs in on a Windows device that is Entra-joined or hybrid-joined. The device acquires a PRT that is cryptographically bound to the user and device.

2. **Obtain a cloud TGT**  
   The CloudAP plug-in consults the Entra ID metadata to locate the Kerberos endpoint for **kerberos.microsoftonline.com**. It presents the PRT to prove the user’s identity. Entra ID issues a TGT in that realm.

3. **Use the TGT**  
   - For cloud resources, the client may use Kerberos tickets or OAuth tokens, depending on the service.  
   - For on-premises resources, if cloud Kerberos trust is enabled, Entra ID can provide service tickets that on-premises domain controllers accept.

4. **No separate credential prompt**  
   The user enjoys seamless single sign-on, including to on-premises file shares, printers, and apps, because on-premises AD trusts the tickets that Entra ID has issued.

## Required configuration

### Directory synchronisation

- Azure AD Connect / Microsoft Entra Connect synchronises on-premises AD data into Entra ID.  
- Password hash synchronisation (PHS) or pass-through authentication allows Entra ID to validate user credentials without contacting the domain controller on every sign-in.

### Windows Hello for Business (cloud Kerberos trust)

- Enable Windows Hello for Business with cloud Kerberos trust so that Microsoft Entra ID can serve as the Kerberos authority.  
- This provides passwordless sign-in and ensures that on-premises AD validates the Entra ID–issued tickets.

### Kerberos service account in on-premises AD

- A Kerberos service account (often named AZUREADSSOACC) is created in your on-premises AD.  
- Microsoft Entra ID leverages the key material of this account to sign Kerberos tickets that on-premises DCs recognise.

### Device registration and PRT issuance

- Windows devices must be Entra-joined or hybrid-joined so they can receive a PRT.  
- The PRT is crucial for silent ticket acquisition from the **kerberos.microsoftonline.com** realm.

## Troubleshooting tips

1. **Check for a TGT**  
   Run `klist tickets` in Command Prompt or PowerShell to verify that a TGT for krbtgt/kerberos.microsoftonline.com is present.

2. **Examine event logs**  
   - In Event Viewer, open Applications and Services Logs → Microsoft → Windows → AAD to see CloudAP logs.  
   - Check on-premises domain controller logs for evidence of validating cloud-issued Kerberos tickets.

3. **verify Azure AD Connect**  
   Confirm that password synchronisation or pass-through authentication is working. Ensure user UPNs, SIDs, and domain data are correctly synchronised.

4. **SPNs and trust**  
   Validate the service principal names (SPNs) on the on-premises Kerberos service account.  
   Confirm that your on-premises domain controllers recognise and trust tickets signed by Entra ID.

## Conclusion

Microsoft Entra ID (formerly Azure AD) acts as a **cloud KDC** by issuing Kerberos tickets in the **kerberos.microsoftonline.com** realm. The **PRT** on a Windows device enables automatic TGT acquisition whenever Kerberos authentication is required. Cloud Kerberos trust ensures on-premises domain controllers accept these tickets, delivering seamless SSO to both cloud and on-premises resources.

**Key points**:

- **kerberos.microsoftonline.com** is the realm used by Entra ID to issue cloud Kerberos tickets.  
- The **PRT** contains the claims and keys the device needs to request a Kerberos TGT from Entra ID.  
- The device discovers the Kerberos endpoint from well-known OpenID Connect metadata.  
- **Azure AD Connect** synchronises on-premises identity data, enabling Entra ID to create valid service tickets for those on-premises domains.  
- **Cloud Kerberos trust** allows on-premises AD to validate and accept tickets from Entra ID, providing true single sign-on without additional prompts.

---
layout: post
title:  "Deep dive into Azure AD SSO"
description: A deep dive into Azure AD (now Entra ID) Single Sign On. what is this AzureADSSOAcc account in Active Directory?
date:   2024-04-25 18:01:59 +0100
category: entra-id
tags: on-premises entra-id migration technical-deepdive identity workstation
comments_id: 20
---
<h1>{{ page.title }}</h1>


As organisations increasingly adopt cloud-first strategies, hybrid environments have become the norm. Azure Active Directory (Azure AD), now part of Microsoft's Entra product family, is the identity platform for managing users, devices, and access to resources across cloud and on-premises environments. One critical aspect of this integration is ensuring seamless Single Sign-On (SSO) for Azure AD-joined devices when accessing on-premises resources. This blog post will delve deeply into how Azure AD SSO works for Entra joined devices, focusing on obtaining Kerberos tickets, NTLM authentication, and the pivotal roles of Service Principal Names (SPNs) and the AzureADSSO account. Additionally, we'll cover troubleshooting techniques for resolving issues in this process.

## Understanding Azure AD and hybrid identity

Before diving into the specifics of SSO, it's essential to understand Azure AD and its interaction with on-premises Active Directory (AD). Azure AD is a cloud-based identity and access management service that provides authentication and authorisation services for cloud applications. In a hybrid environment, Azure AD integrates with on-premises AD to allow users and devices to authenticate against both systems, depending on where the resource is located.

**Key components:**
- **Azure AD**: Manages identities and provides access to cloud applications.
- **On-premises AD**: Manages identities and access to on-premises resources.
- **Hybrid identity**: The integration of Azure AD and on-premises AD, enabling seamless access to both cloud and on-premises resources.

## The SSO flow for Entra joined devices accessing on-premises resources

When an Azure AD-joined device (also referred to as an Entra joined device) needs to access an on-premises resource, the process involves multiple steps and interactions between Azure AD, on-premises AD, and various protocols such as Kerberos and NTLM.

### Device registration and authentication

The process begins when a device is joined to Azure AD. This registration process involves the following steps:
1. **Device registration**: The device is registered in Azure AD, creating a device object in Azure AD.
2. **Primary Refresh Token (PRT)**: After registration, the device obtains a Primary Refresh Token (PRT) from Azure AD. The PRT contains information about the user and the device and is used to request access tokens for various applications and services.
3. **Device authentication**: The device uses the PRT to authenticate with Azure AD, establishing a trust relationship between the device, Azure AD, and on-premises AD.

### Accessing on-premises resources

When a user on an Azure AD-joined device attempts to access an on-premises resource, the process can take one of two paths depending on whether Kerberos or NTLM is used.

#### Kerberos authentication

1. **SPNEGO and Kerberos ticket request**:
   - The client device attempts to access an on-premises resource (e.g., a file share or a web application).
   - The application server requests authentication using the **Simple and Protected GSS-API Negotiation Mechanism (SPNEGO)**, which typically defaults to Kerberos.
   - The device, acting on behalf of the user, initiates a Kerberos ticket request.

2. **Azure AD DS Connector**:
   - The device communicates with the **Azure AD DS Connector** (part of Azure AD Connect), which bridges the on-premises AD and Azure AD environments.
   - The AD DS Connector requests a Kerberos Ticket Granting Ticket (TGT) from the on-premises AD on behalf of the Azure AD-joined device.

3. **Ticket Granting Service (TGS)**:
   - Once the TGT is obtained, it is used to request a service ticket from the on-premises AD's Kerberos Ticket Granting Service (TGS).
   - This service ticket is used to authenticate to the on-premises resource.

4. **Access granted**:
   - The on-premises resource verifies the service ticket, and if valid, grants access to the resource.

#### NTLM authentication

1. **NTLM challenge/response**:
   - If the application server requests NTLM authentication, the client device proceeds with an NTLM challenge/response.
   - The server issues an NTLM challenge to the client device.

2. **Azure AD DS Connector for NTLM**:
   - The device sends the NTLM challenge response to the Azure AD DS Connector.
   - The Connector forwards the response to the on-premises AD domain controller for validation.

3. **NTLM validation**:
   - The on-premises AD validates the NTLM response against the user’s credentials stored in the domain.

4. **Access granted**:
   - If the validation is successful, the on-premises resource grants access to the client device.

## The role of SPNs in Azure AD SSO for on-premises access

Service Principal Names (SPNs) are crucial in the Kerberos authentication process. An SPN is a unique identifier for a service instance in a network and is used by Kerberos to associate a service instance with a service logon account. For Azure AD-joined devices to authenticate against on-premises resources using Kerberos, the correct SPNs must be set up in your on-premises Active Directory (AD).

### Common SPNs in Azure AD SSO

1. **Host SPN**:
   - **Format**: `HOST/<servername>` or `HOST/<servername.domain.com>`
   - **Use**: This is the default SPN that Kerberos uses to authenticate to any general-purpose service running on a host, such as SMB file shares, Remote Desktop, etc.

2. **HTTP SPN**:
   - **Format**: `HTTP/<servername>` or `HTTP/<servername.domain.com>`
   - **Use**: This SPN is used by web services or applications accessed over HTTP/HTTPS. It's crucial for services like SharePoint, IIS-hosted apps, or any web service running on-premises.

3. **Custom SPNs**:
   - **Examples**: `MSSQLSvc/<servername>:<port>` for SQL Server, `ldap/<servername>` for LDAP services.
   - **Use**: Specific services may require their own SPNs, especially if they are accessed via different protocols or ports.

For the Kerberos authentication to succeed, these SPNs must be correctly registered with the corresponding service accounts in your on-premises AD. Incorrect or missing SPNs can cause Kerberos authentication to fail, leading to access denied errors.

## The AzureADSSO account and its role in hybrid SSO

The AzureADSSO account is pivotal in enabling seamless Single Sign-On (SSO) for Azure AD-joined devices when accessing on-premises resources. This account is automatically created and managed by Azure AD Connect during the setup of **Seamless SSO**.

### What is the AzureADSSO account?

- **Account type**: A special computer account created in the on-premises AD.
- **Naming**: Typically named `AZUREADSSOACC` followed by a unique identifier.
- **Purpose**: This account is used by Azure AD to authenticate users to on-premises resources without prompting for additional credentials, leveraging either Kerberos or NTLM.

### How AzureADSSO works

1. **Kerberos ticket granting**:
   - The `AZUREADSSOACC` account is used to generate Kerberos tickets on behalf of Azure AD-joined devices.
   - During authentication, the device uses the Primary Refresh Token (PRT) to interact with the `AZUREADSSOACC` account and request a Kerberos Ticket Granting Ticket (TGT) from the on-premises AD domain controller.

2. **SPN association**:
   - The `AZUREADSSOACC` account must have the correct SPNs associated with it for the services it is expected to authenticate. Typically, these are the `HOST` and `HTTP` SPNs mentioned earlier.
   - Azure AD Connect automatically configures this account, including the registration of SPNs necessary for the Kerberos protocol.

3. **Seamless SSO mechanism**:
   - When an Azure AD-joined device tries to access an on-premises resource, it uses the Seamless SSO feature, which relies on the `AZUREADSSOACC` account to obtain the necessary Kerberos tickets without requiring the user to re-enter their credentials.

## Troubleshooting SPNs and AzureADSSO account

Given the importance of SPNs and the `AZUREADSSOACC` account in the SSO process, it’s essential to include specific troubleshooting steps related to these components.

### Troubleshooting SPNs

1. **Verify SPNs with `setspn`**:
   - Use the `setspn -L <account_name>` command to list the SPNs associated with a specific service account.
   - Ensure that the necessary SPNs (e.g., `HOST`, `HTTP`) are correctly registered on the appropriate accounts.

2. **Check for duplicate SPNs**:
   - Duplicate SPNs can cause Kerberos authentication failures. Use `setspn -X` to check for duplicates within the domain.

3. **Re-register SPNs if necessary**:
   - If SPNs are missing or incorrect, they can be re-registered using the `setspn` command. For example: `setspn -A HTTP/myserver.mydomain.com AZUREADSSOACC`.

### Troubleshooting AzureADSSO account

1. **Verify the AzureADSSO account existence**:
   - Confirm that the `AZUREADSSOACC` account exists in your on-premises AD. This account should have a "Managed Service Account" type or "Computer" type, depending on the configuration.

### Troubleshooting AzureADSSO account (continued)

2. **Check account permissions**:
   - The `AZUREADSSOACC` account should have appropriate permissions to read and write the necessary attributes in AD, particularly for handling Kerberos tickets.

3. **Review Azure AD Connect configuration**:
   - Ensure that Azure AD Connect is properly configured for Seamless SSO. Any misconfiguration can lead to failures in ticket generation or SPN resolution.
   - Use the Azure AD Connect tool to review and, if necessary, re-enable Seamless SSO, ensuring the correct SPNs and account permissions are set.

4. **Examine event logs**:
   - On the domain controllers, check the event logs under **"Security"** and **"System"** for any Kerberos-related errors, which might indicate issues with the `AZUREADSSOACC` account or its associated SPNs.

## Conclusion

Azure AD SSO for Entra joined devices accessing on-premises resources is a critical feature for ensuring seamless user experiences in hybrid environments. Understanding the underlying processes, from device registration and PRT management to Kerberos ticket issuance and NTLM authentication, is essential for maintaining a smooth operation. Properly configuring and troubleshooting components such as SPNs and the `AZUREADSSOACC` account is crucial for resolving authentication issues.

By following the detailed insights and troubleshooting techniques outlined above, IT administrators can ensure that their Azure AD-joined devices authenticate seamlessly to on-premises resources, thereby providing a reliable and efficient user experience.

---
layout: post
title:  "A look into authentication: Single Sign-On"
description: A journey into the world of authentication, from passwords, hashes, credentials, protocols, MFA, through to passwordless
date:   2025-01-14 06:55:14 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 53
---
<h1>{{ page.title }}</h1>

Here is the next part of our series on authentication. In our [previous post]({{ site.baseurl }}{% post_url 2025-01-07-A-look-into-authentication-Authentication-Protocols %}), we talked about authentication protocols passwordless: how this is the next step in the evolution of authentication and how they avoid a lot of the problems that plague passwords, hashes and credential storage.  This blog explores Single Sign On deployed in various authentication protocols 

---

Single sign-on (SSO) simplifies authentication by enabling users to access multiple resources with a single set of credentials. It builds on various authentication protocols, including **NTLM**, **Kerberos**, **OpenID**, **FIDO2/WebAuthn**, **RADIUS**, **TACACS+**, and **LDAP**, to provide secure and user-friendly authentication experiences.

This blog explores these protocols, their role in SSO, and dives into Microsoft's SSO mechanisms—**seamless SSO**, **AzureADSSOAcc**, **cloud Kerberos trust**, and **primary refresh token (PRT)**.

---

## Authentication protocols and their role in SSO

### NTLM (NT LAN Manager)

- **What it is**:  
  A legacy authentication protocol used primarily in Windows environments. NTLM uses a challenge-response mechanism to authenticate users without transmitting their passwords over the network.

- **SSO support**:  
  Limited. NTLM does not natively support SSO but can be used in environments where user credentials are cached for re-authentication to other systems. It often serves as a fallback mechanism when Kerberos is unavailable.

- **SSO example**:  
  In older Windows-based SSO implementations, NTLM may facilitate authentication between older applications and domain controllers.

---

### Kerberos

- **What it is**:  
  A modern, secure authentication protocol relying on ticket-granting mechanisms. Kerberos is the backbone of many SSO implementations in domain-based and hybrid environments.

- **SSO support**:  
  Excellent. Kerberos is specifically designed for SSO in both on-premises (Active Directory) and hybrid environments.

- **SSO examples**:  
  - **Seamless SSO**: Domain-joined devices use Kerberos to authenticate to Azure AD-integrated cloud resources.  
  - **Cloud Kerberos trust**: Azure AD leverages Kerberos tickets for passwordless access to on-premises resources.

---

### OpenID

- **What it is**:  
  A decentralised authentication protocol used to verify user identity across websites. Often associated with OpenID Connect, which is built on top of OAuth 2.0.

- **SSO support**:  
  Strong. OpenID enables SSO across web applications, allowing users to authenticate once and access multiple services.

- **SSO examples**:  
  - Federated SSO: Users authenticate via an OpenID provider (e.g., Google or Microsoft), which provides identity tokens to third-party applications.

---

### SAML

- **What it is**:  
  SAML (Security Assertion Markup Language) is an XML-based standard for exchanging authentication and authorisation data between an identity provider (IdP) and a service provider (SP). While not an authentication protocol itself, SAML enables federated identity and SSO by securely transmitting user identity information in the form of assertions.

- **SSO support**:  
  Strong. SAML is widely used for SSO in web-based applications, particularly in enterprise environments. It enables users to authenticate once with an identity provider and access multiple service providers without re-entering credentials. SAML is highly compatible with legacy systems, making it a staple for many SaaS providers.  

- **SSO examples**:  
  - Enterprise users log into SaaS applications like Salesforce, Workday, or Dropbox using a SAML-based identity provider such as Azure AD or Okta.  
  - Cross-organisational authentication scenarios, where employees from one company authenticate to another organisation’s resources using SAML federation.  
  - Educational institutions enabling access to shared platforms via a single login through SAML-based federations like InCommon.  

---


### FIDO2/WebAuthn

- **What it is**:  
  A modern authentication standard supporting passwordless login using public-key cryptography. It enables devices like security keys, biometrics, or PINs to authenticate users.

- **SSO support**:  
  Indirect. While FIDO2/WebAuthn itself does not natively support SSO, it integrates with systems like Azure AD that provide SSO capabilities through tokens like the primary refresh token (PRT).

- **SSO examples**:  
  - Passwordless SSO in Azure AD: Devices authenticated using FIDO2/WebAuthn can access both cloud and on-premises resources via the PRT.

---

### RADIUS (Remote Authentication Dial-In User Service)

- **What it is**:  
  A protocol for centralised authentication, authorisation, and accounting, commonly used in network access scenarios like VPNs or Wi-Fi authentication.

- **SSO support**:  
  Limited. RADIUS does not inherently provide SSO but can integrate with identity providers to enable seamless access to multiple network resources.

- **SSO examples**:  
  - Integration with Azure AD or LDAP to authenticate users once and provide access to VPN, Wi-Fi, and other networked services.

---

### TACACS+ (Terminal Access Controller Access-Control System Plus)

- **What it is**:  
  A protocol similar to RADIUS but focused on device-level authentication and command authorisation, often used in network devices like routers and switches.

- **SSO support**:  
  Minimal. TACACS+ is primarily used for device management and does not directly support SSO for user applications.

- **SSO examples**:  
  - Device administrators can authenticate once to manage multiple devices in a single session.

---

### LDAP (Lightweight Directory Access Protocol)

- **What it is**:  
  A directory service protocol for accessing and managing directory information (e.g., users and groups). LDAP is widely used in enterprise identity systems.

- **SSO support**:  
  Strong in legacy systems. LDAP can be leveraged as the identity provider backend for SSO implementations.

- **SSO examples**:  
  - On-premises SSO: LDAP can support SSO in systems like Active Directory, enabling authentication to multiple resources using a single set of credentials.

---

## Deep dive into SSO mechanisms


### OpenID and ID/JWT tokens

OpenID enables federated SSO across web applications, allowing users to authenticate once and access multiple services using ID tokens. OpenID Connect (OIDC) is built on OAuth 2.0 and provides a standard way for applications to verify user identity.

**How it works**:
1. A user initiates authentication with an OpenID provider (e.g., Google, Microsoft, or another identity provider).
2. The provider authenticates the user and issues an **ID token** (often a JWT), which contains claims about the user's identity.
3. The application validates the ID token and establishes a session, granting access to its resources without further user interaction.

**Key features**:
- Federated authentication for web applications.
- Uses JSON Web Tokens (JWTs) for secure, compact representation of user claims.
- Supports scenarios like social logins and enterprise SSO.

**Limitations**:
- Relies on the availability and security of the OpenID provider.
- Only facilitates SSO for web applications and services integrated with OpenID Connect.

**SSO examples**:
- Users log into multiple enterprise applications using Azure AD as an OpenID provider.
- A single authentication session with a social login provider grants access to third-party applications.

---

**How it works**:
1. **User request**: A user attempts to access a service provider (e.g., a web application).  
2. **Redirect to IdP**: The service provider redirects the user to the identity provider for authentication.  
3. **User authentication**: The identity provider authenticates the user using its internal mechanism (e.g., Kerberos, LDAP).  
4. **Assertion generation**: After successful authentication, the identity provider generates a **SAML assertion**, which is an XML-based document containing the user's identity and authorisation details.  
5. **Assertion transmission**: The SAML assertion is sent to the service provider via the user's browser (often using a POST or redirect binding).  
6. **Validation and access**: The service provider validates the SAML assertion against a trusted certificate. If valid, it establishes a session and grants the user access to the requested resource.  

**Key features**:
- **Federated SSO**: SAML allows users to authenticate with one identity provider and gain access to multiple service providers without re-entering credentials.  
- **Security**: Assertions are signed and can be encrypted, ensuring the integrity and confidentiality of user data.  
- **Cross-domain compatibility**: SAML supports SSO across multiple organisations and domains, making it ideal for enterprise and SaaS applications.  
- **Broad adoption**: Many legacy and modern systems support SAML, ensuring compatibility with a wide range of applications.  

**Limitations**:
- **Complex implementation**: Setting up SAML involves configuring certificates, metadata, and endpoints for both the identity provider and service provider.  
- **XML overhead**: SAML relies on XML, which can result in larger payloads compared to modern standards like OpenID Connect (which uses JSON).  
- **Browser-based restriction**: SAML is primarily designed for browser-based workflows and is less suitable for APIs or native mobile applications.  
- **Dependence on IdP**: If the identity provider is unavailable, users cannot access any service providers relying on that IdP.  

**SSO examples**:
- **Enterprise SaaS integration**: Employees use SAML to log into services like Salesforce, Workday, or Google Workspace with their corporate credentials, managed by an identity provider like Azure AD or Okta.  
- **Federated identity in education**: Universities enable cross-institutional access to platforms via SAML-based federations like InCommon or Shibboleth.  
- **Cross-organisation resource sharing**: Two organisations establish a trust relationship via SAML, enabling employees to access shared resources with their existing credentials.  

---

### Seamless SSO

Seamless SSO enables **domain-joined** or **hybrid-joined** devices to authenticate to Azure AD resources without user intervention. It leverages **Kerberos** for authentication.

**How it works**:
1. A user logs into a domain-joined or hybrid-joined Windows device and receives a Kerberos ticket from the on-premises AD.
2. When accessing an Azure AD-integrated cloud resource, the Kerberos ticket is automatically used to authenticate with Azure AD.
3. Azure AD validates the ticket using the trust established via Azure AD Connect, enabling access without additional credentials.

**Key features**:
- No user interaction required after signing into the device.
- Works with Windows 10/11 and supported browsers like Edge or Chrome.
- Enabled via Azure AD Connect and Group Policy.

**Limitations**:
- Requires devices to be domain-joined or hybrid-joined.
- Needs line-of-sight to the domain controller for initial Kerberos authentication.

---

### AzureADSSOAcc

AzureADSSOAcc is a service account created during the setup of seamless SSO by Azure AD Connect. It facilitates **Azure AD-joined devices** accessing **on-premises resources**.

**How it works**:
1. AzureADSSOAcc is created in the on-premises AD with a Service Principal Name (SPN) of `AZUREADSSOACC/<tenant-ID>`.
2. Azure AD issues a Kerberos service ticket using AzureADSSOAcc’s SPN for resource access.
3. The on-premises AD validates the ticket, granting the device access to resources.

**Key features**:
- Acts as a bridge between Azure AD and on-premises AD.
- Essential for hybrid identity setups.

**Limitations**:
- Primarily supports on-premises resource access.
- Requires proper Azure AD Connect setup.

---

### Cloud Kerberos trust

Cloud Kerberos trust enables **passwordless authentication** for Azure AD-joined devices accessing **on-premises resources**.

**How it works**:
1. Users sign into an Azure AD-joined device using a modern authentication method, like Windows Hello for Business.
2. Azure AD issues a **PRT**, which includes a Kerberos ticket from the on-premises AD.
3. The Kerberos ticket allows passwordless access to on-premises resources.

**Key features**:
- Simplifies hybrid setups by removing the need for complex federation.
- Enables passwordless SSO.
- Independent of AzureADSSOAcc.

**Limitations**:
- Requires Windows Hello for Business or similar authentication.
- Supported in specific hybrid configurations.

---

### Primary refresh token (PRT)

A **primary refresh token (PRT)** is a session token issued by Azure AD for Azure AD-joined or hybrid-joined devices. It enables seamless access to both cloud and on-premises resources.

**How it works**:
1. Azure AD issues a PRT when a user signs into the device.
2. The PRT is securely stored and used to retrieve access tokens for cloud and on-premises resources.
3. In hybrid scenarios, the PRT may include a Kerberos ticket for on-premises access.

**Key features**:
- Reduces the need for multiple authentications.
- Integrated with Windows Hello for Business.

**Limitations**:
- Requires Azure AD join or hybrid join.
- Needs specific configurations for on-premises resource access.

---
<div class="callout">
  <h3>kerberos.microsoftonline.com</h3>
  <p>
How Microsoft makes the SSO work from Entra ID to your on premises AD servers is via a meta realm called kerberos.microsoftonline.com.   During the PRT retrieval it gets back
  </p>
  <ul>
    <li>The PRT itself</li>
    <li>A cloud TGT (for Cloud Kerberos Trust)</li>
    <li>A FIDO TGT (for passwordless sign in, optional)</li>
    <li>A realm mapping (So Windows can send Kerberos to Microsoft for the desired URLs)</li>
    <li>The AAD tenant details (So Windows can send Entra ID Kerberos to the right Entra ID)</li>
  </ul>
  <p>
This combination of things is what allows the Entra ID to on premises SSO magic to happen.  It is very neat, and also explains why it will never be possible to have the same domain in two tenants for authentication, and why you can't have Cloud Kerberos Trusts from one AD forest to multiple tenants.   Thanks To Steve Syfuhs for his excellent blogs, in this case the <a href="https://syfuhs.net/how-azure-ad-kerberos-works">How Azure AD Kerberos Works blog</a>.  Simply brilliant!
  </p>
</div>

## Mapping SSO mechanisms to authentication protocols

| **SSO mechanism**      | **Supported protocols**         | **Description**                                                                                  |  
|------------------------|---------------------------------|--------------------------------------------------------------------------------------------------|  
| **Seamless SSO**       | Kerberos                       | Enables domain-joined or hybrid-joined devices to authenticate to Azure AD without re-entering credentials. |  
| **AzureADSSOAcc**      | Kerberos                       | Facilitates access from Azure AD-joined devices to on-premises resources by acting as a proxy for Kerberos. |  
| **Cloud Kerberos trust** | Kerberos                      | Provides passwordless access to on-premises resources from Azure AD-joined devices.              |  
| **Federated SSO**      | OpenID, RADIUS, LDAP           | Allows SSO across web applications or networked environments using identity federation.          |  
| **Passwordless SSO**   | FIDO2/WebAuthn, Kerberos       | Combines modern authentication with Azure AD for seamless access.                               |  


## Conclusion

By understanding seamless SSO, AzureADSSOAcc, cloud Kerberos trust, and primary refresh tokens, organisations can optimise hybrid identity environments. Each mechanism caters to different scenarios, ensuring secure and seamless resource access.

In the [next blog post]({{ site.baseurl }}{% post_url 2025-01-11-A-look-into-authentication-Summary %}) on authentication we will summarise and provide recommendation around what to avoid, what to aim for and how to secure protcols.
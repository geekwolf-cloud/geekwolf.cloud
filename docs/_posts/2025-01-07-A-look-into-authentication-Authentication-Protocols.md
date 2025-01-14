---
layout: post
title:  "A look into authentication: Authentication Protocols"
description: A journey into the world of authentication, from passwords, hashes, credentials, protocols, MFA, through to passwordless
date:   2025-01-07 07:01:37 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 52
---
<h1>{{ page.title }}</h1>

Here is the next part of our series on authentication. In our [previous post]({{ site.baseurl }}{% post_url 2024-12-17-A-look-into-authentication-Passwordless %}), we talked about passwordless: how this is the next step in the evolution of authentication and how they avoid a lot of the problems that plague passwords, hashes and credential storage.  This blog explores authentication protocols from legacy systems like LAN Manager and NTLM to modern approaches like Kerberos, OAuth, and WebAuthn/FIDO2. While focusing on Windows and Microsoft Entra ID (formerly Azure AD), we also include other commonly used protocols. Finally, we’ll discuss how modern security features like **continuous access evaluation (CAE)** enhance these protocols. 

---

Authentication protocols play a crucial role in verifying the identity of users and systems in modern networks. This blog explores the most commonly used authentication protocols, focusing on their usage, authentication flows, and encryption techniques.

## NTLM (NT LAN Manager)

**Relevance:** Moderate  
NTLM is a legacy protocol used when Kerberos is unavailable, particularly in older Windows systems.

**Usage:**  
- Found in environments supporting older versions of Windows.  
- Used for backward compatibility in some mixed environments.  

**Flow:**  
1. The client sends a hashed version of the password to the server.  
2. The server validates the hash without transmitting the plaintext password.  

**Encryption:**  
Uses **MD4** or **RC4** for hashing. NTLM is vulnerable to **pass-the-hash** attacks, making it less secure than modern protocols.

---

## Kerberos

**Relevance:** High  
Kerberos is a widely used protocol in **Active Directory (AD)** environments, enabling mutual authentication between clients and servers.  

**Usage:**  
- Primarily used in Windows-based networks.  
- Can also be integrated with Linux/macOS systems for AD authentication.  

**Flow:**  
1. The client sends a request for a **Ticket Granting Ticket (TGT)** to the **Key Distribution Centre (KDC)**.  
2. After validating the request, the KDC issues the TGT.  
3. The client uses the TGT to request service tickets for access to resources.  

**Encryption:**  
Kerberos employs strong encryption like **AES** for securing tickets. Older versions used **RC4**, which is vulnerable to certain attacks, such as using the NT hash to authenticate without the password.

---

## OpenID Connect (OIDC)

**Relevance:** High  
OIDC is an authentication protocol built on top of OAuth 2.0, designed explicitly for verifying user identity.

**Usage:**  
- Used in web-based and mobile applications.  
- Enables SSO by allowing users to authenticate once and access multiple applications.  

**Flow:**  
1. The user is redirected to an **identity provider** for authentication.  
2. Upon successful login, an **ID token** is issued to the client application.  
3. The ID token contains identity information (e.g., username, email).  

**Encryption:**  
ID tokens are signed (and optionally encrypted) using **RSA** or **ECDSA**.

---

## FIDO2 / WebAuthn

**Relevance:** High  
FIDO2 and WebAuthn enable **passwordless authentication**, offering a highly secure alternative to traditional password-based methods.

**Usage:**  
- Supported by modern browsers and devices.  
- Commonly used with **hardware security keys** (e.g., YubiKeys) or **biometric authentication**.  

**Flow:**  
1. The client device generates a **public-private key pair** for authentication.  
2. The private key remains secure on the device, while the public key is shared with the server.  
3. Authentication is validated by signing a challenge with the private key.  

**Encryption:**  
Uses **public key cryptography**, ensuring that private keys never leave the user’s device.

---

## RADIUS (Remote Authentication Dial-In User Service)

**Relevance:** High  
RADIUS is a protocol designed for network access authentication, widely used for services such as Wi-Fi and VPNs.

**Usage:**  
- Commonly deployed in enterprise environments.  
- Integrates with directory services like Active Directory for credential validation.  

**Flow:**  
1. The client sends credentials to a **RADIUS server**.  
2. The server verifies credentials against a backend directory and responds with an accept or reject message.  

**Encryption:**  
The password is encrypted using **MD5**, while other data is transmitted in plaintext.

---

## TACACS+ (Terminal Access Controller Access Control System Plus)

**Relevance:** Moderate  
TACACS+ is a protocol used for authenticating access to network devices, particularly in environments with Cisco equipment.

**Usage:**  
- Provides centralised authentication for network devices.  
- Often used in conjunction with RADIUS for enhanced security.  

**Flow:**  
1. The client sends a request to the TACACS+ server.  
2. The server authenticates the user and sends back a success or failure response.  

**Encryption:**  
Encrypts the **entire payload**, unlike RADIUS, which only encrypts the password.

---

## LDAP (Lightweight Directory Access Protocol)

**Relevance:** Moderate  
LDAP is primarily a **directory access protocol**, but it is widely used for authentication when integrated with systems like Active Directory or OpenLDAP.

**Usage:**  
- Common in enterprise environments for user authentication and directory management.  

**Flow:**  
1. The client sends a **bind request** with credentials to the LDAP server.  
2. The server validates the credentials and returns a success or failure response.  

**Encryption:**  
LDAP communication can be encrypted using **TLS** (referred to as LDAPS).

---

## Summary table of authentication protocols

| **Protocol**           | **Relevance**      | **Usage**                                    |
|------------------------|--------------------|----------------------------------------------|
| **NTLM**               | Moderate           | Legacy authentication, used when Kerberos is unavailable. |
| **Kerberos**           | High               | Used for mutual authentication in AD environments. |
| **OpenID Connect**     | High               | Authentication built on OAuth 2.0, used for web SSO. |
| **FIDO2 / WebAuthn**   | High               | Passwordless authentication using public key cryptography. |
| **RADIUS**             | High               | Network access authentication (e.g., VPN, Wi-Fi). |
| **TACACS+**            | Moderate           | Network device authentication, especially in Cisco environments. |
| **LDAP**               | Moderate           | Directory-based authentication (e.g., Active Directory). |

---

<div class="callout">
  <h3>Continuous Access Evaluation (CAE)</h3>
  <p>
    <strong>Continuous Access Evaluation (CAE)</strong> is a modern enhancement to authentication workflows, primarily implemented in 
    <strong>Microsoft Entra ID (formerly Azure AD)</strong>. While not an authentication protocol itself, CAE ensures that access 
    decisions are dynamically updated based on real-time conditions, improving security and responsiveness to risk.
  </p>
  
  <h4>How CAE works</h4>
  <ul>
    <li>CAE uses <strong>token revocation</strong> and <strong>event-driven policies</strong> to reevaluate a user’s access after 
        initial authentication.</li>
    <li>Instead of relying solely on token lifetimes (e.g., 1 hour for an OAuth token), CAE triggers immediate access revocation 
        in scenarios such as:
      <ul>
        <li>A user’s session is terminated by an admin.</li>
        <li>Suspicious activity, such as signing in from an unfamiliar location.</li>
        <li>Device compliance changes or detection of risk conditions in Microsoft Entra ID.</li>
      </ul>
    </li>
  </ul>
  
  <h4>APIs required for CAE support</h4>
  <p>Applications must implement specific Microsoft Entra ID APIs to support CAE and dynamically handle token revocation and revalidation:</p>
  <ol>
    <li>
      <strong>OAuth 2.0 Token Introspection Endpoint:</strong>
      <ul>
        <li>This endpoint allows an application to verify whether an issued token is still valid.</li>
        <li>Applications can use the introspection API to periodically check token validity instead of relying on static expiry times.</li>
        <li><a href="https://learn.microsoft.com/en-us/linkedin/shared/authentication/token-introspection?tabs=http" 
               target="_blank">Microsoft OAuth 2.0 Token Introspection</a></li>
      </ul>
    </li>
    <li>
      <strong>Retry-after Headers for Token Refresh Attempts:</strong>
      <ul>
        <li>When a token is invalidated, applications should use the <code>retry-after</code> header to determine the appropriate 
            backoff period before retrying access token acquisition.</li>
      </ul>
    </li>
    <li>
      <strong>Microsoft Authentication Library (MSAL):</strong>
      <ul>
        <li>Applications should use <strong>MSAL</strong> to handle token acquisition and refresh transparently.</li>
        <li>CAE-aware tokens obtained through MSAL include extra metadata for evaluating conditions dynamically.</li>
        <li>Example:
          <pre>
result = msal_app.acquire_token_interactive(scopes=["User.Read"])
          </pre>
        </li>
      </ul>
    </li>
  </ol>
  
  <h4>Relevance to authentication protocols</h4>
  <ul>
    <li><strong>OAuth 2.0 / OpenID Connect:</strong> CAE integrates seamlessly with these protocols by dynamically managing access tokens through APIs.</li>
    <li><strong>Kerberos:</strong> While not natively tied to Kerberos, CAE’s principles can complement hybrid setups where OAuth or 
        OpenID Connect interacts with Kerberos-based identity backends.</li>
  </ul>
  
  <h4>Benefits of implementing CAE</h4>
  <ul>
    <li><strong>Real-time security:</strong> Access can be revoked immediately in response to policy violations, reducing exposure time to potential threats.</li>
    <li><strong>Improved user experience:</strong> By avoiding frequent logouts or rigid token expiry, CAE provides a more seamless experience without compromising security.</li>
    <li><strong>Fine-grained access control:</strong> Applications can dynamically adapt user access based on context, such as device health or geographic location.</li>
  </ul>
  
  <h4>Key considerations for developers</h4>
  <ul>
    <li>Ensure that your application periodically validates tokens using the <strong>introspection endpoint</strong> or other CAE-related APIs.</li>
    <li>Use <strong>MSAL</strong> or similar libraries to acquire and manage tokens, ensuring compatibility with CAE.</li>
    <li>Design retry logic to gracefully handle token revocation scenarios, leveraging <code>retry-after</code> headers to reduce unnecessary network traffic.</li>
  </ul>
  
  <p>By combining CAE with robust authentication protocols and enabling its APIs, organisations can strengthen their security posture 
     while maintaining flexibility and a positive user experience.</p>
</div>


## Conclusion  

From legacy protocols like LAN Manager and NTLM to modern standards like WebAuthn and FIDO2, authentication has evolved to meet new security challenges. Today, Microsoft Entra ID, combined with continuous access evaluation, enables dynamic and passwordless authentication methods that reduce risk and improve user experience.  

By adopting modern protocols and eliminating reliance on legacy authentication, organisations can implement a zero-trust security model, ensuring secure access for users across platforms.  

In the [next blog post]({{ site.baseurl }}{% post_url 2025-01-14-A-look-into-authentication-Single-Sign-On %}) on authentication we will focus on Single Sign-On (SSO) and see how that is used to securely reduce the authentication burden on the end user.
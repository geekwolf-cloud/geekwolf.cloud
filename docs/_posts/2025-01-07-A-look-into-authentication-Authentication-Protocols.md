---
layout: post
title:  "A look into authentication: Authentication Protocols"
description: A journey into the world of authentication, from passwords, hashes, credentials, protocols, MFA, through to passwordless
date:   2025-01-07 08:01:37 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 52
---
<h1>{{ page.title }}</h1>

Here is the next part of our series on authentication. In our [previous post]({{ site.baseurl }}{% post_url 2024-12-17-A-look-into-authentication-Passwordless %}), we talked about passwordless: how this is the next step in the evolution of authentication and how they avoid a lot of the problems that plague passwords, hashes and credential storage.  This blog explores authentication protocols from legacy systems like LAN Manager and NTLM to modern approaches like Kerberos, OAuth, and WebAuthn/FIDO2. While focusing on Windows and Microsoft Entra ID (formerly Azure AD), we also include protocols relevant to Linux and macOS. Finally, we’ll discuss how modern security features like **continuous access evaluation (CAE)** enhance these protocols. 

---

## Legacy protocols: LAN Manager and NTLM  

### LAN Manager (LANMAN)  
**Era:** 1980s–1990s  
**Platform:** Windows  

LANMAN was one of the earliest protocols used for user authentication in Windows environments. It is now deprecated due to its severe security limitations.  

#### Authentication flow  
1. **Password hashing:**  
   - User passwords are converted to uppercase, truncated/padded to 14 characters, and split into two 7-character chunks.  
   - Each chunk is hashed using the DES algorithm, and the two hashes are concatenated.  
2. **Challenge-response:**  
   - A server sends an 8-byte challenge to the client.  
   - The client encrypts the challenge using the DES-hashed password and sends the response back to the server.  

---

### NTLM (NT LAN Manager)  
**Era:** 1990s–present (legacy systems)  
**Platform:** Windows  

NTLM replaced LANMAN and is still found in legacy environments. It exists in two versions: NTLMv1 and NTLMv2.  

#### Authentication flow  
1. The client sends the username to the server.  
2. The server generates an 8-byte challenge and sends it to the client.  
3. The client hashes the challenge with the password hash and returns the response.  
4. The server validates the response using its stored password hash.  

#### Encryption techniques  
- **NTLMv1:** Relies on MD4 hashing, which is no longer considered secure.  
- **NTLMv2:** Uses HMAC-MD5 for stronger protection, but it is still vulnerable to brute-force attacks.  

---

## Kerberos: A modern standard  

### Kerberos  
**Era:** 1990s–present  
**Platform:** Windows, Linux, macOS  

Kerberos is the default authentication protocol for Active Directory and is widely adopted across platforms. It provides mutual authentication between clients and servers using symmetric cryptography.  

#### Authentication flow  
1. **Initial request (AS-REQ):**  
   - The client requests a Ticket Granting Ticket (TGT) from the Key Distribution Centre (KDC) and proves possession of the password using **pre-authentication** (by encrypting a timestamp with the user’s secret key).  
2. **TGT issuance (AS-REP):**  
   - The KDC verifies the request and issues a TGT encrypted with the KDC’s secret key.  
3. **Service ticket request (TGS-REQ):**  
   - The client uses the TGT to request a service ticket for a specific resource.  
4. **Service access:**  
   - The client presents the service ticket to the target resource, which validates it using the KDC’s secret key.  

#### Encryption techniques  
- **RC4-HMAC:** Uses the NT hash as the encryption key (legacy; deprecated).  
- **DES:** An outdated 56-bit encryption algorithm.  
- **AES:** Modern Kerberos implementations use AES-128 or AES-256 for robust encryption.  

---

## RADIUS: Network-based authentication  

### RADIUS (Remote Authentication Dial-In User Service)  
**Era:** 1990s–present  
**Platform:** Windows, Linux, network devices  

RADIUS is a client-server protocol widely used for VPNs, Wi-Fi access, and other network services.  

#### Authentication flow  
1. The client submits credentials to the RADIUS client (e.g., a VPN server).  
2. The RADIUS client sends an Access-Request packet to the RADIUS server.  
3. The RADIUS server validates the credentials and responds with Access-Accept or Access-Reject.  

#### Encryption techniques  
- User passwords are obfuscated using **MD5 hashing** with a shared secret.  
- Variants like **RadSec** use TLS for end-to-end encryption.  

---

## OAuth 2.0 and OpenID Connect: Modern cloud authentication  

### OAuth 2.0 and OpenID Connect  
**Era:** 2010s–present  
**Platform:** Cross-platform  

OAuth 2.0 is a modern standard for authorising access to APIs, while OpenID Connect (OIDC) extends OAuth to include user identity information via ID tokens. Microsoft Entra ID leverages OAuth and OIDC for secure cloud authentication.  

#### Authentication flow  
1. **Authorisation request:** The client redirects the user to the authorisation server (Entra ID).  
2. **User authentication:** The user authenticates, and the server sends an authorisation code back to the client.  
3. **Token exchange:** The client exchanges the authorisation code for an access token and ID token.  
4. **Resource access:** The client presents the access token to APIs.  

#### Encryption techniques  
- Tokens are signed using **RSA** or **ECDSA** for integrity.  
- Communication is protected using TLS.  

---

## WebAuthn and FIDO2: The future of passwordless authentication  

### WebAuthn and FIDO2  
**Era:** 2018–present  
**Platform:** Cross-platform  

WebAuthn (Web Authentication API) and FIDO2 are standards designed to enable secure, passwordless authentication.  

#### Authentication flow  
1. **Registration:**  
   - A user registers a security key or biometric device with a server.  
   - The device generates a key pair (public/private) and sends the public key to the server.  
2. **Authentication:**  
   - The server sends a challenge to the client.  
   - The client signs the challenge with its private key and returns the signature to the server.  
3. **Validation:**  
   - The server verifies the signature using the stored public key.  

#### Encryption techniques  
- Uses **asymmetric cryptography** (e.g., RSA, ECC) for key generation and signing.  
- Communication is protected with TLS.  

---

## Continuous access evaluation (CAE): Enhancing modern authentication  

Continuous Access Evaluation (CAE) is a security feature that enhances modern authentication protocols like Kerberos and OAuth. It ensures that access decisions remain valid based on real-time conditions.  

- **Real-time risk evaluation:** Access tokens are dynamically checked against updated Conditional Access policies.  
- **Session revocation:** Tokens are immediately invalidated if a user or device becomes non-compliant.  

CAE is integrated with protocols like OAuth in Microsoft Entra ID to improve security in hybrid and cloud environments.  

---

## Conclusion  

From legacy protocols like LAN Manager and NTLM to modern standards like WebAuthn and FIDO2, authentication has evolved to meet new security challenges. Today, Microsoft Entra ID, combined with continuous access evaluation, enables dynamic and passwordless authentication methods that reduce risk and improve user experience.  

By adopting modern protocols and eliminating reliance on legacy authentication, organisations can implement a zero-trust security model, ensuring secure access for users across platforms.  

In the next blog post on authentication we will focus on Single Sign-On (SSO) and see how that is used to securely reduce the authentication burden on the end user.
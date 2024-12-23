---
layout: post
title:  "A look into authentication: Credentials"
description: A journey into the world of authentication, from passwords, hashes, credentials, protocols, MFA, through to passwordless
date:   2024-11-18 07:58:36 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 49
---
<h1>{{ page.title }}</h1>

Welcome to the next part of our series on authentication. In our [previous post]({{ site.baseurl }}{% post_url 2024-11-11-A-look-into-authentication-Hashes %}), we covered hashes: what they are, how they are calculated and stored.  In this blogs we will step back and look at credentials as a whole and see how these are used, stored and protected

When you log into a Windows machine, authentication typically happens by verifying your credentials with a remote domain controller. But what happens when you're offline, disconnected from the network? Windows provides a feature known as **cached credentials**, which allows you to continue logging in even when you're not connected to the domain. In this blog, we’ll explore how Windows handles cached credentials, the protection mechanisms in place, and the security aspects involved—especially when it comes to different account types, like **local accounts**, **Active Directory (AD) domain accounts**, and **Entra ID accounts**.

## How cached credentials work in Windows

**Cached credentials** are passwords or password hashes that are stored locally on a Windows machine, allowing users to authenticate without contacting a domain controller. This functionality is especially useful when a device is temporarily disconnected from the network, such as when you're travelling or working remotely.

Here’s how the process works:
- **Initial login**: When you log in to a Windows machine for the first time, the system communicates with the domain controller, Entra ID, or the local Security Account Manager (SAM) to verify your credentials. Once the authentication is successful, and if the authentication was remote, then Windows stores a credential locally, either a hash or the password itself.
- **Subsequent logins**: The next time you attempt to log in while offline, Windows checks the locally stored information. If it matches the password you entered, you're granted access to the system.

The specific way **cached credentials** are handled varies depending on the type of account you're using.

## Where and how are cached credentials stored?

Windows stores cached credentials in different ways depending on whether you're using a **local account**, a **domain account**, or an **Entra ID account**.

### Local user accounts
For **local user accounts**, Windows does not rely on the cached credentials system like domain accounts do. Instead, **local credentials** are stored in the **Security Account Manager (SAM)** database on the system.  

### Domain accounts (Active Directory)
For **domain-joined** machines, Windows stores cached credentials for **Active Directory (AD) accounts** in the **Windows registry**, specifically under:

```
HKEY_LOCAL_MACHINE\Security\Cache
```

This registry location holds **PBKDF2-hashed** credentials for the last few successful logins (usually the last 10).
- **Hashing**: The passwords for **domain accounts** are hashed using **PBKDF2** (Password-Based Key Derivation Function 2). This is a strong cryptographic method that makes brute-forcing much more difficult.
- **Security**: The **PBKDF2** hashes are protected in the registry using **Access Control Lists (ACLs)**, limiting access to system processes. However, administrators or attackers with administrative access could potentially extract these hashes and attempt offline attacks.
- **Iteration count**: The **PBKDF2** algorithm is designed to be **computationally expensive**, which makes brute-forcing attempts time-consuming and difficult. In **Windows**, the default iteration count for **PBKDF2** is **100,000 iterations**, which is sufficient to protect against most brute-force attacks.
- **Salts**: Each password hash is **salted**, meaning a random value is added to the password before hashing, ensuring that even two identical passwords will have different hashed values.
- **Storage and protection**: The **PBKDF2**-hashed credentials are stored in the registry under **HKLM\Security\Cache** and are protected by **Access Control Lists (ACLs)**. While this helps prevent unauthorized access, the credentials are still at risk if an attacker has **administrative privileges**.

Really these cached credentials are not credentials as such but they are offline verifiers that are used to confirm a credential that an end user submits.  These verifiers are a relatively low risk, although weak passwords, using the same password in multiple places and lack of MFA does mean that there is still a risk associated with these cached credentials.

### Entra ID (Azure AD) accounts
For **Entra ID** (Azure Active Directory) accounts, the process is somewhat different. These accounts do not use the traditional **cached credentials** stored in the registry. Instead, Entra ID accounts leverage modern authentication mechanisms, where credentials are stored on the device and are encrypted using **Next-Generation DPAPI (NG)**. This encryption relies on the **Entra ID** account and its associated device as the boundary for authentication.  **Windows Hello for Business** or **device-based authentication** is also employed for offline authentication, avoiding the need to store any credentials at all.

By understanding how cached credentials work and the associated protection mechanisms, both administrators and users can take proactive steps to ensure their Windows systems remain secure—even when disconnected from the network.

In the [next blog post]({{ site.baseurl }}{% post_url 2024-12-10-A-look-into-authentication-MFA %}) on authentication we will look at MFA and how that enhances security and the use of passwords


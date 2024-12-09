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

**Cached credentials** are password hashes that are stored locally on a Windows machine, allowing users to authenticate without contacting a domain controller. This functionality is especially useful when a device is temporarily disconnected from the network, such as when you're travelling or working remotely.

Here’s how the process works:
- **Initial login**: When you log in to a Windows machine for the first time, the system communicates with the domain controller to verify your credentials. Once the authentication is successful, Windows stores a **hashed** version of your password locally.
- **Subsequent logins**: The next time you attempt to log in while offline, Windows checks the locally stored hash of your password. If it matches the password you entered, you're granted access to the system.

The specific way **cached credentials** are handled varies depending on the type of account you're using.

## Where and how are cached credentials stored?

Windows stores cached credentials in different ways depending on whether you're using a **local account**, a **domain account**, or an **Entra ID account**.

### Local user accounts
- **Storage**: For **local user accounts**, Windows does not rely on the cached credentials system like domain accounts do. Instead, **local credentials** are stored in the **Security Account Manager (SAM)** database on the system.
- **Offline authentication**: Local user accounts can still be used for offline authentication, but these accounts do not have the same **cached credentials** mechanism as domain accounts.

### Domain accounts (Active Directory)
- **Storage**: For **domain-joined** machines, Windows stores cached credentials for **Active Directory (AD) accounts** in the **Windows registry**, specifically under:

```
HKEY_LOCAL_MACHINE\Security\Cache
```

This registry location holds **PBKDF2-hashed** credentials for the last few successful logins (usually the last 10).
- **Hashing**: The passwords for **domain accounts** are hashed using **PBKDF2** (Password-Based Key Derivation Function 2). This is a strong cryptographic method that makes brute-forcing much more difficult.
- **Security**: The **PBKDF2** hashes are protected in the registry using **Access Control Lists (ACLs)**, limiting access to system processes. However, administrators or attackers with administrative access could potentially extract these hashes and attempt offline attacks.

### Entra ID (Azure AD) accounts
- **Storage**: For **Entra ID** (Azure Active Directory) accounts, the process is somewhat different. These accounts do not use the traditional **cached credentials** stored in the registry. Instead, **Windows Hello for Business** or **device-based authentication** is employed for offline authentication.
- **Offline authentication**: Entra ID accounts leverage modern authentication mechanisms, where credentials are stored on the device and are encrypted using **Next-Generation DPAPI (NG)**. This encryption relies on the **Entra ID** account and its associated device as the boundary for authentication, not just the machine itself.

## How are cached credentials protected?

The protection of cached credentials depends on the type of account and the method used for authentication. Let’s break it down:

### PBKDF2 hashing for AD accounts
- **Iteration count**: The **PBKDF2** algorithm is designed to be **computationally expensive**, which makes brute-forcing attempts time-consuming and difficult. In **Windows**, the default iteration count for **PBKDF2** is **100,000 iterations**, which is sufficient to protect against most brute-force attacks.
- **Salts**: Each password hash is **salted**, meaning a random value is added to the password before hashing, ensuring that even two identical passwords will have different hashed values.
- **Storage and protection**: The **PBKDF2**-hashed credentials are stored in the registry under **HKLM\Security\Cache** and are protected by **Access Control Lists (ACLs)**. While this helps prevent unauthorized access, the credentials are still at risk if an attacker has **administrative privileges**.

### Security considerations
While **PBKDF2** is a strong and secure hashing algorithm, there are still potential security risks:
- **Offline attacks**: If an attacker gains administrative access, they can dump cached credentials from the registry and attempt brute-force attacks offline. Since there are no time limits for offline attacks, an attacker can test many passwords without facing account lockout policies.
- **Weak passwords**: Even though **PBKDF2** is resistant to attacks, weak passwords can still be cracked with relative ease. This highlights the importance of enforcing **strong password policies** to ensure that user passwords are complex enough to withstand attacks.

#### Additional protection mechanisms
- **BitLocker encryption**: Using **BitLocker** to encrypt the disk adds an additional layer of protection. If the machine is physically compromised, the attacker cannot easily extract and attempt cracking the cached credentials without the BitLocker recovery key.
- **Multi-factor authentication (MFA)**: Enabling **MFA** adds another layer of defence by requiring more than just the password to authenticate, making offline credential attacks much harder to succeed.

## Windows cached credentials for different account types
1. **Local accounts**: These are managed entirely locally on the machine, with authentication handled by the **SAM** database. There is no cached credential mechanism like in domain or Entra ID accounts.
2. **Active Directory (AD) domain accounts**: Cached credentials for domain accounts are stored as **PBKDF2 hashes** in the **registry** under **HKLM\Security\Cache**, and they are protected by **ACLs** and encryption. These hashes can be accessed by anyone with **administrative privileges**, which is why it’s critical to limit admin access and use additional security measures like **BitLocker** and **MFA**.
3. **Entra ID (Azure AD) accounts**: Entra ID accounts use modern authentication methods like **Windows Hello for Business** for offline authentication. These credentials are protected using **Next-Generation DPAPI (NG)**, ensuring that they are tied to the user's **Entra ID account** and the associated device.

## Security risks and mitigations
Despite the strength of **PBKDF2** and other protective measures, there are some inherent risks:
- **Offline cracking**: Attackers with **administrator access** could dump cached credentials from the registry and attempt brute-force attacks. However, the **PBKDF2 hashing** with **100,000 iterations** makes this process slow and resource-intensive.
- **Weak passwords**: The effectiveness of cached credentials is only as strong as the **password** chosen by the user. Enforcing **strong password policies** is essential.
- **Physical access**: If an attacker gains physical access to the machine, even with **BitLocker** encryption, there is still a potential risk if other security policies (like **MFA**) are not enforced.

## Conclusion

Windows **cached credentials** are a crucial feature that allows users to authenticate when offline. These credentials are stored locally, with **domain accounts** using **PBKDF2 hashes** stored in the registry, and **Entra ID accounts** utilizing modern authentication methods. 

While **PBKDF2** provides a strong defence against brute-force attacks, there are still risks if **administrative access** is compromised, weak passwords are used, or additional protections like **BitLocker** and **MFA** are not enabled. To mitigate these risks, it’s important to follow best practices for password complexity, access control, and encryption, and to implement **multi-factor authentication** wherever possible.

By understanding how cached credentials work and the associated protection mechanisms, both administrators and users can take proactive steps to ensure their Windows systems remain secure—even when disconnected from the network.

In the next blog post on authentication we will look at MFA and how that enhances security and the use of passwords


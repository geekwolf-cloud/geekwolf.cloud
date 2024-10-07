---
layout: post
title:  "Strong authentication overview"
description: An overview into the different multi factor authentication methods in particular their relative strengths
date:   2024-04-04 21:31:42 +0100
category: entra-id
tags: entra-id identity technical-overview
image: /android-chrome-192x192.png
comments_id: 18
---
<h1>{{ page.title }}</h1>

In today's cybersecurity landscape, robust authentication methods are crucial to protect sensitive information and ensure that only authorised users can access critical systems. Microsoft offers a range of strong authentication options tailored to meet diverse security needs, categorised into three key areas: **multifactor authentication (MFA)**, **passwordless authentication**, and **phishing-resistant authentication**. This blog will explore each category, discussing their strengths, weaknesses, and performance in preventing credential theft while maintaining a smooth user experience.

---

## 1. Multifactor authentication (MFA)

### Overview
Multifactor authentication (MFA) is a security enhancement requiring users to provide two or more forms of verification to gain access. This typically includes something you know (a password), something you have (a phone or security key), and something you are (biometrics).

### Strengths
- **Enhanced security**: MFA significantly raises the security bar, making it much harder for attackers to gain unauthorised access.
- **Flexible options**: Users can choose from various authentication methods, such as SMS codes, app notifications, and hardware tokens.
- **Wide adoption**: MFA is widely supported across Microsoft’s ecosystem, making it relatively easy for organisations to implement.

### Weaknesses
- **User friction**: MFA can add extra steps to the login process, which may frustrate users, especially when frequent logins are required.
- **Device dependence**: If the user’s secondary device is unavailable, it can complicate the authentication process and potentially lock the user out.
- **Vulnerability to certain attacks**: Some MFA methods, particularly SMS-based ones, are vulnerable to attacks like SIM swapping.

### Credential theft resistance
MFA provides strong protection against credential theft by requiring multiple factors for access. However, the level of protection varies depending on the specific methods used.

### User experience impact
While MFA increases security, it can also lead to inconvenience, particularly in environments where users need to log in frequently. The additional steps can slow down access and may cause frustration.

---

## 2. Passwordless authentication

### Overview
Passwordless authentication removes the need for traditional passwords, relying instead on alternative methods such as biometrics, security keys, or mobile apps like Microsoft Authenticator.

### Strengths
- **High security**: By eliminating passwords, this method removes a significant attack vector, protecting against phishing, brute-force attacks, and credential stuffing.
- **User convenience**: Without the need to remember and enter passwords, users enjoy a more seamless and efficient authentication process.
- **Reduced password fatigue**: Users are relieved from the burden of managing and frequently changing complex passwords.

### Weaknesses
- **Initial setup complexity**: Implementing passwordless authentication may require additional hardware and can be challenging to set up initially.
- **Device dependence**: This method often relies on specific devices, which can be a single point of failure if the device is lost or inaccessible.
- **Adoption challenges**: Transitioning to passwordless methods can be challenging in environments where traditional passwords are deeply entrenched.

### Credential theft resistance
Passwordless authentication offers strong resistance to credential theft, as it eliminates passwords, making it particularly effective against phishing attacks and keylogging.

### User experience impact
Passwordless authentication generally enhances the user experience by simplifying the login process and eliminating password-related frustrations. However, device dependence can be a drawback if those devices are unavailable.

---

## 3. Phishing-resistant authentication

### Overview
Phishing-resistant authentication methods are designed to protect against advanced phishing attacks that can compromise even multifactor authentication systems. These methods include technologies like **FIDO2 security keys**, **certificate-based authentication (CBA)**, **Windows Hello for Business**, and the increasingly important **passkeys** supported by Microsoft Authenticator.

### Passkeys and their role in phishing resistance
**Passkeys** are a modern, passwordless authentication method that leverages public-key cryptography, which is resistant to phishing. Passkeys replace traditional passwords with cryptographic key pairs—one public, stored by the service, and one private, stored on the user’s device. They are designed to work across platforms and are supported in the latest versions of Microsoft Authenticator.

### Strengths
- **Superior security**: Phishing-resistant methods like passkeys and FIDO2 security keys provide robust protection against phishing. They do not rely on shared secrets, making them immune to phishing.
- **Compliance-friendly**: These methods align with strict compliance requirements, making them suitable for high-security environments.
- **No shared secrets**: Passkeys and other phishing-resistant methods eliminate the use of shared secrets like passwords, reducing the risk of interception and misuse.

### Weaknesses
- **Complexity and cost**: Implementing phishing-resistant solutions can require significant investment in hardware and user training.
- **Adoption challenges**: Despite their security advantages, these methods are still not as widely adopted as traditional MFA, partly due to the cost and complexity of implementation.
- **User learning curve**: Users may need to be educated on how to use new authentication methods, especially when it comes to security keys or passkeys.

### Credential theft resistance
Phishing-resistant authentication, especially when using passkeys or FIDO2 security keys, offers the highest level of protection against credential theft. These methods are virtually immune to phishing attacks because they do not involve the exchange of secrets that can be stolen.

### User experience impact
While phishing-resistant methods initially require users to adapt to new processes, they generally provide a smooth and secure experience once the setup is complete. Passkeys, in particular, are designed to be user-friendly while providing top-tier security.

---

## Conclusion: Choosing the right authentication method

Selecting the appropriate authentication method depends on your organisation’s security needs, user base, and risk tolerance. 

- **MFA** is a solid choice for adding an extra layer of security, but its effectiveness depends on the methods used and can introduce some user friction.
- **Passwordless authentication** offers strong security and an enhanced user experience by eliminating passwords, though it requires careful implementation and support for compatible devices.
- **Phishing-resistant authentication** stands out for its superior protection against phishing, making it ideal for high-security environments. Methods like passkeys and FIDO2 keys offer the best defence against credential theft, though they may require more complex setup and user training.

By understanding the strengths and weaknesses of each approach, organisations can better protect themselves against credential theft while ensuring a smooth and efficient user experience. With Microsoft’s comprehensive suite of authentication options, you can tailor security measures to meet your specific needs, safeguarding your enterprise against the ever-evolving landscape of digital threats.

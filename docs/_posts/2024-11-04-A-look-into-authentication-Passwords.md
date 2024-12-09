---
layout: post
title:  "A look into authentication: Passwords"
description: A journey into the world of authentication, from passwords, hashes, credentials, protocols, MFA, through to passwordless
date:   2024-11-04 07:39:54 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 47
---
<h1>{{ page.title }}</h1>

Passwords are the guardians of our digital lives. From unlocking our phones to accessing bank accounts, they’ve become a universal mechanism for proving identity in the digital age. But where did they come from, and how do they work? In this first entry of a multipart series on authentication, we’ll explore the fascinating history of passwords, their role in modern systems, and the techniques attackers use to crack them.

---

## A brief history of passwords

The concept of passwords is ancient. In the Roman military, guards used “watchwords” to verify the identity of those entering their camps. These verbal passwords ensured only those with proper authorisation gained access. While primitive by today’s standards, the idea of using a shared secret to establish trust has persisted through the ages.

Fast forward to the 1960s, when the first digital password was implemented at MIT in the Compatible Time-Sharing System (CTSS). Users needed passwords to access individual files on the shared system. Interestingly, even at this early stage, vulnerabilities emerged—one user famously discovered all the system passwords by exploiting a printing bug. This incident marked the beginning of a long and storied history of password security challenges.

---

## The anatomy of a password

A password is, at its core, a shared secret between a user and a system. Its primary purpose is to prove identity. A well-designed password balances three key factors:

- **Length**: Longer passwords are exponentially harder to crack because they increase the number of possible combinations.
- **Complexity**: Using a mix of uppercase letters, lowercase letters, numbers, and symbols makes guessing significantly harder.
- **Unpredictability**: Avoiding dictionary words, names, or predictable patterns prevents attackers from exploiting common strategies.

### How passwords work

When a user enters a password, it typically undergoes several steps:
1. **Storage**: A password isn’t stored in plain text. Instead, systems hash the password—a process that converts it into a fixed-length string of characters.
2. **Verification**: When a user logs in, the entered password is hashed and compared to the stored hash. If the hashes match, access is granted.
3. **Transmission**: Passwords are usually transmitted securely using encryption protocols like HTTPS, ensuring they can’t be intercepted in transit.

Despite this sophistication, passwords remain vulnerable due to weaknesses in their creation and the ingenuity of attackers.

---

## How passwords are attacked

Modern attackers employ a variety of techniques to crack passwords. Here are the most common methods:

### Brute force

This is the simplest form of attack: systematically trying every possible combination of characters until the correct password is found. The time required depends on the password’s length and complexity:
- A short, simple password like “1234” can be cracked in milliseconds.
- A 12-character password with mixed symbols can take years, even with powerful hardware.

### Dictionary attacks

Rather than trying random combinations, attackers use precompiled lists of common words and phrases. These lists, derived from password leaks and user habits, make it easy to guess weak passwords like “password” or “iloveyou.”

### Credential stuffing

When users reuse passwords across multiple sites, breaches in one system can compromise others. Attackers take leaked credentials and try them on other platforms, often with alarming success rates.

### Rainbow tables

Hashes add a layer of security, but they’re not foolproof. Rainbow tables are precomputed datasets that map hashed values back to their original passwords. By using these tables, attackers can crack hashed passwords quickly—unless additional defences like *salting* are in place.  See the [blog post on hashing](% post_url 2024-11-11-A-look-into-authentication-Hashes %) for more details.

### Phishing and social engineering

Not all attacks rely on technical prowess. Many breaches occur because users are tricked into revealing their passwords. Phishing emails, fake login pages, or direct manipulation can compromise even the strongest passwords.

---

## How long does it take to crack a password?

The time required to crack a password depends on its length, complexity, and the tools available to attackers. Modern hardware, like GPUs, can test billions of password combinations per second. Here’s a simple breakdown of cracking times under different conditions:

| **Password complexity**         | **Example**     | **Cracking time**           |
|----------------------------------|-----------------|-----------------------------|
| 6 characters, lowercase only     | `abcdef`        | Less than a second          |
| 8 characters, mixed case         | `Abc12345`      | Minutes to hours            |
| 12 characters, mixed case + symbols | `A$3d!9zX@fP2` | Hundreds of years           |

### The role of GPUs in cracking

Graphics processing units (GPUs) have revolutionised password cracking by allowing attackers to perform massive calculations in parallel. Tools like Hashcat leverage this power, making it crucial for users to create strong, unique passwords.

### What about quantum computing?

While still theoretical, quantum computers have the potential to crack traditional cryptographic systems—including passwords—at unprecedented speeds. This possibility underscores the need for forward-looking security practices.

## Passwords transmitted over the network

You may think oh yes but passwords are surely no longer transmitted, or they are transmitted in a very secure way, but unfortunately that is NOT the case.  Many software systems still transmit the password and are poorly protected.  Now systems use methods to mitigate that risk like SQL uses certificates, but most people click the trust certificate button, similarly RDP uses Network Level Authentication (NLA) but again some folks turn off NLA, so even where there are mitigations they are often disabled by the user.  NLA requires authentication before access to the rdp port (3389) is granted.

### SQL Server

- **SQL Server authentication**: When using SQL Server’s username/password authentication (as opposed to Windows authentication), the client transmits the plaintext password to the server. Even though the transport is encrypted using TLS (if configured properly), the server must receive and handle the plaintext password to authenticate the user.
- **Risks**: If TLS is not enabled or configured incorrectly, the password can be exposed during transmission. Even with TLS, this architecture inherently trusts the server to secure the password during processing.

---

### Websites and web applications

- **Basic login forms**: Many websites and web apps still use standard login forms where the password is transmitted to the server for processing. While HTTPS encrypts the transport layer, the password itself is sent as plaintext within the encrypted tunnel.
- **Modern practices**: For critical applications, best practices like hashing the password on the client before transmission or using challenge-response protocols (e.g., Secure Remote Password (SRP) or Password-Authenticated Key Exchange (PAKE)) are often recommended. However, this approach is not universally implemented because it increases client-side complexity.

<div class="callout">
  <h3>Secure Remote Password (SRP)</h3>
  <p><strong>Definition:</strong> SRP is a cryptographic protocol that enables secure password authentication by proving knowledge of a password without directly transmitting it. It's resistant to eavesdropping and replay attacks.</p>
  <h3>Password-Authenticated Key Exchange (PAKE)</h3>
  <p><strong>Definition:</strong> PAKE protocols allow two parties to securely establish a shared encryption key using a password, even if the communication channel is insecure.</p>
</div>
---

### Entra ID

- **Azure AD/Microsoft 365 (M365)**: When logging in directly to Microsoft services, the password is sent over an encrypted HTTPS connection. The password itself is transmitted securely within the encrypted tunnel to Microsoft's identity platform for verification.
- **Modern alternatives**: In some scenarios, Microsoft encourages passwordless authentication mechanisms like FIDO2, Windows Hello, or mobile app-based authentication. These methods eliminate the need to transmit passwords entirely, relying instead on cryptographic keys or token-based systems.

---

## Conclusion

Passwords are both a relic of the past and a vital component of today’s digital security landscape. Their simplicity belies their importance, and their weaknesses demand constant vigilance. As we’ve seen, the way passwords are created, stored, and cracked tells a story of innovation and exploitation—a story that sets the stage for the next evolution in authentication.

In the [next blog]({{ site.baseurl }}{% post_url 2024-11-11-A-look-into-authentication-Hashes %}) of this series, we’ll dive into how passwords are stored and protected, exploring hashing algorithms, salting techniques, and the critical role of secure credential management. Stay tuned!

---
layout: post
title:  "A look into authentication: Passwordless and Passkeys"
description: A journey into the world of authentication, from passwords, hashes, credentials, protocols, MFA, through to passwordless
date:   2024-12-17 06:58:42 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 51
---
<h1>{{ page.title }}</h1>

Here is the next part of our series on authentication. In our [previous post]({{ site.baseurl }}{% post_url 2024-12-10-A-look-into-authentication-MFA %}), we talked about MFA: how this is used to strengthen the use of credentials, and the different methods available to secure user accounts and identities.  In this post, we'll dive deep into how **passkeys** work, how they differ from MFA, and how they are securely synced across devices in Windows and Microsoft Entra ID environments. We’ll explore both the conceptual and technical aspects of passwordless authentication, why it wasn't enough, and how passkeys represent the next step in securing digital identities.

---

## Passwordless authentication: A step toward the future

### What is passwordless authentication?

**Passwordless authentication** refers to an authentication method that does not rely on traditional passwords. Instead of entering a password, users authenticate using more secure and user-friendly factors, such as:

- **Biometrics**: Fingerprints, facial recognition, or retina scans.
- **One-time passcodes (OTPs)**: Sent via SMS, email, or authenticator apps.
- **Hardware tokens**: USB keys or smart cards (like **YubiKeys**).

Passwordless solutions are often tied to an account (e.g., via **Windows Hello**, **Apple Face ID**, or **Google biometrics**) and rely on the use of **public-key cryptography** or **token-based authentication** to verify user identity.

### What are passkeys?

A **passkey** is a new form of passwordless authentication designed to replace traditional passwords with more secure and user-friendly methods. Rather than using a password, passkeys rely on **public-key cryptography** to authenticate users.

Here’s how the process works:

1. **Public-private key pair**: A **private key** (kept securely on the user’s device) and a **public key** (stored on the server) are generated. The private key is never transmitted during authentication; only a **signature** created by the private key is sent.
   
2. **Challenge-response authentication**: When the user attempts to authenticate, the server sends a **unique challenge** (a random nonce or timestamp) to the device. The device signs this challenge using the private key, and the signed response is sent back to the server, where the public key is used to verify it. This prevents the need for a password, but still ensures that only the user’s device can authenticate.

Passkeys are based on standards such as **FIDO2** and **WebAuthn**, which provide a robust and highly secure method for online authentication.

### How does passwordless authentication work?

Passwordless authentication is conceptually based on the same principles as **multi-factor authentication (MFA)**, but it removes the reliance on passwords. Here’s a general outline of how it works:

1. **Enrollment**: During the first setup, the user registers their authentication method, such as a fingerprint, facial scan, or a physical hardware token, with their account. A public-private key pair is generated for this authentication method, similar to how passkeys work.

2. **Authentication**: On each login attempt:
   - A challenge (such as a randomly generated nonce or timestamp) is sent by the server to the user’s device.
   - The device uses the **private key** (stored securely in a **hardware module** like **TPM** or **Secure Enclave** and requires a PIN or Biometrics to access) to sign the challenge.
   - The signed challenge is sent back to the server, where the server verifies it using the stored **public key**.

This system eliminates the need for passwords, relying on something the user has (e.g., a hardware token or a biometric factor) to prove their identity.

### Why was passwordless authentication not enough?

While passwordless authentication was a huge improvement over passwords, it had some limitations that led to the development of **passkeys**:

- **Single-device focus**: Early passwordless systems often relied on a single device to authenticate. For example, logging into a service on a new device using **Windows Hello** or **Apple Face ID** could be cumbersome. Users would have to authenticate again, or use **back-up methods** like OTPs sent to their phone.
  
- **Device-specific**: Early implementations also meant that if a user lost their device, they might lose access to their accounts unless they had a back-up method or a second device for recovery.

- **Vendor lock-in**: Some passwordless solutions were tied to specific platforms (e.g., Windows Hello or Apple Face ID), leading to vendor lock-in. This created compatibility issues across devices and ecosystems.

**Passkeys** were developed to address these issues by offering a **cross-device, standardised**, and **secure** solution that eliminates passwords completely while solving the syncing and recovery problems associated with earlier passwordless solutions.

---

## How do passkeys work technically?

When a user registers a passkey on their device (e.g., a phone or laptop), the device generates a **public-private key pair**. The private key remains stored securely on the device (inside a **secure hardware environment**, such as **TPM** in Windows or **Secure Enclave** in Apple devices), while the public key is sent to the server. During authentication, the server sends a challenge to the device, which signs the challenge with the private key. One of the most important features of passkeys is that **the private key never leaves the device**, meaning that even if an attacker intercepts the communication, they cannot steal the key to authenticate.

### Protecting the private key

The private key is securely stored in the **hardware security module** (HSM) on the device, such as:

- **TPM (Trusted Platform Module)** in **Windows**.
- **Secure Enclave** in **Apple devices**.
- **Android Keystore** in **Android devices**.

These security modules ensure that the private key is used only for cryptographic operations (e.g., signing a challenge) and cannot be accessed by malicious apps or processes.

---

## Syncing passkeys across devices

One of the challenges with passkeys is how they are **synced across devices**. Since passkeys are device-centric, the private key must be securely transferred between devices without compromising security.  Note that at the time of writing this post, Microsoft Authenticator does not support syncing of passkeys, and keeps them bound to the device they were generated on.

### How is the private key transferred?

To sync **passkeys** across devices (e.g., between a phone and laptop), the **private key** is **encrypted locally** on the source device using a symmetric encryption algorithm (e.g., **AES**). The symmetric encryption key itself is protected through public-key cryptography before being uploaded to a cloud service (e.g., **iCloud**, **Google Drive**, or **Microsoft OneDrive**). At no point is the raw private key ever transmitted or accessible outside of secure, trusted hardware.

When a new device needs to access the passkey

1. **User authentication**  
   The user must authenticate on the receiving device.  
   This is typically done via **biometric authentication** (e.g., fingerprint, Face ID) or a **PIN** to confirm the user's presence.

2. **Establishing trust and secure key exchange**  
   The receiving device generates a **public/private key pair** for secure communication.  
   The sending device (or cloud service) encrypts the **symmetric encryption key** (used to protect the private key) with the **public key** of the receiving device.  
   Only the receiving device, holding the corresponding **private key**, can decrypt the symmetric encryption key.

3. **Secure decryption**  
   The symmetric encryption key is used to decrypt the private key for the passkey.  
   This process happens entirely on the receiving device, ensuring the private key is never exposed to the cloud or transmitted in plaintext.

4. **Hardware-backed protection**  
   The private key is securely stored on the receiving device using hardware-backed secure storage:  
   - **Secure Enclave** on Apple devices.  
   - **Trusted Execution Environment (TEE)** or **StrongBox** on Android.  
   - **Trusted Platform Module (TPM)** on Windows.  
   These hardware components ensure the private key cannot be extracted or tampered with.

5. **Proximity and ownership verification**  
   The devices must both belong to and be trusted by the same user.  
   This is enforced through:  
   - Account verification (e.g., signing into the same Apple ID, Google account, or Microsoft account).  
   - Optional **proximity checks** (e.g., Bluetooth) or additional **biometric confirmation** to ensure physical control of both devices.

6. **Passkey retrieval and final setup**  
   The encrypted passkey (including the private key) is downloaded from the cloud service.  
   The symmetric key, securely obtained in the previous steps, is used to decrypt the private key.  
   The private key is then stored securely within the appropriate hardware-backed secure storage.

---

## Authentication flow with passkeys: A practical example

Let’s walk through a practical example of how passkey authentication works when you sign in to a website from your **PC** with your **phone** acting as the authentication device.

### Step 1: **Initiating authentication on your PC**
1. **Navigate to the website**: You visit a website (e.g., Microsoft, Google) on your PC where you want to sign in.
2. **Request for passkey authentication**: The website offers the option to authenticate using a **passkey**.
3. **Challenge sent to your PC**: The website sends a **challenge** (nonce) to your PC over the Internet for authentication.

### Step 2: **Proximity check via Bluetooth**
4. **Proximity check**: Your phone verifies that it is nearby your PC via **Bluetooth**. This ensures that both devices are physically close to each other, adding an extra layer of security to the process.

### Step 3: **Biometric authentication on your phone**
5. **Biometric verification**: After proximity is confirmed, your phone prompts you for **biometric authentication** (e.g., fingerprint, Face ID).
6. **Unlocking the private key**: Upon successful biometric authentication, the phone unlocks the **private key** associated with the passkey.

### Step 4: **Signature creation and response**
7. **Signing the challenge**: The private key is used to **sign** the challenge sent by the website.
8. **Sending the signed response**: The signed response is then sent **via the Internet** from your phone back to the website.

### Step 5: **Verification by the website**
9. **Signature verification**: The website uses the **public key** stored on its server to verify the signed response.
10. **Access granted**: Once verified, you are logged in to the website, with no password required.

### Why is Bluetooth important?
- **Bluetooth** is used for proximity detection and to ensure that the phone and PC are physically near each other during the authentication process. However, **the signed response itself is always sent via the Internet** to the website for verification using the public key.

---

## Conclusion: A more secure future with passkeys

Passkeys represent a leap forward in passwordless authentication, combining the **user-friendliness** of biometrics with the **security** of public-key cryptography. They address the weaknesses of traditional passwordless authentication methods, enabling seamless, secure, cross-device authentication without passwords.

By leveraging technologies such as **Windows Hello**, **Microsoft Entra ID**, and **FIDO2**, passkeys ensure that users can authenticate securely across multiple devices, enhancing security while maintaining ease of use. As more platforms adopt this technology, the future of authentication is shaping up to be not only **passwordless**, but also **more secure** than ever before.

In the [next blog post]({{ site.baseurl }}{% post_url 2025-01-07-A-look-into-authentication-Authentication-Protocols %}) on authentication we will segway to authentication protocols, to explore how various authentication protocols actually authenticate you, using the components we've talked about so far: passwords, hashes, credentials, MFA and passwordless.
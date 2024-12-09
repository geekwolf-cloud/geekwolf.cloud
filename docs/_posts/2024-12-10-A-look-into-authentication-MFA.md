---
layout: post
title:  "A look into authentication: Multi Factor Authentication"
description: A journey into the world of authentication, from passwords, hashes, credentials, protocols, MFA, through to passwordless
date:   2024-12-10 07:27:00 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 50
---
<h1>{{ page.title }}</h1>

Welcome back after Ignite, to the next part of our series on authentication. In our [previous post]({{ site.baseurl }}{% post_url 2024-11-18-A-look-into-authentication-Credentials %}), we talked about credentials: what they are and how they are stored.  In this blogs we will step back and look at Multi Factor Authentication (MFA) and how this is used to strengthen the use of credentials, and the different methods available to secure user accounts and identities. We'll also dive into the strengths and weaknesses of each method, with a particular focus on **Windows/Entra ID**, though the principles are widely applicable to any Identity Provider (IdP).

## What is multi-factor authentication (MFA)?

MFA is a security protocol that requires users to present two or more different types of credentials (factors) to verify their identity when accessing an application or system. These factors fall into three categories:

1. **Something you know**: Knowledge-based factors such as passwords, PINs, or security questions.
2. **Something you have**: A physical device, such as a smartphone, hardware token, or smart card, used to verify identity.
3. **Something you are**: Biometric factors, such as fingerprints, face recognition, or retina scans.

By requiring at least two of these factors, MFA drastically reduces the likelihood of unauthorised access, as it is far more difficult for attackers to compromise multiple factors simultaneously.

## Why is MFA needed?

With the increasing sophistication of cyberattacks—ranging from **phishing** to **brute-force** and **credential stuffing**—relying solely on passwords is no longer sufficient. Passwords can be easily guessed, stolen, or leaked. MFA adds critical layers of security by combining multiple factors, making it much harder for attackers to succeed.

For example:
- Even if a password is compromised, the attacker still needs access to the second factor (like a phone or biometric data) to gain entry.
- It protects against phishing attacks, as the second factor (something you have or something you are) is harder to steal than a password.

## MFA methods

Let’s explore the different types of MFA methods available, their strengths, and their weaknesses.

### 1. SMS or email-based one-time password (OTP)

**How it works**:  
An OTP is sent to the user’s registered phone number (via SMS) or email address. The user must enter this temporary code to complete the login process.

- **Strengths**:
  - Easy to implement and widely supported.
  - Does not require specialised hardware or apps.
  - User-friendly for most people, as they are familiar with receiving SMS or email messages.
  
- **Weaknesses**:
  - **Vulnerable to interception**: SMS can be intercepted via **SIM swapping** or other attacks, compromising the security of the OTP.
  - **Phishing risk**: Attackers can trick users into revealing the OTP in a phishing attack.
  - **Dependency on mobile signal**: If the user is in an area with no signal, they cannot receive the OTP.

### 2. Authenticator apps (TOTP - Time-based one-time password)

**How it works**:  
An authenticator app (e.g., **Google Authenticator**, **Microsoft Authenticator**) generates a one-time password that is valid for a short period, usually 30 seconds. The user enters the code from the app during login.

- **Strengths**:
  - More secure than SMS-based OTPs because the code is generated on the device and is not transmitted over potentially insecure channels.
  - Not reliant on a mobile network or email service, making it less vulnerable to SIM swapping or email compromise.
  
- **Weaknesses**:
  - Requires a smartphone or dedicated hardware token.
  - If the device with the authenticator app is lost or compromised, the user might face issues accessing their accounts unless recovery methods are set up.
  - Can be inconvenient for users who are not comfortable with apps or smartphones.

<div class="callout">
  <h3>TOTP: How it's calculated</h3>
  <p>TOTP (Time-based One-Time Password) is a widely used MFA method that generates a one-time password (OTP) based on a shared secret key and the current time.</p>
  
  <h4>How is the TOTP calculated?</h4>
  <ol>
    <li><strong>Shared secret key:</strong> The service generates a unique secret key for the user, which is shared between the service and the user's device. The secret key is typically transmitted via a QR code or manual entry during setup.</li>
    <li><strong>Time factor:</strong> The current time is divided into intervals (usually 30 seconds). The time is used to create a time-based counter.</li>
    <li><strong>HMAC-SHA1 algorithm:</strong> The secret key and the time-based counter are used as inputs to the HMAC-SHA1 (Hash-based Message Authentication Code) algorithm, which produces a hashed output.</li>
    <li><strong>OTP:</strong> The hashed output is truncated to produce a six-digit OTP that changes every 30 seconds.</li>
  </ol>

  <h4>How is the secret key securely transferred?</h4>
  <p>The secret key is securely transferred from the service to the user's device using the following methods:</p>
  <ul>
    <li><strong>QR code:</strong> The secret key is encoded into a QR code, which is scanned by the authentication app. The key is transferred over an encrypted HTTPS connection to prevent interception.</li>
    <li><strong>Manual entry:</strong> Alternatively, users can manually enter the secret key, which is also transmitted over an encrypted HTTPS connection during setup.</li>
    <li><strong>End-to-end encryption:</strong> Once the secret key is securely transmitted, it is stored locally on the user's device and is never sent again.</li>
  </ul>

  <h4>Strengths of TOTP</h4>
  <ul>
    <li>Highly secure: OTPs are time-sensitive and change every 30 seconds, making them resistant to replay attacks.</li>
    <li>Offline functionality: OTPs can be generated offline once the secret key is securely stored on the device.</li>
    <li>Widely supported: TOTP is widely supported by most MFA apps and services.</li>
  </ul>

  <h4>Weaknesses of TOTP</h4>
  <ul>
    <li>Device dependency: If the user's device is lost or compromised, the user may be locked out of their account unless alternative recovery options are available.</li>
    <li>Initial setup vulnerability: The secret key transfer (QR code or manual entry) is vulnerable if the device or app is compromised during the setup phase.</li>
    <li>Time synchronisation: OTPs are time-dependent, and any desynchronisation between the client and server can cause the OTP to be invalid.</li>
  </ul>
</div>


### 3. Push notifications (via mobile devices)

**How it works**:  
A push notification is sent to the user’s registered mobile device (via an app like **Microsoft Authenticator** or **Okta Verify**). The user simply taps “Approve” or “Deny” to complete the authentication process.

- **Strengths**:
  - Fast and user-friendly: Just one tap to approve or deny access.
  - Strong security because the approval action occurs on the user’s device and cannot easily be intercepted.
  
- **Weaknesses**:
  - Requires a smartphone with the appropriate app installed.
  - Users may inadvertently approve a fraudulent request if they are tricked into doing so via phishing.
  - Susceptible to device theft: If the device is lost or stolen and not properly secured, an attacker could approve the request.

### 4. Phishing-resistant push notifications

Traditional push notifications—where users simply approve or deny a login attempt by tapping "Approve" or "Deny"—are quick and convenient. However, they can be vulnerable to **phishing attacks**, where an attacker tricks a user into approving a fraudulent login attempt, especially when the user isn't paying close attention.

To address these concerns, **phishing-resistant push notifications** have been developed, adding safeguards to ensure the user is authenticating a legitimate request. These enhanced push notifications are designed to mitigate the risk of attackers getting unauthorised access through social engineering tactics.

#### How phishing-resistant push notifications work

Phishing-resistant push notifications add a level of context that makes it harder for attackers to deceive the user. The two primary features typically used are:

1. **Location-based context**  
   - **What it is**: The authenticating application or service sends the user a push notification that includes **location-based details** about the request—such as the **IP address**, **geographical location**, or **device type**.
   - **Why it helps**: If the location shown in the push notification doesn't match the user's usual location or seems suspicious (e.g., the login attempt is from an unfamiliar country or city), the user can instantly reject the request. This is a clear sign that someone else may be trying to access their account.
   - **Example**: "A login attempt was made from New York, USA. Do you recognise this location?"

2. **Challenge with a number or code**  
   - **What it is**: To further ensure the legitimacy of the request, users are often asked to **verify a number or code** displayed within the authentication application. This method works by presenting a series of numbers or a visual indicator in the push notification that the user must either:
     - **Select the correct number** shown in the notification (matching it to the one displayed in the authentication app), or
     - **Type the number** shown in the notification into the app to confirm that the user is approving the right request.
   - **Why it helps**: This ensures that the user is truly interacting with the correct request and not a fraudulent one. Even if the attacker has stolen the login credentials and managed to send a push notification, they wouldn't know the number that the user needs to verify.
   - **Example**: "Please approve this login attempt. Type the number displayed in your authenticator app: **12345**."

#### Strengths of phishing-resistant push notifications

- **Added security**: By including location details or requiring the user to verify a specific number, phishing-resistant push notifications make it much harder for attackers to fool users into approving a fraudulent login attempt.
- **Real-time awareness**: Users can spot suspicious activity immediately, such as unexpected login attempts from unfamiliar locations or devices.
- **User control**: By asking the user to verify specific numbers or information, these notifications put more control in the hands of the legitimate user, rather than relying solely on a yes/no approval.

#### Weaknesses of phishing-resistant push notifications

- **Usability**: While phishing-resistant push notifications offer better security, they may slightly complicate the user experience. Users have to be vigilant and may need to take a moment to verify the information shown in the notification.
- **Technical challenges**: Some services may not implement these features properly, which can lead to inconsistencies or confusion in certain cases. It also requires the service to support more complex authentication flows.
- **Device dependency**: Just like regular push notifications, phishing-resistant push notifications require the user to have a mobile device or token with the app installed. If the user doesn't have their device on hand, they may be unable to authenticate.

### 5. Hardware tokens (e.g., YubiKey)

**How it works**:  
A hardware token, such as a **YubiKey**, is a physical device that generates a unique code or uses a protocol (e.g., **FIDO2**, **U2F**) to authenticate the user. The user inserts the key into a USB port or uses it via **NFC** (Near Field Communication) to complete the authentication.

- **Strengths**:
  - Extremely secure: The private key never leaves the hardware device, making it highly resistant to phishing, malware, and other attacks.
  - Works with many services that support **FIDO2** or **U2F** standards.
  - Can be used for both local (Windows login) and cloud-based (e.g., Google, Microsoft) authentication.
  
- **Weaknesses**:
  - Risk of theft: If the hardware token is lost or stolen, it could be used to access accounts if it is not protected by a PIN or biometric authentication.
  - Requires physical possession of the token: If forgotten or lost, access to the account may be blocked.
  - More expensive compared to other MFA methods.

### 6. Biometric authentication (fingerprint, face recognition, etc.)

**How it works**:  
Biometric authentication relies on unique biological characteristics of the user (e.g., **fingerprints**, **facial recognition**, **iris scans**) to verify identity.

- **Strengths**:
  - Very secure: Difficult for attackers to replicate someone’s biometric features.
  - Convenient: Fast and easy for users, no need to remember passwords or carry tokens.
  - Non-repudiation: Biometrics are linked to the person and cannot be easily shared or stolen.

- **Weaknesses**:
  - **Privacy concerns**: Storing biometric data can raise privacy issues if not handled securely.
  - **False positives/negatives**: Some systems might incorrectly identify users or fail to recognise them.
  - **Device dependency**: Requires specialised hardware (fingerprint sensor, camera, etc.) on the user's device.

## Conclusion

MFA is an essential security practice that significantly improves the protection of user accounts. From **SMS/OTP** to **hardware tokens** and **biometrics**, each MFA method has its strengths and weaknesses, and understanding these helps in choosing the right solution for your organisation or personal use.

Phishing-resistant push notifications are an excellent example of how MFA continues to evolve, adding additional context and safeguards to combat ever more sophisticated phishing attacks. While they may add a slight layer of complexity for users, the enhanced security they provide is well worth the trade-off.

Incorporating MFA into your security strategy is no longer optional but a necessity in today’s cyber environment. By understanding and utilising the right combination of factors, you can drastically reduce the risk of unauthorised access and enhance your overall security posture.

In the next blog post on authentication we will look at passwordless and passkeys, comparing it to MFA and how these avoid the use of passwords
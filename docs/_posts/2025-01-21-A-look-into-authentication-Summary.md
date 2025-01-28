---
layout: post
title:  "A look into authentication: Summary"
description: A journey into the world of authentication, from passwords, hashes, credentials, protocols, MFA, through to passwordless
date:   2025-01-21 06:39:23 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 54
---
<h1>{{ page.title }}</h1>

Here is the final blog of our series on authentication. In our [previous post]({{ site.baseurl }}{% post_url 2025-01-14-A-look-into-authentication-Single-Sign-On %}), we explored Single Sign On deployed in various authentication protocols  This blog summaries the previous blogs and provides recommendations and best practices around securing the recommended authentication protocols.

When it comes to securing your systems, it’s crucial to distinguish between **user authentication** and **application authentication**. Both are essential components in any security strategy, but each comes with its own unique requirements, challenges, and solutions. By understanding the differences and specific needs of each, you can implement the best practices to ensure your applications and users remain secure.

---

### User authentication vs. application authentication: the key differences

**User authentication** refers to the process of verifying the identity of the **individual users** attempting to access an application or service. The goal is to ensure that the user is who they claim to be, typically through the use of credentials (username, password, multi-factor authentication) or biometric data. User authentication focuses on ensuring the person is legitimate and granting them appropriate access based on their identity.

**Application authentication**, on the other hand, focuses on verifying the identity of the **application or service** itself. This type of authentication ensures that the application interacting with a system or another service is legitimate, preventing unauthorised applications from gaining access to sensitive data or services. This is particularly important for scenarios where one system or application needs to securely communicate with another, such as in API interactions or microservices architectures.

While both types of authentication are necessary, they differ significantly in their approach and the mechanisms used. By understanding these differences, we can tailor our approach to securing both user and application authentication effectively.

---

### Choosing the right authentication protocols and SSO methods

Now that we understand the distinctions between user and application authentication, the next step is to choose the appropriate **authentication protocol** and **SSO method** that best suits your needs. The right choice depends on several factors, including your infrastructure (on-premises vs. cloud), the scale of your application, and the security requirements.

#### Choosing the right authentication protocol

When selecting an **authentication protocol**, it’s essential to consider the following factors:
- **Type of user or system**: Are you authenticating human users or machine-to-machine (M2M) communication?
- **Security requirements**: How sensitive is the data being accessed, and what level of security do you need?
- **Environment**: Is your application hosted on-premises, in a cloud environment, or across a hybrid infrastructure?

Let’s look at the most common protocols used for **user authentication** and **application authentication**.

- **For user authentication**:
  - **OAuth 2.0** + **OpenID Connect (OIDC)**: These are the most widely adopted protocols for **web and mobile applications**. OAuth 2.0 is used for authorisation (granting access to resources), while **OIDC** builds on OAuth to provide user authentication. These protocols are ideal for cloud-based environments where single sign-on (SSO) across multiple services is required.
  - **SAML (Security Assertion Markup Language)**: SAML is often used for **enterprise SSO** in federated environments, particularly for large organisations with multiple legacy systems. It's a good choice for applications that need to integrate with older identity management systems.
  - **Kerberos**: Kerberos is still widely used in **on-premises environments** that rely on **Active Directory** for managing identities. It’s an excellent choice for systems where mutual authentication between services is needed, and it's highly secure for internal network communications.
  - **FIDO2/WebAuthn**: For **passwordless and passkey authentication**, **FIDO2** and **WebAuthn** provide a modern alternative for user authentication, often paired with biometric or hardware-based authentication methods like security keys or mobile devices.

- **For application authentication**:
  - **OAuth 2.0**: OAuth 2.0 can also be used for **application authentication** in scenarios where an application needs to access resources or APIs on behalf of a user or another service.
  - **Client Credentials Flow (OAuth 2.0)**: This specific OAuth flow is ideal for **machine-to-machine authentication**, where an application (acting as a client) authenticates itself to a service without involving user interaction.
  - **JWT (JSON Web Tokens)**: **JWTs** are commonly used in **microservices** and **serverless architectures** to securely transmit authentication information between systems. JWTs are stateless, making them ideal for scalable applications where services authenticate each other without maintaining session states.
  - **Kerberos**: Kerberos is still widely used in **on-premises environments** that rely on **Active Directory** for hosting their applications. It’s an excellent choice for systems where mutual authentication between services is needed, and it's highly secure for internal network communications.

#### Choosing the right single sign-on (SSO) method

Choosing the right **SSO method** is vital for streamlining the user experience while ensuring secure access across multiple applications. The choice of SSO depends on the environment, the protocols in use, and the security requirements.

- **For cloud-based applications**:
  - **OAuth 2.0 + OpenID Connect (OIDC)**: As previously mentioned, **OIDC** is the protocol for user authentication in the cloud, and it’s designed to be used in conjunction with **OAuth 2.0** for authorisation. OIDC enables **SSO** across multiple cloud-based services with **identity providers** such as **Azure AD**, **Google Identity**, or **Okta**.
  - **Federated SSO** (e.g., **SAML**): If you're operating in a **federated identity environment**, where external identity providers manage user identities (e.g., **Google**, **Microsoft**, or **Salesforce**), **SAML** is a reliable choice for **enterprise SSO**.

- **For on-premises or hybrid environments**:
  - **Kerberos + Active Directory**: For **on-premises environments** where **Active Directory** is in use, **Kerberos** is the protocol of choice for **SSO**. It allows users to authenticate once and access all resources within the domain. It's especially useful for legacy systems where cloud-based protocols like OIDC or SAML aren’t applicable.
  - **Windows Integrated Authentication (WIA)**: In environments that rely on **Windows authentication**, **WIA** allows SSO using **Kerberos** or **NTLM**, but ensure you disable NTLM to force the use of Kerberos.

---

### Best practices for securing user authentication

Securing user authentication requires a combination of robust identity verification mechanisms, policies, and tools to prevent unauthorised access. Here are the key steps to secure user authentication:

#### 1. Use multi-factor authentication (MFA)  
**MFA** should be a standard practice for user authentication. By requiring users to provide more than one form of verification (something they know, something they have, or something they are), MFA significantly reduces the chances of unauthorised access due to compromised passwords.  
- **Example**: Implement MFA using methods like TOTP (Authenticator), or hardware tokens.

#### 2. Leverage single sign-on (SSO)  
SSO simplifies the user experience by allowing users to authenticate once and gain access to multiple applications. It reduces the risk of password fatigue and weak passwords.  
- **Best protocols**: **OpenID Connect (OIDC)** for user authentication across multiple apps. Pair with **OAuth 2.0** for delegated authorisation when necessary.

#### 3. Enforce strong password policies  
Ensure that users use complex, hard-to-guess passwords by enforcing policies for minimum length, and complexity. You can also implement **passwordless or passkey authentication** (e.g., using biometrics or WebAuthn) to enhance security.  
- **Password storage**: Store passwords securely using hashed and salted algorithms (e.g., bcrypt, PBKDF2).

#### 4. Require strong encryption policies
Ensure that the protocol chosen is secured using strong encryption methods.  e.g. in Kerberos ensure that DES and RC4 are disabled so that AES is the only available option, and ideally make that as strong as you need.

#### 5. Protect against phishing attacks  
Educate users on recognising phishing attempts that may mimic official login pages. You can also use **contextual authentication** that adapts based on the user's location, device, or other factors to detect unusual login attempts.

#### 6. Secure session management  
Once authenticated, it’s crucial to protect user sessions:
- Implement **secure cookies** (HTTPOnly, SameSite) to prevent session hijacking.
- Set reasonable **session expiry times** and force re-authentication after a period of inactivity.

#### 7. Monitor security events
Ensure that you are monitoring security events like signing in and granting access as well as changes to the permissions on accounts.  Retain logs to allow forensics, and to adhere to compliance/data privacy frameworks like SOC2, GDRP, HIPPA, etc.

---

### Best practices for securing application authentication

Securing **application authentication** focuses on ensuring that the application itself is authenticated and authorised to interact with other systems or services. The way you approach this depends on the context in which your application is hosted—whether on-premises, in the cloud, or in hybrid environments.

#### 1. Application authentication based on hosting context

- **On-premises or hybrid environments (Active Directory + Kerberos)**:  
  If your application is integrated with **Active Directory (AD)**, **Kerberos authentication** is a strong choice, especially for internal services. Use **Group Managed Service Accounts (gMSAs)** or the new **Delegated Managed Service Accounts (dMSAs)** for services running on multiple servers to securely authenticate applications without managing credentials manually.
  If you have to use a traditional service account, then ensure the password is long and complex, tie the service account to the machines that you expect a sign in from, consider adding the service account to the **Protected Users** group for much stronger protection of the accounts.

- **Cloud-hosted applications (Azure, AWS, Google Cloud)**:  
  In the cloud, use platform-specific services like **Managed Identities (Azure)** or **IAM Roles (AWS)** for application authentication. These services provide secure, automatic management of application identities and permissions, reducing the risk of credential leakage.

#### 2. Use platform-specific authentication mechanisms for cloud-native applications  
If your application is deployed in a cloud environment like **Azure**, **AWS**, or **Google Cloud**, there are platform-specific authentication mechanisms that should be leveraged:
- **Azure Managed Identities**: If your application is hosted on **Azure**, use **Managed Identities** for Azure resources to authenticate to other Azure services securely without managing secrets. This eliminates the need for handling credentials or API keys.
- **AWS IAM Roles**: For applications hosted on **AWS**, use **IAM roles** for secure authentication between services without embedding secrets.
- **Google Cloud Service Accounts**: In **Google Cloud**, use **service accounts** for authentication to securely access other resources.

#### 3. Use mutual TLS (mTLS) for sensitive applications  
In high-security environments, particularly where sensitive data is involved, **mutual TLS (mTLS)** is an excellent solution for application-to-application authentication. With **mTLS**, both the client and server authenticate each other using certificates, ensuring that only trusted applications can communicate with each other.
- **Best for**: Applications that need to authenticate each other in a trusted environment, such as microservices architectures or when integrating third-party services.

#### 4. Least privileges
For service account and administration accounts alike, use the principles of least privileges and where possible use a Just in Time (JIT) method like Privileged Identity Management (PIM) to avoid standing elevated rights

#### 5. Split app registrations
If you have an application that requires both delegated and application permissions then create two enterprise applications and split your application into front end and back end, where the former uses only the delegated permissions and the latter only the application permissions.  You can then ensure that the back end part of the applications is shielded from users and malicious activities by controlling tightly what can and cannot communicate with it.   This is especially true with multi tenant applications.

#### 6. Require strong encryption policies
Ensure that the protocol chosen is secured using strong encryption methods.  e.g. in Kerberos ensure that DES and RC4 are disabled so that AES is the only available option, and ideally make that as strong as you need.

#### 7. Adopt secure token-based authentication  
For distributed systems and APIs, **JSON Web Tokens (JWT)** are commonly used for stateless authentication, particularly in **microservices** and **serverless** environments. JWT allows you to authenticate applications without maintaining session states, which makes it scalable and efficient.
- **Best practice**: Ensure that JWTs are signed and encrypted, and that token expiration is implemented properly.

#### 8. Monitor security events
Ensure that you are monitoring security events like signing in and granting access as well as changes to the permissions on accounts.  Retain logs to allow forensics, and to adhere to compliance/data privacy frameworks like SOC2, GDRP, HIPPA, etc.

---

### Conclusion: tailoring authentication to your application’s needs

Both **user authentication** and **application authentication** are integral to a secure system, but they require different approaches and mechanisms to ensure robust protection. By understanding the distinction between the two, you can take appropriate steps to secure your environment:

- **For user authentication**, implement MFA, strong password policies, and SSO to ensure that only legitimate users can access your applications.
- **For application authentication**, ensure that the right mechanisms are in place depending on where your application is hosted, whether it’s leveraging OAuth/OIDC for cloud apps, Kerberos for on-prem apps, or using cloud-native services like Managed Identities for Azure or IAM Roles for AWS.

No matter where your application is deployed, the key is to understand the context and select the appropriate authentication mechanisms that not only secure the application but also align with the infrastructure and tools you're using.

By following these best practices, you can ensure that your authentication processes are both secure and scalable, ready to support the growing needs of your users and applications.

This wraps up our blog series on authentication.  I hope you found this useful.  If you think of other topics, angles, or missing/incorrect pieces then please let me know.  I'd love to hear :)
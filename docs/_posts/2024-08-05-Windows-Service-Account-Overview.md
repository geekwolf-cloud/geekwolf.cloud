---
layout: post
title:  "Windows service accounts overview"
date:   2024-08-05 14:22:34 +0100
category: on-premises
tags: on-premises technical-overview
comments_id: 6
---
<h1>{{ page.title }}</h1>

When building and deploying applications on Microsoft Windows, one of the key considerations is how these applications authenticate and interact with the operating system and other network resources. This often involves the use of service accounts—specialized accounts under which applications, services, or scripts run. However, not all service accounts are created equal. Microsoft provides several types, including standard service accounts, managed service accounts (MSAs), group managed service accounts (gMSAs), and delegated service accounts. Each type offers different benefits, security features, and implementation nuances. This blog post will compare and contrast these service account types, focusing on how they affect application design, where passwords or secrets are stored, and their respective security advantages.

## 1. Standard Windows service accounts

**Overview:**  
Standard service accounts are the traditional way to run services on Windows. These are user accounts created in Active Directory or locally on the server, and they are configured manually with necessary permissions.

**How applications use them:**  
Applications need to be configured to run under these accounts, typically by specifying the username and password in the service properties. Developers often write code that connects to resources (like databases or file shares) using the credentials stored in these service accounts.

**Where passwords are stored:**  
- **On disk:** The password is typically stored in the Windows Services Manager when the service is configured. The service manager securely stores the password, but if an attacker gains administrative access, they can retrieve this password from the system's memory or configuration files.
- **In Active Directory:** If the service account is an AD account, the password hash is stored in the AD database and can potentially be harvested if AD is compromised.

**Security implications:**
- **Password management:** One of the major downsides is that passwords for these accounts need to be managed manually. This includes regular updates and securely storing these passwords, which can be a security risk if mishandled.
- **Attack surface:** Because these accounts are regular user accounts with elevated privileges, they increase the attack surface if compromised.

**When to use:**  
Use standard service accounts for simple, standalone applications where automatic password management and shared accounts across servers aren't necessary.

## 2. Managed service accounts (MSAs)

**Overview:**  
MSAs are an evolution of standard service accounts, introduced in Windows Server 2008 R2. They are designed to provide automatic password management and simplified SPN (Service Principal Name) management for individual services.

**How applications use them:**  
Applications need minimal changes to use MSAs. During configuration, administrators specify the MSA name (without a password) in the service properties. Windows handles the rest, including password changes.

**Where passwords are stored:**  
- **Securely managed by Windows:** The password for an MSA is automatically generated and managed by Windows, and it's stored in Active Directory. The password is rotated automatically, and no human interaction is required.
- **Stored temporarily in memory:** The service uses the MSA password hash stored temporarily in system memory. While Windows minimizes exposure, the password hash could potentially be harvested if the system is compromised and attackers gain privileged access.

**Security implications:**
- **Automatic password management:** MSAs automatically manage passwords, changing them regularly without requiring administrative intervention, reducing the risk of weak or stale passwords.
- **Single-server limitation:** MSAs can only be used on a single server, which can be a limitation in load-balanced or distributed environments.

**When to use:**  
MSAs are ideal for applications running on a single server where you want to reduce the overhead of password management and improve security.

## 3. Group managed service accounts (gMSAs)

**Overview:**  
gMSAs expand on MSAs by allowing the same account to be used across multiple servers. They were introduced in Windows Server 2012 and are particularly useful for services running in a server farm or load-balanced environment.

**How applications use them:**  
Similar to MSAs, applications are configured to use gMSAs without specifying a password. However, gMSAs require that the application servers are part of a domain and are configured to retrieve the account's credentials.

**Where passwords are stored:**  
- **Securely Managed Across Servers:** The password for a gMSA is generated and managed by Windows and is securely stored in Active Directory. The gMSA password is rotated automatically, similar to MSAs.
- **Fetched by Servers:** When a server needs to use a gMSA, it securely retrieves the password hash from Active Directory. The password hash is temporarily stored in memory during service execution and is less exposed to potential harvesting.

**Security implications:**
- **Automatic Password Management Across Servers:** Like MSAs, gMSAs automatically manage passwords, but they extend this functionality across multiple servers, reducing the complexity of managing service accounts in large environments.
- **Reduced Attack Surface:** Since passwords aren’t manually managed, and because gMSAs can’t be used interactively, the attack surface is smaller compared to traditional service accounts.

**When to ise:**  
gMSAs are best suited for distributed applications or services running in a load-balanced or clustered environment, where consistent and secure access is needed across multiple servers.

## 4. Delegated service accounts (dMSAs)

**Overview:**  
Delegated service accounts are not a distinct type like MSAs or gMSAs but rather a configuration where permissions are delegated to a specific service account, allowing it to perform certain actions on behalf of a user or another account.

**How applications use them:**  
Applications must be explicitly coded to take advantage of delegation. This involves using protocols like Kerberos with constrained delegation or OAuth with token-based authentication, depending on the application and the resources accessed.

**Where passwords or secrets are stored:**  
- **Kerberos Tickets:** In cases where Kerberos delegation is used, service tickets and session keys are stored in memory. If an attacker compromises the system, these tickets could potentially be harvested.
- **OAuth Tokens:** If OAuth or similar token-based methods are used, the tokens are typically stored temporarily in memory or on disk, depending on the application. These tokens could be intercepted if not securely managed.

**Security implications:**
- **Granular Control:** Delegation allows for fine-grained control over what a service account can do, which enhances security by limiting the account’s actions to only what’s necessary.
- **Complex Configuration:** Delegation requires careful setup to ensure that it’s secure and that permissions are not overly broad. Misconfigurations can lead to security vulnerabilities.

**When to use:**  
Delegated service accounts are ideal for scenarios where an application needs to act on behalf of a user or another service with limited permissions, such as in enterprise environments with strict security and compliance requirements.

## Conclusion

Each type of service account offers unique benefits and trade-offs, and choosing the right one depends on your application’s specific needs:

- **Standard Service Accounts** offer simplicity but come with higher administrative overhead, potential security risks, and the need for manual password management.
- **Managed Service Accounts (MSAs)** automate password management and reduce security risks but are limited to single-server environments.
- **Group Managed Service Accounts (gMSAs)** provide the benefits of MSAs with multi-server support, making them ideal for distributed applications while reducing the risk of password harvesting.
- **Delegated Service Accounts** offer granular security controls with complex configurations, requiring careful management of tickets or tokens to prevent unauthorized access.

When designing applications, it’s crucial to consider how the service accounts will be used, focusing on both security and maintainability. By selecting the appropriate service account type, you can significantly enhance your application’s security posture while minimizing administrative effort.

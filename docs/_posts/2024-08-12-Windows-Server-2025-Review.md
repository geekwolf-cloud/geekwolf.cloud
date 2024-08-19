---
layout: post
title:  "Windows Server 2025 review"
date:   2024-08-12 09:11:15 +0100
category: on-premises
tags: on-premises
comments_id: 5
---
<h1>{{ page.title }}</h1>

# Windows Server 2025: New Features, Changes, and Removals

Windows Server 2025 is shaping up to be a significant update with various new features, improvements, and removals. Microsoft has focused on enhancing security, modernizing protocols, and streamlining management tools. Here's an overview of what to expect:

## New Features

1. **Delegated Managed Service Accounts (dMSA):**  
   These replace traditional service accounts with more secure, fully randomized machine accounts, reducing the risk of credential harvesting attacks. This feature improves the security posture by tying account authentication to device identity more closely.

2. **Server Message Block (SMB) Protocol Updates:**  
   The SMB protocol sees several enhancements, including new options for disabling SMB over QUIC and auditing successful connections. These updates boost both security and compliance, offering administrators more control over data transfers.

3. **Support for TLS 1.3:**  
   With the adoption of TLS 1.3 for LDAP over TLS, Windows Server 2025 strengthens encrypted communication, aligning with modern security standards.

4. **Forest and Domain Functional Level:**  
   A new functional level for forests and domains is introduced, allowing for more advanced features and better overall management.

5. **AES Encryption for Password Changes:**  
   To further enhance security, Windows Server 2025 now supports AES encryption for password changes, providing an additional layer of protection against potential vulnerabilities.

## Removed and Deprecated Features

1. **PowerShell 2.0 Engine:**  
   This outdated version has been removed, necessitating migration to PowerShell 5.0 or higher.

2. **SMTP Server:**  
   The built-in SMTP server is no longer included, reflecting the move towards more modern email solutions.

3. **IIS 6 Management Console:**  
   This old management interface is removed, encouraging the use of newer versions for web server management.

4. **NTLM 1.0 and 1.1:**  
   These older versions of NTLM are deprecated and blocked by default due to security concerns.

5. **WebDAV Redirector:**  
   Disabled by default on fresh installations, signaling a shift away from older, less secure web-based file sharing methods.

## What’s Next?

Windows Server 2025, as the next Long-Term Servicing Channel (LTSC) release, is expected to arrive in the second half of 2024. The updates and removals in this version clearly signal Microsoft's commitment to modernizing and securing enterprise environments. For organizations, these changes mean better performance, stronger security, and a push towards adopting newer technologies and practices.

Overall, Windows Server 2025 will require organizations to prepare for some significant shifts, especially in how they manage accounts, secure data, and maintain compatibility with legacy applications.


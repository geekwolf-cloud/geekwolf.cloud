---
layout: post
title:  "Comparing Active Directory and AD LDS"
description: Comparing Active Directory and AD LDS.  Did you know that Entra ID (aka Azure AD) has a lot in common with AD LDS?
date:   2024-02-02 18:12:37 +0100
category: on-premises
tags: on-premises technical-overview entra-id
image: \android-chrome-192x192.png
comments_id: 8
---
<h1>{{ page.title }}</h1>

When it comes to managing identities, access, and directory services within an organisation, Microsoft's Active Directory (AD) and its variant, Active Directory Lightweight Directory Services (AD LDS), have been pivotal tools for IT professionals. With the evolution of cloud computing, Entra ID (formerly known as Azure Active Directory) has emerged as a key player in identity and access management. However, even in this cloud-centric world, the foundations of traditional directory services like AD and AD LDS continue to play a crucial role.

In this blog post, we'll explore the differences between Active Directory and AD LDS, and explain how AD LDS still underpins modern identity services like Entra ID.

## What is Active Directory?

Active Directory (AD) is a comprehensive directory service developed by Microsoft for Windows domain networks. Introduced with Windows 2000, AD provides centralised authentication and authorisation services to manage users, computers, and other resources in a networked environment. Key features of AD include:

1. **Domain services**: AD Domain Services (AD DS) is the core component of AD, managing domain-based networks, and allowing for the creation and management of domains, users, groups, and policies.

2. **Group policy**: AD allows administrators to implement group policies across an organisation, ensuring security, consistency, and streamlined management.

3. **Authentication**: AD provides centralised authentication via Kerberos, LDAP, and NTLM protocols, allowing users to log in once and gain access to resources across the network (Single Sign-On).

4. **Replication**: AD uses a multi-master replication model, ensuring that changes made on one domain controller (DC) are replicated across all other DCs in the domain.

## What is AD LDS?

Active Directory Lightweight Directory Services (AD LDS) is a more flexible, lightweight version of AD DS. It provides directory services without the need for domains or the full range of AD DS features. Key distinctions of AD LDS include:

1. **No domain services**: Unlike AD DS, AD LDS does not manage domains. It provides a directory for applications to store and retrieve data, but without the complexity of domain-based management.

2. **Flexibility and customisation**: AD LDS allows organisations to create multiple instances, each serving a different application with its own schema. This makes it an ideal choice for applications that require directory services but don't need full AD functionality.

3. **Decoupled from Windows Server roles**: AD LDS can run on non-domain controllers and does not require the same infrastructure as AD DS. This makes it easier to deploy in various environments, including those that don’t rely on domain-based structures.

4. **Schema customisation**: AD LDS supports custom schemas tailored to specific applications, making it a highly customisable solution compared to the rigid structure of AD DS.

## How AD LDS underpins Entra ID

Entra ID, formerly known as Azure Active Directory, is Microsoft's cloud-based identity and access management service. It is a fundamental component of Microsoft’s cloud ecosystem, providing identity services for Azure, Microsoft 365, and other cloud applications. While Entra ID is a cloud-native solution, its underlying principles are deeply rooted in the technologies developed for AD and AD LDS.

1. **Directory services architecture**: Entra ID shares architectural similarities with AD and AD LDS, such as the use of directory objects (users, groups, etc.), schemas, and LDAP-like queries. This lineage allows organisations to extend their on-premises AD environment into the cloud using Entra ID, leveraging tools like Azure AD Connect.

2. **Synchronisation and federation**: Entra ID can synchronise with on-premises AD DS using Azure AD Connect, enabling hybrid identity scenarios. AD LDS can play a role here, particularly for applications that rely on custom directories or schemas not supported directly in Entra ID.

3. **Extensible directory**: Like AD LDS, Entra ID is designed to be an extensible directory service. Developers can build custom attributes and schemas into their Entra ID tenant, similar to how AD LDS allows custom directory instances for specific applications.

4. **Modern applications and protocols**: While Entra ID focuses on modern protocols like OAuth, OpenID Connect, and SAML, it still supports LDAP-like operations and concepts. The lightweight, flexible nature of AD LDS’s architecture echoes in Entra ID’s ability to cater to various application needs, providing a bridge between traditional on-premises directories and modern cloud services.

## Conclusion

Active Directory and AD LDS have been cornerstone technologies in the realm of identity and access management. While AD DS is best suited for managing domain-based networks, AD LDS offers a flexible, lightweight alternative for specific application scenarios. As organisations transition to cloud-based infrastructures, the principles and technologies behind AD and AD LDS continue to underpin services like Entra ID, enabling hybrid environments and supporting both legacy and modern applications.

Understanding these differences and how AD LDS still influences modern identity management solutions like Entra ID is key to navigating the evolving landscape of IT infrastructure. Whether you're managing an on-premises environment, a cloud-native application, or a hybrid setup, the legacy of AD and AD LDS ensures continuity and compatibility in a rapidly changing world.

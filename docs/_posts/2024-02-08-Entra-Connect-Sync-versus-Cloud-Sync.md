---
layout: post
title:  "Entra Connect Sync versus Cloud Sync"
description: Comparing Entra Connect Sync (previously called Azure AD Connect) and Entra Cloud Sync. Which one should you use?
date:   2024-02-08 7:22:21 +0100
category: on-premises
tags: on-premises technical-overview entra-id identity
image: /android-chrome-192x192.png
comments_id: 8
---
<h1>{{ page.title }}</h1>

In the realm of identity management, organisations often face the challenge of synchronising on-premises directories with cloud environments. Microsoft provides two primary tools to achieve this: **Microsoft Entra Connect Sync** and **Microsoft Entra Cloud Sync**. Both are designed to synchronise user identities between on-premises Active Directory (AD) and Microsoft Entra (formerly Azure Active Directory), but they differ significantly in features, capabilities, and use cases. Understanding these differences is crucial for choosing the right tool to meet your organisation’s needs.

## Overview of Microsoft Entra Connect Sync

**Microsoft Entra Connect Sync** (formerly Azure AD Connect) is a robust and feature-rich solution designed for comprehensive directory synchronisation and identity management. Typically deployed as an on-premises server application, it connects an organisation's AD with Entra, ensuring that user identities and attributes are consistent across environments.

**Key features:**
- **Full directory synchronisation**: Supports synchronisation of users, groups, contacts, and devices from on-premises AD to Entra.
- **Hybrid identity capabilities**: Facilitates complex hybrid scenarios, including Hybrid Azure AD Join, where devices can be joined to both on-premises AD and Azure AD.
- **Password synchronisation**: Offers both Password Hash Synchronisation (PHS) and Pass-through Authentication (PTA) for seamless sign-on experiences.
- **Federation support**: Integrates with Active Directory Federation Services (ADFS) to enable single sign-on (SSO) across on-premises and cloud resources.
- **Advanced configuration and customisation**: Provides extensive control over synchronisation rules, custom attribute mapping, and multi-forest support.

**Use cases:**
- Large organisations with complex on-premises environments.
- Scenarios requiring deep integration between on-premises and cloud identities, including support for hybrid identity, federation, and device management.

## Overview of Microsoft Entra Cloud Sync

**Microsoft Entra Cloud Sync** is a lightweight, cloud-managed synchronisation tool designed for simpler identity synchronisation needs. It offers an easy-to-deploy solution with minimal on-premises infrastructure requirements, making it ideal for organisations looking for a straightforward setup.

**Key features:**
- **Agent-based architecture**: A small agent installed on-premises handles synchronisation tasks, reducing the need for extensive on-premises infrastructure.
- **Simplified deployment**: Easier to set up compared to Entra Connect Sync, with fewer configuration steps.
- **Automatic updates**: Cloud Sync agents are automatically updated by Microsoft, reducing the maintenance burden.
- **Support for multi-forest**: Supports synchronisation across multiple AD forests, but with less customisation compared to Entra Connect Sync.
- **Password hash synchronisation only**: Provides basic password synchronisation without the support for Pass-through Authentication or federation services.

**Use cases:**
- Organisations with straightforward identity management needs.
- Scenarios where minimal on-premises infrastructure and easy deployment are priorities.

## Key feature comparison: Entra Connect Sync vs. Cloud Sync

Let’s compare some of the critical features and capabilities of both tools:

| **Feature**                            | **Microsoft Entra Connect Sync**        | **Microsoft Entra Cloud Sync**             |
|----------------------------------------|-----------------------------------------|--------------------------------------------|
| **Multi-forest synchronisation**       | Yes, with detailed configuration options | Yes, but with more standardised management |
| **Hybrid joined devices**              | Yes, supports Hybrid Azure AD Join      | No                                         |
| **Syncing password expiration**        | Yes                                     | No                                         |
| **Kerberos and NTLM authentication**   | Yes, via Hybrid Azure AD Join           | No                                         |
| **Federation integration**             | Yes, integrates with ADFS               | No                                         |
| **Customisation and control**          | Extensive, with custom rules and attribute mapping | Limited, with standardised configurations  |
| **On-premises infrastructure**         | Requires dedicated servers or VMs       | Requires only lightweight agents           |
| **Deployment complexity**              | Higher, with extensive setup options    | Lower, with streamlined deployment         |
| **Automatic updates**                  | Manual updates required                 | Automatic updates from the cloud           |

## Choosing between Entra Connect Sync and Cloud Sync

The decision between Microsoft Entra Connect Sync and Cloud Sync hinges on the complexity of your organisation’s identity management needs.

- **Microsoft Entra Connect Sync** is the ideal choice for organisations with complex environments that require comprehensive identity management capabilities, including hybrid identity scenarios, advanced synchronisation rules, and support for legacy authentication protocols like Kerberos and NTLM. It's also the go-to solution for scenarios involving Hybrid Azure AD Join.

- **Microsoft Entra Cloud Sync**, on the other hand, is best suited for organisations that need a simpler, cloud-first synchronisation solution. It is particularly useful for smaller companies or those with less complex environments that do not require deep integration with on-premises systems. Cloud Sync excels in scenarios where ease of deployment, minimal maintenance, and reduced on-premises infrastructure are the primary considerations.

## Conclusion

Both Microsoft Entra Connect Sync and Cloud Sync play essential roles in synchronising on-premises identities with the cloud. However, they cater to different needs:

- **Entra Connect Sync** offers a full suite of features for organisations with complex identity management requirements, including support for hybrid identities, deep customisation, and legacy on-premises authentication.
- **Entra Cloud Sync** provides a streamlined, cloud-managed approach for organisations with simpler needs, focusing on ease of use and minimal infrastructure.

By carefully evaluating your organisation’s specific needs—such as the requirement for hybrid device management, legacy authentication support, or multi-forest synchronisation—you can choose the tool that best aligns with your operational goals and IT strategy.

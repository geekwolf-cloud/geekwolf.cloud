---
layout: post
title:  "Understanding cross-tenant features in Microsoft 365"
description: A look into the M365 cross tenant features and when they may be useful (as well as when they are not)
date:   2024-10-21 07:54:43 +0100
category: microsoft-365
tags: microsoft-365 migration
image: /android-chrome-192x192.png
comments_id: 46
---
<h1>{{ page.title }}</h1>

As organisations increasingly adopt Microsoft 365 for collaboration and productivity, many encounter scenarios requiring communication and resource sharing across different tenants. Microsoft 365 offers several **cross-tenant features** that enable seamless interaction while maintaining security and compliance. This blog explores these features, how they work, and when to use them.

---

## What are cross-tenant features in Microsoft 365?

Cross-tenant features in Microsoft 365 enable organisations with separate tenants to collaborate, share resources, or migrate data without merging into a single tenant. They are particularly useful for scenarios like mergers and acquisitions, partnerships, or managed service environments. Below, we break down the key features:

---

## 1. Cross-tenant access settings (Microsoft Entra ID)

**Description**  
Cross-tenant access settings allow organisations to establish trust and define collaboration policies between Microsoft Entra ID (formerly Azure AD) tenants. These settings are part of the Microsoft Entra External Identities capabilities and include:

- **B2B collaboration**: Share apps and resources with guest users from another tenant.
- **B2B direct connect**: Enable seamless connectivity for services like Microsoft Teams and SharePoint.

**Key features**:
- Trust-based access control between tenants.
- Granular policies for user access and resource sharing.
- Support for multi-factor authentication (MFA) and conditional access.

**Use cases**:
- **Mergers and acquisitions**: Establish controlled access between two tenants during integration.
- **External collaboration**: Allow trusted partners to access specific apps or resources while enforcing security policies.

**Warnings**:
- Collaboration and direct connect don't play nicely together.  They offer different features that are incompatible with each other
- If looking to migrate then creating guests in the target tenant is going to create more complications than it solves, and using shared channels is going to leave you with shared channels at the end (which can't be used by guest users)

---

## 2. Microsoft Teams shared channels

**Description**  
Shared channels in Microsoft Teams allow users from different tenants to collaborate in a single channel without switching tenants. It leverages Azure AD B2B Direct Connect for seamless integration.

**Key features**:
- Users from external tenants appear as team members within the shared channel.
- Supports chat, file sharing, and app integration.
- Security and compliance policies from both tenants are applied.
- Users who are guests in your tenant cannot use a shared channel

**Use cases**:
- **Partner collaboration**: Work closely with external vendors or partners on specific projects.
- **Joint ventures**: Facilitate long-term collaboration between organisations without tenant switching.

---

## 3. Cross-tenant mailbox migration

**Description**  
This feature supports mailbox migrations between Microsoft 365 tenants. It is particularly beneficial during company mergers, acquisitions, or divestitures.

**Key features**:
- Secure migration of mailboxes between tenants.
- Includes migration of emails, contacts, and calendar items.
- Powered by Microsoft 365 Exchange Online.
- Requires Entra Connect Sync on both sides

**Use cases**:
- **Mergers and acquisitions**: Consolidate users from acquired companies into a single tenant.
- **Divestitures**: Separate mailboxes for spun-off entities while maintaining data integrity.

---

## 4. Cross-tenant data sharing (OneDrive and SharePoint)

**Description**  
OneDrive and SharePoint allow users to securely share files and folders with users in other tenants. This feature supports B2B collaboration and maintains compliance.

**Key features**:
- External sharing via secure links or direct access.
- Enforced compliance through conditional access and data loss prevention (DLP) policies.
- Auditing and activity reporting for external sharing.

**Use cases**:
- **Project collaboration**: Share large files or project documents with external clients or partners.
- **Vendor collaboration**: Exchange sensitive documents securely with vendors.

**Warnings**:
- Guests will need to be deleted or converted as part of any subsequent migration, so be careful about using it for pre-migration collaboration

---

## 5. Cross-tenant analytics and reporting

**Description**  
Microsoft 365 allows cross-tenant analytics through tools like Power BI and Viva Insights. These enable aggregated reporting and actionable insights across multiple tenants.

**Key features**:
- Centralised dashboards for monitoring activity.
- Ability to analyse trends and patterns across tenant boundaries.

**Use cases**:
- **Managed service providers**: Monitor and report on multiple customer tenants.
- **Large organisations**: Gain insights into employee productivity and collaboration across subsidiaries.

---

## 6. Cross-tenant identity synchronisation

**Description**  
Microsoft Entra ID allows synchronisation of user identities across tenants, facilitating a unified identity experience while maintaining separate tenants.

**Key features**:
- Unified sign-in experience across tenants.
- Secure synchronisation of user identities.
- Supports hybrid environments with on-premises integration.
- Creates externally authenticated accounts (Guests) that can be userType guest or member

**Use cases**:
- **Subsidiaries or franchises**: Provide employees in different tenants with a seamless user experience.
- **Multi-tenant organisations**: Enable employees to access resources across tenants without multiple logins.

---

## 7. Tenant-to-tenant app sharing

**Description**  
This feature allows applications hosted in one tenant to be accessed by users in another tenant without re-deploying the app.

**Key features**:
- Centralised application hosting.
- Secure access through Entra ID.
- Cost efficiency by reducing the need for duplicate infrastructure.

**Use cases**:
- **Joint ventures**: Share proprietary apps between partnering organisations.
- **Subsidiary management**: Allow multiple tenants to access parent organisation-hosted apps.

---

## Choosing the right feature

| **Scenario**                  | **Recommended feature**                                   |
|-------------------------------|----------------------------------------------------------|
| Partner collaboration          | Teams shared channels, cross-tenant access settings      |
| Mergers and acquisitions       | Cross-tenant mailbox migration, identity synchronisation |
| File sharing with external users | Cross-tenant data sharing                               |
| Centralised app access         | Tenant-to-tenant app sharing                             |
| Multi-tenant monitoring        | Cross-tenant analytics and reporting                     |

---

## Conclusion

Cross-tenant features in Microsoft 365 empower organisations to collaborate effectively without sacrificing security or compliance. Whether you're navigating a merger, collaborating with partners, or managing multiple subsidiaries, these features provide flexibility and control. By leveraging the right tools for your scenario, you can foster efficient, secure collaboration across tenant boundaries.

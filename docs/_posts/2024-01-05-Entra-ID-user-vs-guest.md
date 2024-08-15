---
layout: default
title:  "Entra ID User versus Guest in Microsoft 365"
date:   2024-01-05 11:55:20 +0100
category: entra-id
tags: entra-id identity
---

In the world of Microsoft 365 (M365) and Azure Entra ID (formerly Azure Active Directory), managing user access and roles is crucial for both security and collaboration. Two important terms you'll often come across are "Guest" and "User." These terms have specific meanings both as a user type value in Entra ID and as concepts related to internal and external authentication. In this blog, we'll explore the differences between these two roles, focusing on their significance and impact within M365.

## userType in Entra ID: Guest vs. User

**userType** is a property in Azure Entra ID that defines the relationship between an individual and your organization. It determines the level of access the individual has within your M365 environment.

- **Member (User)**: This refers to an individual who is a part of your organization. Members typically have an email address associated with your organization's domain (e.g., user@yourcompany.com). When a user is classified as a "User" or "Member" in Entra ID, they are considered internal employees or contractors who have been granted full access to your organization's resources.

- **Guest**: A "Guest" is someone who is not part of your organization. Guests might include partners, clients, vendors, or any other external collaborators. These users are often invited to access specific resources within your M365 environment, but they do not have the same level of access as internal members. Guests usually log in using an account from their own organization or a personal account (e.g., user@partnercompany.com or user@gmail.com).

## Capabilities of Members vs. Guests in Microsoft 365

The distinction between Members and Guests has practical implications in M365, especially regarding what these users can and cannot do.

**Members** typically have the following capabilities:

1. **Access to All M365 Apps and Services**: Members can access the full suite of M365 apps, including Outlook, Teams, SharePoint, OneDrive, and more, depending on their assigned licenses.
  
2. **Creation and Management Rights**: Members can create and manage resources like Teams, SharePoint sites, and Planner boards. They also have the ability to invite other users, including guests, to these resources.

3. **Internal Collaboration**: Members can collaborate with other internal users seamlessly across M365 services. They can see each other’s availability in Teams and Outlook and have access to the organization's shared resources like calendars and contacts.

4. **Unified Management**: Internal members are typically managed through Entra ID, with centralized control over policies like password expiration, multi-factor authentication (MFA), and conditional access.

In contrast, **Guests** have more limited access:

1. **Restricted App Access**: Guests generally have limited access to M365 apps and services. For instance, they might only be able to participate in Teams meetings, access specific SharePoint sites, or collaborate in shared documents via OneDrive. However, they won't have full access to all M365 applications.

2. **Limited Creation Rights**: Guests cannot create Teams, SharePoint sites, or other resources. Their role is more about consuming and interacting with content created by internal users rather than generating new content.

3. **External Collaboration**: Guests are mainly used for external collaboration. While they can participate in Teams chats and meetings, access shared files, and contribute to projects, their access is often restricted to specific resources. For example, they may only be able to view and edit files in certain folders on SharePoint but not create new folders.

4. **Governance and Compliance**: From a governance perspective, Guests are managed with stricter policies. For instance, their access might be time-limited, and they could be subject to different conditional access policies to ensure that external access does not compromise the organization’s security.

## Internal vs. External Authentication Concepts

Understanding the difference between internal and external authentication is key to managing Members and Guests in Entra ID.

- **Internal Authentication**: This applies to Members (internal users) who authenticate using their organization-provided credentials. Authentication is typically handled through Entra ID, which may enforce policies like MFA, conditional access, and device compliance.

- **External Authentication**: Guests, on the other hand, usually authenticate via their own organization’s credentials or personal accounts. This means that while they are accessing your organization’s resources, they are not using credentials issued by your organization. Entra ID facilitates this external authentication by trusting the identity provider (such as another Azure AD instance, Google, or Microsoft accounts).

The security implications here are significant. Internal users are subject to your organization’s full suite of security controls, while external users bring in potential security risks. Therefore, it’s crucial to have robust guest access policies in place to manage these risks effectively.

## Practical Scenarios: When to Use Members vs. Guests

- **Project Collaboration with External Partners**: If you're working with external vendors or clients on a project, you might invite them as Guests. This allows them to participate in specific Teams channels, access relevant SharePoint documents, and join meetings without granting them full access to your M365 environment.

- **Contractor Onboarding**: If you have a contractor who needs full access to internal resources for an extended period, it might be more appropriate to provision them as a Member, especially if they require access to sensitive or extensive M365 resources.

- **External Audits or Reviews**: For external auditors who need access to certain documents or files within your organization, you can provide Guest access to specific SharePoint sites or OneDrive folders, ensuring they only see what’s necessary for their work.

## Conclusion

Understanding the difference between "Guest" and "User" in Entra ID and M365 is essential for managing your organization’s security and collaboration efforts. Members have full access to resources and can perform a wide range of actions within M365, while Guests have restricted access designed for external collaboration. By leveraging these roles appropriately, you can ensure that your organization’s data remains secure while facilitating seamless collaboration both internally and externally.

---
layout: post
title:  "Do Cross Tenant Features Help with Migration?"
description: Let's explorer Microsoft's cross tenant features and see if they help or hinder a tenant to tenant migration
date:   2024-10-28 08:01:17 +0100
category: microsoft-365
tags: microsoft-365 migration
image: /android-chrome-192x192.png
comments_id: 45
---
<h1>{{ page.title }}</h1>

# Cross-tenant features and tenant-to-tenant migration

While cross-tenant features in Azure AD (such as B2B collaboration, guest access, and shared channels in Teams) can offer some short-term benefits during a migration scenario, they do not provide a comprehensive solution for tenant-to-tenant migration. In fact, they can introduce additional complexity and confusion during the process.

Below is an explanation of why cross-tenant features generally fail to address the core challenges of a tenant-to-tenant migration.

## Challenges with cross-tenant features in migration

### B2B collaboration and guest access
- Not a true solution for user migration: Inviting users as guests in the target tenant does not migrate their full user account. Instead, it creates a guest user in the target tenant, which does not carry over entitlements, settings, or data.
- Entitlements do not migrate: Licences or specific access rights in the source tenant are not automatically transferred when users are invited as guests.
- User confusion: Managing dual identities across tenants can confuse users, particularly when it comes to authentication, UPNs, and access.

### Shared channels in Teams
- Limited utility in migration: Shared channels facilitate collaboration between tenants but do not solve issues like account movement, email coexistence, or UPN redirection.
- Not a replacement for tenant migration: Shared channels cannot handle services such as email forwarding or full user data migration.

### Cross-tenant trusts
- Not a simplification for identity management: While cross-tenant trusts allow some forms of identity sharing, they do not solve core issues such as account transfer, data migration, or DNS changes.
- No direct impact on core migration tasks: Cross-tenant trusts do not simplify tasks such as email flow, user account transfer, or domain management.

### Coexistence settings and UPN redirection
- Cannot address the UPN issue: Azure AD does not natively support UPN redirection. Since a domain can only exist in one tenant at a time, UPN changes are required during migration, and cross-tenant settings do not help with this.
- Inconsistent user experience: Users may face disruption and confusion when switching between tenants with different UPNs, credentials, and entitlements.

## Why cross-tenant features create confusion during migration

- No seamless user migration: Cross-tenant features like B2B collaboration do not fully integrate users across tenants. This creates fragmented experiences, with users managing accounts in both tenants.
- Licencing and data inconsistencies: Guests in the target tenant do not inherit licences, entitlements, or migrated data from the source tenant. Migration tasks such as licence assignment and data transfer still need to be managed separately.
- Complicated coexistence: During migration, maintaining consistent email flow, Teams access, and data synchronisation across tenants becomes challenging. Cross-tenant collaboration features do not resolve these coexistence issues.
- UPN and domain management: When a domain is removed from the source tenant and added to the target tenant, cross-tenant settings do not assist in managing UPNs, which must be updated and synchronised manually.

## Conclusion: cross-tenant features are not a migration solution

While cross-tenant features like B2B collaboration and shared channels provide temporary collaboration and some identity management flexibility, they do not solve the core issues of tenant-to-tenant migration. These include:

- Domain transfer (a domain cannot exist in both tenants simultaneously),
- UPN redirection (Azure AD does not support true UPN redirection),
- Data and entitlement transfer (migrated users do not automatically inherit licences or data).

While cross-tenant features may offer short-term benefits, they often break down during migration and lead to increased complexity and user confusion. For a successful tenant-to-tenant migration, a structured migration strategy using specialised tools is required to address these challenges effectively.

In summary, cross-tenant features are helpful for several specific scenarios, but they do not replace the need for a comprehensive migration plan.

---
layout: post
title:  "Active Directory migration overview"
date:   2024-04-11 09:29:32 +0100
category: on-premises
tags: on-premises migration technical-overview
comments_id: 17
---
<h1>{{ page.title }}</h1>


Migrating from one Active Directory (AD) environment to another is a complex and delicate task that requires careful planning and execution. This guide will walk you through the essential steps and considerations for a successful AD-to-AD migration, focusing on minimising user impact, maintaining security, and ensuring ongoing access to critical services like password synchronisation and self-service password reset.

## 1. Understanding the scope and structure of AD migration

Before initiating the migration, it's crucial to clearly define its scope. This includes understanding:

- **Source and target domains:** Identify all objects (users, groups, computers, applications) that need to be migrated.
- **Migration goals:** Are you aiming for a full migration, a phased migration, or just migrating specific objects?
- **Timeline:** Set realistic timelines based on the complexity and size of the migration.

## 2. Planning the migration: key considerations

### a. Trusts: do you need them?

Trust relationships between the source and target AD domains can simplify resource access during the migration. Consider establishing a trust if:

- You need to maintain access to resources in the source domain during the migration.
- You plan on performing a phased migration where users will need temporary access to resources in both domains.

However, if your goal is to fully migrate without ongoing dependencies, avoiding trusts can help simplify the post-migration environment.

### b. SIDHistory: to use or not to use?

Security Identifier (SID) History allows migrated users to retain access to resources in the source domain using their old SID. While it can reduce disruption, it also comes with security implications:

- **Advantages:** Easier access to resources post-migration without requiring extensive ACL (Access Control List) changes.
- **Disadvantages:** Potential security risks, such as lingering old SIDs that could be exploited. Consider reassigning permissions in the target domain instead of relying on SIDHistory.

### c. Password synchronisation and encryption considerations

One of the critical challenges in AD-to-AD migrations is ensuring that user passwords are synchronised correctly between the source and target domains, especially if RC4 encryption is disabled in either or both forests.

1. **RC4 encryption and its impact on password synchronisation:**
   - **RC4 disabled in source or target domain:** If RC4 is disabled, legacy password synchronisation methods may not work. Ensure that your migration tools and methods are compatible with modern encryption protocols like AES.
   - **Password synchronisation tools:** Utilise tools like Microsoft Password Synchronisation or third-party tools that support modern encryption standards. These tools help ensure that user passwords are synchronised without requiring them to reset their passwords during the migration.

2. **Maintaining self-service password reset (SSPR) capabilities:**
   - **SSPR during migration:** Users should be able to reset their passwords independently throughout the migration process. Ensure that your SSPR solution is configured to work with both the source and target domains.
   - **Reverse password sync:** Implement a reverse password synchronisation mechanism that syncs passwords from the target domain back to the source domain. This ensures that users who reset their passwords in the target domain will still be able to authenticate in the source domain if necessary.

## 3. Structuring the migration process

### a. Phase 1: pre-migration activities

1. **Assess the current environment:**
   - Conduct a thorough audit of your current AD environment.
   - Identify outdated or unnecessary objects and clean them up before migration.

2. **Establish the target environment:**
   - Set up the target AD domain with the necessary structure (OUs, GPOs, etc.).
   - Create placeholders for users, groups, and computers.

3. **Implement trusts (if needed):**
   - If you decide to use a trust, establish it between the source and target domains.
   - Test the trust relationship to ensure that it functions correctly.

4. **Security preparations:**
   - Review and tighten security policies in the target domain.
   - Plan for the secure transfer of sensitive data.

### b. Phase 2: migration execution

1. **User and group migration:**
   - Migrate user accounts and groups to the target domain using tools like ADMT (Active Directory Migration Tool).
   - If using SIDHistory, ensure that it is correctly populated.

2. **Password synchronisation:**
   - Implement a robust password synchronisation solution that supports modern encryption standards, especially if RC4 is disabled.
   - Ensure continuous password synchronisation between the source and target domains.
   - Configure reverse password sync to maintain SSPR functionality and user convenience during the transition.

3. **Workstation migration:**
   - Migrate user workstations to the target domain.
   - Ensure that user profiles are preserved and that logins function seamlessly.
   - Use tools like USMT (User State Migration Tool) to migrate user profiles.

4. **Server and application migration:**
   - Migrate servers, including file servers, application servers, and database servers, to the target domain.
   - Reconfigure applications to authenticate against the target domain.
   - Test all migrated applications to ensure they function as expected.

5. **Cloud services integration:**
   - If you're using cloud services like Microsoft 365, reconfigure these services to point to the new AD domain.
   - Ensure that Entra ID (formerly Azure AD) is synchronised with the target AD domain.
   - Test Single Sign-On (SSO) and Multi-Factor Authentication (MFA) setups in the new environment.

### c. Phase 3: post-migration activities

1. **Cutover and testing:**
   - Schedule a final cutover, where all users and systems transition to the target domain.
   - Conduct comprehensive testing to ensure all objects have migrated correctly, and that users can access necessary resources.

2. **Decommissioning the source domain:**
   - Once everything is confirmed to be functioning in the target domain, gradually decommission the source domain.
   - Remove any trusts and ensure no lingering dependencies on the old domain.

3. **Documentation and knowledge transfer:**
   - Document the new environment’s structure and any changes made during the migration.
   - Provide training to IT staff and end-users as needed.

## 4. Minimising user impact

User experience should be at the forefront of your migration strategy. Here’s how to minimise disruption:

- **User communication:** Inform users about the migration timeline, what to expect, and whom to contact if they encounter issues.
- **Phased migration:** Consider migrating users in phases, especially for large organisations. This approach allows you to manage and address issues in smaller batches.
- **Allow user choice:** Where feasible, allow users to choose their migration date/time within a set window. This flexibility can help in accommodating business needs and minimising impact on productivity.

## 5. Security implications

During the migration, be mindful of security risks:

- **SIDHistory:** While useful, it can introduce risks. Ensure that SIDHistory is carefully managed, and eliminate unnecessary SIDs post-migration.
- **Trusts:** If using trusts, ensure that they are correctly configured to prevent unauthorised access.
- **Password security:** Ensure that password synchronisation respects modern encryption protocols and that SSPR remains functional.
- **Data sensitivity:** Encrypt sensitive data during transfer and ensure that access controls are correctly applied in the target domain.

## 6. Conclusion

Migrating from one AD to another is a significant task that requires careful planning, execution, and post-migration activities. By considering the aspects mentioned above—trusts, SIDHistory, security, password synchronisation, and minimising user impact—you can achieve a successful migration with minimal disruption to your organisation.

Every migration is unique, so tailor the process to your organisation’s needs, involve stakeholders early, and prioritise security and user experience throughout the transition.

---
layout: post
title:  "How Entra join impacts the local Administrators group"
date:   2024-07-09 11:08:52 +0100
category: entra-id
tags: entra-id on-premises identity migration
comments_id: 22
---
<h1>{{ page.title }}</h1>


As organisations move to Microsoft Entra ID (formerly Azure Active Directory), it's crucial to understand the implications for device management, particularly how the local administrators group is handled when transitioning from AD-joined or workgroup-joined devices to Entra-joined devices. This blog explores what changes occur during this process, including the addition of specific SIDs, the implications of bulk enrolment methods, and the interaction with Autopilot settings.

## Local administrators group: AD-joined and workgroup-joined scenarios

Before diving into the Entra join process, it's essential to understand the local administrators group in different states:

1. **AD-joined devices:**
   - **Local Administrator Account:** The built-in local administrator account.
   - **Domain Admins Group:** Members of this AD group have local admin rights.
   - **SIDs Added:** Includes the SID for the Domain Admins group.

2. **Workgroup-joined devices:**
   - **Local Administrator Account:** The primary local administrator account.
   - **Other Local Admin Accounts:** Any additional accounts added manually.

## Transitioning to Entra join: What happens?

When a device transitions to being Entra-joined, several significant changes occur in the local administrators group:

1. **Microsoft Entra Global Administrator role:**
   - **Global Administrator SID:** Added to the local administrators group, representing users with the Global Administrator role in Microsoft Entra ID. These users have extensive permissions, including device management capabilities.

2. **Microsoft Entra Device Administrator role:**
   - **Entra ID Device Administrator SID:** Added to the local administrators group for users assigned the Device Administrator role. This role allows for device management without broader directory permissions.

3. **Registering user added to local administrators group:**
   - By default, the user who performs the Entra join (the "registering user") is added to the local administrators group on that device. This ensures they have administrative control over the device.

4. **Removal of domain-based SIDs:**
   - For AD-joined devices, SIDs associated with on-premises AD groups are removed, ensuring that only appropriate cloud-based roles retain admin rights.

## Bulk enrolment considerations

When using bulk enrolment methods, such as Windows Autopilot, the behaviour of the local administrators group differs from standard Entra join scenarios:

1. **Bulk enrolment methods:**
   - **Registering User SID:** In bulk enrolment scenarios, the registering user is the bulk enrolment user account, not the end user. As a result, the end user’s SID will not automatically be added to the local administrators group. 

## Autopilot and Entra ID device settings

Windows Autopilot simplifies device provisioning and can impact the local administrators group in the following ways:

1. **Autopilot profiles:**
   - **Autopilot Profile Settings:** These profiles can override the default settings configured in Microsoft Entra ID for device management. Specifically, Autopilot profiles can dictate local administrator settings, such as which accounts should have administrative rights on newly provisioned devices.
   - **Device Settings Override:** If an Autopilot profile is configured to add specific users or groups to the local administrators group, it will override the settings configured in the Microsoft Entra ID device settings. This allows for granular control during the provisioning process.

2. **Profile Configuration:**
   - In the Microsoft Endpoint Manager admin centre, administrators can configure Autopilot profiles to specify additional local administrators. This ensures that, regardless of the Entra ID settings, the Autopilot profile settings will apply to devices enrolled using this method.

## Controlling local administrators group configuration

Administrators have several options to control local administrators group membership during the Entra join process:

1. **Microsoft Entra ID device settings:**
   - Use the **"Additional local administrators on Entra-joined devices"** setting in the Microsoft Entra ID portal to specify additional users or groups. This can be adjusted under **Microsoft Entra ID > Devices > Device settings**.

2. **Microsoft Intune policies:**
   - Intune allows for detailed management of local administrator rights. Create configuration profiles or use RBAC policies to define who should have admin rights on Entra-joined devices.

3. **Autopilot profiles:**
   - Configure Windows Autopilot profiles to specify local administrator rights, which can override Entra ID settings. This configuration is done in the Microsoft Endpoint Manager admin centre and provides control over who is granted admin access during device provisioning.

## Conclusion

Transitioning devices from AD-joined or workgroup-joined to Entra-joined status involves significant changes to the local administrators group, with new SIDs added and domain-based SIDs removed. Understanding the implications of bulk enrolment methods and Autopilot settings is crucial for effective device management.

By leveraging Microsoft Entra ID settings, Intune policies, and Autopilot profiles, IT administrators can precisely control local admin rights, ensuring that devices are securely and efficiently managed in a cloud-first environment.

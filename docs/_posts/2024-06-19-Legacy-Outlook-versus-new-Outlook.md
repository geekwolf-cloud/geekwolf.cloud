---
layout: post
title:  "Legacy Outlook versus new Outlook"
description: Microsoft Outlook has been the default mail client for M365 for years.  What is this 'new Outlook', and how does it compare?
date:   2024-06-19 06:58:04 +0100
category: entra-id
tags: entra-id technical-overview microsoft-365
comments_id: 31
---
<h1>{{ page.title }}</h1>


Microsoft Outlook has been a cornerstone of email communication and personal information management for decades. As technology advances, so do the tools we use. Microsoft has introduced a new iteration of Outlook, often referred to as "One Outlook" or "Project Monarch," designed to modernise the user experience and unify the Outlook ecosystem. This blog will compare the legacy Outlook client with the new Outlook client, focusing on their features, technical inner workings, and limitations, with particular attention to some specific challenges users might face.

## 1. Overview and product/project name

- **Legacy Outlook client:** The traditional Outlook client, often called "Outlook for Windows" or "Outlook Desktop," has been a staple in both corporate and personal settings, providing comprehensive email, calendar, and task management capabilities.

- **New Outlook client (One Outlook / Project Monarch):** The new Outlook client, known internally as "Project Monarch," is part of Microsoft's "One Outlook" initiative, aiming to create a unified experience across all platforms. This client is designed to replace the existing Outlook for Windows with a more modern, lightweight, and consistent experience across devices.

## 2. User interface and experience

- **Legacy Outlook client:** The traditional Outlook client offers a feature-rich interface with extensive customisation options. However, it can sometimes feel cluttered due to the sheer number of features available, especially for users who need only basic functionality.

- **New Outlook client:** The new Outlook client has a cleaner, more streamlined interface that aligns with modern design principles seen in other Microsoft 365 applications. The emphasis is on ease of use and consistency across platforms. While the interface is simpler and more accessible, it can feel less customisable, particularly for advanced users.

## 3. Features and functionality

- **Legacy Outlook client:** 
  - **Offline access and advanced features:** The legacy client excels in offline capabilities and supports advanced features like VBA macros, third-party add-ins, and complex mail rules.
  - **Customisation and flexibility:** Users can extensively customise their experience, including managing multiple email accounts, creating custom views, and configuring mail rules.
  - **Shared mailboxes and favourites:** The legacy client allows users to add shared mailboxes easily and also supports adding folders from these mailboxes to the Favourites section, enabling quick access to important folders.

- **New Outlook client:** 
  - **Unified experience and simplified interface:** While offering a more unified experience across devices, the new client is missing some critical features from the legacy client.
  - **Inability to add shared mailboxes:** Currently, the new Outlook client does not support adding shared mailboxes directly. This is a significant limitation for users who rely on shared mailboxes for collaboration and workflow management.
  - **No favourites for auto-mapped mailbox folders:** Users cannot add folders from auto-mapped mailboxes (e.g., shared or delegated mailboxes) to their Favourites, which can be a substantial workflow disruption for those who need quick access to specific folders.
  - **Limited calendar functionality:** The new client also struggles with calendar management:
    - **Inability to add calendar availability in summary format:** Users cannot view or add calendar availability in the same summary format that the legacy client offers, which complicates scheduling and managing appointments.
    - **Reliability issues with multiple calendars:** Operating multiple calendars simultaneously in the new client is less reliable, and users often face challenges opening all calendar items, which is a significant drawback for those managing complex schedules or team calendars.

## 4. Technical inner workings

- **Legacy Outlook client:** 
  - **Local data storage and COM architecture:** The legacy client relies on local data storage (PST or OST files) and a COM-based architecture, allowing for extensive offline access and deep integration with Windows and other Office applications.

- **New Outlook client:** 
  - **Web-based architecture and cloud-first approach:** The new client is built using web technologies and a cloud-first approach, offering a more consistent and lightweight experience but at the cost of reduced offline functionality and certain advanced features.

## 5. Limitations and challenges

- **Legacy Outlook client:** 
  - **Performance and complexity:** The legacy client, while powerful, can experience performance issues on older systems and may feel overwhelming for new users due to its complexity.

- **New Outlook client:**
  - **Limited feature set:** The new client is missing several important features that are present in the legacy client:
    - **Shared mailboxes:** The inability to add shared mailboxes directly in the new Outlook client is a critical limitation for users who rely on these for collaborative work.
    - **Favourites for auto-mapped folders:** The inability to add auto-mapped mailbox folders to the Favourites section disrupts workflows and makes it harder to access frequently used folders quickly.
    - **Calendar management issues:** The limitations in managing calendar availability and operating multiple calendars effectively are significant drawbacks for users who depend on Outlook for scheduling.
  - **Reduced customisation and offline access:** Users will find the new client less customisable and less reliable for offline work, which may hinder productivity, particularly in environments with unstable internet connectivity.

## 6. Conclusion

The transition from the legacy Outlook client to the new Outlook client under Project Monarch reflects Microsoft's drive to modernise and unify the Outlook experience across devices. While the new client introduces a cleaner, more consistent interface and integrates seamlessly with other Microsoft 365 services, it also comes with some notable limitations, particularly in terms of shared mailbox management, folder organisation, and calendar functionality.

For users who rely heavily on shared mailboxes, custom folder arrangements, and complex calendar management, the legacy Outlook client remains the more capable tool. The new Outlook client, while promising, may not yet meet the needs of power users or those in enterprise environments where these features are critical.

As Microsoft continues to develop and refine the new Outlook client, it will be important to see if these limitations are addressed. For now, organisations and users will need to weigh the benefits of a modern, streamlined interface against the potential disruptions to established workflows and capabilities.

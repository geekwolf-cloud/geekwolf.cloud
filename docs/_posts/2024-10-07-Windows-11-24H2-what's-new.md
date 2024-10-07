---
layout: post
title:  "What is new in Windows 11 24H2"
description: A look at what is new, what has changed and what has been removed in Windows 11 24H2
date:   2024-10-07 14:21:09 +0100
category: microsoft-365
tags: microsoft-365 workstation
image: /android-chrome-192x192.png
comments_id: 41
---
<h1>{{ page.title }}</h1>

**Windows 11 24H2** is a major update bringing a mix of new features, improvements, and the removal of legacy elements. In this blog, we’ll explore both the changes that end users will notice and those that matter more for IT administrators. We’ll also highlight features that are being removed or deprecated in this release.

## End-user focused changes and additions

### Native support for rar and 7-zip file formats
One of the standout features in **Windows 11 24H2** is native support for **RAR**, **7-Zip**, and **tar** file formats. Previously, third-party tools like WinRAR or 7-Zip were required.

- **Impact**: Users can now handle compressed file formats without needing additional software, simplifying file management.

### Dynamic lighting for RGB peripherals
**Dynamic Lighting** is now built into Windows, providing a native way to control **RGB lighting** on peripherals like keyboards, mice, and more. Previously, users needed separate software from device manufacturers.

- **Impact**: This simplifies RGB control for users, especially gamers, and reduces the need for multiple vendor-specific apps.

### Notifications Hub consolidation
**Windows 11 24H2** revamps the **Notifications Hub**, streamlining notifications and making them less intrusive but easier to manage. Alerts, reminders, and messages are consolidated for a cleaner experience.

- **Impact**: Users will benefit from fewer interruptions and a more organised notification centre.

### Improved cloud backup and restore
The updated **Windows Backup** tool now allows users to back up apps, settings, and files directly to **OneDrive**, making it easier to restore them on new devices.

- **Impact**: Setting up a new device will be smoother, as users can restore their apps and settings with minimal effort.

### Energy recommendations
Windows 11 now provides **Energy Recommendations** in the **Settings** app. These recommendations help users optimise their devices for lower energy consumption, such as adjusting screen brightness or sleep settings.

- **Impact**: Users looking to extend battery life or reduce their carbon footprint will find this feature helpful.

### MS Paint updates
**MS Paint** gets a significant update, adding support for **layers** and **transparency**. While still not a full-blown photo editor, these new features increase its usability for light image editing.

- **Impact**: Casual users may find MS Paint more useful for simple graphic tasks, while advanced users may still prefer third-party tools.

## IT administrator focused changes

### More control over windows autopatch
**Windows Autopatch** gets new features, allowing administrators to have more control over how updates are scheduled and deployed. Granular patching options enable testing with smaller groups before a full rollout.

- **Impact**: This helps reduce potential issues during large-scale patch deployments and gives admins more flexibility.

### Enhanced security dashboard
The **Microsoft Defender** and **Security Center** dashboards have been unified, providing a single view of threat detection, antivirus status, and compliance. This integration offers better visibility into device security.

- **Impact**: Administrators can monitor and respond to security threats more efficiently with a more streamlined interface.

### Windows Hello for Business improvements
With **24H2**, Microsoft continues its push towards a **passwordless** future with enhancements to **Windows Hello for Business**. Administrators now have more tools to enforce biometric and **FIDO2** key authentication policies.

- **Impact**: Stronger passwordless authentication reduces the risk of credential theft and phishing attacks.

### Continued migration from control panel to settings
Microsoft continues its gradual removal of **Control Panel** elements, migrating more settings to the modern **Settings app**. System settings like networking and device management are now accessible only through the new interface.

- **Impact**: IT departments may need to update workflows and inform users about where to find certain settings in the new interface.

## Features removed or deprecated in Windows 11 24H2

### WordPad removal
**WordPad** is being fully removed from **Windows 11 24H2**. Microsoft is no longer developing this lightweight text editor, and it will no longer be included in future releases.

- **Impact for users**: Users who relied on WordPad for simple text editing will need to switch to alternatives like **Notepad**, **Microsoft Word**, or **LibreOffice**.

### Cortana app
The **Cortana app** has been fully removed from Windows 11. With the rise of **Windows Copilot** and other AI-driven tools, Cortana is no longer part of the OS.

- **Impact for users**: Users who previously used Cortana for tasks like reminders and voice commands will need to transition to **Windows Copilot** or other alternatives.

### Tablet mode
The traditional **Tablet Mode** introduced in Windows 10 has been fully phased out. Windows 11 focuses on auto-adjustments and gestures for touchscreen devices.

- **Impact for users**: Users with 2-in-1 devices will still benefit from touchscreen enhancements, but without the distinct Tablet Mode experience.

### Live tiles in the start menu
**Live Tiles**, a feature from earlier Windows versions, have been completely removed. Windows 11 focuses on pinned apps and widgets for real-time information.

- **Impact for users**: Users who liked Live Tiles’ dynamic updates will need to rely on **widgets** for similar functionality.

### Quick status on lock screen
The ability to show **Quick Status** (e.g., weather, calendar notifications) on the lock screen has been deprecated.

- **Impact for users**: Those who used this feature will need to rely on widgets or notifications within the unlocked interface.

### Internet Explorer fully disabled
**Internet Explorer** is now fully disabled, even for legacy compatibility purposes. Users needing to access legacy websites must use **IE Mode** in **Microsoft Edge**.

- **Impact for admins**: IT teams must ensure that legacy applications relying on Internet Explorer are compatible with **IE Mode** or plan to migrate away from older systems.

### Snipping Tool unification
The classic **Snipping Tool** and **Snip & Sketch** have been merged into a single tool. Some legacy features of the original Snipping Tool are no longer available.

- **Impact for users**: Long-time users of the Snipping Tool may notice some minor feature changes but still retain core screenshot capabilities with modern improvements.

## Conclusion

**Windows 11 24H2** brings a range of exciting new features while continuing to phase out legacy components. From **native support for compressed files** to **RGB lighting control** and **enhanced backup options**, users will notice improved usability. Meanwhile, administrators will benefit from better patch management tools, security enhancements, and the ongoing shift away from legacy apps like **WordPad** and **Internet Explorer**.

As always, it’s important to review these changes before updating, particularly for organisations, to ensure workflows remain uninterrupted and compatible with the latest version of Windows.

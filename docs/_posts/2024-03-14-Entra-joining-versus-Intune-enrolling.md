---
layout: post
title:  "Entra joining versus Intune enrolling"
description: In Microsoft Entra, the word enrolling is often used to mean Entra joining, but let's look at why that isn't quite right
date:   2024-03-14 11:03:01 +0100
category: entra-id
tags: entra-id workstation
comments_id: 13
---
<h1>{{ page.title }}</h1>

In the realm of device management and security, **Entra** and **Intune** are critical tools that serve different but complementary roles. Understanding their distinct functions and how they interact can help organisations better manage their IT infrastructure. Let’s dive into what each service does and how they interrelate.

## What is Entra joining?

**Entra Joining** refers to the process of a device being registered with Microsoft Entra (formerly known as Azure Active Directory or AAD). Entra Joining essentially integrates the device into the organisation’s identity infrastructure, allowing it to be managed and secured according to the organisation's policies. Key aspects include:

- **Identity integration:** Entra Joining involves associating the device with the organisation’s Azure AD tenant. This association allows for identity-based policies and authentication, making it easier to control access to organisational resources.
- **Single Sign-On (SSO):** Devices that are Entra Joined can take advantage of Single Sign-On capabilities, streamlining the user experience by reducing the need for multiple logins.
- **Conditional access:** Organisations can apply conditional access policies to Entra Joined devices, ensuring that only compliant devices can access sensitive data.

## What is Intune enrolling?

**Intune Enrollment** is the process of registering a device with Microsoft Intune for management and security purposes. Intune Enrollment focuses on applying policies, configurations, and updates to ensure the device meets organisational standards. Key points include:

- **Device management:** Intune Enrollment provides a framework for managing and securing devices by applying policies for compliance, configuration, and updates.
- **Application deployment:** Through Intune, organisations can deploy and manage applications, ensuring that devices have the necessary tools and software for users to be productive.
- **Security policies:** Intune enables the application of security policies, including encryption, password requirements, and restrictions on data sharing.

## How one can trigger the other

Although Entra Joining and Intune Enrollment serve different purposes, they can be complementary. Here's how:

- **Entra Joining as a prerequisite for Intune Enrollment:** Often, a device must be Entra Joined before it can be enrolled in Intune. This is because Entra Joining establishes the device within the organisation's identity system, allowing Intune to apply management policies and configurations based on the device’s identity.
- **Automatic enrollment:** In many scenarios, enrolling a device in Intune can be triggered automatically once the device is Entra Joined. This seamless integration ensures that devices that are Entra Joined are promptly brought under Intune management, streamlining the administrative process.

## Intune enrollment without Entra joining

It’s important to note that Intune Enrollment does not always require Entra Joining. Intune supports various device states, including:

- **Personal devices:** For devices that are not corporate-owned, such as personal devices used for work (BYOD - Bring Your Own Device), Intune can manage these devices without Entra Joining. Instead, Intune applies policies through device enrollment and application management frameworks.
- **Non-Windows devices:** Devices that are not running Windows, such as iOS or Android devices, can also be enrolled in Intune for management without needing to be Entra Joined. Intune’s management capabilities extend to various platforms, allowing for comprehensive control over diverse device types.

## Hybrid join and Intune enrollment

**Hybrid Join** is another important device state that supports Intune Enrollment. Hybrid Join refers to a configuration where devices are joined to both Azure Active Directory (AAD) and an on-premises Active Directory (AD). This setup combines the benefits of both environments:

- **GPO-based enrollment:** Devices that are Hybrid Joined can be configured to automatically enrol in Intune through Group Policy Objects (GPOs). This setup is particularly useful for organisations with existing on-premises Active Directory infrastructure that want to leverage cloud-based management through Intune.
- **Seamless integration:** Hybrid Join allows devices to benefit from both on-premises and cloud-based management capabilities. This integration supports comprehensive device management, applying Intune policies while retaining some traditional AD management practices.

## Conclusion

In summary, while **Entra Joining** and **Intune Enrollment** both play pivotal roles in device management, they address different aspects of this process. Entra Joining integrates the device into the organisation's identity infrastructure, enabling identity-based security and access control. Intune Enrollment focuses on ongoing management and security of the device, ensuring compliance with organisational policies and deployment of necessary configurations and applications. **Hybrid Join** further extends management capabilities by combining on-premises and cloud-based approaches, supporting automatic Intune Enrollment via GPO settings. Understanding these differences and how they interact can help organisations optimise their device management strategy, ensuring both security and efficiency.

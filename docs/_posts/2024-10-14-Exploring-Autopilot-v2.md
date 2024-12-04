---
layout: post
title:  "Exploring Autopilot v2, what has changed?"
description: Let's see what has changed in Autopilot v2, what are some great changes and what definitely still needs work
date:   2024-10-14 07:42:58 +0100
category: microsoft-365
tags: microsoft-365 workstation
image: /android-chrome-192x192.png
comments_id: 42
---
<h1>{{ page.title }}</h1>

Windows Autopilot has long been a game-changer for IT departments looking to streamline the deployment of Windows devices. With the release of **Autopilot v2**, Microsoft introduces a more flexible and responsive framework aimed at addressing many of the limitations of the original Autopilot (now referred to as **Autopilot v1**). But as with any major update, it comes with highlights as well as challenges. In this blog, we'll explore what makes Autopilot v2 different, its key strengths and weaknesses, how it compares to Autopilot v1, and look at the roadmap and known issues for this evolving tool.

---

### Key highlights of Autopilot v2

#### 1. No more hardware hash collection
Thus far Autopilot required the collection of the hardware hash of each machine before it can be onboarded.  With Autopilot v2 this changes to using the manufacturer, model and serial number, and they are uploaded as corporate identifiers

#### 2. Frequent updates via Intune
Autopilot v2 brings a significant architectural change by moving most device deployment logic to the **Intune Management Extension (IME)**. Unlike Autopilot v1, where updates were tied to Windows release cycles, v2 allows for frequent updates and bug fixes through Intune. This decoupling enables faster feature rollouts, meaning administrators can expect more frequent improvements and quicker resolutions to issues.

#### 3. Enhanced flexibility and customization
Autopilot v2 offers more customization options during the Out-Of-Box Experience (OOBE). IT admins now have control over pages that were previously hidden, such as the **EULA** and **privacy settings**. While this can result in a more involved setup, it provides more flexibility for organizations that need to control various deployment aspects.

#### 4. Streamlined deployment
Autopilot v2 introduces **Device Preparation Policies** and **Enrollment Time Grouping**, which make deployments faster and more efficient. By assigning devices to pre-defined groups instead of using dynamic queries, deployments now proceed more quickly, reducing the time it takes to fully onboard new devices.

#### 5. Support for sovereign clouds
A standout feature of Autopilot v2 is its ability to work in **sovereign cloud environments**. This makes the service more attractive to organizations that need stricter control over their cloud infrastructure, such as government or defense sectors.

---

### Key lowlights of Autopilot v2

#### 1. Reintroduced complexity
While Autopilot v1 focused on simplicity, v2 reintroduces some complexity by surfacing additional screens in the OOBE process. This includes showing the **EULA**, **device personalization**, and **privacy settings**, which were previously hidden. For organizations that favor a streamlined, zero-touch deployment process, this added complexity could be a drawback.

#### 2. Known bugs and limitations
Autopilot v2 is still a work in progress, with some features like **self-deploying mode** and **pre-provisioning** not fully implemented yet. Early adopters have reported various bugs, such as installation timeouts with key agents like the IME. Additionally, limitations such as the inability to install more than 10 applications during OOBE can hinder larger deployments.

#### 3. No hybrid Azure AD join support
One significant limitation of Autopilot v2 is the lack of support for **Hybrid Azure AD Join** (AADJ). Currently, only **Microsoft Entra Join** is supported, which could be problematic for organizations relying on a hybrid infrastructure model.

#### 4. Learning curve for administrators
With increased flexibility comes a steeper learning curve. IT administrators used to the simplicity of Autopilot v1 might find it more challenging to configure the many new features in v2. Additionally, troubleshooting may become more complex as Autopilot v2 involves multiple components, including Intune, IME, and Azure AD.

---

### Autopilot v2 vs. Autopilot v1: a comparison

| **Feature**              | **Autopilot v1**                   | **Autopilot v2**                                 |
|--------------------------|------------------------------------|--------------------------------------------------|
| **Update cadence**        | Tied to Windows release cycles     | Frequent updates via Intune (monthly or more)     |
| **OOBE customization**    | Simplified, minimal screens        | More screens reintroduced (e.g., EULA, privacy)   |
| **Deployment logic**      | Built into Windows OS              | Managed by Intune Management Extension (IME)      |
| **Self-deploying mode**   | Fully supported                    | Not yet fully implemented                        |
| **Pre-provisioning**      | Fully supported                    | Partial support                                  |
| **Troubleshooting**       | Simple, fewer components           | More components = harder to debug                |
| **Flexibility**           | Less flexible, more static         | Highly flexible, with frequent updates            |

---

### Roadmap and known issues for Autopilot v2

While Microsoft has not provided a detailed, public roadmap for Autopilot v2, there are ongoing efforts to expand its feature set and resolve current issues.

#### Upcoming features:
- **Self-deploying mode** and **pre-provisioning support** are expected to roll out in future updates.
- Microsoft is working on integrating **pre-provisioned applications** during OOBE, allowing for more complex deployments.
- Improved reporting and **admin-specified configurations** during the setup process are also in development.

#### Known issues:
- **Buggy deployments**: Users have reported problems with the IME failing to install properly during the enrollment process.
- **App installation limit**: Only 10 applications can be installed during OOBE, which is sufficient for most deployments but may hinder larger organizations.
- **Hybrid Azure AD join not supported**: Many companies relying on a hybrid infrastructure will find that v2 lacks this crucial feature, as it only supports **Microsoft Entra Join** at the moment.

For now, both **Autopilot v1** and **v2** will coexist on mutually exclusive sets of devices, allowing organizations to choose based on their current needs while Microsoft works to close the feature gap between the two versions.  For a single device, if Autopilot has the hardware hash then that means it will use Autopilot v1.  Right now to use Autopilot v2 you have to first delete the hardware hash.

---

### Final thoughts

Autopilot v2 represents a significant step forward for organizations seeking more flexibility and frequent updates in their device deployment strategy. However, this increased flexibility comes at the cost of added complexity and some key features still being in development. 

If you’re in need of more frequent updates and are comfortable with some initial growing pains, Autopilot v2 is a forward-looking choice. But if stability and simplicity are top priorities for your organization, Autopilot v1 might still be your best option, at least until Microsoft resolves the known issues and completes feature parity between the two versions.

For detailed updates and to stay current with known issues, follow Microsoft's [Device Preparation FAQs](https://learn.microsoft.com/en-us/autopilot/device-preparation/faq) and announcements on Intune blogs.

---

By balancing these strengths and challenges, organizations can better assess which version of Autopilot best fits their needs and prepare accordingly for the evolving landscape of device management in the Windows ecosystem.

---
layout: post
title:  "MFA for all users and the user experience impact"
description: An overview into Multi Factor Authentication, in particular the impact on the user experience.  Why would you not enable MFA for all users?
date:   2024-02-22 11:10:01 +0100
category: entra-id
tags: entra-id technical-overview identity best-practice modernisation
comments_id: 11
---
<h1>{{ page.title }}</h1>

When recommending that Multi-Factor Authentication (MFA) be configured for all users in Entra ID (formerly Azure Active Directory), one of the most common concerns you'll encounter is, "How often will users be prompted to complete MFA?" This question often stems from a fear that MFA will disrupt daily workflows by requiring frequent authentication, leading to frustration and decreased productivity. However, understanding how modern technologies like Windows Hello for Business, Primary Refresh Token (PRT), and Microsoft 365 applications work can help alleviate these concerns.

## What is MFA and why is it essential?

Before diving into the frequency of prompts, it’s crucial to remember why MFA is necessary. MFA adds an extra layer of security beyond just the username and password, protecting against phishing, credential theft, and other types of unauthorised access. By requiring a second form of verification, such as a phone notification or biometric scan, MFA significantly reduces the likelihood of a security breach.

## How often will users be prompted?

One of the key concerns around MFA is the perceived inconvenience due to frequent prompts. However, with the right configuration and modern authentication technologies, the actual number of times a user is prompted for MFA can be minimised significantly. Here’s how:

### Primary Refresh Token (PRT)

- When a user signs in on a Windows 10 or later device, a PRT is issued after a successful MFA. This token is then used to authenticate the user silently and seamlessly across different applications and services, reducing the need for repeated MFA prompts.
- The PRT is continuously refreshed as long as the user’s session remains active, which means that the user might not be prompted for MFA again on the same device unless there’s a change in their security posture or an extended period of inactivity.

### Windows Hello for Business

- Windows Hello for Business replaces passwords with strong two-factor authentication on devices. It uses biometrics (such as facial recognition or fingerprint) or a PIN, which is tied to the user’s device and is protected by a Trusted Platform Module (TPM).
- When Windows Hello for Business is configured, users can authenticate to their device and automatically gain access to cloud and on-premises resources without being prompted for MFA repeatedly. The MFA happens seamlessly during the device login process, making it a one-time experience at the start of the session.

### Microsoft 365 applications

- Many Microsoft 365 applications are designed to work with the authentication token provided by the PRT, meaning that after an initial MFA challenge, the user can access their email, OneDrive, Teams, and other services without repeated prompts.
- Additionally, Microsoft 365 apps are optimised to understand session tokens and refresh tokens, further reducing unnecessary MFA requests. This integration ensures that users are not continually interrupted throughout their workday.

## The role of conditional access

Conditional Access policies in Entra ID allow administrators to fine-tune when MFA is required based on the user’s location, device compliance, and the risk level of the sign-in attempt. For example, a user might be prompted for MFA only when they log in from a new device or an untrusted network. These policies can be tailored to balance security and user convenience, further minimising the need for frequent MFA prompts.

## Addressing user concerns

When communicating the benefits of MFA and addressing concerns about prompt frequency, it’s important to emphasise:

- **Seamless user experience:** With the help of PRT, Windows Hello for Business, and session tokens in Microsoft 365 applications, the actual number of MFA prompts a user encounters will be minimal.
- **Security without disruption:** These technologies allow for a robust security posture without disrupting the user’s workflow, as most MFA challenges happen silently in the background.
- **Customisable policies:** Conditional Access allows for flexible, user-friendly MFA policies that only prompt when necessary, reducing the chances of unnecessary interruptions.

By educating users on these technologies and how they work together to create a seamless and secure authentication experience, you can alleviate concerns and ensure widespread acceptance of MFA in your organisation. In today’s threat landscape, the security benefits of MFA far outweigh the occasional prompt, and with modern solutions in place, these prompts can be kept to a minimum.

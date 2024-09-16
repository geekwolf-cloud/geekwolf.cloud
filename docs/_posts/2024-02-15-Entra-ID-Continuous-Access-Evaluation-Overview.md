---
layout: post
title:  "Entra ID Continuous Access Evaluation overview"
description: An overview of Continuous Access Evaluation,  How does it work and impact the end users?  How can you configure CAE via the Azure portal
date:   2024-02-15 12:59:39 +0100
category: entra-id
tags: entra-id technical-overview identity modernisation
image: \android-chrome-192x192.png
comments_id: 9
---
<h1>{{ page.title }}</h1>

With the rise of remote work and the increasing complexity of cyber threats, maintaining robust security without disrupting user productivity is a significant challenge for IT administrators. Microsoft’s Entra ID Continuous Access Evaluation (CAE) is a powerful solution designed to meet this challenge, providing a dynamic security posture that adapts to changing conditions in real-time. In this blog, we'll explore how CAE works, how to configure it, and what the user experience looks like.

## What is continuous access evaluation (CAE)?

Continuous Access Evaluation (CAE) is a feature of Microsoft Entra ID (formerly known as Azure AD) that enhances the traditional access control model by evaluating access policies continuously and dynamically. Instead of relying solely on session lifetimes, CAE reacts to changes in user conditions, such as location, device health, or sign-in risk, in near real-time. This ensures that access to resources is only granted when certain criteria are met, enhancing security while minimizing unnecessary interruptions.

## How does CAE work?

At its core, CAE operates by continuously monitoring and evaluating conditions that might impact the security of a user’s session. Here’s a breakdown of how CAE functions:

1. **Continuous monitoring:** CAE continuously monitors signals such as user location, IP address, device compliance status, and sign-in risk. If any of these factors change during a session, CAE triggers an evaluation.

2. **Real-time enforcement:** Upon detecting a significant change, CAE re-evaluates the user's access to resources based on predefined policies. This evaluation happens almost instantly, ensuring that the user’s access reflects their current risk level.

3. **Session termination:** If the re-evaluation identifies a risk that exceeds the allowed threshold (e.g., a change in the user’s location to an unauthorised region), CAE can immediately terminate the session, prompting the user to re-authenticate or denying access entirely.

4. **Policy compliance:** CAE works in tandem with Conditional Access policies in Microsoft Entra ID. It enforces these policies in real-time, applying controls like multi-factor authentication (MFA), device compliance checks, or network location restrictions based on the current session state.

## Configuring continuous access evaluation

Configuring CAE within Microsoft Entra ID involves a few steps to ensure it aligns with your organisation’s security requirements.

### 1. Ensure licensing and prerequisites

To use CAE, your organisation needs the appropriate Microsoft Entra ID licensing, typically included in Azure AD Premium P1 or P2. Ensure your environment meets these prerequisites before proceeding.

### 2. Enable CAE in the Azure portal

CAE is typically enabled by default for supported applications like Microsoft 365. However, you can manage its settings through the Azure portal:
   - Navigate to the Azure portal and go to **Azure Active Directory**.
   - Select **Security** > **Conditional Access**.
   - Choose the policy where you want to enforce CAE.
   - Under the **Session** section, **Customize continuous access evaluation**.

### 3. Configure Conditional Access policies

CAE works in conjunction with Conditional Access policies. You can create or modify policies that trigger CAE when certain conditions are met:
   - Specify conditions such as user location, device compliance, or sign-in risk.
   - Set controls like requiring MFA or blocking access under specific conditions.
   - Ensure the **Sign-in frequency** and **Session lifetime** settings are optimised for your environment.

### 4. Testing and monitoring

Once configured, it’s crucial to test CAE with different user scenarios to ensure it behaves as expected. Use the Azure portal to monitor active sessions and review sign-in logs to verify CAE's effectiveness.

## User experience with CAE

From the end-user perspective, the goal of CAE is to maintain a seamless experience while enhancing security. Here’s how users might experience CAE in their day-to-day activities:

### 1. Minimal disruption

For most users, CAE operates in the background, ensuring continuous access without frequent interruptions. Users won’t notice CAE unless a security event triggers a policy action, such as requiring re-authentication.

### 2. Real-time security

If CAE detects a change in risk during a session (e.g., the user switches to an unsecured network), the user might be prompted to verify their identity again, often through MFA. This ensures that security risks are mitigated without the need to log out and back in.

### 3. Session termination

In cases where a significant threat is detected, CAE may terminate the user’s session immediately. The user will then be required to sign in again, providing an opportunity to apply stronger authentication measures or block access if necessary.

### 4. Transparent access control

The integration of CAE with Conditional Access policies ensures that users understand the security measures being applied. For example, if a session is terminated due to a location change, users may see a prompt explaining why they need to re-authenticate.

## Conclusion

Continuous Access Evaluation (CAE) is a critical component of Microsoft’s Entra ID that brings dynamic, real-time access control to your organisation’s security posture. By continuously monitoring user sessions and enforcing access policies based on current conditions, CAE minimizes risk without sacrificing user experience.

For IT administrators, configuring CAE is a straightforward process that, when combined with well-crafted Conditional Access policies, can significantly enhance your organisation’s security while keeping users productive and safe. As cyber threats continue to evolve, CAE represents a proactive step in safeguarding your digital environment.

If you haven’t already, now is the time to explore and implement CAE in your organisation to stay ahead of potential threats while maintaining a seamless user experience.

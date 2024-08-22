---
layout: post
title:  "WARNING: Enforced MFA in admin portals"
date:   2024-08-19 08:10:05 +0100
category: azure
tags: entra-id microsoft-365 azure identity
comments_id: 4
---
<h1>{{ page.title }}</h1>

Microsoft are going to start enforcing MFA in the Azure portal, Entra admin center, and Intune admin center from October 2024.   This is generally a good thing, however it has implications...   This is an enforced MFA with no exceptions.  So this will include service accounts and break glass accounts too.   The recommendation for service accounts is to move to workload identities, such as app registrations.  For break glass accounts the only options are to register an MFA method.  Given you want to be able to log in even when Microsoft MFA is down, that leaves the options certificate, Windows Hello for Business, and FIDO2 keys as your only options.

For regular users (without admin access to the portals), there may still be impacts...  e.g. Windows 365 Cloud PC is accessed via the Intune portal, ergo MFA will be enforced.  Anything where access is via the 3 portals will require MFA.

You can ask for a postponement until March 2025 via the Azure Portal, which will probably coincide with the widening of the scope for mandatory MFA to include Azure CLI, Azure PowerShell, Azure mobile app and the Infrastructure as Code (IaC) tools

There is a lot of momentum behind this change, and it is definitely coming.  

More information can be found here:
* [https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/update-on-mfa-requirements-for-azure-sign-in/ba-p/4177584](https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/update-on-mfa-requirements-for-azure-sign-in/ba-p/4177584)
* [https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mandatory-multifactor-authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mandatory-multifactor-authentication)
* [https://azure.microsoft.com/en-us/blog/announcing-mandatory-multi-factor-authentication-for-azure-sign-in/](https://azure.microsoft.com/en-us/blog/announcing-mandatory-multi-factor-authentication-for-azure-sign-in/)
* [https://techcommunity.microsoft.com/t5/intune-customer-success/support-tip-enforcement-of-multifactor-authentication-for-intune/ba-p/4220014](https://techcommunity.microsoft.com/t5/intune-customer-success/support-tip-enforcement-of-multifactor-authentication-for-intune/ba-p/4220014)
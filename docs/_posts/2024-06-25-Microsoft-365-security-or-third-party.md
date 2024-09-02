---
layout: post
title:  "Microsoft 365 security or third party"
description: Microsoft 365 has various security components, when do you need to consider adding 3rd party products to augment those features?
date:   2024-06-25 08:10:00 +0100
category: entra-id
tags: entra-id technical-overview microsoft-365
comments_id: 31
---
<h1>{{ page.title }}</h1>

As the digital landscape evolves, organisations face increasingly sophisticated threats that target various aspects of their infrastructure. Microsoft 365 (M365) offers a comprehensive suite of security products designed to protect identities, data, devices, and networks in both cloud and hybrid environments. While M365's security tools provide robust protection, organisations may still need to integrate third-party solutions to address specific needs or enhance certain capabilities.

In this blog, we will delve into Microsoft's full spectrum of M365 security offerings, including some of its lesser-known tools, and explore how they integrate to create a cohesive security platform. We will also discuss scenarios where third-party solutions might be necessary to fill gaps or enhance protection, particularly in hybrid environments where on-premises security remains critical.

---

## The full spectrum of M365 security solutions

Microsoft's M365 security suite is a comprehensive platform that covers a wide array of security needs. Let's break down the key components and explore how they work together.

### 1. Azure Active Directory (Azure AD)
   - **Role:** Azure AD is central to identity and access management within M365. It supports user authentication, single sign-on (SSO), multi-factor authentication (MFA), conditional access, and more.
   - **Hybrid protection:** For on-premises environments, Azure AD can integrate with Active Directory, providing a seamless hybrid identity experience. However, it might lack advanced on-premises privileged access management (PAM) and granular identity governance.
   - **Third-party consideration:** **BeyondTrust** or **CyberArk** can complement Azure AD by offering advanced PAM capabilities, particularly for securing on-premises Active Directory environments.

### 2. Microsoft Defender for Office 365
   - **Role:** Provides comprehensive protection against email-based threats, such as phishing, malware, and business email compromise, through advanced threat protection (ATP) features.
   - **Hybrid consideration:** In hybrid environments, where email might be routed through on-premises servers or other cloud services, integration with on-premises email protection tools might be necessary.
   - **Third-party consideration:** **Proofpoint** or **Mimecast** can offer advanced threat intelligence and granular email filtering, which are critical in environments with complex email routing or higher compliance demands.

### 3. Microsoft Defender for Endpoint
   - **Role:** A comprehensive endpoint protection platform (EPP) and endpoint detection and response (EDR) solution that protects against advanced threats on devices running Windows, macOS, Linux, Android, and iOS.
   - **On-premises protection:** Defender for Endpoint also extends to on-premises servers and workstations, providing real-time threat detection and automated responses.
   - **Third-party consideration:** Solutions like **CrowdStrike** or **SentinelOne** may be considered for organisations requiring specialised attack prevention, superior threat hunting capabilities, or more extensive cross-platform support.

### 4. Microsoft Defender for Identity
   - **Role:** Focuses on protecting on-premises Active Directory and hybrid environments by detecting suspicious activities such as lateral movement and privilege escalation.
   - **Hybrid protection:** Defender for Identity is crucial in hybrid scenarios where on-premises Active Directory plays a significant role, offering integration with Azure AD for comprehensive identity protection.
   - **Third-party consideration:** **Varonis** or **Exabeam** can provide enhanced user and entity behaviour analytics (UEBA) for detecting insider threats and sophisticated attacks that might evade standard defences.

### 5. Microsoft Sentinel
   - **Role:** A cloud-native security information and event management (SIEM) and security orchestration, automation, and response (SOAR) solution. Sentinel aggregates data from across the organisation to provide comprehensive threat detection, investigation, and response capabilities.
   - **Hybrid consideration:** Sentinel supports integration with on-premises infrastructure, making it a powerful tool for organisations operating in hybrid environments.
   - **Third-party consideration:** **Splunk** or **IBM QRadar** might be considered for organisations with existing SIEM investments or those needing specific integrations and advanced analytics that align with their broader IT strategy.

### 6. Microsoft Defender for Cloud (formerly Azure Security Center)
   - **Role:** Provides unified security management and threat protection across hybrid cloud workloads, offering visibility, compliance, and advanced threat protection for Azure and multi-cloud environments.
   - **Hybrid consideration:** Defender for Cloud extends its capabilities to on-premises servers and virtual machines, making it a critical tool for organisations with hybrid deployments.
   - **Third-party consideration:** **Palo Alto Networks Prisma Cloud** or **Check Point CloudGuard** can be considered for organisations requiring enhanced multi-cloud support or more detailed security analytics.

### 7. Microsoft Cloud App Security (MCAS)
   - **Role:** MCAS is a cloud access security broker (CASB) that provides visibility, control, and protection for cloud applications. It monitors cloud app usage, enforces policies, and protects sensitive data.
   - **Hybrid consideration:** MCAS integrates with both Microsoft and non-Microsoft cloud services, making it a versatile tool in hybrid cloud environments.
   - **Third-party consideration:** **Zscaler** or **Netskope** may be preferred in environments heavily reliant on non-Microsoft cloud services, or where more granular control over data in transit is required.

### 8. Microsoft Intune (MDM/MAM)
   - **Role:** Intune provides mobile device management (MDM) and mobile application management (MAM), allowing organisations to secure and manage devices, apps, and data, whether corporate-owned or bring-your-own-device (BYOD).
   - **Hybrid consideration:** In hybrid environments, Intune integrates with on-premises Active Directory and System Center Configuration Manager (SCCM) for unified endpoint management.
   - **Third-party consideration:** **VMware Workspace ONE** or **MobileIron** might be considered for organisations needing advanced cross-platform management or specific mobile security features not covered by Intune.

### 9. Global Secure Access
   - **Role:** Part of the Microsoft Entra suite, Global Secure Access provides Zero Trust network access by securing user and device connections to internal resources without requiring traditional VPNs.
   - **Hybrid consideration:** This tool is particularly valuable in hybrid environments where secure access to both cloud and on-premises resources is necessary.
   - **Third-party consideration:** **Zscaler Zero Trust Exchange** or **Palo Alto Networks Prisma Access** might be chosen for organisations that require a broader set of secure access controls or have complex multi-cloud and on-premises connectivity needs.

---

## On-premises security: Extending protection beyond the cloud

While M365's security solutions are cloud-centric, many organisations still operate hybrid environments with significant on-premises infrastructure. Here’s how M365 integrates with on-premises systems and where third-party tools might come into play:

- **Active Directory (AD) and Azure AD integration:** Azure AD seamlessly integrates with on-premises Active Directory, enabling a unified identity management experience across both cloud and on-premises resources. However, for enhanced on-premises AD protection, **CyberArk** or **BeyondTrust** can be employed to manage privileged accounts and secure sensitive credentials.

- **Server and workstation security:** Defender for Endpoint extends protection to on-premises servers and workstations, offering real-time threat detection and response. For more advanced or specialised needs, tools like **CrowdStrike** or **Carbon Black** can provide additional layers of security.

- **Network security:** While Microsoft’s solutions like Global Secure Access offer robust network security in hybrid environments, organisations may still require traditional network security appliances or next-gen firewalls. **Palo Alto Networks** or **Fortinet** might be preferred in environments needing more granular network segmentation or deep packet inspection.

---

## The platform advantage vs. best-of-breed approach

When building a security strategy, organisations often face the decision between adopting a unified platform (like Microsoft 365) or integrating best-of-breed solutions from multiple vendors. Each approach has its pros and cons.

### Platform advantage
   - **Seamless integration:** M365 offers tight integration between its security products, ensuring a unified security posture with simplified management and reporting.
   - **Lower complexity:** A single-vendor approach reduces the complexity of managing multiple tools and reduces the risk of compatibility issues.
   - **Cost efficiency:** Leveraging an integrated platform can be more cost-effective, particularly if your organisation is already invested in the Microsoft ecosystem.

### Best-of-breed advantage
   - **Specialised features:** Third-party solutions often offer more advanced or specialised features tailored to specific security needs.
   - **Flexibility:** Organisations can choose the best tools for each specific use case, ensuring optimal security coverage across different environments.
   - **Innovation:** Best-of-breed vendors often innovate rapidly, providing cutting-edge protection against emerging threats.

## When to consider third-party solutions

While Microsoft 365's security platform is robust, there are scenarios where third-party solutions may be necessary or beneficial:

- **Advanced threat protection:** For organisations facing sophisticated threats, advanced EDR solutions like **CrowdStrike** or **SentinelOne** might offer superior threat detection and response capabilities.

- **Privileged access management:** For more granular control over privileged accounts, especially in hybrid or on-premises environments, solutions like **BeyondTrust** or **CyberArk** are essential.

- **Email security:** While Defender for Office 365 is strong, third-party solutions like **Proofpoint** might offer more detailed filtering and protection, especially in highly regulated industries.

- **Cloud security:** Organisations with multi-cloud environments may find tools like **Palo Alto Networks Prisma Cloud** provide better multi-cloud visibility and protection.

- **Network security:** Traditional network security tools, such as **Fortinet** or **Palo Alto Networks**, might be necessary for deep packet inspection, network segmentation, or protection of legacy systems.


---
layout: post
title:  "Infrastructure versus user authentication"
description: Let's break authentication into user authentication and infrastructure authentication and use this to significantly decrease your attack surface
date:   2024-03-28 11:45:51 +0100
category: on-premises
tags: on-premises entra-id migration identity
image: \android-chrome-192x192.png
comments_id: 16
---
<h1>{{ page.title }}</h1>


In today's rapidly evolving digital landscape, securing both infrastructure and user authentication is critical to reducing the attack surface of an organisation's IT environment. Traditionally, on-premises authentication has played a central role in managing access to applications, services, and servers. However, as threats have grown more sophisticated, it has become clear that shifting certain aspects of authentication to the cloud, particularly to solutions like Entra ID (formerly Azure Active Directory), can significantly bolster security. This blog will explore how considering infrastructure and user authentication separately, and driving user authentication towards Entra ID, can help organisations minimise vulnerabilities and leverage richer policies, controls, and auditing capabilities.

## Understanding infrastructure vs. user authentication

Before diving into the benefits of shifting user authentication to Entra ID, it’s important to differentiate between infrastructure and user authentication:

- **Infrastructure authentication**: This involves authentication processes that enable applications, services, and servers to communicate securely. It ensures that only authorised services or machines can access specific resources within the network. Common methods include Kerberos, NTLM, certificates, and service accounts.

- **User authentication**: This pertains to authenticating individual users to grant access to systems, applications, and data. It traditionally relies on credentials like usernames and passwords, but modern methods increasingly utilise multi-factor authentication (MFA), biometrics, and other advanced mechanisms.

Historically, both infrastructure and user authentication have been tightly coupled with on-premises identity systems, such as Active Directory (AD). However, this approach can introduce several challenges, particularly as organisations expand their use of cloud services.

## The security challenges of on-premises authentication

While on-premises authentication systems like AD have been the backbone of enterprise identity management, they present some inherent risks:

1. **Limited policy enforcement**: On-premises solutions often lack the sophisticated policy enforcement mechanisms found in cloud-based systems. For example, enforcing MFA or context-based access controls can be more challenging in a purely on-premises environment.

2. **Complex infrastructure**: Managing a complex on-premises infrastructure with multiple applications and services interacting can create gaps in security. Misconfigurations, outdated protocols, and unmanaged service accounts can all increase the attack surface.

3. **Limited auditing and monitoring**: Traditional on-premises systems may not offer the comprehensive logging and monitoring capabilities needed to detect and respond to sophisticated attacks. This limits an organisation’s ability to detect anomalies and respond in real-time.

## The case for shifting user authentication to Entra ID

Entra ID offers a modern, cloud-based identity platform that addresses many of the limitations of traditional on-premises authentication systems. By driving user authentication to Entra ID, organisations can leverage a host of advanced security features, including:

1. **Rich policies with Conditional Access**: Entra ID’s Conditional Access policies allow organisations to define granular access controls based on user, location, device, and risk. For instance, access can be granted or denied based on a user’s location, device compliance status, or real-time risk assessment.

2. **Continuous Access Evaluation (CAE)**: CAE enhances security by allowing policies to be enforced continuously throughout a session, not just at the point of login. This means that if a user’s context changes during a session (e.g., if their device becomes non-compliant or they move to a risky location), access can be revoked in real-time.

3. **Comprehensive auditing and monitoring**: Entra ID provides robust logging and monitoring capabilities that surpass what’s typically available in on-premises systems. This includes real-time alerts, detailed audit logs, and integration with SIEM solutions, enabling organisations to detect and respond to threats faster.

4. **Improved user experience**: By centralising authentication in Entra ID, users benefit from Single Sign-On (SSO) across cloud and on-premises applications, reducing password fatigue and the associated risks of credential reuse.

## Implementing the shift: Modernising applications and infrastructure

Shifting user authentication to Entra ID may require rethinking how applications and services are authenticated. Here are a few strategies organisations can consider:

1. **Azure Active Directory Application Proxy**: For on-premises applications that still require access, Azure AD Application Proxy allows you to publish these apps to the cloud securely. Users authenticate through Entra ID, leveraging its advanced security features, while the application remains hosted on-premises.

2. **Modernising authentication models**: Many legacy applications rely on outdated authentication methods like NTLM or Kerberos. Modernising these applications to support OAuth2 or OpenID Connect, which are natively supported by Entra ID, can significantly enhance security.

3. **Hybrid identity solutions**: Organisations that cannot fully migrate to the cloud can adopt a hybrid identity model, where Entra ID is integrated with on-premises AD. This allows for centralised policy management while maintaining compatibility with existing infrastructure.

4. **Service principal management**: For infrastructure authentication, managing service principals in Entra ID can provide better control and auditing over service-to-service communications, reducing the risk associated with unmanaged service accounts.

## Conclusion

As organisations continue to navigate the complexities of modern IT environments, rethinking on-premises authentication is crucial to reducing the attack surface. By distinguishing between infrastructure and user authentication and strategically driving user authentication to Entra ID, organisations can leverage powerful cloud-based security features, including Conditional Access, Continuous Access Evaluation, and advanced auditing capabilities.

Modernising authentication not only strengthens security but also enhances the user experience, paving the way for a more resilient and responsive IT infrastructure. The shift to Entra ID may require changes to application architectures and infrastructure, but the long-term benefits in terms of security, compliance, and operational efficiency make it a worthwhile investment.

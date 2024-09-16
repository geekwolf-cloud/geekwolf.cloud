---
layout: post
title:  "Domain Controller placement: A modern perspective"
description: How do you choose how many Domain Controllers to build and where to place them.  Modern AD environments have fewer than you think.
date:   2024-03-21 19:02:43 +0100
category: on-premises
tags: on-premises
image: \android-chrome-192x192.png
comments_id: 14
---
<h1>{{ page.title }}</h1>


The placement of domain controllers remains a pivotal consideration for maintaining an efficient and resilient IT infrastructure. While the advent of Entra Join and advancements in Windows 10/11 have shifted some dynamics, effective domain controller placement still hinges on balancing network latency, redundancy, and high availability. This blog will explore a modern approach to domain controller placement, taking into account practical considerations such as Kerberos authentication, the scalability of domain controller deployments, and best practices for site link configurations.

## Understanding Kerberos authentication and modern Windows improvements

Kerberos authentication, a cornerstone of Active Directory, issues tickets that are valid for 10 hours, with renewals occurring less frequently. This caching mechanism helps mitigate the impact of occasional latency issues between clients and domain controllers. Windows 10 and 11 improvements focus on reducing the dependency on frequent domain controller communications by optimising caching and local resource access, further decreasing the immediate need for numerous domain controllers.

## Practical considerations for domain controller placement

1. **Network latency and user experience**

   Although Kerberos tickets reduce the frequency of authentication requests, network latency still affects overall user experience and performance:
   - **Regional placement**: Place domain controllers in regions where users are geographically concentrated to minimise latency for initial authentication and subsequent interactions with Active Directory.
   - **Network optimisation**: Ensure that network links between domain controllers and users are optimised to avoid unnecessary latency and improve the performance of other domain-related services.

2. **Redundancy and high availability**

   High availability is crucial to ensure uninterrupted access to Active Directory services:
   - **Efficient deployment**: Large organisations often manage with fewer domain controllers by leveraging replication and Kerberos ticket caching. Ensure that domain controllers are deployed in a way that provides coverage for all major user locations while maintaining redundancy.
   - **Disaster recovery**: Implement disaster recovery plans that include offsite domain controllers or cloud-based solutions like Azure AD Domain Services to ensure continuity in case of a major failure.

3. **Active Directory Sites and Services configuration**

   Proper configuration of Active Directory Sites and Services remains essential:
   - **Site links configuration**: Configure site links to reflect the physical and logical network topology accurately. Use appropriate costs to prioritise replication paths and set the "Change Notify" option to facilitate prompt replication of changes.
   - **Replication strategy**: Regularly review and adjust replication schedules to ensure efficient data synchronisation across domain controllers. This helps in maintaining up-to-date information and reducing replication latency.

4. **Scalability and management**

   Modern Active Directory setups are designed to scale efficiently:
   - **Centralised management**: Use a centralised management approach to oversee domain controllers, which allows you to maintain fewer but more strategically placed domain controllers. Tools like Active Directory Administrative Centre and PowerShell can streamline management tasks.
   - **Monitoring and optimisation**: Continuously monitor domain controller performance and adjust configurations as necessary. This includes tuning replication intervals, evaluating site link settings, and reviewing authentication performance metrics.

## Conclusion

In large organisations, the placement of domain controllers should balance practical scalability with the need for efficient user access and redundancy. Kerberos ticket caching and modern improvements in Windows reduce the need for a high number of domain controllers, allowing for effective management with fewer servers. By strategically placing domain controllers, optimising site link configurations, and leveraging centralised management tools, you can ensure a robust and responsive Active Directory environment that meets organisational needs.  I have built out Active Directory for multiple multinational clients with tens of thousands of users and less than a dozen domain controllers worldwide

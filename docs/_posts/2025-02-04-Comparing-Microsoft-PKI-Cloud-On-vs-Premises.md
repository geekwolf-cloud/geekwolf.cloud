---
layout: post
title:  "Comparing Microsoft PKI: Cloud versus On Premises"
description: Microsoft Cloud PKI is gaining momentum, but how do you choose whether to use Cloud PKI or continue with on premises servers?
date:   2025-02-04 07:01:56 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 56
---
<h1>{{ page.title }}</h1>


Public key infrastructure (PKI) secures everything from server certificates and device authentication to encrypted communications. When designing—or modernising—a PKI, you face a key decision: **Microsoft cloud PKI** or **on-premises PKI**. While Microsoft cloud PKI offers certain advantages—particularly for **Intune-managed devices**—it also has limitations that may not suit all organisations. Below, we’ll compare these approaches across four organisation sizes with respect to **cost**, **complexity**, and **suitability**, while considering the additional roles that typically accompany a PKI (e.g. **NDES**, **SCEP**, **Intune Certificate Connector**).

---

## PKI roles beyond the CA

A fully functional PKI often includes more components than just a certificate authority (CA):

- **Network device enrolment service (NDES)** and **simple certificate enrolment protocol (SCEP)**  
  Allow devices that are not domain-joined (like iOS or Android phones, network devices, or printers) to request certificates automatically.

- **Intune Certificate Connector**  
  Bridges your on-premises PKI with Microsoft Intune, enabling Intune-managed devices to obtain certificates from your internal CA.

In a **Microsoft cloud PKI** model, these roles are largely abstracted for **Intune-only** devices. In an **on-premises** deployment, you typically manage NDES, SCEP, and connectors yourself—leading to more flexibility but also more administrative burden.

---

## 1. Small businesses (<100 users)

### Microsoft cloud PKI

- **Cost**  
  - **Low upfront**: Subscription fees instead of buying servers for the CA, NDES, or SCEP.  
  - **Ongoing**: Fees scale with certificate usage, which remains modest for fewer than 100 users.

- **Complexity**  
  - **Minimal**: Offloads PKI roles (CA, NDES, etc.) to Microsoft, leaving you to manage only device enrolment in Intune.  
  - **Limitations**: Certificates can only be issued to **Intune-managed** devices.

- **Suitability**  
  - **Ideal if**: All endpoints are in Intune, and you don’t need certificates for local servers or network equipment.  
  - **Potential blocker**: If you need certificates for an internal website or a printer, Microsoft cloud PKI cannot cover those.

### On-premises PKI

- **Cost**  
  - **Hardware/VMs**: At least one server (often virtual) can host CA + NDES + SCEP + the Intune Connector.  
  - **Operational**: Ongoing patching, Windows Server licences, and staff time.

- **Complexity**  
  - **Manageable**: For fewer than 100 users, a single server can handle all PKI roles.  
  - **Upgrades**: If using older Windows Server versions (e.g. Server 2008/2012), you’ll need a clear migration plan.

- **Suitability**  
  - **Ideal if**: You want the freedom to issue certificates to printers, access points, internal websites, or anything else.  
  - **Potential downside**: You must maintain and update the server, which can be tough if IT resources are limited.

---

## 2. Medium-sized organisations (<1,000 users)

### Microsoft cloud PKI

- **Cost**  
  - **Subscription**: Suitable for moderate volumes of Intune-managed devices.  
  - **Predictable**: No separate hardware or OS to purchase or upgrade.

- **Complexity**  
  - **Low**: Microsoft manages the CA, NDES, and SCEP components in the cloud.  
  - **Intune-only**: Any device not enrolled in Intune remains uncovered.

- **Suitability**  
  - **Great for**: Organisations adopting a primarily mobile-first, Intune-managed strategy.  
  - **Caveat**: If you still manage on-prem servers, third-party devices, or networks needing certificates, you’ll need a parallel on-prem PKI.

### On-premises PKI

- **Cost**  
  - **Moderate**: At least two servers are common—one for the CA, another for NDES/SCEP.  
  - **Staffing**: Requires basic PKI expertise, though still feasible for a medium-sized IT team.

- **Complexity**  
  - **Scalable**: You can add more CAs or distribute roles as the organisation grows.  
  - **Upgrade path**: Migrating from older systems (Server 2008/2012) may involve side-by-side deployments to minimise downtime.

- **Suitability**  
  - **Best for**: Organisations needing certificates for diverse platforms and devices, not just Intune.  
  - **Risk**: Higher management load—patching, monitoring, maintaining CRL distribution.

---

## 3. Large organisations (<10,000 users)

### Microsoft cloud PKI

- **Cost**  
  - **Subscription scales**: Potentially high if you’re issuing many certificates, but offset by no hardware costs.  
  - **No data centre footprint**: Everything is in Azure.

- **Complexity**  
  - **Simplified**: Intune devices automatically enrol through Microsoft’s infrastructure.  
  - **Limitations**: You likely have a mix of cloud and on-prem systems—only Intune devices are served by cloud PKI.

- **Suitability**  
  - **Good choice if**: You’re heavily invested in Microsoft 365 and manage most endpoints via Intune.  
  - **Not enough if**: You must issue certificates for internal servers, third-party MDMs, or IoT devices.

### On-premises PKI

- **Cost**  
  - **Infrastructure**: Potentially multiple CAs, plus hardware security modules (optional) and load balancers for NDES.  
  - **Admin staff**: You may need a dedicated PKI team or at least well-trained administrators.

- **Complexity**  
  - **High**: Large environments often have an offline root CA, optional policy CAs, and several issuing CAs.  
  - **Upgrade overhead**: Phasing out older Windows Server versions can be lengthy.

- **Suitability**  
  - **Fits**: Organisations needing certificates across varied platforms—servers, devices, web applications—beyond Intune.  
  - **Challenge**: Managing multi-region replication, CRL publishing, and 24/7 availability.

---

## 4. Enterprise organisations (>10,000 users)

### Microsoft cloud PKI

- **Cost**  
  - **Subscription**: Significantly high, but no separate servers or HSMs.  
  - **Operational**: Frees internal teams from the day-to-day PKI overhead.

- **Complexity**  
  - **Straightforward**: Automatically handles certificate requests for large fleets of Intune devices.  
  - **Insufficient coverage**: Your enterprise likely runs complex on-prem services, non-Microsoft devices, or network equipment needing certificates.

- **Suitability**  
  - **Ideal if**: You’re nearly 100% cloud-first and Intune-managed.  
  - **Blocking factor**: If you need wide-ranging certificate support, you still need some form of on-prem PKI.

### On-premises PKI

- **Cost**  
  - **Infrastructure**: Multiple CA tiers, potential hardware security modules, and dedicated data centre resources.  
  - **Skilled team**: Requires expert PKI administrators to oversee policy, templates, and upgrades.

- **Complexity**  
  - **Advanced**: Might have offline root procedures, dedicated policy CAs, layered issuance, and multiple environments.  
  - **Legacy OS**: Enterprise PKI often spans servers on different Windows versions, needing phased upgrades or migrations.

- **Suitability**  
  - **Crucial if**: You have stringent compliance or widely varied device/app requirements.  
  - **Long-term advantage**: Maximum flexibility and control over certificate issuance and policies, at the cost of higher internal overhead.

---

## Factoring in the “Intune-only” limitation of Microsoft cloud PKI

A major constraint of **Microsoft cloud PKI** is that it can currently issue certificates **only** to devices enrolled in Intune.  
- This **excludes** internal servers, non-Intune endpoints, or specialised equipment like network printers, routers, or IoT devices.  
- Many large and enterprise organisations have diverse infrastructure, forcing them into a **hybrid** approach—using Microsoft cloud PKI for mobile endpoints under Intune while maintaining an on-premises CA for everything else.

---

## Upgrading older on-premises PKI: a critical consideration

If you have an established on-premises PKI running on older Windows Server versions (e.g. 2008/2012):

- **Security risk**  
  Once support ends, your CA could be exposed to unpatched vulnerabilities.  
- **Side-by-side migrations**  
  Commonly recommended: build new CAs on modern OS versions, then transfer issuance roles gradually.  
- **Role-by-role**  
  If you run NDES, SCEP, or Intune Certificate Connector on older servers, plan carefully to keep services uninterrupted.

Refer to [this blog]({{ site.baseurl }}{% post_url 2025-01-28-Upgrading-Microsoft-PKI %}) for more details on upgrading PKI

---

## Conclusion

Choosing between **Microsoft cloud PKI** and **on-premises PKI** ultimately hinges on **what devices and services** require certificates. If you only need certificates for Intune-managed endpoints, cloud PKI minimises operational overhead and infrastructure costs. However, most organisations have broader requirements, necessitating an **on-premises solution** (or a hybrid) to cover servers, network devices, or any system that can’t enrol via Intune.

- **Small to medium**: Cloud PKI can work if you’re already Intune-centric, but an on-prem PKI is more versatile for mixed environments.  
- **Large to enterprise**: Likely need a hybrid approach—cloud for mobile devices and on-prem for everything else—or stick to full on-prem for maximum flexibility.

If you maintain older on-prem PKI servers, be mindful of upgrade paths and potential security exposures. A side-by-side migration to newer OS versions, with careful planning for NDES, SCEP, and any connectors, is usually the safest route. By weighing cost, complexity, and the extent of your certificate needs, you can devise a PKI strategy that secures your infrastructure and grows with your organisation.

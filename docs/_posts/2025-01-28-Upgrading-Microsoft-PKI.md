---
layout: post
title:  "Upgrading Microsoft PKI"
description: Microsoft PKI is often a critical part of the infrastructure, but how do you upgrade an on premises PKI
date:   2025-01-28 06:43:28 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 55
---
<h1>{{ page.title }}</h1>

Public key infrastructure (PKI) upgrades can be daunting—especially when juggling offline root CAs, policy CAs, and issuing CAs. Yet maintaining a healthy PKI is essential for strong security, regulatory compliance, and smooth certificate-based operations. In this blog, we’ll explore the fundamental considerations of upgrading a PKI, discuss the side-by-side method in detail, and finish by examining how to decommission your old environment without disruption.

## understanding PKI components

Before diving into upgrade strategies, let’s establish the roles of different PKI components:

1. **Offline root CA**  
   The pinnacle of the certificate hierarchy, typically kept offline to minimise risk. It signs subordinate (policy or issuing) CA certificates but does not directly issue end-entity certificates.

2. **Policy CA**  
   An optional layer that enforces policies between the root CA and issuing CAs. It can offer an extra rung in the hierarchy for compliance or separation of duties, though many organisations operate without one.

3. **Issuing CAs**  
   The workhorses of a PKI, these online servers issue certificates to users, devices, and services. They must be accessible enough for day-to-day certificate requests and renewals, yet still secured against compromise.

## key upgrade approaches

When upgrading a PKI, there are two main paths:

1. **In-place upgrade**  
   - **Advantages:** Retains existing certificates and reduces the number of servers.  
   - **Challenges:** Risk of errors during the upgrade, possible incompatibilities, and usually requires the old operating system (OS) to support a direct upgrade path.

2. **Side-by-side migration**  
   - **Advantages:** Allows you to build fresh servers on a newer OS, thoroughly test configuration, and gradually migrate.  
   - **Challenges:** Requires additional hardware or virtual machines, planning for certificate re-issuance, and coordination to shift workloads smoothly.

Most experienced PKI administrators favour the **side-by-side method** for critical infrastructure like certificate services. It gives you far more control, reduces production risk, and provides a safety net if something goes wrong.

## the offline root CA upgrade

An **offline root CA** does not get powered on frequently. This isolation protects the all-important private key. Consequently, upgrading or migrating it can be simpler in some respects, because it is rarely in active use:

1. **Backup the root keys and configuration**  
   Use `certutil` or equivalent to export the private key and root certificate, then store them securely (offline media in a locked safe, for instance).

2. **Build your new offline root**  
   Install the latest OS on a hardened machine (kept offline) and import the existing root keys and certificate, ensuring the same chain of trust is preserved.

3. **Preserve CRL publication**  
   If the root CA publishes revocation data (CRLs), confirm the publishing mechanism remains intact so that existing certificates can still be verified.

## policy and issuing CAs: the side-by-side method

For **policy and issuing CAs**, the side-by-side approach offers a controlled way to introduce new servers without abruptly cutting off existing certificate services. Here’s a closer look:

### step 1: planning and preparation

- **Scope the project:** Decide how many new CAs you need and plan for where they will reside—on-premises, in Azure, or in another secure environment.  
- **Check validity periods:** Note the expiry dates of certificates issued by the old CAs. This helps you gauge how long you’ll need to keep them running.  
- **Develop a migration timeline:** Align upgrades with certificate renewal schedules if possible, to avoid re-issuing certificates prematurely.

### step 2: build the new CA servers

- **Fresh OS installation:** Provision new servers on the latest supported Windows Server version.  
- **Install AD CS:** Configure the certificate authority role, ensuring you apply security best practices.  
- **Configure certificate templates and policies:** Mirror existing templates or modernise them if you’re introducing updated cryptographic algorithms or stricter policies.

### step 3: issue certificates from the new CAs

- **Import chain of trust:** Ensure the new CAs trust the offline root (and policy CA, if you have one).  
- **Begin gradual roll-out:** Start issuing new certificates for systems that can easily switch over (for example, test systems or less critical services).  
- **Enable auto-enrolment (if applicable):** Update your group policy settings to point end-users and devices to the new CAs for certificate enrolment.

### step 4: monitor and validate

- **Audit certificate requests:** Ensure the new CAs are functioning properly and logging issuance events as expected.  
- **Check CRLs and OCSP (if used):** Confirm clients can retrieve revocation data without errors.  
- **Ensure application compatibility:** Some services may have pinned certificates or rely on older cryptographic settings. Test thoroughly before full-scale migration.

## graceful decommissioning of old CAs

Once you’ve established the new infrastructure, gradually move all certificate issuance to the new environment. However, old CAs typically need to remain operational for a set period. Here’s how to retire them cleanly:

1. **Stop issuing new certificates**  
   Disable issuance on the old CAs or remove templates so that no fresh certificates are unexpectedly produced.

2. **Wait for certificate expiries**  
   Existing certificates issued by the old CAs may still be valid for months or even years. Accelerate transitions by re-issuing certificates from the new CAs where feasible.

3. **Maintain CRLs and OCSP responses**  
   Clients will continue to check the old CA’s CRL distribution points until all certificates signed by it expire. You can keep the old CA servers online or publish CRLs to a separate server if you’d prefer to power them down sooner.

4. **Final power down**  
   Once no active certificates remain, you can securely retire the old CAs. Make a final backup of the database and private key material for compliance or audit needs.

## conclusion

Upgrading your PKI can be a substantial endeavour, but with careful preparation—and by embracing a **side-by-side migration**—you can significantly reduce risk and downtime. By starting with the offline root CA, introducing new policy and issuing CAs alongside the old ones, and finally decommissioning your legacy infrastructure in a controlled manner, you’ll maintain trust across your organisation and ensure a smooth transition for all certificate-dependent services.

This modernisation provides not only the latest features but also an opportunity to tighten security, enforce more robust cryptographic standards, and align with current compliance guidelines. Approach the process methodically, test thoroughly, and you’ll reap the rewards of a more reliable and future-proof PKI for years to come.

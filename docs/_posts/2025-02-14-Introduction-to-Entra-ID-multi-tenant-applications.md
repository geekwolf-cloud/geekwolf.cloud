---
layout: post
title:  "Introduction to Entra ID multi-tenant applications"
description: Building Entra ID multi-tenant applications requires many design choices.  Let's talk about how we handle authentication from many Entra ID tenants
date:   2025-02-14 10:58:03 +0000
category: entra-id
tags: entra-id identity
image: /android-chrome-192x192.png
comments_id: 57
---
<h1>{{ page.title }}</h1>

When building a Software as a Service (SaaS) or any application that serves multiple organisations, you often need a single identity platform to handle authentication and authorisation on behalf of each customer. Entra ID (formerly Azure Active Directory) allows you to register a single application in a “home” tenant, which can be accessed by users from multiple “remote” or “guest” tenants.

In a multi-tenant scenario, the application is registered in one tenant (the “publisher” or “provider” tenant), but users and admins from various other tenants (the “consumer” or “customer” tenants) can consent to the application’s permissions or install the app in their own directory.

## Delegated permissions vs. application permissions

Before exploring credential options and multi-tenancy, it’s important to distinguish between delegated permissions and application permissions.

- **Delegated permissions**  
  Used when your app calls APIs on behalf of a signed-in user. This requires interactive sign-in, and the effective permissions are limited by the user’s privileges plus the permissions your app requests. For example, a web application that reads the signed-in user’s calendar data in Microsoft Graph.

- **Application permissions**  
  Used when your app operates without a signed-in user, such as a background or daemon service. These permissions require admin consent because they can allow broader access, for instance reading all mailboxes in a tenant.

Many multi-tenant applications need both delegated and application permissions: user-driven interactions at the front end, and automated background jobs at the back end.

## Multi-tenant registration patterns

When you register a multi-tenant application in Entra ID:

1. **Register in your home tenant**  
   Create an app registration in your “publisher/provider” tenant. In the Azure portal under “Authentication,” ensure “Accounts in any organisational directory (Any Azure AD directory)” is selected to permit remote tenants to sign in.

2. **Consent from each remote tenant**  
   Each customer or remote tenant must grant permission for your application. Admin consent is required for higher-privilege permissions (either via an admin consent URL or directly in the Azure portal).

3. **Token issuance**  
   Once consented, remote users sign into your application and receive tokens referencing your app registration from the home tenant. Make sure to validate tokens carefully and handle any tenant-specific logic.

## Credential options

### Client secrets

**What is it?**  
A client secret is a string shared between Entra ID and your application. Your app uses this secret to request tokens in confidential flows.

**Pros**  
- Straightforward to set up.  
- Good for development or proofs of concept.

**Cons**  
- Storing secrets securely can be challenging.  
- Requires periodic rotation (up to 2 years).  
- Less secure for production workloads with higher privileges.

**Where to use**  
- Simple or lower-risk scenarios.  
- Non-production environments or small-scale multi-tenant apps.

### Certificates

**What is it?**  
An X.509 certificate can replace the client secret, with the public key uploaded into Entra ID. Your application holds the private key securely (e.g., in Azure Key Vault).

**Pros**  
- Offers better security than a text-based secret.  
- Can be rotated less frequently than secrets (though rotation is still essential).  
- Private keys can be protected in hardware security modules or secure vaults.

**Cons**  
- Slightly more complex to manage and automate.  
- Requires a solid plan for storing and renewing certificates.

**Where to use**  
- Production multi-tenant environments needing stronger security.  
- Environments where secret handling must be minimised and controlled.

### Managed identities

**What is it?**  
Managed identities are automatically managed by Azure for Azure resources, removing the need to store secrets or certificates. Your app can request tokens from Entra ID without manual credential management.

**Pros**  
- No secrets to handle or rotate.  
- Simplifies authenticating Azure-hosted workloads.  
- Rotated automatically by Azure.

**Cons**  
- Available only on Azure-hosted services.  
- Each managed identity is bound to its own tenant, so multi-tenant usage may require cross-tenant trust or different approaches for remote tenants.

**Where to use**  
- Azure-based back-end services in your home tenant.  
- Microservices or serverless solutions in Azure where minimal credential management is desired.

### Workload identity federation

**What is it?**  
Workload identity federation allows external identity providers (like GitHub Actions or Kubernetes) to exchange their tokens for Entra ID tokens, eliminating the need for stored secrets. This trust relationship is configured in Entra ID.

**Pros**  
- Avoids static credentials for CI/CD or container-based workflows.  
- Uses short-lived tokens, reducing security risk.  
- Integrates with many external providers.

**Cons**  
- Requires establishing trust between Entra ID and the external IdP.  
- Multi-tenant scenarios may be more complicated if each remote tenant also needs federation.

**Where to use**  
- GitHub Actions or other CI/CD pipelines needing secure access to Azure services.  
- Kubernetes or serverless platforms configured to exchange tokens dynamically.

## Consent framework

Entra ID’s consent model manages permissions in each remote tenant. Depending on the permission type:

- **User consent**  
  Suits lower-privilege delegated permissions. A user can grant consent on their own if tenant policies allow.

- **Admin consent**  
  Needed for application permissions or higher-privilege delegated permissions, such as reading all mailboxes or accessing sensitive organisational data.

Ensure you clearly communicate the admin consent process to remote tenant administrators, especially when your application requests broad scopes.

## Assigning permissions across tenants

1. **Guide admins for admin consent**  
   Provide an admin consent URL or portal instructions so remote tenant admins can grant your requested permissions. Admin consent is essential for application permissions or any elevated delegated scopes.

2. **Use tenant-specific tokens**  
   When calling Microsoft Graph or your own resource APIs, request tokens from the relevant tenant’s authority (e.g. `https://login.microsoftonline.com/<tenant_id>`). Always validate the tenant ID and permission claims in returned tokens.

3. **Track consent status**  
   Keep a record of which tenants have granted which permissions. This audit trail is crucial for compliance and support, particularly if an admin needs to review or revoke access.

## Best practices and considerations

- **Use certificates or managed identities over secrets**  
  Where possible, favour more secure options like certificates or managed identities to reduce risk.

- **Leverage workload identity federation for DevOps**  
  CI/CD pipelines often need temporary access to resources. Workload identity federation avoids storing long-lived credentials.

- **Implement robust consent flows**  
  Clearly explain why your application needs specific permissions. Simplify the admin consent experience for remote tenants.

- **Request minimal privileges**  
  Ask for only the permissions you genuinely need. Overly broad requests can deter potential customers and pose security risks.

- **Monitor and audit**  
  Log consent grants, token requests, and access patterns. Provide a means for tenant admins to revoke access easily.

- **Apply zero trust principles**  
  Validate tokens thoroughly, check claims, and enforce least privilege. Use short-lived tokens and secure storage for any credentials.

## Conclusion

By designing your Entra ID multi-tenant application to address delegated and application permissions, and carefully choosing the right authentication method (secrets, certificates, managed identities, or workload identity federation), you can ensure a secure and seamless experience for all your customers. A well-planned consent strategy, coupled with strong security measures, enables your application to operate effectively across many remote tenants while maintaining rigorous standards of compliance and data protection.

**Further reading**  
- [Microsoft Entra ID (Azure AD) documentation](https://learn.microsoft.com/azure/active-directory/fundamentals/)  
- [Admin consent for multi-tenant apps](https://learn.microsoft.com/azure/active-directory/manage-apps/grant-admin-consent)  
- [Workload identity federation in Microsoft Entra ID](https://learn.microsoft.com/azure/active-directory/develop/workload-identity-federation)  



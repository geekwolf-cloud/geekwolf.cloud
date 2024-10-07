---
layout: post
title:  "A look at Kerberos in Windows Server 2025"
description: A follow on from a 7-part blog on Kerberos back in 2018, this time refreshed for Windows Server 2025.  What has improved?
date:   2024-09-03 07:41:17 +0100
category: on-premises
tags: entra-id identity on-premises
image: \android-chrome-192x192.png
comments_id: 36
---
<h1>{{ page.title }}</h1>

I first wrote a 7 part series blog on Kerberos back in 2018. With the advent of Windows Server 2025 and the demise of RC4 in Active Directory, I thought it was worth refreshing this blog and talk about any differences in how Kerberos works in the new server OS. I won't go over all the details of Kerberos in terms of terminology, etc.  If you'd like to read about What is Kerberos, what are tickets, what is a PAC, etc then please first read the blog on the [Nero Blanco website](https://neroblanco.co.uk/2018/04/inside-kerberos-sids-tickets-and-tokens-part-1/).

So let us look at the three parts of the network flows types: authentication service, ticket granting services and application

## Authentication Service

The Authentication Service flow is part of the KDC and is all about surprise, surprise… authentication. This flow verifies the user and returns to them the TGT and the TGS Session Key. Picking this flow apart we see:

![Kerberos Authentication Service](/assets/images/2024-09-03-Windows-Server-2025-Kerberos-auth-service.png)

1. **Client to KDC – KRB_AS_REQ**

   The client locates a KDC for its own realm and creates a KRB_AS_REQ message. This initial message contains:

   - `padata` structure for PA-PAC-REQUEST
   - `kdc-options` flags: typically forwardable, renewable, canonicalize, renewable-old
   - `cname`: left part of the user principal name
   - `realm`: the user’s FQDN
   - `sname`: the krbtgt service and FQDN
   - `till/rtime`: expiry and renewal times both set to around 20 years
   - `nonce`: client-generated random value
   - `etype`: ordered list of preferred encryption methods
   - `addresses`: device host name

2. **KDC to Client – KRB_ERROR: Pre Authentication Required**

   Kerberos v5 requires pre-authentication, so the KDC responds asking for that pre-authentication. It creates a KRB_ERROR message with the following main fields:

   - `error-code`: ERR_PREAUTH_REQUIRED
   - `realm`: The KDC realm
   - `sname`: the krbtgt service and FQDN
   - `e-data`: contains multiple `padata` structures, an offer of encryption methods, plus a set of acceptable pre-authentication data structures:
     - an ordered list of encryption types supported, including information about any salt required
     - Request for encrypted timestamp
     - Request for password
     - Request for Private Key

<div class="callout">
<p><b>Windows Server 2025:</b> This does NOT include the RC4 cipher</p>

<p><img src="/assets/images/2024-09-03-Windows-Server-2025-Kerberos-auth-service-KRBERR.png" alt="KRB_ERROR: Pre Authentication Required"></p>
</div>

3. **Client to KDC – KRB_AS_REQ (with pre-authentication)**

   The client re-creates the KRB_AS_REQ but this time adds the encrypted pre-authentication data. For a standard Windows 10 client with a standard password logon, the main fields are:

   - `padata` structure for PA-ENC-TIMESTAMP, which includes a timestamp encrypted with the user’s secret key (a one-way hash of the user’s password)
   - `padata` structure for PA-PAC-REQUEST
   - `kdc-options` flags: typically forwardable, renewable, canonicalize, reneable-old
   - `cname`: left part of the user principal name
   - `realm`: the user’s FQDN
   - `sname`: the krbtgt service and FQDN
   - `till/rtime`: expiry and renewal times both set to around 20 years
   - `nonce`: client-generated random value
   - `etype`: ordered list of preferred encryption methods
   - `addresses`: device host name

4. **KDC to Client – KRB_AS_REP**

   The KDC uses its stored value of the user’s secret key to decrypt the pre-authentication data and validates that it is correct (in the case of a timestamp it needs to be within the tolerance set for Active Directory). Assuming the validation succeeds, a KRB_AS_REP is constructed with the following main fields:

   - `padata` structure for encryption info, informing the client of the encryption method and the salt used
   - `crealm`: the user’s FQDN
   - `cname`: left part of the user principal name
   - `ticket`: the TGT, which includes the krbtgt service and realm of the issuer as well as information encrypted with the krbtgt secret key
   - `enc-part`: the TGS Session Key, and information about the TGT as well as the original nonce, all encrypted with the user’s secret key. The client uses this information to validate the TGT as well as cache the TGT and TGS Session Key

At the end of this conversation, the client has a TGT that is encrypted with the krbtgt secret key and a TGS Session Key that can be used to secure the Ticket Granting Service flow.

<div class="callout">
<p><b>Windows Server 2025:</b> There really isn't anything different here for Windows Server 2025, other than RC4 no longer being possible.  If you do force RC4 then you will get the following errors.</p>

<p><img src="/assets/images/2024-09-03-Windows-Server-2025-Kerberos-auth-service-no-RC4.png" alt="Forced RC4 Kerberos error"></p>
</div>

## Ticket Granting Service

The Ticket Granting Service flow is also part of the KDC and, as you might guess, aims to grant tickets to services. This flow verifies the TGT and returns to the user the Service Ticket (ST) and the Session Key. Picking this flow apart we see:

![Kerberos Ticket Granting Service](/assets/images/2024-09-03-Windows-Server-2025-Kerberos-ticket-granting-service.png)

1. **Client to KDC – KRB_TGS_REQ**

   The client locates a KDC in its own realm and looks up the TGT and TGS Session Key in its cache. If not found, it starts an Authentication Service flow first. Once it has the TGT and TGS Session Key, the KRB_TGS_REQ is crafted with the following main fields:

   - `padata` structure with a PA-TGS-REQ structure which includes:
     - the TGT
     - an authenticator (encrypted with the TGS Session Key). This authenticator includes:
       - `crealm`: the user’s realm
       - `cname`: the left part of the user principal name
       - `cksum`: A checksum of the `req_body` structure below
       - `cusec/ctime`: time information to prevent replaying
       - `subkey`: The client can optionally add an encryption key to use for any responses
   - `req_body` structure including:
     - `kdc-options`: forwardable, renewable, canonicalize
     - `realm`: the realm we’re trying to contact
     - `sname`: the service principal name for the service we’re trying to consume
     - `till`: The ideal duration of the Session Ticket (set to around 20 years)
     - `nonce`: a random value generated by the client
     - `etype`: an ordered list of preferred encryption types

2. **KDC to Client – KRB_TGS_REP (in this case a cross-realm referral)**

   The response the KDC gives depends on whether the service principal is in its own domain or a trusting domain. In this case, we’re assuming that it is in a trusting domain, and so the KDC returns a referral, which includes:

   - `crealm`: the user’s realm
   - `cname`: the left part of the user principal name
   - `ticket`: a TGT with realm and `sname` set to the krbtgt service and FQDN to contact next, as well as information encrypted using the trust secret key
   - `enc-part`: the TGS Session Key, and information about the TGT as well as the original nonce, all encrypted with the subkey from the KRB_TGS_REQ (if present) or the user’s secret key. The client uses this information to validate the TGT as well as cache the TGT and TGS Session Key

3. **Client to KDC – KRB_TGS_REQ**

   Given that we got a referral, a new KRB_TGS_REQ is created to be sent to the krbtgt we got in step 2, with the following main fields:

   - `padata` structure with a PA-TGS-REQ structure which includes:
     - the TGT (from step 2) but with realm set to the user’s realm (so that the receiving KDC knows which trust secret key to use to decrypt)
     - an authenticator (encrypted with the TGS Session Key). This authenticator includes:
       - `crealm`: the user’s realm
       - `cname`: the left part of the user principal name
       - `cksum`: A checksum of the `req_body` structure below
       - `cusec/ctime`: time information to prevent replaying
       - `subkey`: The client can optionally add an encryption key to use for any responses
   - `req_body` structure including:
     - `kdc-options`: forwardable, renewable, canonicalize
     - `realm`: the realm we’re trying to contact
     - `sname`: the service principal name for the service we’re trying to consume
     - `till`: The ideal duration of the Session Ticket (set to around 20 years)
     - `nonce`: a random value generated by the client
     - `etype`: an ordered list of preferred encryption types

4. **KDC to Client – KRB_TGS_REP**

   Assuming the TGS Request validates, i.e. ticket is valid, authenticator can be decrypted, checksum matches the `req_body`, then the KDC creates a KRB_TGS_REP and returns to the client the following fields:

   - `crealm`: the user’s realm
   - `cname`: the left part of user principal name
   - `ticket`: the Service Ticket with realm and `sname` set to the service we’re trying to contact, and information encrypted using the service secret key
   - `enc-part`: The Session Key and information about the Service Ticket as well as the original nonce, all encrypted using the subkey in the request (if present) or the user’s secret key. The client uses this information to validate the response and cache the Service Ticket and Session Key

<div class="callout">
<p><b>Windows Server 2025:</b> No changes here other than the encryption method.  If RC4 was forced then you'll never get a TGT ergo you won't get a TGS request.</p>
</div>

## Application

The application flow is embedded within whatever application the user is trying to access. In the screenshot below we’ve requested access to an SMB share:

<p><img src="/assets/images/2024-09-03-Windows-Server-2025-Kerberos-application-smb2-Kerberos.png" alt="Kerberos within SMB"></p>
<p><img src="/assets/images/2024-09-03-Windows-Server-2025-Kerberos-application-smb2-Kerberos-response.png" alt="Kerberos response within SMB"></p>

1. **Client to Server: SMB2 Session Request with an embedded KRB_AP_REQ**

   SMB uses the Generic Security Service (GSS) API to encapsulate Kerberos authentication/authorization information. The information inside the GSS structure includes:

   - `ap-options`: mutual-required
   - `ticket`: the Service Ticket, including the realm and service principal name and information encrypted with the service secret key
   - `authenticator`: a structure encrypted using the Session Key. This authenticator includes:
     - `crealm`: the user’s realm
     - `cname`: the left part of the user principal name
     - `cksum`: A checksum of the `req_body` structure below
     - `cusec/ctime`: time information to prevent replaying
     - `subkey`: The client can optionally add an encryption key to use for any responses

2. **Server to Client: SMB2 Session Response with an embedded KRB_AP_REP**

   The Server validates the ticket, decrypts the authenticator and assuming the user is authorized then it will reply with an SMB Session Response which again includes a GSS-API structure, this time encrypted either using the Session key, or using the subkey from the request:

   - cusec/ctime: returned from the client’s request (to validate that the server was the one how managed to decrypt the authenticator)
   - subkey: an optional server generated encryption key to use for all future communication in this session

<div class="callout">
<p><b>Windows Server 2025:</b> No changes here other than the encryption method again.  If you did force RC4 then you will see this fall back to NTLM as shown below.</p>

<p><img src="/assets/images/2024-09-03-Windows-Server-2025-Kerberos-application-smb2-ntlm.png" alt="NTLM Fallback when forcing RC4"></p>
<p><img src="/assets/images/2024-09-03-Windows-Server-2025-Kerberos-application-smb2-ntlm-response.png" alt="NTLM Fallback response when forcing RC4"></p>
</div>

So that's the update for Windows Server 2025.  I will next dig into Cloud Kerberos and see how that flow works with Windows Hello for Business getting a partial TGT from Entra ID, and using that via the Cloud Kerberos Trust to get tickets for the on premises resources.  If you have any comments or insights, then please comment below and I will gladly chat more :)

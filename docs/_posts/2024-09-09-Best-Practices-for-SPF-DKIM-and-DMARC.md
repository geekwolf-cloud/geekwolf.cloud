---
layout: post
title:  "Best Practices for SPF, DKIM and DMARC"
description: A look at SPF, DKIM and DMARC.  What are the best practices around these three key mail authentication methods, and how should you plan for bulk mailers.
date:   2024-09-09 08:05:37 +0100
category: microsoft-365
tags: microsoft-365 best-practice
comments_id: 37
---
<h1>{{ page.title }}</h1>

In an era where email is a primary communication channel, ensuring the security and reliability of your email delivery is crucial. For organisations using Microsoft 365 (M365) and those engaging in bulk email sending, it’s essential to properly configure SPF, DKIM, and DMARC to protect against phishing and spoofing. Additionally, managing and monitoring your email deliverability, especially when you don’t control the sending IPs directly, requires a strategic approach. Here’s a comprehensive guide to achieving effective email security and performance.

## Understanding SPF, DKIM, and DMARC

**SPF (Sender Policy Framework)**: SPF verifies which mail servers are allowed to send emails on behalf of your domain. It helps prevent unauthorised use of your domain in emails.

**DKIM (DomainKeys Identified Mail)**: DKIM adds a digital signature to your emails, allowing recipients to verify the email’s authenticity and integrity.

**DMARC (Domain-based Message Authentication, Reporting & Conformance)**: DMARC builds on SPF and DKIM by providing a reporting mechanism and a policy for handling emails that fail authentication checks.

## Best practices for M365 users

### 1. Configuring SPF

- **Use Microsoft’s SPF record**: Add the following SPF record to your DNS settings to authorise Microsoft 365 to send emails on your behalf:

```
v=spf1 include:spf.protection.outlook.com -all
```


- **Avoid SPF record bloat**: Keep your SPF record concise to stay within the 10 DNS lookup limit. Use `include:` for third-party services and minimise direct IP entries. (<a href="#spf-macros">see below for a work around for the 10 DNS lookup limit</a>)
- **Regular updates**: Update your SPF record whenever you change or add email services to avoid delivery issues.

### 2. Setting up DKIM

- **Enable DKIM in M365**: Activate DKIM for your domain through the Exchange admin centre. Follow M365’s instructions to generate DKIM keys and publish the required CNAME records in your DNS settings.
- **Rotate DKIM keys**: Periodically rotate DKIM keys for added security. M365 provides options to manage key rotation within the admin centre.

### 3. Implementing DMARC

- **Create a DMARC record**: Start with a basic DMARC record to gather data:

```
v=DMARC1; p=none; rua=mailto:dmarc-reports@yourdomain.com
```

This setup allows you to receive reports without enforcing any policies. Gradually shift to `p=quarantine` or `p=reject` based on your data.
- **Monitor DMARC reports**: Analyse DMARC reports to understand authentication performance and potential issues. Use this data to adjust your email practices.
- **Increase policy strictness**: Once confident, move from `none` to `quarantine` and eventually `reject` to strengthen protection against email spoofing.

## Best practices for bulk email senders

### 1. Use a separate domain or subdomain

- **Create a subdomain**: Use a subdomain (e.g., `news.yourdomain.com`) for bulk email campaigns to protect your main domain’s reputation.
- **Configure SPF, DKIM, and DMARC**: Ensure the subdomain has its own SPF, DKIM, and DMARC records to manage reputation separately.

### 2. Select reputable bulk email services

- **Microsoft Dynamics 365 Marketing**: Utilise Microsoft’s own bulk email service (not sure this is ready for prime time, just yet), which integrates with M365 and adheres to Microsoft’s security and deliverability best practices.
- **Other providers**: For third-party services, ensure they are compliant with industry standards and offer tools to monitor email performance and reputation.

### 3. Monitor and maintain

- **Deliverability insights**: Regularly check the deliverability metrics provided by your ESP. High bounce rates or spam complaints should be addressed promptly.
- **Clean mailing lists**: Regularly update your email lists to remove invalid addresses and inactive users, reducing bounce rates and improving engagement.
- **Analyse reports**: Use DMARC reports and feedback from ISPs to identify and resolve any issues impacting deliverability.

## Indirect monitoring options

When you don’t own the sending IP addresses, you can still monitor and manage email deliverability using these indirect methods:

### 1. Email service provider (ESP) dashboards

- **Analytics**: Utilise the dashboards provided by your ESP to track delivery rates, bounce rates, open rates, and spam complaints. This data helps you gauge email performance and sender reputation.

### 2. DMARC reports

- **Aggregate reports**: These reports provide an overview of how your emails are processed by recipient servers and highlight any authentication issues.
- **Forensic reports**: Detailed reports on failed email authentication can help you troubleshoot specific issues.

### 3. Google Postmaster Tools

- **Domain performance**: Gain insights into how Gmail handles your emails, including spam rates and delivery errors.
- **Feedback loop**: Use data from Google Postmaster Tools to understand and improve your email practices.

### 4. Feedback loops with ISPs

- **Enrollment**: Sign up for feedback loops from major ISPs to receive notifications about spam complaints and address issues promptly.

### 5. Third-party deliverability monitoring tools

- **Testing tools**: Use tools like Mail Tester, GlockApps, and SenderScore for deliverability testing and reputation scoring.
- **Reputation monitoring**: Some services provide ongoing monitoring of your sender reputation even when using third-party IPs.

### 6. Review bounce and complaint rates

- **Bounce analysis**: Regularly review and address high bounce rates.
- **Complaint tracking**: Analyse spam complaints to adjust your email strategies and reduce future complaints.

### 7. Consult with ESP support

- **Expert advice**: Reach out to your ESP’s support team for guidance on managing deliverability and resolving issues.

### 8. Regular email audits

- **Compliance checks**: Ensure compliance with email marketing laws and best practices.
- **Quality control**: Regularly review your email content and practices to maintain high deliverability and engagement.

<h2 id="spf-macros">Working around the 10 DNS lookup limit in SPF using macros</h2>

One of the key limitations of SPF records is the **10 DNS lookup limit**. When you include multiple third-party services or senders in your SPF record, you can quickly exceed this limit, which may cause SPF checks to fail and affect your email deliverability. To help manage this constraint, SPF macros can be used strategically to optimise DNS lookups and remain within the limit.

### What are SPF macros?

SPF macros are dynamic expressions within SPF records that allow the receiving mail server to insert certain values, such as the sending IP address or domain, during the SPF check. These macros enable more flexible and dynamic SPF records, which can be useful in scenarios where you need to reduce the number of explicit DNS lookups.

### Available SPF macros

Here is a list of commonly used SPF macros:

- **`%{s}`**: The sender’s email address.
- **`%{l}`**: The local part of the sender’s email address (the portion before the `@` symbol).
- **`%{d}`**: The domain of the sender’s email address (the portion after the `@` symbol).
- **`%{i}`**: The IP address of the sending mail server, represented in dotted-quad notation.
- **`%{p}`**: The validated domain name of the sending server.
- **`%{h}`**: The HELO/EHLO domain used by the sending server.
- **`%{c}`**: The SMTP client IP address.
- **`%{r}`**: The domain name of the receiving server performing the SPF check.
- **`%{t}`**: The current timestamp.

Each of these macros can be expanded into subfields and transformations to allow further customisation. For example:
- **Subfields**: Macros like `%{d1}` can reference specific parts of the domain (in this case, the top-level domain).
- **Transformations**: Modifiers such as `r` (reverse the order of an IP address) or `n` (truncate the field) allow further processing of macro data.

### Example macro usage in SPF

Here’s an example of a simple SPF record using macros:

```
v=spf1 ip4:%{i} -all
```

In this example:
- `%{i}` is a macro that represents the IP address of the sender (in reverse dotted-quad notation).

While this specific example isn't directly used to work around the DNS lookup limit, it demonstrates the basic syntax of an SPF macro.

### Using macros to reduce DNS lookups

Macros can be helpful in certain situations where dynamic components, like domain names, change or if you want to limit how many times DNS lookups are performed for specific subdomains or hosts. Instead of adding multiple `include:` directives that each require separate DNS lookups, you can use macros to collapse or reduce redundant queries.

A common scenario for using macros involves dynamically determining the sending domain's IP address:



```
v=spf1 exists:%{i}.spf.yourdomain.com -all
```

In this record:
- `exists:%{i}.spf.yourdomain.com` checks whether the IP address of the sending server (`%{i}`) exists within your own SPF subdomain (`spf.yourdomain.com`).
- This approach allows you to offload some of the DNS lookups to your own domain, reducing the number of explicit lookups that are required.

### Combining macros with IP ranges

If you have multiple IP ranges that need to be authorised in your SPF, you can use macros to dynamically reference them instead of listing them individually in the main SPF record. For example, by pointing to your own domain's SPF record and using macros, you could condense several lookups into one:



```
v=spf1 ip4:%{i}.spf.mail.yourdomain.com -all
```


You would need to configure the DNS under `spf.mail.yourdomain.com` to respond appropriately for different IP ranges or services, reducing the load on the main SPF record.

### Best practices when using SPF macros

1. **Keep it simple**: While macros can offer flexibility, they can also introduce complexity and confusion if not properly managed. Be sure to test any SPF record changes thoroughly to ensure that your intended logic works correctly.
2. **Balance lookup reduction with accuracy**: Although macros can reduce lookups, make sure they don't inadvertently block legitimate emails. Always validate how the receiving server will interpret the macro values.
3. **Monitor performance**: Keep an eye on SPF performance and your email deliverability after implementing macros to ensure that the SPF record is functioning as expected.

### Limitations of macros

While macros can help manage the DNS lookup limit, they are not a silver bullet. You must still carefully manage your SPF records to ensure that any third-party services you use are properly authenticated. Additionally, macros are not as commonly used or well-supported as other SPF features, so it's important to test them thoroughly and ensure they work across different email systems.

---

By leveraging macros effectively, you can optimise your SPF records and potentially avoid the dreaded 10 DNS lookup limit. However, careful implementation and testing are key to making this approach work without introducing deliverability issues.



## Conclusion

Successfully managing email deliverability and security requires a strategic approach, especially when using third-party services or Microsoft 365. By effectively implementing SPF, DKIM, and DMARC, and utilising indirect monitoring methods, you can safeguard your email communications, maintain a strong sender reputation, and ensure your emails reach your intended audience. Regular monitoring, compliance with best practices, and proactive engagement with your ESP’s tools and support will help you navigate the complexities of email deliverability and achieve reliable results.


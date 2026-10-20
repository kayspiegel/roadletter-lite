# 0002: Amazon SES is the only sending provider

- Status: Accepted
- Date: 2026-10-19

## Context
A newsletter tool needs a sending service that delivers well, costs little and handles bounces and complaints. Supporting several providers means several setups, several webhook formats and several sets of tests. Subscribers' addresses should be processed inside the EU.

## Decision
Amazon SES in eu-central-1 (Frankfurt) is the only sending provider in Roadletter Lite. Emails are sent through the SES API, not SMTP.

## Consequences
- Easier: one setup guide, one bounce and complaint path (SES → SNS → webhook), one set of tests.
- Easier: sending costs stay low, and the API returns a message ID for every email.
- Easier: data stays in an EU region.
- Harder: you need an AWS account and SES production access before you can send.
- Harder: anyone who prefers another provider has to change the code themselves.

# 0004: No tracking

- Status: Accepted
- Date: 2026-10-19

## Context
Most newsletter tools track opens with an invisible pixel and clicks by rewriting every link. That collects personal data readers never asked to give, needs extra consent under the GDPR, and open rates are unreliable anyway because many mail clients load images in advance.

## Decision
Roadletter Lite has no open or click tracking: no tracking pixels and no rewritten links. Links in an issue go exactly where the writer pointed them.

## Consequences
- Easier: less personal data to store, explain and delete.
- Easier: the privacy promise is short and literally true.
- Easier: links in an issue are what readers see, not a redirect.
- Harder: there are no open or click rates; the numbers shown are subscribers, deliveries, bounces and unsubscribes.
- Harder: anyone who wants tracking has to look elsewhere.

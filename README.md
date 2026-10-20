# Roadletter Lite

A small, self-hosted newsletter tool for writers, built in public with Rails and Amazon SES.

**Status:** Stage 00 of 10. Not usable yet.

## What it will do

Planned for v1.0:

- Let readers subscribe with double opt-in, and keep a record of every consent: when, from where, and which consent text they agreed to.
- Give you a calm editor for writing an issue, with a preview at desktop and phone width and a test send.
- Send each issue through Amazon SES to every active subscriber, with live progress you can pause and resume.
- Handle one-click unsubscribes, bounces and complaints, so addresses that shouldn't get mail stop getting it.
- Publish a public archive with RSS, and include the GDPR tools you need: export, erasure and retention periods.

It will run on one small server, in English and German.

## What it will not do

- No tracking: no open or click tracking, no pixels, no rewritten links.
- No pop-up newsletters.
- One sending provider only: Amazon SES.
- No installer or setup wizard. You set it up yourself, with the guides in this repository.
- No hosted version.

Lite stays small.

## Follow along

Every stage is one week, one release and one blog post.

- Blog: https://kayspiegel.com/
- RSS: https://kayspiegel.com/feed.xml
- X: https://x.com/kay_spiegel
- LinkedIn: https://www.linkedin.com/in/kay-spiegel
- Indie Hackers: https://www.indiehackers.com/kayspiegel
- GitHub releases: [releases of this repository](https://github.com/kayspiegel/roadletter-lite/releases)
- Stage roadmap: [roadletter.com](https://roadletter.com/#roadmap)

## Decisions

The choices made before the first line of code are written down in [`docs/decisions/`](docs/decisions/).

## Contributing and security

See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md).

## License

Source-available under the O'Saasy License. See [LICENSE.md](LICENSE.md).

Nothing in this repository is legal advice.

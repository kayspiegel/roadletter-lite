# 0001: Rails 8 with SQLite, Solid Queue and Solid Cache

- Status: Accepted
- Date: 2026-10-19

## Context
Roadletter Lite has one admin, one newsletter and a few thousand subscribers at most. It should run on one small server that one person can understand, back up and restore. Every extra service — a separate database server, Redis, a JavaScript build — is one more thing to install, update and watch.

## Decision
Roadletter Lite uses Rails 8 with SQLite for app data, Solid Queue for background jobs, Solid Cache for caching and Solid Cable for live updates, each in its own SQLite file. It runs on one server, with no Redis and no Node build.

## Consequences
- Easier: one container and one volume to deploy; nothing to run besides the app.
- Easier: backups are SQLite files, taken with the SQLite online backup API.
- Easier: no Node toolchain; JavaScript comes through importmap and CSS is plain CSS.
- Harder: SQLite allows one writer at a time, so writes stay short and sending runs in background jobs.
- Harder: it doesn't scale out to several servers. Lite doesn't need to.

# 0005: English code, bilingual interface

- Status: Accepted
- Date: 2026-10-19

## Context
The build happens in public for readers in many countries, so the code and its discussion need one shared language. The first writers using Roadletter Lite, starting with its author, write in German as well as English. Adding a second language later means hunting down every hard-coded string.

## Decision
Code, commits, issues and documentation are in English. The interface is in English and German from the first line of code: the admin chooses a language for the admin area, and the newsletter has its own for public pages and emails.

## Consequences
- Easier: anyone can read and discuss the code.
- Easier: German-speaking writers and readers get a complete interface from the start.
- Easier: no string is hard-coded, so the CI catches missing translations.
- Harder: every string is written twice, and both translations must be kept in step.
- Harder: German copy needs its own care: informal "du" and gender-inclusive forms.

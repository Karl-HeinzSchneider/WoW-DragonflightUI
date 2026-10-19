# CLAUDE.md

## Plan

Goal: make the addon work again on every supported game version (see the
`## Interface` lines in `DragonflightUI.toc`: Classic Era, TBC, Wrath, Cata
and Mists), while keeping changes to a minimum.

- Fix problems at the level of individual lines of code.
- Do not rewrite whole functions or files; prefer the smallest change that
  restores working behavior.
- A fix for one game version must not break the others.

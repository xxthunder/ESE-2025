# ESE 2025 Presentation Project

## Project Overview

This repository contains a presentation for the ESE Kongress 2025 (Embedded Software Engineering Congress) titled **"A CI Journey or Less Pipelines, More Happy Developers!"**.

The presentation documents a two-decade journey in the automotive industry, transforming from reactive "Continuous Kind im Brunnen" (Continuous "Child in the Well") CI practices to a modern Internal Developer Platform (IDP) for Software Product Line Engineering (SPLE).

## Topic Summary

### Main Theme

Building a modern CI/CD platform in the automotive industry that ensures:

- Fast, reliable feedback for developers
- Reproducible builds across local and CI environments
- Reduced pipeline complexity
- Improved developer happiness

### Key Technologies

- **Python + Pytest**: Unified test framework for all quality gates
- **CMake + Ninja**: Meta-build system and fast build executor
- **Jenkins**: Thin orchestration layer (not business logic)
- **Scoop**: Windows package manager for toolchain installation

### Architecture Principles

1. **Separation of Concerns**: Pipeline logic handles only orchestration; business logic resides in build system
2. **Local-First Development**: Jenkins executes identical commands developers run locally
3. **Bootstrapping**: Build scripts handle all dependency resolution
4. **Unified Build System**: CMake as single source of truth for all build artifacts
5. **Quality Gates as Test Selection**: Different test levels are simply pytest marker selections

### The Problem Solved

The presentation addresses the evolution from "Jenkinstein" - a monolithic Jenkins pipeline containing thousands of lines of unmaintainable Groovy DSL code that served as build system, test system, deployment system, and monitoring system - to a clean, modular platform where:

- Failures are reproducible locally
- Debugging is straightforward
- Quality gates are transparent pytest marker selections
- The same commands work in CI and on developer machines

## Project Structure

```
/workspaces/ESE-2025/
├── index.html                 # Main presentation entry point
├── slides/                    # Presentation content (Markdown)
│   ├── 01_eine-ci-cd-reise.md           # Introduction
│   ├── 02_wer-sind-wir.md               # Who we are
│   ├── 03_wo-kommen-wir-her.md          # Where we came from
│   ├── 04_software-factory.md           # Software factory approach
│   ├── 05_was-haben-wir-falsch-gemacht.md  # What we did wrong
│   └── 06_wie-geht-es-richtig.md        # How to do it right
├── docs/
│   └── article/
│       └── index.md           # Conference proceedings article
├── images/                    # Presentation images and diagrams
├── css/                       # Custom styling
├── reveal.js/                 # Reveal.js framework (submodule)
└── .devcontainer/             # Development container configuration
```

## Presentation Slides

The presentation is structured in 6 main sections:

1. **Eine CI/CD Reise** - Introduction to the CI journey
2. **Wer sind wir** - Team and organizational context
3. **Wo kommen wir her** - Historical context and pain points (2005-2020s)
4. **Software Factory** - The platform engineering approach
5. **Was haben wir falsch gemacht** - Lessons learned from mistakes
6. **Wie geht es richtig** - The correct architecture and implementation

## Conference Proceedings Article

The `docs/article/index.md` file contains the written conference proceedings contribution for the ESE Kongress 2025. It provides a detailed written companion to the presentation, covering the CI journey, architectural principles, solution details (Python/Pytest quality gates, CMake build system, Jenkins orchestration), and lessons learned. This article is intended for publication in the conference proceedings.

## Technology Stack

### Presentation Framework

- **Reveal.js**: HTML presentation framework
- **Markdown**: Slide content format
- **Mermaid**: Diagram rendering
- **PlantUML**: Additional diagram support
- **Vite**: Build and development server

### Development Environment

- Git repository with develop branch as main
- DevContainer support for consistent development environment
- VSCode integration

## Key Concepts Explained

### Quality Gates as Test Selection

Instead of complex pipeline logic determining what to test, the platform uses pytest markers:

```python
@pytest.mark.build        # Build quality gate
@pytest.mark.unittests    # Unit test quality gate
```

Different triggers select different marker combinations:

- **Pull Request**: Quick tests only
- **Main Branch**: Full test suite
- **Nightly**: Extended tests including long-running scenarios

### SPLE Platform Benefits

**For Developers:**

- Same commands work locally and in CI
- Easy debugging of failures
- Fast feedback cycles

**For Platform Engineers:**

- Maintainable Python code instead of complex Groovy DSL
- Reusable components across Software Product Lines
- Clear separation of concerns

**For Management:**

- Fast, reliable feedback on software quality
- Transparent quality criteria
- Always releasable software state

## Conference Context

**ESE Kongress 2025**: The Embedded Software Engineering Congress is a major European conference focusing on embedded systems, automotive software, and software engineering practices in safety-critical industries.

This presentation targets:

- Platform engineers building CI/CD systems
- Automotive software teams
- Organizations dealing with complex multi-tool landscapes
- Teams struggling with "Jenkinstein"-style monolithic pipelines

## Development Instructions

The presentation is built using Reveal.js and can be viewed by opening `index.html` in a web browser. To run the development server with live reload, use `npm run dev`.

## Related Standards and Frameworks

- **ASPICE**: Automotive Software Process Improvement and Capability Determination
- **ISO 26262**: Functional safety standard for automotive systems
- **SAFe**: Scaled Agile Framework used for organizational coordination
- **V-Model**: Development model with multiple test levels (SIL, HIL, etc.)

## Historical Context

The CI journey spans from 2005 (RCS-based repositories, nightly builds only) through multiple failed attempts at improvement (separate build environments, freestyle Jenkins jobs, centralized JSON configuration) to the eventual "Jenkinstein" crisis that motivated the complete architectural redesign presented in this talk.

The key turning point was recognizing that build failures must be reproducible locally, and that CI pipelines should orchestrate, not implement, business logic.

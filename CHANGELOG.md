# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2026-07-17
### Added
- Initial release of the CLI Task Manager.
- Support for `RegularTask` and `UrgentTask`.
- CRUD operations via command line (`add`, `list`, `done`, `delete`).
- `JsonRepository` for persisting tasks to `tasks.json`.
- `InMemoryRepository` for fast, I/O-free testing.
- Sorting options by priority or date.
- Comprehensive test suite with 15 test cases.
- Enforced SOLID design principles across the application architecture.

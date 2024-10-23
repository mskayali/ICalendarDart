# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.5] - 2024-10-21
### Fixed
Small bugs and improvements

## [0.0.5] - 2024-10-21
### Added
Abstract Trigger class added to generate alarms with DateTime or Duration objects
### Fixed
Parser problems fixed


## [0.0.4] - 2024-10-21
Model implementation compleated

## [0.0.1] - 2024-10-22

### Added
- Initial release of the iCalendar Dart plugin.
- Core `ICalendar` class to create and manage iCalendar objects.
- `VEvent` component for defining calendar events with support for:
  - Recurrence rules (`RRULE`)
  - Exception dates (`EXDATE`)
  - Attendees, organizers, and contacts
  - Alarms, attachments, and status updates
- `VTodo` component for managing tasks and to-dos with support for:
  - Priority, due dates, and descriptions
  - Recurrence rules and exception dates
  - Attendees and organizers
- `VJournal` component for creating journal entries.
- `VAlarm` component to set reminders and alerts for events and tasks.
- `VFreeBusy` component to define free and busy periods.
- `VTimezone` component to manage time zone information.
- `RecurrenceRule` class to handle recurring patterns.
- `VParticipant` class for attendees, organizers, and contacts.
- `VAttachment` class for handling document and sound attachments.
- Comprehensive parsing capabilities for all components to convert `.ics` strings back to objects.
- Utility methods for serialization to `.ics` format and JSON conversion.
- Integration tests to validate core functionalities.

### Changed
- N/A

### Removed
- N/A

## [Unreleased]

### Added
- Support for more complex recurrence patterns (e.g., exceptions, extended recurrence options).
- Additional validation and error handling for parsing inputs.

### Changed
- N/A

### Removed
- N/A

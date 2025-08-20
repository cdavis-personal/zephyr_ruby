## [Unreleased]

## [0.6.0] - 2025-08-20

### Changed
- Updated Test Cycles resource to support `testCycleIdOrKey` parameter for all relevant methods
- Renamed resource methods for consistency with the API (e.g., `create_test_cycle` instead of `create_testcycle`)
- Updated CLI implementation to handle both ID and key parameters
- Changed payload generators to use `projectKey` instead of `projectId` to match API requirements
- Improved CLI parameter handling using Thor options hash
- Added better handling for boolean parameters in automation payloads

### Added
- Added aliases for backward compatibility with old method names
- Added better parameter descriptions in CLI commands
- Added support for `autoCloseCycle` parameter in automation payloads

### Backward Compatibility
- Maintained full backward compatibility with existing code
- CLI commands support both positional arguments and options hash
- Payload generators accept both `project_id` (numeric) and `project_key` (string)
- Resource methods maintain aliases for old method names
- API client automatically handles both numeric IDs and string keys

## [0.1.0] - 2022-11-24

- Initial release

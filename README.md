# update_build_settings_key plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-update_build_settings_key)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-update_build_settings_key`, add it to your project by running:

```bash
fastlane add_plugin update_build_settings_key
```

## About update_build_settings_key

Updates build settings key to a new value

**Note to author:**Updates build settings key to a new value including specific profile,
will update code signing settings from 'Automatic' to a specific profile when key is PROVISIONING_PROFILE_SPECIFIER


## Example

```
  update_build_settings_key(
    xcodeproj: "Demo/Demo.xcodeproj",
    configuration: "Release",
    build_settings_key: "PROVISIONING_PROFILE_SPECIFIER",
    map: {
      "Demo Watch Extension/Info.plist" => "Demo WatchKit Extension 2",
      "Demo Watch/Info.plist" => "Demo WatchKit App",
      "Demo Today/Info.plist" => "Demo Today",
      "Demo/Info.plist" => "Demo"
    }
  )
```
Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About `fastlane`

`fastlane` is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).

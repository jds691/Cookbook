# Cookbook

iOS app for tracking and managing food expiry dates.

This app is built to serve my own purposes and does not guarantee stability or data integrity.

## Features

- Expriy date tracking + notification reminders
- App Intents + App Shortcuts to check expiry
- Home Screen Quick Actions
- Localisation support

In the future it is also planned to support:
- Recipe tracking
- Meal planning
- More platforms than iOS

## Building

iOS Target: iOS 18

Cookbook depends on the app group: "group.com.neo.Cookbook" in order to share its SwiftData store with App Intents.
You can create this app group in Project -> Cookbook (Target) -> Signing & Capabilities -> App Groups

You should also do the same for CookbookIntents (Target). It is intended to remove this requirement at a later date.

Cookbook requires no additional depdencencies or packages and can be built directly from Xcode.

## Contributing

I am happy enough to review pull requests, if there are any, but I cannot guarantee that I will actively review them.

I am a full time CS student and simply do not have the time to keep track of this repository.

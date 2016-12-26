describe Fastlane::Actions::UpdateBuildSettingsKeyAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:success).with("Successfully updated project")
      Fastlane::Actions::UpdateBuildSettingsKeyAction.run(
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
    end
  end
end

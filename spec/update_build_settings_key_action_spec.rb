describe Fastlane::Actions::UpdateBuildSettingsKeyAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The update_build_settings_key plugin is working!")

      Fastlane::Actions::UpdateBuildSettingsKeyAction.run(nil)
    end
  end
end

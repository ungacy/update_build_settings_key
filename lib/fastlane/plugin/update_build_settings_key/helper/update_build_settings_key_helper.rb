module Fastlane
  module Helper
    class UpdateBuildSettingsKeyHelper
      # class methods that you define here become available in your action
      # as `Helper::UpdateBuildSettingsKeyHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the update_build_settings_key plugin helper!")
      end
    end
  end
end

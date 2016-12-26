module Fastlane
  module Actions
    class UpdateBuildSettingsKeyAction < Action
      def self.run(params)
        require 'plist'
        require 'xcodeproj'

        info_plist_key = 'INFOPLIST_FILE'
        identifier_key = params[:build_settings_key]
        project_path = params[:xcodeproj]
        configuration = params[:configuration]
        map = params[:map]
        project = Xcodeproj::Project.open(project_path)
        pbxprojects = project.objects.select { |obj| obj.isa == 'PBXProject' }
        # Set ProvisioningStyle to Manual
        pbxprojects.each { |obj| obj.attributes.each { |attribute, value| value.each { |key, item| item['ProvisioningStyle'] = 'Manual' } if value.kind_of? Hash } }
        configs = project.objects.select { |obj| obj.isa == 'XCBuildConfiguration' && obj.to_s == configuration && obj.build_settings[info_plist_key] }
        UI.user_error!("Info plist uses $(#{identifier_key}), but xcodeproj does not") unless configs.count > 0
        configs = configs.select do |obj|
          info_plist_value = obj.build_settings[info_plist_key]
          !map[info_plist_value].nil?
        end
        UI.user_error!("Xcodeproj doesn't have #{configuration} with info plist #{project_path}.") unless configs.count > 0
        # For each of the build configurations, set specific profile
        configs.each do |c|
          info_plist_value = c.build_settings[info_plist_key]
          c.build_settings[identifier_key] = map[info_plist_value]
        end
        project.save
        UI.success("Successfully updated project ")
      end

      def self.description
        "Updated code signing settings from 'Automatic' to a specific profile"
      end

      def self.authors
        ["taoye"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Updated code signing settings from 'Automatic' to a specific profile"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :xcodeproj,
                                       env_name: "FL_PROJECT_SIGNING_PROJECT_PATH",
                                       description: "Path to your Xcode project",
                                       verify_block: proc do |value|
                                         UI.user_error!("Path is invalid") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :configuration,
                                       description: "name of your configuration"),
          FastlaneCore::ConfigItem.new(key: :build_settings_key,
                                       description: "key of your build setting"),
          FastlaneCore::ConfigItem.new(key: :map,
                                       type: Hash,
                                       description: "new value of your build setting in hash")
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end

module Fastlane
  module Actions
    class UpdateBuildSettingsKeyAction < Action
      def self.run(params)
        require 'plist'
        require 'xcodeproj'

        info_plist_key = 'INFOPLIST_FILE'
        build_settings_key = params[:build_settings_key]
        project_path = params[:xcodeproj]
        configuration = params[:configuration]
        map = params[:map]
        project = Xcodeproj::Project.open(project_path)
        # Set ProvisioningStyle to Manual if
        if 'PROVISIONING_PROFILE_SPECIFIER' == build_settings_key
          pbxprojects = project.objects.select { |obj| obj.isa == 'PBXProject' }
          pbxprojects.each { |obj| obj.attributes.each { |attribute, value| value.each { |key, item| item['ProvisioningStyle'] = 'Manual' } if value.kind_of? Hash } }
        end
        configs = project.objects.select { |obj| obj.isa == 'XCBuildConfiguration' && obj.to_s == configuration && obj.build_settings[info_plist_key] }
        UI.user_error!("Info plist uses $(#{build_settings_key}), but xcodeproj does not") unless configs.count > 0
        configs = configs.select do |obj|
          info_plist_value = obj.build_settings[info_plist_key]
          !map[info_plist_value].nil?
        end
        UI.user_error!("Xcodeproj doesn't have #{configuration} with info plist #{project_path}.") unless configs.count > 0
        # For each of the build configurations, set specific profile
        configs.each do |c|
          info_plist_value = c.build_settings[info_plist_key]
          c.build_settings[build_settings_key] = map[info_plist_value]
        end
        project.save
        UI.success("Successfully updated project ")
      end

      def self.description
        "Updated build settings key to a new value"
      end

      def self.authors
        ["taoye"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Updated build settings key to a new value including specific profile,\nwill Updated code signing settings from 'Automatic' to a specific profile when key is PROVISIONING_PROFILE_SPECIFIER"
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
                                       description: "name of your configuration ,such as 'Release'"),
          FastlaneCore::ConfigItem.new(key: :build_settings_key,
                                       description: "key of the build setting you want update"),
          FastlaneCore::ConfigItem.new(key: :map,
                                       type: Hash,
                                       description: "KEY is path to Info.plist , VALUE is updated value of build setting key")
        ]
      end

      def self.example_code
        [
          'update_build_settings_key(
            xcodeproj: "Demo/Demo.xcodeproj",
            configuration: "Release",
            build_settings_key: "PROVISIONING_PROFILE_SPECIFIER",
            map: {
              "Demo Watch Extension/Info.plist" => "Demo WatchKit Extension 2",
              "Demo Watch/Info.plist" => "Demo WatchKit App",
              "Demo Today/Info.plist" => "Demo Today",
              "Demo/Info.plist" => "Demo"
            }
          )'
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

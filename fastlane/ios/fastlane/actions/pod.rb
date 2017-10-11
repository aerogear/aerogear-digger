module Fastlane
  module Actions
    class PodAction < Action
      def self.run(params)
        verbose = params[:verbose]

        cmd = [
          'pod',
          'install'
        ]

        if verbose then
          cmd << ['--verbose']
        end

        Fastlane::Actions::sh(cmd, log: true)
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "OSX Keychain management"
      end

      def self.available_options 

        keychain_name = "tempkeychain"

        [
          FastlaneCore::ConfigItem.new(key: :verbose,
                                       env_name: "COCOAPODS_VERBOSE",
                                       description: "Verbose command",
                                       default_value: true,
                                       optional: true,
                                       is_string: false)
        ]
      end

      def self.authors
        "aerogear"
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end

require 'fileutils'

module Fastlane
  module Actions
    module SharedValues
      IPA_PATH = :IPA_PATH
    end

    class CodesignAction < Action
      def self.run(params)
        identity = Actions.lane_context[SharedValues::CODESIGN_IDENTITY]
        keychain_name = Actions.lane_context[SharedValues::KEYCHAIN_NAME]
        delete_keychain = Actions.lane_context[SharedValues::DELETE_KEYCHAIN]
        app_path = params[:app_path]
        config = params[:config]
        profile_path = params[:profile_path]
        ipa_path = params[:ipa_path]

        self.prepare(app_path)
        self.profile_setup(app_path, profile_path, keychain_name)
        self.sign(app_path, 'entitlements.plist', identity, keychain_name)
        self.check_signature(app_path)
        self.archive(app_path, ipa_path)

        if delete_keychain then
          Fastlane::Actions::sh("security delete-keychain #{keychain_name}")
        end

        Actions.lane_context[SharedValues::IPA_PATH] = ipa_path
      end

      def self.prepare(app_path)
        embedded_profile_path =  "#{app_path}/embedded.mobileprovision"
        app_signature_path = "#{app_path}/_CodeSignature"
        frameworks_path = "#{app_path}/Frameworks"

        File.delete(embedded_profile_path) if File.exist?(embedded_profile_path)
        FileUtils.rm_rf(app_signature_path) if Dir.exist?(app_signature_path)

        for fpath in Dir.glob("#{app_path}/*.dylib").select{ |e| File.file? e } do
          File.delete(fpath)
        end

        for fpath in Dir.glob("#{frameworks_path}/*") do
          full_path = "#{fpath}/_CodeSignature"
          FileUtils.rm_rf(full_path) if Dir.exist?(full_path) 
        end
      end

      def self.profile_setup(app_path, profile_path, keychain_name)
         UI.user_error!("Couldn't find provisioning profile in path #{profile_path}.") unless File.exist?(profile_path)

         FileUtils.cp(profile_path, "#{app_path}/embedded.mobileprovision")

         Fastlane::Actions::sh("security cms -k #{keychain_name} -D -i #{profile_path} > temp.plist", log: true)
         Fastlane::Actions::sh("/usr/libexec/PlistBuddy -x -c 'Print :Entitlements' temp.plist > entitlements.plist", log: true)

         File.delete('temp.plist')
      end

      def self.sign(app_path, entitlements_path, identity, keychain_name)
        frameworks_path = "#{app_path}/Frameworks"
        for fpath in Dir.glob("#{frameworks_path}/*") do
          Fastlane::Actions::sh("codesign -v -f -s #{identity} --keychain #{keychain_name} #{fpath}", log: true)
        end

        Fastlane::Actions::sh("codesign -v -f -s #{identity} --keychain #{keychain_name} --entitlements #{entitlements_path} #{app_path}", log: true)
      
        File.delete('entitlements.plist')
      end

      def self.check_signature(app_path)
        Fastlane::Actions::sh("codesign --verify --deep --strict --verbose=2 #{app_path}", log: true)
        Fastlane::Actions::sh("codesign -vvvv -d #{app_path}", log: true)
      end

      def self.archive(app_path, ipa_path)
        FileUtils.rm_rf('Payload') if Dir.exist?('Payload')
        FileUtils.rm_rf(ipa_path) if Dir.exist?(ipa_path)
        app_name = app_path.split('/')[-1]

        FileUtils.mkdir_p("Payload/#{app_name}")
        FileUtils.copy_entry(app_path, "Payload/#{app_name}")

        Fastlane::Actions::sh("zip -r #{ipa_path} Payload/", log: true)
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Codesign app binary"
      end

      def self.available_options 
        [
          FastlaneCore::ConfigItem.new(key: :config,
                                         env_name: "SIGN_CONFIG",
                                         description: "Codesign config, sould be either Debug or Release",
                                         default_value: 'Debug',
                                         optional: false),
          FastlaneCore::ConfigItem.new(key: :app_path,
                                         env_name: "APP_PATH",
                                         description: "App binary path to be signed",
                                         optional: false),
          FastlaneCore::ConfigItem.new(key: :profile_path,
                                         env_name: "PROFILE_PATH",
                                         description: "Mobile provisioning profile path",
                                         optional: false),
          FastlaneCore::ConfigItem.new(key: :ipa_path,
                                         env_name: "IPA_PATH",
                                         description: "IPA path to be used instead of the default one",
                                         optional: false)
        ]
      end

      def self.output
          ['IPA_PATH', 'Signed IPA file path']
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

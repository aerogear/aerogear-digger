module Fastlane
  module Actions
    module SharedValues
      CODESIGN_IDENTITY = :CODESIGN_IDENTITY
      KEYCHAIN_NAME = :KEYCHAIN_NAME
      DELETE_KEYCHAIN = :DELETE_KEYCHAIN
    end
    class KeychainAction < Action
      def self.run(params)
        keychain_name = params[:keychain_name]
        keychain_password = params[:keychain_password]
        cert_path =  params[:cert_path]
        key_path = params[:key_path]
        key_password = params[:key_password]
        delete_keychain = params[:delete_keychain]

        if !self.keychain_exists(keychain_name) then
          Fastlane::Actions.sh("security create-keychain -p #{keychain_password} #{keychain_name}", log: true)
        end

        #keychain bootstrap
        Fastlane::Actions.sh("security unlock-keychain -p #{keychain_password} #{keychain_name}", log: true)
        Fastlane::Actions.sh("security set-keychain-settings #{keychain_name}", log: true)
        Fastlane::Actions::sh("security list-keychains -d user -s #{keychain_name} login.keychain", log: true)

        #certificate bootstrap
        Fastlane::Actions::sh("security import #{cert_path} -k #{keychain_name} -t cert -A  -P  ''", log: true)
        Fastlane::Actions::sh("security import #{key_path} -k #{keychain_name} -t priv -A  -P  #{key_password}", log: true)
        Fastlane::Actions::sh("security set-key-partition-list -S 'apple-tool:,apple:' -s -k #{keychain_password} #{keychain_name}", log: true)

        #codesign identity
        identity = self.get_identity(keychain_name)
        UI.user_error!("Couldn't find a valid codesign identity.") unless identity

        Actions.lane_context[SharedValues::CODESIGN_IDENTITY] = identity
        Actions.lane_context[SharedValues::KEYCHAIN_NAME] = keychain_name
        Actions.lane_context[SharedValues::DELETE_KEYCHAIN] = delete_keychain
      end

      def self.get_keychain_list()
        return Fastlane::Actions::sh('security list-keychain -d user').split("\n")
      end

      def self.keychain_exists(name)
        for keychain in self.get_keychain_list() do
          s = keychain.strip
          keychain_db_name = name + '-db'
          if s.include?(keychain_db_name) then
            return true
          end
        end

        return false
      end

      def self.get_identity(keychain_name)
        output = Fastlane::Actions::sh("security find-identity -v -p codesigning #{keychain_name}", log:true)
        identity = output.match(/\s+\d\)\s+([a-zA-Z0-9]+)\s+/)

        if identity then
          return identity[1]
        end

        return nil
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
          FastlaneCore::ConfigItem.new(key: :keychain_name,
                                       env_name: "KEYCHAIN_NAME",
                                       description: "Keychain name to be used, will create a new one if it does not exits",
                                       default_value: keychain_name,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :keychain_password,
                                       env_name: "KEYCHAIN_PASSWORD",
                                       description: "Keychain password to be used when needed",
                                       optional: false,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :cert_path,
                                       env_name: "CERT_PATH",
                                       description: "Apple developer certificate path"),
          FastlaneCore::ConfigItem.new(key: :key_path,
                                       env_name: "KEY_PATH",
                                       description: "Apple developer private key path"),
          FastlaneCore::ConfigItem.new(key: :key_password,
                                       env_name: "KEY_PASSWORD",
                                       description: "Apple developer private key password"),
          FastlaneCore::ConfigItem.new(key: :delete_keychain,
                                       env_name: "DELETE_KEYCHAIN",
                                       description: "Boolean value to indicate if keychain should be deleted after usage",
                                       default_value: false,
                                       is_string: false)
        ]
      end

      def self.output
          ['CODESIGN_IDENTITY', 'Codesign identity for ipa generation']
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

module Fastlane
  module Actions
    module SharedValues
      ZIPALIGN_CUSTOM_VALUE = :ZIPALIGN_CUSTOM_VALUE
    end

    class ZipalignAction < Action
      def self.run(params)

       UI.user_error!("Couldn't find '*release.apk' file at path 'app/build/outputs/apk/'") unless params[:apk_path]

       apk_path = params[:apk_path]
       build_tool = params[:build_tool]
       zipalign_path = "${ANDROID_HOME}/build-tools/#{build_tool}/zipalign"

       error_callback = proc do |error|
         new_name = params[:apk_path].gsub('.apk', '-unaligned.apk')
         rename_command = ["mv -n",params[:apk_path],new_name]
         Fastlane::Actions.sh(rename_command, log: false)

         aligncmd = ["#{zipalign_path} -v -f 4", new_name , " ",  apk_path]
         Fastlane::Actions.sh(aligncmd, log: true)

         return
        end

       zipalign = Fastlane::Actions.sh("#{zipalign_path} -c -v 4 #{params[:apk_path]}", log: false , error_callback: error_callback)
    
       UI.message('Input apk is aligned')

     end 
      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Zipalign an apk. Input apk is renamed '*-unaligned.apk'"
      end

      def self.available_options

        apk_path_default = Dir["*.apk"].last || Dir[File.join("app", "build", "outputs", "apk", "*release.apk")].last

        [
          FastlaneCore::ConfigItem.new(key: :apk_path,
                                       env_name: "INPUT_APK_PATH",
                                       description: "Path to your APK file that you want to align",
                                       default_value: Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH] || apk_path_default,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :build_tool,
                                       env_name: "BUILD_TOOL",
                                       description: "Build tool version to be used during zipalign",
                                       optional: false)
        ]
      end

      def self.authors
        ["nomisRev"]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end

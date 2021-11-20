source 'https://github.com/CocoaPods/Specs.git'
source 'https://gitlab.casstime.net/app/ios/CassSpecs-iOS.git'

platform :ios, '9.0'
install! 'cocoapods', :disable_input_output_paths => true
project 'PetersLab.xcodeproj'
inhibit_all_warnings!
# 三方组件库
def third_pods
  pod 'YYKit'
  pod 'Masonry'
end
# 本地组件库
def local_pods

end


target 'PetersLab' do
  third_pods
  local_pods
end

target 'PetersLabTests' do
    pod 'Kiwi', '~> 3.0.0'
end

# Config Pod Targets config
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      deployment_target = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
      if deployment_target < '9.0'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end
end

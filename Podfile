platform :ios, '8.0'
#use_frameworks!个别需要用到它，比如reactiveCocoa
use_frameworks!
workspace ‘dddd.xcworkspace'

target :aaaa do
    project ‘aaaa/aaaa.xcodeproj'
	pod 'SDWebImage', '~> 3.7.5'
end

target :cccc do
    project ‘cccc/cccc.xcodeproj'
	pod 'Reachability'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

platform:ios,'7.0'

pod 'JSAnimatedImagesView'
pod 'BZGFormField'
pod 'TSMessages'
pod 'RESideMenu', '~> 3.4'
pod 'MBProgressHUD'
pod 'Parse-iOS-SDK'
pod 'SDWebImage'
pod 'MRProgress', '~> 0.3'
pod 'Bolts','~> 1.1.0'
pod 'SwipeView'
pod 'FaceAwareFill'
pod 'RPFloatingPlaceholders'
pod 'ASMediaFocusManager'
pod 'EAIntroView'
pod 'ReactiveCocoa'
pod 'Mantle'
pod 'TOWebViewController'
pod 'pop'


post_install do |installer|
    installer.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ARCHS'] = "armv7s armv7"
        end
    end
end
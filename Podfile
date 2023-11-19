platform :ios, '15.0'

target 'Scandocs' do
  use_frameworks!
  
  pod 'SDCameraScan', :path => 'Modules/SDCameraScan'
  pod 'SDCloudKitModel', :path => 'Modules/SDCloudKitModel'
  pod 'SDCoreKit', :path => 'Modules/SDCoreKit'
  pod 'SDDatabaseWorker', :path => 'Modules/SDDatabaseWorker'
  pod 'SDDocsOrganizer', :path => 'Modules/SDDocsOrganizer'
  pod 'SDDocumentEditor', :path => 'Modules/SDDocumentEditor'
  pod 'SDPhotosGallery', :path => 'Modules/SDPhotosGallery'
  pod 'SDScanKit', :path => 'Modules/SDScanKit'

  pod 'FirebaseAnalytics'
  pod 'FirebaseCrashlytics'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
    end
  end
end
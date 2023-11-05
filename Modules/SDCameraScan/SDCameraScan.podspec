Pod::Spec.new do |spec|
    spec.name         = "SDCameraScan"
    spec.version      = "1.0.0"
    spec.summary      = "A short summary of SDCameraScan."
    spec.description  = "A short description of SDCameraScan."
    spec.homepage     = "https://github.com/rickirby"
    spec.license      = "MIT"
    spec.author       = { "Ricki Bin Yamin" => "ricki.bin.yamin@gmail.com" }
    spec.source       = { :git => "dummy.url.link", :tag => spec.version.to_s }
  
    spec.ios.deployment_target  = '15.0'
  
    spec.source_files  = "SDCameraScan/**/*.{h,m,swift}"
    spec.exclude_files = "ExampleApps/","Pod/"
  
    spec.resource_bundles = {
      'SDCameraScan' => ['**/*.{xib,storyboard,xcassets,json}'] 
    }
    
    spec.dependency 'SDCoreKit'
    spec.dependency 'SDScanKit'
  end

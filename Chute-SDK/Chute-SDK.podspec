Pod::Spec.new do |s|
  s.name         = "Chute-SDK"
  s.version      = "2.0.0"
  s.summary      = "A short description of Chute-SDK."
  s.homepage     = "http://getchute.com"
  s.license      = {:type => 'MIT'}
  s.author       = { "Aleksandar Kex Trpeski" => "kex@getchute.com" }
  s.source       = { :git => "https://github.com/chute/Chute-SDK-v2-iOS", :tag => "2.0.0" } 
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  # s.prefix_header_file = 'Chute-SDK/Chute-SDK-Prefix.pch'
  s.source_files = 'Chute-SDK', 'Chute-SDK/**/*.{h,m,c}'
  s.frameworks = 'AssetsLibrary', 'CoreGraphics', 'QuartzCore', 'KeyValueObjectMapping'
  
#  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '"$(PODS_ROOT)/Vendor/KeyValueObjectMapping/KeyValueObjectMapping.framework"','FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/Vendor/KeyValueObjectMapping/*"' }
    
  s.dependency 'AFNetworking','~> 1.3.2'
  s.dependency 'DCKeyValueObjectMapping'
  s.dependency 'MBProgressHUD'
  s.dependency 'Lockbox'
  
end

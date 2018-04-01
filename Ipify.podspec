Pod::Spec.new do |s|
  s.name         = "Ipify"
  s.version      = "2.0.0"
  s.summary      = "Swift library for checking your IP address from ipify.org"

  s.description  = "Retrieve user's public IP address via ipify's API service."

  s.homepage     = "https://github.com/vincent-peng/swift-ipify"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author           = { 'Vincent Peng' => 'vincent@vincentpeng.me' }
  s.source           = { :git => 'https://github.com/vincent-peng/swift-ipify.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_VincentPeng'

  s.swift_version = "4.0"
  
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.10"
  s.source_files  = "Ipify/Ipify.swift"
end

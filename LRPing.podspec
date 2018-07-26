Pod::Spec.new do |s|
  s.name          =  "LRPing"
  s.summary       =  "Test the speed of the client to the alternate server."
  s.version       =  "1.0.0"
  s.homepage      =  "https://github.com/rannger/LRPing"
  s.license       =  { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author        =  { "Liang Rannger" => "liang.rannger@gmail.com" }
  s.source        =  { :git => "https://github.com/rannger/json2pb.git", :tag => "1.0.0" }
  s.ios.deployment_target     = '7.0'
  s.osx.deployment_target     = '10.8'
  s.source_files  =  'Classes/*.{h,m}'
  s.requires_arc  =  true
  s.dependency       'CocoaLumberjack'
  s.framework     =  'CFNetwork', 'CoreServices'
end

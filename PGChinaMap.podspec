
Pod::Spec.new do |s|
s.name         = "PGChinaMap"
s.version      = "0.0.1"
s.ios.deployment_target = '6.0'
s.osx.deployment_target = '10.8'
s.summary      = "Draw a map of China, support manual clicks, and select"
s.homepage     = "https://github.com/PggMan/PGChinaMap"
s.license      = "MIT"
s.author             = { "PggMan" => "pg890101@gmail.com" }
s.source       = { :git => "https://github.com/PggMan/PGChinaMap.git", :tag => s.version }
s.source_files  = 'PGChinaMap/PGChinaMap/*.{h,m}'
s.requires_arc = true
end

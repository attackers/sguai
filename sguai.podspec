
Pod::Spec.new do |s|

  s.name         = "sguai"
  s.version      = "0.0.2"
  s.summary      = "small cup"

  s.description  = <<-DESC
                   small sguai cup
			    DESC
  s.homepage     = "https://github.com/attackers/sguai"

  # s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "leaf" => "305296172@qq.com" }
  # Or just: s.author    = "leaf"
  # s.authors            = { "leaf" => "" }
  # s.social_media_url   = "http://twitter.com/leaf"

  # s.platform     = :ios
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/attackers/sguai.git", :tag => "#{s.version}" }


#s.source_files  = "sguai", "sguai/*"
s.source_files  = "sguai/SmartCupGuai1/*.{h,m}"

  #s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # s.resource  = "icon.png"
s.resources = "sguai/SmartCupGuai1/*.wav"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end

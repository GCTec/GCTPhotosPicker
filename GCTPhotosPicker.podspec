
Pod::Spec.new do |s|
  s.name         = "GCTPhotosPicker"
  s.version      = "0.0.1"
  s.summary      = "图片选择组件"
  s.description  = <<-DESC
  基于 iOS Photos 的图片选择组件：
  高度支持自定义 UI；
  支持滑动选择图片。
                   DESC

  s.homepage     = "https://github.com/GCTec/GCTPhotosPicker"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Later" => "lshxin89@126.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/GCTec/GCTPhotosPicker.git", :tag => s.version }
  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }
  s.frameworks = 'UIKit', 'Foundation','Photos'
  s.requires_arc = true

  s.public_header_files = 'GCTPhotosPicker/Classes/*.h'
  s.source_files = 'GCTPhotosPicker/Classes/*.{h,m}'
  s.resource_bundles = {
    "GCTPhotosPickerAsset" => "GCTPhotosPicker/Resource/*.xcassets"
  }
end

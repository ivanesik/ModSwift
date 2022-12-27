Pod::Spec.new do |s|
    s.name                      = 'ModSwift'
    s.version                   = '0.0.2'
    s.summary                   = 'Library to easy generate Modbus commands in Swift.'

    s.homepage                  = 'https://github.com/ivanesik/ModSwift'
    s.license                   = 'MIT'
    s.author                    = { 'ivanesik' => 'https://github.com/ivanesik' }
    s.source                    = { :git => 'https://github.com/ivanesik/ModSwift.git', :tag => s.version.to_s }
 
    s.swift_version             = '5.0'
    s.ios.deployment_target     = '11.0'
    s.osx.deployment_target     = '11.0'
    s.tvos.deployment_target    = '11.0'

    s.source_files              = 'Sources/ModSwift/**/*'
    s.dependency                'CrcSwift'
  end

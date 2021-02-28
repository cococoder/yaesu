# frozen_string_literal: true

require_relative "lib/yaesu/version"

Gem::Specification.new do |spec|
  spec.name          = "yaesu"
  spec.version       = Yaesu::VERSION
  spec.authors       = ["Coco Coder"]
  spec.email         = ["shout@cococoder.com"]

  spec.summary       = "Yaesu"
  spec.description   = "Yaesu message bus"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'ohm'
  spec.add_dependency 'ost'
  spec.add_dependency 'msgpack'
  spec.add_dependency 'uuid'
  spec.add_dependency 'sdbm'
  spec.add_dependency 'thor'
  spec.add_dependency 'terminal-table'
  
  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end

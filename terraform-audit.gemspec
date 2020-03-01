
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "terraform-audit/version"

Gem::Specification.new do |spec|
  spec.name          = "terraform-audit"
  spec.version       = TerraformAudit::VERSION
  spec.authors       = ["Thayne McCombs"]
  spec.email         = ["thayne@lucidchart.com"]

  spec.summary       = %q{Tool to list resources not managed by terraform.}
  spec.description   = %q{This compares your actual infrastructure to the terraform
  state to find resources that aren't managed by terraform, but should be.
  This DOES NOT generate terraform config for or delete unmanaged resources, it just
  reports them.
  At the moment, only AWS resources are supported.}
  #spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-rds", "~> 1.78"

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0"
end

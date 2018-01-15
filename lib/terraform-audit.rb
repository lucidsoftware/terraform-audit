require "terraform-audit/version"
require "terraform-audit/state"
require "terraform-audit/aws"
require "terraform-audit/config"

module TerraformAudit
  def self.run(options)
    config = Config.new
    if options[:config_file]
      config.load(options[:config_file])
    end

    state = if options[:state_file]
              open(options[:state_file]) do |f|
                State.new(f)
              end
            else
              IO.popen(["terraform", "state", "pull"]) do |f|
                State.new(f)
              end
            end

    aws_reporter = AwsReporter.new($stdout, config.ignore_rules, config.aws_config)
    aws_reporter.report(state)
  end
end

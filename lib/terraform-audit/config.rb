module TerraformAudit
  class Config
    attr_reader :aws_config, :ignore_rules

    def initialize
      @aws_config = {}
      @ignore_rules = Hash.new { |h, k| h[k] = [] }
    end

    # Set the configuration for the AWS client
    #
    # +config+ should be an object suitable to pass as the options to create an
    # AWS client from the AWS SDK.
    def configure_aws(config)
      raise TypeError, "AWS config must be hash" unless config.is_a?(Hash)
      @aws_config = config
    end

    # Ignore all resources of a given type
    def ignore_resource_type(type)
      @ignore_rules[type] = "*"
    end

    # Ignore resources for a given typ that matche one or more patterns.
    # The patterns are strings that are matched as case-insensitive glob
    # patterns.
    def ignore_resources(type, *patterns)
      @ignore_rules[type] += patterns
    end

    # Set the ignore pattern(s) for a resource type.
    #
    # This overwrites any existing ignore rules for that type.
    # +pattern+ should be either a single string, or an array of strings with
    # the pattern(s) to ignore.
    def set_resource_ignore_pattern(type, pattern)
      raise TypeError "Ignore pattern must be a string or an array" unless pattern.is_a?(String) || pattern.is_a?(Array)
      @ignore_rules[type] = pattern
    end

    def load(path)
      instance_eval(File.read(path), path)
    end
  end
end

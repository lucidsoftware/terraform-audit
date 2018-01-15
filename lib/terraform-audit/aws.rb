require 'terraform-audit/auditor'

require 'terraform-audit/aws/rds'

module TerraformAudit
  class AwsReporter < Reporter
    def initialize(stream, ignore_rules = {}, config = {})
      super stream, ignore_rules
      @config = config
    end

    protected
    Auditors = [RdsAuditor]

    def construct(clazz)
      clazz.new(@config)
    end

  end
end

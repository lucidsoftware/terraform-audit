require 'terraform-audit/auditor'
require 'aws-sdk-rds'
require 'set'

module TerraformAudit
  class RdsAuditor < Auditor
    # Create the Rds Auditor.
    #
    # +rds_options+ are options passed through to the AWS client.
    def initialize(rds_options = {})
      @rds = Aws::RDS::Resource.new(rds_options)
    end
    def self.type
      "aws_rds_cluster"
    end

    def audit(clusters, state)
      @rds.db_clusters().map { |c| c.id } - clusters.map { |c| c['attributes']['cluster_identifier'] }
    end
  end
end

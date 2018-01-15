require 'json'

module TerraformAudit
  class State
    def initialize(state_source)
      data = JSON.load(state_source)
      ingest_data(data)
    end

    def resources(type)
      @resources.fetch(type, [])
    end

    private
    def ingest_data(data)
      @resources = Hash.new { |h, k| h[k] = [] }
      data.fetch("modules").each do |m|
        m.fetch("resources").each do |_, resource|
          @resources[resource.fetch("type")] << resource.fetch("primary")
        end
      end
    end
  end

end

module TerraformAudit
  class Auditor
    # This should return a string containing the type resources
    # this audits
    def self.type
      raise NotImplementedError
    end
    # Audits a type of resource.
    #
    # === Arguments
    # [+resources+] An array of json objects for each resource of the type returned by +type+.
    # [+state+]     The +State+ object, which can be used to get data about resources of other types.
    #
    # === Returns
    # An array of strings describing the resources that aren't managed.
    def audit(resources, state)
      raise NotImplementedError
    end
  end

  class Reporter
    # Create a new Reporter
    #
    # === Arguments
    # [+stream+] The stream to right the report to
    # [+ignore_rules+] A Hash mapping a resource type to a blacklist of
    # ids to ignore for that resources. Each blacklist can either be a single
    # string, or an array of strings. Each such string is treated as a case-insensitive
    # glob pattern.
    #
    def initialize(stream = $stdout, ignore_rules = {})
      @stream = stream
      @ignore_rules = ignore_rules
    end

    # Run audits for the report, write the report
    # to the stream, and return the number of unmanaged resources.
    def report(state)
      count = 0
      self.class::Auditors.each do |audit|
        type = audit.type
        ignore_rule = @ignore_rules.fetch(type, [])
        next if ignore_rule == "*"
        auditor = construct(audit)

        unmanaged = []
        ignore_count = 0
        auditor.audit(state.resources(type), state).each do |id|
          if ignored?(id, ignore_rule)
            ignore_count += 1
          else
            unmanaged << id
          end
        end
        audit_report(type, unmanaged, ignore_count)
        count += unmanaged.size
      end
      count
    end

    protected
    Auditors = []

    def construct(clazz)
      clazz.new
    end

    def ignored?(id, rule)
      if rule.nil?
        false
      elsif rule.instance_of?(String)
        glob_match?(rule, id)
      else
        rule.any? { |pattern| glob_match?(pattern, id) }
      end
    end

    def glob_match?(pattern, s)
      File.fnmatch?(pattern, s, File::FNM_DOTMATCH | File::FNM_CASEFOLD)
    end

    def audit_report(type, unmanaged, ignored)
        unless unmanaged.empty?
          @stream.puts "Unmanaged #{type} resources:"
          unmanaged.each do |id|
            @stream.puts "\t#{id}"
          end
        else
          @stream.puts "No unmanaged #{type} resources."
        end
        @stream.puts "\t#{ignored} resources ignored." unless ignored == 0
    end
  end
end

# terraform-audit

`terraform-audit` is a tool that supplements [Terraform](https://www.terraform.io/) by finding resources in your cloud infrastructure that aren't managed
by Terraform, but should be.

Currently it only supports some types of AWS resources, but adding additional resource types is easy and pull requests are welcome.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'terraform-audit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install terraform-audit

## Usage

The simplist usage is simply to run `terraform-audit` from your terraform configuration directory. This will use `terraform state pull` to get the current state, then compare the to your AWS infrastructure, and list
identifiers for any resources that are in AWS but not in your terraform state.

Additionally, the following options are supported:

* `-s`, `--state`: Specify a terraform state file to use instead of running `terraform state pull`. This could be a terraform.tfstate file, or a file retrieved from a previous call to `terraform state pull`.
* `-c`, `--config`: Specify a configuration file. See [Configuration](#configuration)

### Configuration

If a `tfaudit.rb` file exists in the working directory (or the `--config` option is used), that is used to configure `terraform-audit`.

The configuration file is a standard ruby file, with the following functions provided:

* `configure_aws(options)`: This takes a hash of configuration options to use when creating AWS clients. See the [AWS SDK Documentation](https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html) for details.
* `ignore_resources(type, *patterns)`: This takes a resource type (ex. `aws_rds_cluster`) and a list of exclusion rules which are case-insensitive glob patterns for identifiers to ignore. This can be called multiple times, and each list of patterns is added to the final list.
* `ignore_resource_type(type)`: This specifies that a given resource type should be ignored altogether.
* `set_resource_ignore_pattern(type, pattern)`: Overwrites the ignore pattern for a resource type. `pattern` can be a single string or an array of strings for the pattern to ignore.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, tag the commit with the same version, then push. Travis will automatically release to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/terraform-audit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Terraform::Audit project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lucidsoftware/terraform-audit/blob/master/CODE_OF_CONDUCT.md).

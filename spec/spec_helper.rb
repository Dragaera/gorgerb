require 'gorgerb'

RSpec.configure do |config|
  config.before :each do
    Typhoeus::Expectation.clear
  end

  config.expect_with :rspec do |expectations|
    # RSpec 4
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Disallow mocking/stubbing nonexistant methods
    mocks.verify_partial_doubles = true
  end

  # RSpec 4
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # RSpec persistance
  config.example_status_persistence_file_path = 'spec/examples.txt'

  # Run tagged examples only if any are tagged.
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!

  config.warnings = true

  # Profile examples
  config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed
end

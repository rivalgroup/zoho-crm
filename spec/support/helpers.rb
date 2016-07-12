module Helpers
  def fixture(name)
    File.read("spec/support/fixtures/#{name}")
  end
end

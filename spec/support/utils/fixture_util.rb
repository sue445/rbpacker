# frozen_string_literal: true

module FixtureUtil
  def fixture(file)
    fixtures_dir.join(file).read
  end
end

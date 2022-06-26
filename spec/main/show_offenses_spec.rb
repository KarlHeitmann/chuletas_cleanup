# frozen_string_literal: true

require 'main'
require 'json'

RSpec.describe 'method showOffenses' do
  def loadFixture(fixture)
    json = File.read(['spec/fixtures/results', fixture].join('/'))
    JSON.parse(json)
  end
  let (:results) {
    [
      {
        "lib/main.rb"=>
          {"puts"=>6}
      },
      {
        "spec/main/show_offenses_spec.rb"=>
        {
          "HACK_ME"=>2,
          "puts"=>1,
          "XXX_ME"=>1
        }
      }
    ]
  }
  it "returns a string message with detailed an human readable string telling which are the offenses" do
    expect(showOffenses(results)).to eq(<<-RESPONSE
OFFENSES:
  lib/main.rb
    puts 6
  spec/main/show_offenses_spec.rb
    HACK_ME 2
    puts 1
    XXX_ME 1
    RESPONSE
                                       )
  end
end


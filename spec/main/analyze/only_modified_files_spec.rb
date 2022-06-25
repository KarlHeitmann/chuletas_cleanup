# frozen_string_literal: true

require 'main'
require 'json'

RSpec.describe 'method analyze with only modified files' do
  def loadFixture(fixture)
    json = File.read(['spec/fixtures/data', fixture].join('/'))
    JSON.parse(json)
  end

  let(:file_no_offenses) do
    loadFixture('prueba.rb_diff.json')
  end
  let(:file_with_offenses) do
    loadFixture('prueba.rb_diff_hack_me.json')
  end
  it 'returns empty array on no offenses' do
    expect(analyze(file_no_offenses)).to eq({})
  end
  it 'returns empty array on no offenses' do
    expect(analyze(file_with_offenses)).to eq({ 'HACK_ME' => 1 })
  end
end

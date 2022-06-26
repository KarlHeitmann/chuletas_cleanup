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
  let(:file_with_offenses_adds_substracts) do
    loadFixture('adds_substracts_diff.json')
  end
  let(:file_with_no_offenses_only_substracts) do
    loadFixture('only_substracts_diff.json')
  end
  it 'returns empty hash on no offenses' do
    expect(analyze(file_no_offenses)).to eq({})
  end
  it 'returns array counts the offenses' do
    expect(analyze(file_with_offenses)).to eq({ 'HACK_ME' => 1 })
  end
  it 'returns array counts the offenses, more complex diff with adds and subtracts' do
    expect(analyze(file_with_offenses_adds_substracts)).to eq({ 'puts' => 6 })
  end
  it 'returns empty hash on no offenses, more complex diff with adds and subtracts' do
    expect(analyze(file_with_no_offenses_only_substracts)).to eq({})
  end
end

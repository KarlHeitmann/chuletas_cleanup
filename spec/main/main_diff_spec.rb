# frozen_string_literal: true

require 'main'

RSpec.describe 'mainDiff' do
  let(:response) { "prueba.rb\nprueba3.rb\n".split("\n") }
  let(:cmd) { 'git diff --cached --name-only --diff-filter=ACM'.split }
  let(:io) { IOUtils.new }
  before :each do
    allow(io).to receive(:getCmdData).with(cmd).and_return(response)
  end
  it 'returns the correct array of files changed' do
    expect(mainDiff(io)).to eq(response)
  end
end

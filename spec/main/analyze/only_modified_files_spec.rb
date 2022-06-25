# frozen_string_literal: true

require 'main'

RSpec.describe 'method analyze with only modified files' do
  let(:file_no_offenses) do
    [
      'diff --git a/prueba.rb b/prueba.rb',
      'index 9058067e02..33f9fe0eb3 100644',
      '--- a/prueba.rb',
      '+++ b/prueba.rb',
      '@@ -7,0 +8,2 @@ end',
      '+"bla bla"',
      '+'
    ]
  end
  let(:file_with_offenses) do
    [
      'diff --git a/prueba.rb b/prueba.rb',
      'index 9058067e02..33f9fe0eb3 100644',
      '--- a/prueba.rb',
      '+++ b/prueba.rb',
      '@@ -7,0 +8,2 @@ end',
      '+"bla bla" # HACK_ME',
      '+'
    ]
  end
  it 'returns empty array on no offenses' do
    expect(analyze(file_no_offenses)).to eq({})
  end
  it 'returns empty array on no offenses' do
    expect(analyze(file_with_offenses)).to eq({ 'HACK_ME' => 1 })
  end
end

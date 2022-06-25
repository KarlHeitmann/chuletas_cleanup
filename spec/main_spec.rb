require 'main'

RSpec.describe 'main' do
  describe 'mainDiff' do
    let (:response) { "prueba.rb\nprueba3.rb\n".split("\n") }
    let (:cmd) { "git diff --cached --name-only --diff-filter=ACM".split(" ") }
    let (:io) { IOUtils.new }
    before :each do
      allow(io).to receive(:getCmdData).with(cmd).and_return(response)
    end
    it "returns the correct array of files changed" do
      expect(mainDiff(io)).to eq(response)
    end
  end
  describe 'analyze' do
    context 'only with modified files' do
      let (:file_no_offenses) {
        [
          'diff --git a/prueba.rb b/prueba.rb',
          'index 9058067e02..33f9fe0eb3 100644',
          '--- a/prueba.rb',
          '+++ b/prueba.rb',
          '@@ -7,0 +8,2 @@ end',
          '+"bla bla"',
          '+'
        ]
      }
      let (:file_with_offenses) {
        [
          'diff --git a/prueba.rb b/prueba.rb',
          'index 9058067e02..33f9fe0eb3 100644',
          '--- a/prueba.rb',
          '+++ b/prueba.rb',
          '@@ -7,0 +8,2 @@ end',
          '+"bla bla" # HACK_ME',
          '+'
        ]
      }
      it 'returns empty array on no offenses' do
        expect(analyze(file_no_offenses)).to eq({})
      end
      it 'returns empty array on no offenses' do
        expect(analyze(file_with_offenses)).to eq({"HACK_ME" => 1})
      end
    end
  end
end

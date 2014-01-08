require 'spec_helper'
require 'yaml'

module Patentscope

  describe 'WIPO supplied test suite', :more, :vcr do

    before(:all) do
      Patentscope.configure_from_env
    end

    let(:webservice) { Webservice.new }

    after(:all) do
      Patentscope.reset_configuration
    end

    context 'International Application numbers' do

      File.open(File.join(File.dirname(__FILE__), *%w[wipo_test_suite_ia_number_examples.yaml])) do |file|
        examples = YAML.load(file)
        examples['passes'].each do |e|
          it "get_iasr of #{e['ia_number']} includes title #{e["title"]}" do
            iasr_xml = webservice.get_iasr(ia_number: e["ia_number"])
            expect(iasr_xml).to include(e["title"])
          end
        end
      end
    end

    context 'Document IDs' do

      File.open(File.join(File.dirname(__FILE__), *%w[wipo_test_suite_doc_id_examples.yaml])) do |file|
        examples = YAML.load(file)
        examples['passes'].each do |e|
          it "get_document_table_of_contents of #{e['doc_id']} includes #{e["signature"]}" do
            iasr_xml = webservice.get_document_table_of_contents(doc_id: e["doc_id"])
            expect(iasr_xml).to include(e["signature"])
          end
        end
      end
    end
  end
end

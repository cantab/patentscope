require 'spec_helper'

module Patentscope

  describe PctAppNumber, :core do

    let(:pct_app_number) { PctAppNumber.new }

    describe "methods" do
      it "has the right methods" do
        expect(pct_app_number).to respond_to(:valid?)
        expect(pct_app_number).to respond_to(:validate)
        expect(pct_app_number).to respond_to(:to_ia_number)
      end
    end

    describe "valid? validate methods" do

      describe "application numbers in acceptable format" do

        describe "country, year and number run on" do
          let(:pct_app_number) { PctAppNumber.new('SG2012000001') }

          it "is valid" do
            expect(pct_app_number).to be_valid
          end

          it "validates" do
            expect { pct_app_number.validate }.to_not raise_error
          end
        end

        describe "year and number run on separated by a slash" do
          let(:pct_app_number) { PctAppNumber.new('SG2012/000001') }

          it "is valid" do
            expect(pct_app_number).to be_valid
          end

          it "validates" do
            expect { pct_app_number.validate }.to_not raise_error
          end
        end

        describe "leading space before application number" do
          let(:pct_app_number) { PctAppNumber.new(' SG2012000001') }

          it "is valid" do
            expect(pct_app_number).to be_valid
          end

          it "validates" do
            expect { pct_app_number.validate }.to_not raise_error
          end
        end

        describe "trailing space after application number" do
          let(:pct_app_number) { PctAppNumber.new('SG2012000001 ') }

          it "is valid" do
            expect(pct_app_number).to be_valid
          end

          it "validates" do
            expect { pct_app_number.validate }.to_not raise_error
          end
        end

        describe "non-existent applications" do
          let(:pct_app_number) { PctAppNumber.new('SG2012999999') }

          it "is valid even when application doesn't exist" do
            expect(pct_app_number).to be_valid
          end

          it "validates" do
            expect { pct_app_number.validate }.to_not raise_error
          end
        end

        describe "application number prefixed with PCT" do
          let(:pct_app_number) { PctAppNumber.new('PCTSG2012000001') }

          it "is valid" do
            expect(pct_app_number).to be_valid
          end

          it "validates" do
            expect { pct_app_number.validate }.to_not raise_error
          end
        end

        describe "application number prefixed with PCT/" do
          let(:pct_app_number) { PctAppNumber.new('PCT/SG2012000001') }

          it "is valid" do
            expect(pct_app_number).to be_valid
          end

          it "validates" do
            expect { pct_app_number.validate }.to_not raise_error
          end
        end

        describe "application number prefixed with PCT/, slash between year and number" do
          let(:pct_app_number) { PctAppNumber.new('PCT/SG2012/000001') }

          it "is valid" do
            expect(pct_app_number).to be_valid
          end

          it "validates" do
            expect { pct_app_number.validate }.to_not raise_error
          end
        end

        describe "lowercase" do
          let(:pct_app_number) { PctAppNumber.new('pct/sg2012/000001') }

          it "is valid" do
            expect(pct_app_number).to be_valid
          end

          it "validates" do
            expect { pct_app_number.validate }.to_not raise_error
          end
        end

        describe "mixed case" do
          let(:pct_app_number) { PctAppNumber.new('pCt/sG2012000001') }

          it "is valid" do
            expect(pct_app_number).to be_valid
          end

          it "validates" do
            expect { pct_app_number.validate }.to_not raise_error
          end
        end
      end

      describe "application numbers not in acceptable format" do

        describe "no application number" do
          let(:pct_app_number) { PctAppNumber.new('') }

          it "is not valid" do
            expect(pct_app_number).to_not be_valid
          end

          it "does not validate" do
            expect { pct_app_number.validate }.to raise_error
          end
        end

        describe "blank application number" do
          let(:pct_app_number) { PctAppNumber.new('   ') }

          it "is not valid" do
            expect(pct_app_number).to_not be_valid
          end

          it "does not validate" do
            expect { pct_app_number.validate }.to raise_error
          end
        end

        describe "incorrectly formatted application numbers" do

          describe "application number is too short" do
            let(:pct_app_number) { PctAppNumber.new('SG201200001') }

            it "is not valid" do
              expect(pct_app_number).to_not be_valid
            end

            it "does not validate" do
              expect { pct_app_number.validate }.to raise_error
            end
          end

          describe "application number is too long" do
            let(:pct_app_number) { PctAppNumber.new('SG20120000011') }

            it "is not valid" do
              expect(pct_app_number).to_not be_valid
            end

            it "does not validate" do
              expect { pct_app_number.validate }.to raise_error
            end
          end

          describe "application number contains non-digits" do
            let(:pct_app_number) { PctAppNumber.new('SG2012A00001') }

            it "is not valid" do
              expect(pct_app_number).to_not be_valid
            end

            it "does not validate" do
              expect { pct_app_number.validate }.to raise_error
            end
          end

          describe "application number has more than one slash" do
            let(:pct_app_number) { PctAppNumber.new('SG2012//000001') }

            it "is not valid" do
              expect(pct_app_number).to_not be_valid
            end

            it "does not validate" do
              expect { pct_app_number.validate }.to raise_error
            end
          end
        end
      end
    end

    describe "to_ia_number method" do
      context "uppercase letters" do
        it "converts to an ia_number" do
          expect(PctAppNumber.new('SG2012000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('SG2012/000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('PCTSG2012000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('PCT/SG2012000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('PCTSG2012/000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('PCT/SG2012/000001').to_ia_number).to eq('SG2012000001')
        end
      end

      context "lowercase letters" do
        it "converts to an ia_number" do
          expect(PctAppNumber.new('sg2012000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('sg2012/000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('pctsg2012000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('pct/sg2012000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('pctsg2012/000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('pct/sg2012/000001').to_ia_number).to eq('SG2012000001')
        end
      end

      context "mixed case letters" do
        it "converts to an ia_number" do
          expect(PctAppNumber.new('sG2012000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('sG2012/000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('pCtsG2012000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('pCt/sG2012000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('pCtsG2012/000001').to_ia_number).to eq('SG2012000001')
          expect(PctAppNumber.new('pCt/sG2012/000001').to_ia_number).to eq('SG2012000001')
        end
      end
    end
  end
end

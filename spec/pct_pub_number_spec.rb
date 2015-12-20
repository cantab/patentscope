require 'spec_helper'

module Patentscope

  describe PctPubNumber, :core do

    let(:pct_pub_number) { PctPubNumber.new }

    describe "methods" do
      it "has the right methods" do
        expect(pct_pub_number).to respond_to(:valid?)
        expect(pct_pub_number).to respond_to(:validate)
      end
    end

    describe "valid? validate methods" do

      describe "publication numbers in acceptable format" do

        describe "prefix, year and number run on" do
          let(:pct_pub_number) { PctPubNumber.new('WO2009105044') }

          it "is valid" do
            expect(pct_pub_number).to be_valid
          end

          it "validates" do
            expect { pct_pub_number.validate }.to_not raise_error()
          end
        end

        describe "year and number separated by a slash" do
          let(:pct_pub_number) { PctPubNumber.new('WO2009/105044') }

          it "is valid" do
            expect(pct_pub_number).to be_valid
          end

          it "validates" do
            expect { pct_pub_number.validate }.to_not raise_error
          end
        end

        describe "prefix and year and year and number separated by slashes" do
          let(:pct_pub_number) { PctPubNumber.new('WO/2009/105044') }

          it "is valid" do
            expect(pct_pub_number).to be_valid
          end

          it "validates" do
            expect { pct_pub_number.validate }.to_not raise_error
          end
        end

        describe "leading space before application number" do
          let(:pct_pub_number) { PctPubNumber.new(' WO2009105044') }

          it "is valid" do
            expect(pct_pub_number).to be_valid
          end

          it "validates" do
            expect { pct_pub_number.validate }.to_not raise_error
          end
        end

        describe "trailing space after application number" do
          let(:pct_pub_number) { PctPubNumber.new('WO2009105044 ') }

          it "is valid" do
            expect(pct_pub_number).to be_valid
          end

          it "validates" do
            expect { pct_pub_number.validate }.to_not raise_error
          end
        end

        describe "non-existent applications" do
          let(:pct_pub_number) { PctPubNumber.new('WO2009999999') }

          it "is valid even when application doesn't exist" do
            expect(pct_pub_number).to be_valid
          end

          it "validates" do
            expect { pct_pub_number.validate }.to_not raise_error
          end
        end

        describe "space before year, no slash" do
          let(:pct_pub_number) { PctPubNumber.new('WO 2009105044') }

          it "is valid" do
            expect(pct_pub_number).to be_valid
          end

          it "does validates" do
            expect { pct_pub_number.validate }.to_not raise_error
          end
        end

        describe "space before year, with slash" do
          let(:pct_pub_number) { PctPubNumber.new('WO 2009/105044') }

          it "is valid" do
            expect(pct_pub_number).to be_valid
          end

          it "does validates" do
            expect { pct_pub_number.validate }.to_not raise_error
          end
        end

        describe "lowercase" do
          let(:pct_pub_number) { PctPubNumber.new('wo 2009/105044') }

          it "is valid" do
            expect(pct_pub_number).to be_valid
          end

          it "does validates" do
            expect { pct_pub_number.validate }.to_not raise_error
          end
        end

        describe "mixed case" do
          let(:pct_pub_number) { PctPubNumber.new('wO 2009/105044') }

          it "is valid" do
            expect(pct_pub_number).to be_valid
          end

          it "does validates" do
            expect { pct_pub_number.validate }.to_not raise_error
          end
        end
      end

      describe "publication numbers not in acceptable format" do

        describe "no application number" do
          let(:pct_pub_number) { PctPubNumber.new('') }

          it "is not valid" do
            expect(pct_pub_number).to_not be_valid
          end

          it "does not validate" do
            expect { pct_pub_number.validate }.to raise_error(Patentscope::WrongNumberFormatError)
          end
        end

        describe "blank application number" do
          let(:pct_pub_number) { PctPubNumber.new('   ') }

          it "is not valid" do
            expect(pct_pub_number).to_not be_valid
          end

          it "does not validate" do
            expect { pct_pub_number.validate }.to raise_error(Patentscope::WrongNumberFormatError)
          end
        end

        describe "incorrectly formatted application numbers" do

          describe "application number is too short" do
            let(:pct_pub_number) { PctPubNumber.new('WO200910504') }

            it "is not valid" do
              expect(pct_pub_number).to_not be_valid
            end

            it "does not validate" do
              expect { pct_pub_number.validate }.to raise_error(Patentscope::WrongNumberFormatError)
            end
          end

          describe "application number is too long" do
            let(:pct_pub_number) { PctPubNumber.new('WO20091050449') }

            it "is not valid" do
              expect(pct_pub_number).to_not be_valid
            end

            it "does not validate" do
              expect { pct_pub_number.validate }.to raise_error(Patentscope::WrongNumberFormatError)
            end
          end

          describe "application number contains non-digits" do
            let(:pct_pub_number) { PctPubNumber.new('WO2009A05044') }

            it "is not valid" do
              expect(pct_pub_number).to_not be_valid
            end

            it "does not validate" do
              expect { pct_pub_number.validate }.to raise_error(Patentscope::WrongNumberFormatError)
            end
          end

          describe "application number has too many slashes" do
            let(:pct_pub_number) { PctPubNumber.new('WO//2009/105044') }

            it "is not valid" do
              expect(pct_pub_number).to_not be_valid
            end

            it "does not validate" do
              expect { pct_pub_number.validate }.to raise_error(Patentscope::WrongNumberFormatError)
            end
          end
        end
      end
    end
  end
end

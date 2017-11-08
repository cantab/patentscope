require 'spec_helper'

module Patentscope

  describe Configuration, :core do

    describe 'instance methods' do

      it 'has a username instance method' do
        expect(Configuration.new).to respond_to(:username)
      end

      it 'has a password instance method' do
        expect(Configuration.new).to respond_to(:password)
      end
    end

    describe 'initialize' do

      let(:configuration) { Configuration.new }

      describe 'default values' do

        it 'username is blank' do
          expect(configuration.username).to eq('')
        end

        it 'password is blank' do
          expect(configuration.password).to eq('')
        end
      end
    end
  end

  describe Patentscope, :core, :vcr do

    before(:each) do
      Patentscope.reset_configuration
    end

    after(:each) do
      Patentscope.configure_from_env
    end

    describe 'class methods' do

      it 'has configure class method' do
        expect(Patentscope).to respond_to(:configure)
      end

      it 'has configure_from_env class method' do
        expect(Patentscope).to respond_to(:configure_from_env)
      end

      it 'has configured? class method' do
        expect(Patentscope).to respond_to(:configured?)
      end

      it 'has reset_configuration class method' do
        expect(Patentscope).to respond_to(:reset_configuration)
      end
    end

    it 'has an class level accessor to the configuration instance' do
      expect(Patentscope).to respond_to(:configuration)
    end

    describe 'unconfigured' do

      describe 'configuration state' do

        it 'is not configured' do
          expect(Patentscope.configured?).to be false
        end

        it 'configuration object is nil' do
          expect(Patentscope.configuration).to be_nil
        end
      end

      describe 'behaviours when called' do

        it 'raises an error when trying to access username' do
          expect do
            Patentscope.configuration.username
          end.to raise_error(NoMethodError)
        end

        it 'raises an error when trying to access password' do
          expect do
            Patentscope.configuration.password
          end.to raise_error(NoMethodError)
        end

        it 'raises an error during client operations' do
          expect do
            Webservice.new.get_iasr(ia_number: 'SG2009000062')
          end.to raise_error(Patentscope::NoCredentialsError)
        end
      end
    end

    describe 'Patentscope.configure' do

      context 'Patentscope.configure called but no credentials given in block' do

        before { Patentscope.configure }

        describe 'configuration state' do

          it 'is configured' do
            expect(Patentscope.configured?).to be true
          end

          it 'configuration object exists' do
            expect(Patentscope.configuration).to_not be_nil
          end

          it 'username defaults to null string if not explicitly set in the configure block' do
            expect(Patentscope.configuration.username).to eq('')
          end

          it 'password defaults to null string if not explicitly set in the configure block' do
            expect(Patentscope.configuration.password).to eq('')
          end
        end

        describe 'behaviours when called' do

          it 'does not raise an error when trying to access username' do
            expect do
              Patentscope.configuration.username
            end.to_not raise_error
          end

          it 'does not raise an error when trying to access password' do
            expect do
              Patentscope.configuration.password
            end.to_not raise_error
          end

          it 'raises an error during client operations' do
            expect do
              Webservice.new.get_iasr(ia_number: 'SG2009000062')
            end.to raise_error(Patentscope::WrongCredentialsError)
          end
        end
      end

      context 'Patentscope.configure called with credentials set in block' do

        before(:each) do
          Patentscope.configure do |config|
            config.username     = 'joe_bloggs'
            config.password     = 'b10ggsy'
          end
        end

        it 'configures the username' do
          expect(Patentscope.configuration.username).to eq('joe_bloggs')
        end

        it 'configures the password' do
          expect(Patentscope.configuration.password).to eq('b10ggsy')
        end
      end
    end

    describe 'Patentscope.configure_from_env"'do

      context 'with no existing configuration' do

        it 'loading operation succeeds' do
          expect(Patentscope.configure_from_env).to be true
        end

        describe 'loads configurations from environment variables' do

          before do
            ENV['PATENTSCOPE_WEBSERVICE_USERNAME'] = 'joe_bloggs'
            ENV['PATENTSCOPE_WEBSERVICE_PASSWORD'] = 'b10ggsy'
            Patentscope.configure_from_env
          end

          it 'loads the username' do
            expect(Patentscope.configuration.username).to eq('joe_bloggs')
          end

          it 'loads the password' do
            expect(Patentscope.configuration.password).to eq('b10ggsy')
          end
        end
      end

      context 'with an existing configuration already loaded' do

        before do
          ENV['PATENTSCOPE_WEBSERVICE_USERNAME'] = 'foo'
          ENV['PATENTSCOPE_WEBSERVICE_PASSWORD'] = 'bar'
          Patentscope.configure_from_env
        end

        it 'loading operation fails' do
          expect(Patentscope.configure_from_env).to be false
        end

        describe 'does not load configurations from environment variables' do

          before do
            ENV['PATENTSCOPE_WEBSERVICE_USERNAME'] = 'joe_bloggs'
            ENV['PATENTSCOPE_WEBSERVICE_PASSWORD'] = 'b10ggsy'
            Patentscope.configure_from_env
          end

          it 'keeps the already configured username' do
            expect(Patentscope.configuration.username).to eq('foo')
          end

          it 'keeps the already configured password' do
            expect(Patentscope.configuration.password).to eq('bar')
          end
        end
      end
    end
  end
end

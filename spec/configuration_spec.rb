require 'spec_helper'

module Patentscope

  describe Patentscope do

    it 'has a configure class method' do
      expect(Patentscope).to respond_to(:configure)
    end

    it 'has a configure_from_env class method' do
      expect(Patentscope).to respond_to(:configure_from_env)
    end

    it 'has a configured? class method' do
      expect(Patentscope).to respond_to(:configured?)
    end

    it 'has a reset_configuration class method' do
      expect(Patentscope).to respond_to(:reset_configuration)
    end

    it 'has a configuration class method' do
      expect(Patentscope).to respond_to(:configuration)
    end
  end

  describe 'Patentscope::Configuration class' do

    it 'has a username instance method' do
      expect(Patentscope::Configuration.new).to respond_to(:username)
    end

    it 'has a password instance method' do
      expect(Patentscope::Configuration.new).to respond_to(:password)
    end
  end

  describe 'Patentscope before configuration' do

    before { Patentscope.reset_configuration }

    it 'configuration object is nil if configure not called' do
      expect(Patentscope.configuration).to be_nil
    end

    it 'is not configured' do
      expect(Patentscope.configured?).to be_falsey
    end

    it 'raises an error during client operations' do
      expect do
        Webservice.new.get_iasr(ia_number: 'SG2009000062')
      end.to raise_error(Patentscope::NoCredentialsError)
    end
  end

  describe 'Patentscope with configuration but no specific credentials given' do

    before { Patentscope.reset_configuration }

    it 'username defaults to null string if not explicitly set in the configure block' do
      Patentscope.configure
      expect(Patentscope.configuration.username).to eq('')
    end

    it 'password defaults to null string if not explicitly set in the configure block' do
      Patentscope.configure
      expect(Patentscope.configuration.password).to eq('')
    end

    it 'raises an error during client operations' do
      expect do
        Webservice.new.get_iasr(ia_number: 'SG2009000062')
      end.to raise_error(Patentscope::NoCredentialsError)
    end
  end

  describe 'Patentscope with configuration using configuration block' do

    before do
      Patentscope.configure do |config|
        config.username     = 'joe_bloggs'
        config.password     = 'b10ggsy'
      end
    end

    after(:each) do
      Patentscope.reset_configuration
    end

    it 'configures the username and password in a block in the configure method' do
      expect(Patentscope.configuration.username).to eq('joe_bloggs')
      expect(Patentscope.configuration.password).to eq('b10ggsy')
    end
  end

  describe "Patentscope with configuration loading from environment variables" do

    after(:each) do
      Patentscope.reset_configuration
    end

    describe 'where a configuration has already been set' do
      before do
        Patentscope.configure do |config|
          config.username     = 'joe_bloggs'
          config.password     = 'b10ggsy'
        end
      end

      it 'loading operation fails' do
        expect(Patentscope.configure_from_env).to be false
      end

      it 'does not overwrite existing configuration' do
        expect(Patentscope.configuration.username).to eq('joe_bloggs')
        expect(Patentscope.configuration.password).to eq('b10ggsy')

        expect(Patentscope.configuration.username).to_not eq(ENV['PATENTSCOPE_WEBSERVICE_USERNAME'])
        expect(Patentscope.configuration.password).to_not eq(ENV['PATENTSCOPE_WEBSERVICE_PASSWORD'])
      end
    end

    describe 'where there is no existing configuration' do

      it 'loading operation succeeds' do
        expect(Patentscope.configure_from_env).to be true
      end

      it 'assigns the configuration from environment variables' do
        Patentscope.configure_from_env
        expect(Patentscope.configuration.username).to eq(ENV['PATENTSCOPE_WEBSERVICE_USERNAME'])
        expect(Patentscope.configuration.password).to eq(ENV['PATENTSCOPE_WEBSERVICE_PASSWORD'])
      end
    end
  end
end

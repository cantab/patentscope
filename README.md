# patentscope gem
[![Gem Version](https://badge.fury.io/rb/patentscope.png)](http://badge.fury.io/rb/patentscope)
[![Code Climate](https://codeclimate.com/github/cantab/patentscope.png)](https://codeclimate.com/github/cantab/patentscope)

Gem to allow easy access to data from the WIPO PATENTSCOPE Web Service.

## Introduction

The Patentscope gem allows easy access, with Ruby, to data provided by the PATENTSCOPE Web Service of the World Intellectual Property Organisation (WIPO).

As provided by WIPO, the PATENTSCOPE Web Service is available through a SOAP interface. The documentation provided by WIPO uses Java.

The Patentscope gem, on the other hand, provides a simple Ruby interface to the PATENTSCOPE Web Service. The gem allows access for each of the functions available from the SOAP interface.

## About the WIPO PATENTSCOPE Web Service

From [PATENTSCOPE Web Service](http://www.wipo.int/patentscope/en/data/products.html) site:

"Includes:

* Bibliographic data for all published international applications (XML format);
* Images for all published international applications (TIFF format);
* Full-text description and claims (OCR output) for all international applications published in English, French, German, Spanish and Russian, as well as Japanese and Korean (soon available) (PDF format).

Available on the Internet on the day of publication. Programmatic access ... to the documents available in the document tab of the PATENTSCOPE search engine ([example](http://www.wipo.int/pctdb/en/wo.jsp?WO=2009120859&IA=US2009038389&DISPLAY=DOCS)). This set makes it possible to integrate access to PATENTSCOPE in an IT architecture, to retrieve the International Application Status Report (IASR) and to parse it on the fly and to download, within the framework of the [authorized uses policy](http://www.wipo.int/patentscope/en/data/terms.html); documents by batch. The formats of the documents are the same as the formats of the documents available via the web site, i.e. TIFF, XML for all documents and a text-based PDF OCR for most pamphlets."

The PATENTSCOPE Web Service is available from the World Intellectual Property Organisation (WIPO) through a [paid subscription](http://www.wipo.int/patentscope/en/data/forms/web_service.jsp). The current cost of a subscription  is 600 Swiss Francs per calendar year.

If you [ask nicely](mailto:patentscope@wipo.int?subject=Request%20for%20Trial%20Trial%20to%20PATENTSCOPE%20Web%20Service), the folks at WIPO might give you a trial account.

## Installation

Add this line to your application's Gemfile:

    gem 'patentscope'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install patentscope

## Usage

### Configuration
Run the configuration block first to set the credentials for the PATENTSCOPE Web Service.

      	Patentscope.configure do |config|
      		config.username     = 'username'
      		config.password     = 'password'
      	end

### Configuring from Environment Variables

It is most convenient to store the PATENTSCOPE Web Service username and password credentials as environment variables.

If these are stored as `PATENTSCOPE_WEBSERVICE_USERNAME` and `PATENTSCOPE_WEBSERVICE_PASSWORD` respectively, you can simply use

    	Patentscope.configure_from_env

to load the credentials into the configuration in a single step.

### Querying and Resetting Configuration

The `configured?` class method returns a boolean indicating whether the configuration has been set. This doesn't necessarily mean that the credentials are valid, only that they have been set.

		Patentscope.configured? #=> true

Use the `username` method of the `configuration` object to obtain the username set in the configuration.

		Patentscope.configuration.username #=> 'username'

The `password` method of the `configuration` object returns the password set in the configuration.

		Patentscope.configuration.password #=> 'password'

The `reset_configuration` class method resets the configuration.

		Patentscope.reset_configuration
		Patentscope.configuration #=> nil

### List of Available Methods

* `get_iasr`
* `get_available_documents`
* `get_document_content`
* `get_document_ocr_content`
* `get_document_table_of_contents`
* `get_document_content_page`
* `wsdl`

### Getting the International Application Status Report (`get_iasr`)

This is possibly the most useful of all the functions provided by this gem.

The `get_iasr` class method returns an International Application Status Report in XML format for the specified application number. The IASR document is essentially a bibliographic summary of the PCT application in XML format.

The `get_iasr` method takes an International Application number, with or without the PCT prefix and with or without slashes.

		Patentscope.get_iasr('SG2003000062')
		Patentscope.get_iasr('SG2003/000062')
		Patentscope.get_iasr('PCTSG2003000062')
		Patentscope.get_iasr('PCT/SG2003/000062')

Example output for SG2003000062:

		Patentscope.get_iasr('SG2003000062')
		#=>
		<?xml version="1.0"?>
		<wo-international-application-status>
  			<wo-bibliographic-data produced-by="IB" dtd-version="0.2" lang="EN" date-produced="20140108">
    			<publication-reference>
      			<document-id lang="EN">
        			<country>WO</country>
        			<doc-number>2009/105044</doc-number>
        			<kind>A1</kind>
        			<date>20090827</date>
      			</document-id>
    			</publication-reference>
    			<wo-publication-info>...

The PATENTSCOPE Web Service doesn't allow us to access documents using WO publication numbers. Calling `Patentscope.get_iasr('WO2003/080231')` for example will fail.

### Getting a List of Available Documents (`get_available_documents`)

The `get_available_documents` class method returns the list of available documents for the specified application number.

      	Patentscope.get_available_documents('SG2009000062')
      	# =>
      	<?xml version="1.0"?>
		<doc ocrPresence="no" docType="RO101" docId="id00000008679651"/>

### Getting the Binary Content of a Document (`get_document_content`)

The `get_document_content` class method returns the binary content of the document for the specified document id.

      	Patentscope.get_document_content('090063618004ca88')
      	#=>
      	<?xml version="1.0"?>
		<documentContent>UEsDBBQACAAIAIyMOy0AAAAAAAAAAAAAAAAKAAAAMDAwMDAxLnRpZsy7ezxU2 ...

### Getting the Text of a Document in PDF Format (`get_document_ocr_content`)

The `get_document_ocr_content` class method returns the binary content of the document for the specified document id, in text-based PDF format (high quality OCR).

      	Patentscope.get_document_ocr_content('id00000015801579')
      	=>
      	<?xml version="1.0"?>
		<documentContent>JVBERi0xLjQKJeLjz9MKOCAwIG9iago8PC9EZWNvZGVQYXJtcyA8PC9CbG ...

### Getting a List of Page IDs for a Document (`get_document_table_of_contents`)

The `get_document_table_of_contents` class method returns the list of page ids for the specified document id.

		Patentscope.get_document_table_of_contents('090063618004ca88')
		#=>
		<?xml version="1.0"?>
		<content>000001.tif</content>

### Getting the Binary Content for a Document and Page (`get_document_content_page`)

The `get_document_content_page` class method returns the binary content for specified document and page ids.

		Patentscope.get_document_content_page('090063618004ca88', '000001.tif')
		#=>
		<?xml version="1.0"?>
			<pageContent>SUkqAAgAAAASAP4ABAABAAAAAAAAAAABAwABAAAA</pageContent>

###Getting a WSDL Document for the Web Service (`wsdl`)

The `wsdl` method returns a WSDL document for the PATENTSCOPE Web Service

		Patentscope.wsdl
		#=>
		<?xml version='1.0' encoding='UTF-8'?>
		...
		<wsdl:definitions...

### Errors

* NoCredentialsError - attempting to use the client when no credentials were entered
* WrongCredentialsError - attempting to access the PATENTSCOPE Webservice with incorrect credentials
* NoAppNumberError - no application numbere was entered, or unable to convert number
* NoDocIDError - no document id was entered
* NoPageIDError - no page id was entered
* BusinessError - PATENTSCOPE Webservice returned a "business error"

## Disclaimer

The Patentscope gem is not an official product of the World Intellectual Property Organization. No warranty is attached to the provision of this gem. Please use this gem at your own risk.

You are solely responsible for ensuring that any uses are suitable, authorized and otherwise legal. In particular, you are solely responsible for maintaining a subscription at WIPO and adhering to WIPO's terms of use for the PATENTSCOPE Web Service.

Please note the [Terms and Conditions](http://www.wipo.int/patentscope/en/data/terms.html) relating to use of the PATENTSCOPE Web Service, especially Section 3.2 ("authorized uses", i.e., fewer than 10 retrieval related actions per minute from an individual IP address of a subscriber).

## Support

I am happy to help with any queries in relation to the Patentscope gem. Please file an issue on the Github repo and I will try my best to help.

**I am unable to answer any queries on the PATENTSCOPE Web Service itself**.

For support on the PATENTSCOPE Web Service, please see the resources in the section below, visit the [PATENTSCOPE Forum](http://wipo-patentscope-forum.2944828.n2.nabble.com) or send an email to WIPO at patentscope@wipo.int

## Resources

### Web App Using Patentscope Gem

* The [PCT National Phase](http://guides.cantab-ip.com/singapore-national-phase) Guide fetches IASR data from WIPO PATENTSCOPE and displays a customised guide for the national phase entry of a PCT application

### PATENTSCOPE Web Service
* [PATENTSCOPE Web Service](http://www.wipo.int/patentscope/en/data/products.html)
* [Terms and Conditions](http://www.wipo.int/patentscope/en/data/terms.html)
* [Subscription Form](http://www.wipo.int/patentscope/en/data/forms/web_service.jsp)
* [News](http://www.wipo.int/patentscope/en/news/pctdb/)
* [PCT PATENTSCOPE Web-services for Offices](http://www.wipo.int/edocs/mdocs/pct/en/wipo_pct_mow_12/wipo_pct_mow_12_ref_pctpatentscope.pdf) (Presentation by WIPO)

### PATENTSCOPE Search System
* [PATENTSCOPE](http://www.wipo.int/patentscope/en/)
* [Search Interface](http://patentscope.wipo.int/search/)
* [Webinars](http://www.wipo.int/patentscope/en/webinar/)
* [Forum](http://wipo-patentscope-forum.2944828.n2.nabble.com)

## Contact
Comments and bug reports are welcome.

## Contributing
Feel free to drop us a line to let us know you would like to work on something or if you have an idea. Otherwise, fork, code, commit, push and create pull request, *viz*:

1. Create a fork of the repo from http://github.com/cantab/patentscope.
2. Create your feature branch (`git checkout -b new-feature`).
2. Write some tests (in RSpec, if you please).
3. Write the code that allows the tests to pass.
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin new-feature`).
5. Create a new [Pull Request] (https://help.github.com/articles/using-pull-requests).

More details on how to contribute can be found at this great Thoughtbot blogpost [8 (new) steps for fixing other people's code] (http://robots.thoughtbot.com/8-new-steps-for-fixing-other-peoples-code).

## License

Copyright (c) 2013-2016 Chong-Yee Khoo. All rights reserved.

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

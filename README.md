# Middleman-citation

This is an extension for the [Middleman](http://middlemanapp.com/) static
site generator that adds functions you can use in your templates for 
formating citations from BibTeX.

An example of a Middleman template using this plugin is available at
<https://github.com/gabysbrain/website/blob/master/source/cv.html.slim>.

## Installation

Add this line to your Gemfile:

    gem 'middleman-citation'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install middleman-citation


## Configuration

In your `config.rb` file for your site add:

    require 'middleman-citation'

    activate :citation do |options|
      options.bibtex = "/Users/tom/Dropbox/Research/all.bib" # full path to a bibtex file
      options.style = "ieee" # or whatever style you want from citeproc-styles
    end

## Usage

This adds the following helper methods you can use in your Middleman
templates.



* `cite_full(key)`: given the BibTeX citation key return a formatted string
                  for the citation according to how the `style` option is set.
* `find_pubs(search_key, author)`: Search the BibTeX file for all citations 
                                 of a certain type for a # certain author.  
                                 Returns a list of citation keys you can send 
                                 to `cite_full`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

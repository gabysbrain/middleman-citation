# Middleman-citation

[ ![Codeship Status for gabysbrain/middleman-citation](https://codeship.com/projects/cd5fdc40-6601-0133-2d2b-5adfc3e4cb23/status?branch=master)](https://codeship.com/projects/113648)

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

    activate :citation do |opts|
      opts.bibtex = '/path/to/your.bib' # path to a bibtex file
      opts.style  = 'ieee'              # style from citeproc-styles
      opts.format = 'html'              # output format
    end

## Usage

This adds the following helper methods you can use in your Middleman
templates.

* `citations_search(search_term, author)`: Search the BibTeX file for all
   citations matching a search term (such as `'@article'`) and by the given
   author.  The `author` argument can be ommitted to match all authors and
   a `search_term` of `nil` will match all items in the bibliography.

* `citation(key)`: Given a BibTeX citation key as returned from
  `citations_search`, return a formatted string the citation according to
  how the `style` and `format` options were set.

For extra control on the output, one can use:

* `citation_entry(key)`: Return the unformatted entry (a hash)
  corresponding to the BibTeX citation key. 

* `citation_formatted(entry)`: Format an unformatted entry.

In fact the `citation` method is implemented using these:

    def citation(key)
      entry = citation_entry(key)
      citation_formatted(entry)
    end

The point is that one can interrogate the unformatted entry to
add extra formatting: The following code adds a DOI link if the
entry matching the `key` has a `URL` field containing the DOI.

    entry      = citation_entry(key)
    entry_html = citation_formatted(entry)
    if doi_url = entry.fetch('URL', false) then
      doi_link = "(%s)" % link_to('doi', doi_url)
    end
    [entry_html, doi_link].compact.join(' ')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

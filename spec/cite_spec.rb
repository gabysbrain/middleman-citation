require 'middleman-citation/citations'

RSpec.describe Citations, "citations" do
  require 'bibtex'
  bib = BibTeX.open('fixtures/test.bib', :filter => :latex)

  turkay_chi = "Turkay, Cagatay, J. Parulek, N. Reuter, and Helwig Hauser. 2011. “Interactive Visual Analysis of Temporal Cluster Structures.” Computer Graphics Forum 30 (3). Wiley-Blackwell: 711–20. doi:10.1111/j.1467-8659.2011.01920.x. http://dx.doi.org/10.1111/j.1467-8659.2011.01920.x."
  turkay_ieee = "C. Turkay, J. Parulek, N. Reuter, and H. Hauser, “Interactive Visual Analysis of Temporal Cluster Structures,” Computer Graphics Forum, vol. 30, no. 3, pp. 711–720, Jun. 2011."
  tw_chi = "Torsney-Weir, Thomas, Ahmed Saad, Torsten Möller, Britta Weber, Hans-Christian Hege, Jean-Marc Verbavatz, and Steven Bergner. 2011. “Tuner: Principled Parameter Finding for Image Segmentation Algorithms Using Visual Response Surface Exploration.” IEEE Transactions on Visualization and Computer Graphics 17 (12): 1892–1901."

  context "long-form citation" do
    it "gives a nice error for a bad style" do
      expect {Citations::cite_full('Turkay:2011a', bib, 'crazyformat')}.to \
        raise_error(Citations::InvalidStyleError, /crazyformat/)
    end

    it "gives a nice error for a bad key" do
      expect {Citations::cite_full('notthere', bib, 'chicago-author-date')}.to \
        raise_error(Citations::InvalidKeyError, /notthere/)
    end

    it "generates a proper chicago-style citation" do
      full_cite = Citations::cite_full('Turkay:2011a', bib, 'chicago-author-date')
      expect(full_cite).to eq(turkay_chi)
    end

    it "generates a proper ieee-style citation" do
      full_cite = Citations::cite_full('Turkay:2011a', bib, 'ieee')
      expect(full_cite).to eq(turkay_ieee)
    end

    it "properly handles accented characters" do
      full_cite = Citations::cite_full('Torsney-Weir:2011', bib, 'chicago-author-date')
      expect(full_cite).to eq(tw_chi)
    end
  end

  context "short-form inline citation" do
    it "generates a proper chicago-style citation" do
      inline_cite = Citations::cite_inline('Turkay:2011a', bib, 'chicago-author-date')
      expect(inline_cite).to have_tag("span", :with => {:class => 'inline-citation'}) do
        with_tag('span', :text => turkay_chi, :with => {:class => 'citation'})
      end
    end
  end
end


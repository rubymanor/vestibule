xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Vestibule :: Suggestions for #{proposal_title_for_rss(@proposal)}"
    xml.description "A list of all suggestions made for #{proposal_title_for_rss(@proposal)}"
    xml.link proposal_url(@proposal)

    @proposal.suggestions.latest.each do |suggestion|
      xml.item do
        xml.title suggestion_title_for_rss(suggestion)
        xml.description :type => 'html' do
          xml.cdata! markdown suggestion.body
        end
        xml.pubDate suggestion.created_at.to_s(:rfc822)
        xml.link proposal_url(@proposal, :anchor => dom_id(suggestion))
        xml.guid proposal_url(@proposal, :anchor => dom_id(suggestion))
      end
    end
  end
end

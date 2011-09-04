xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Vestibule :: All Proposals "
    xml.description "A list of all talk proposals made to the vestibule system"
    xml.link proposals_url

    @proposals.each do |proposal|
      xml.item do
        xml.title proposal_title_for_rss(proposal)
        xml.description :type => 'html' do
          xml.cdata! markdown proposal.description
        end
        xml.pubDate proposal.created_at.to_s(:rfc822)
        xml.link proposal_url(proposal)
        xml.guid proposal_url(proposal)
      end
    end
  end
end

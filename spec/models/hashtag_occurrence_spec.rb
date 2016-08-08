describe HashtagOccurrence do

  let(:hashtag_occurrence) {create(:hashtag_occurrence)}

  describe "#link" do
    it "returns twitter url" do
     expect(hashtag_occurrence.link).to eq("https://twitter.com/hashtag/#{hashtag_occurrence.value}")
    end
  end

  describe "formatted_value" do
    it "returns value with # prepending it" do
     expect(hashtag_occurrence.formatted_value).to eq("#" + hashtag_occurrence.value)
     end
  end


end
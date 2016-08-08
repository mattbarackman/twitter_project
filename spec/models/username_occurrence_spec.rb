describe UsernameOccurrence do

  let(:username_occurrence) {create(:username_occurrence)}

  describe "#link" do
    it "returns twitter url" do
     expect(username_occurrence.link).to eq("https://twitter.com/#{username_occurrence.value}")
    end
  end

  describe "formatted_value" do
    it "returns value with @ prepending it" do
     expect(username_occurrence.formatted_value).to eq("@" + username_occurrence.value)
     end
  end


end
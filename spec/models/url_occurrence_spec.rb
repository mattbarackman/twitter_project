describe UrlOccurrence do

  let(:url_occurrence) {create(:url_occurrence)}

  describe "#link" do
    it "returns value" do
     expect(url_occurrence.link).to eq(url_occurrence.value)
    end
  end

  describe "formatted_value" do
    context "link is more than 25 characters" do

      let(:url_occurrence) {create(:url_occurrence, :value => "https://www.google.com/thisisalongurl")}

      it "returns value" do
        expect(url_occurrence.formatted_value).to eq("https://www.google.com/thi...")
      end
    end

    context "link is less than 25 characters" do

      let(:url_occurrence) {create(:url_occurrence, :value => "https://www.google.com")}

      it "returns value" do
        expect(url_occurrence.formatted_value).to eq(url_occurrence.value)
      end

    end
  end


end
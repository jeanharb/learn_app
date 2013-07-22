require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    it "should have the content 'Learnocracy'" do
    	visit root_path
    	page.should have_content('Learnocracy')
    end
  end
end
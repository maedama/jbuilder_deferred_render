require 'rails_helper'
require 'json_spec'
describe JbuilderDeferredRender do
  before(:all) do
    10.times do |index|
      user = User.create!( name: "name of user#{index}" )
      user.books.create( title: " title of book#{index}" )
    end
   end

  describe "JBuilder" do
    describe "rendered result" do
      before(:all) do
        @users = User.all
        @jbuilder = Jbuilder.new do |json|
          json.array! @users do |user|
            json.name user.name
            #user.deferred.books do |books|
              #json.books books, :title; nil
            #end
          end
        end
      end

      it "Renders json correctly" do
        expected_result = (0 ... 10).to_a.collect  { |index|
          { name: "name of user#{index}", books: [ { title: "title of book#{index}" } ] }
        }
        expect(@jbuilder.target!).to be_json_eql(expected_result.to_json)
      end
    end
  end 
end

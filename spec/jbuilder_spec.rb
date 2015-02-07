require 'rails_helper'
require 'json_spec'
describe JbuilderDeferredRender do
  before(:all) do
    10.times do |index|
      user = User.create!( name: "name of user#{index}" )
      user.books.create( title: "title of book#{index}" )
    end
   end

  describe "JBuilder" do
    describe "rendered result" do
      before(:all) do
        @users = User.all
        @jbuilder = Jbuilder.new do |json|
          
          json.array! @users do |user|
            json.name user.name
            json.when(
              user.deferred_load.books
            ).then do |books|
              json.books books, :title
            end
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

    describe "Queries count" do

      before(:all) do
        @users = User.all
      end
      let(:jbuilder_block) { nil }
      let(:count) {
        count_queries {
          Jbuilder.new &jbuilder_block
        }
      }
      
      context 'When rendered with deferred' do
        let(:jbuilder_block) {
          Proc.new { |json|
            json.array! @users do |user|
              json.name user.name
              json.when(
                user.deferred_load.books
              ).then do |books|
                json.books books, :title
              end
            end
          }
        }
      
        it "Should not have n+1 problem" do
          expect(count).to eq(1)
        end

      end

      context 'When not rendered with deferred' do
        let(:jbuilder_block) {
          Proc.new { |json|
            json.array! @users do |user|
              json.name user.name
              json.books user.books, :title
            end
          }
        }

        it "Should have n+1 problem" do
          expect(count).to be > 5
        end
      end
    end
  end 
end

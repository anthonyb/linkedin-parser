require 'rails_helper'

describe Api::ProfilesApiController, :type => :controller do
  before(:all) do
    @profile = Profile.create!(
      name:"John Doe",
      linkedin_profile_id: "johndoe",
      title: "Head of Stuff and Things",
      skills: "Skill1, Skill2, Skill3"
    )
  end
  describe "GET #index" do
    context "when the GET request params are empty" do
      it "responds with an empty object but with an HTTP 200 status code" do
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(response.body).to eq("[]")
      end
    end

    context "when the GET request params include 'name'" do
      context "and when the name is not matched" do
        it "responds with" do
          get :index, params = {name:"Jimmy"}
          expect(response).to be_success
          expect(response).to have_http_status(200)
          expect(response.body).to eq("[]")
        end
      end
      context "and when the name is matched" do
        it "responds with " do
          get :index, params = {name:"John"}
          expect(response).to be_success
          expect(response).to have_http_status(200)
          expect(response.body).to eq("[#{@profile.to_json}]")
        end
      end
    end

    context "when the GET request params include 'skills'" do
      context "and when the skills are not matched" do
        it "responds with" do
          get :index, params = {skills:"Skill81"}
          expect(response).to be_success
          expect(response).to have_http_status(200)
          expect(response.body).to eq("[]")
        end
      end
      context "and when the skills are matched" do
        it "responds with " do
          get :index, params = {skills:"Skill2"}
          expect(response).to be_success
          expect(response).to have_http_status(200)
          expect(response.body).to eq("[#{@profile.to_json}]")
        end
      end
    end

  end

  #-------------------------------------------

  describe "POST #index" do
    context "when the user POST request to index" do
      it "responds with a blank object" do
        post :index, params = {url:"not.linked.in/nothing"}
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(response.body).to eq('[]')
      end
    end
  end

  describe "POST #create" do
    context "when the POST request params are not valid" do
      it "responds with an error" do
        post :create, params = {url:"http://not.linked.in/nothing"}
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: false, message: "That isn't a LinkedIn URL!"}.to_json)
      end
    end
  end

  describe "POST #create" do
    context "when the POST request params are valid" do
      it "responds with a success object" do
        post :create, params = {url:"https://www.linkedin.com/in/mdell"}
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, message: "Added Profile Successfully"}.to_json)

        #just count the matching object
        #not going to serialize the whole object in case it changes and breaks the test
        profile_count = Profile.where(linkedin_profile_id: 'mdell').count
        expect(profile_count).to eq(1)
      end
    end
  end

end

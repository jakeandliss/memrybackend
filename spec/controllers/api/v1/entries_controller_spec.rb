require 'rails_helper'

RSpec.describe Api::V1::EntriesController, type: :controller do
	
	describe "GET #index" do
		
		context "success" do
			it "must return a response ok"
			it "must return all the entries of the user"
			it "must return all the entries with tags"
			it "must return all the entries for the tags specified"
		end

		context "failure" do
			it "must return error response"
		end
	end

	describe "POST #create" do

		context "success" do
			it "must return okay response"
			it "must return the created entry"
			it "must assign tags to entry"
			it "must create tag if tag not present"
			it "must assign tag if tag is already present"
			it "must return entry with tags"
		end

		context "failure" do
			it "must return error response"
		end
	end

	describe "GET #show" do

		context "success" do
			it "must return okay response"
			it "must return the requested entry"
			it "must return entry with tags"
		end

		context "failure" do
			it "must return a error response"
			it "must return not found error" 
		end
	end

	describe "PUT #update" do

		context "success" do
			it "must return okay response"
			it "must return the updated entry"
			it "must return the updates entry with tags"
		end

		context "failure" do
			it "must return a error response"
			it "must return not updated message" 
		end
	end

	describe "DELETE #destroy" do

		context "success" do
			it "should destroy the entry"
			it "should also destroy its resources"
		end

		context "error" do
			it "should return error message"
			it "should return message of deletion failure"
		end
	end

end
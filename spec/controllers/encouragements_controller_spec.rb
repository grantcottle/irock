# frozen_string_literal: true

require 'rails_helper'

describe EncouragementsController do
  let(:user) { FactoryBot.create(:user) }
  let(:author) { FactoryBot.create(:user) }
  let(:achievement) { FactoryBot.create(:public_achievement, user: author) }
  describe 'GET new' do
    context 'guest user' do
      it 'is redirect back to achievement page' do
        get :new, params: { achievement_id: achievement.id }
        expect(response).to redirect_to(achievement_path(achievement))
      end
      it 'assigns flash message' do
        get :new, params: { achievement_id: achievement.id }
        expect(flash[:alert]).to eq('You must be logged in to encourage people')
      end
    end
    context 'authenticated user' do
      before { sign_in(user) }

      it 'renders :new template' do
        get :new, params: { achievement_id: achievement.id }
        expect(response).to render_template(:new)
      end
      it 'assigns new encouragement to template' do
        get :new, params: { achievement_id: achievement.id }
        expect(assigns(:encouragement)).to be_a_new(Encouragement)
      end
    end

    context 'achievement author' do
      before { sign_in(author) }

      it 'is redirect back to achievement page' do
        get :new, params: { achievement_id: achievement.id }
        expect(response).to redirect_to(achievement_path(achievement))
      end

      it 'assings flash message' do
        get :new, params: { achievement_id: achievement.id }
        expect(flash[:alert]).to eq("You can't encourage yourself")
      end
    end

    context 'user who already left encouragment for this achievment' do
      before :each do
        sign_in(user)
        FactoryBot.create(:encouragement, user: user, achievement: achievement)
      end
      it 'is redirect back to achievement page' do
        get :new, params: { achievement_id: achievement.id }
        expect(response).to redirect_to(achievement_path(achievement))
      end
      it 'assings flash message' do
        get :new, params: { achievement_id: achievement.id }
        expect(flash[:alert]).to eq("You already encouraged it. You ca't be so generous!")
      end
    end
  end

  describe 'POST create' do
    let(:encouragement_params) { FactoryBot.attributes_for(:encouragement) }

    context 'authenticated user' do
      before { sign_in(user) }
      context 'valid data' do
        it 'redirects back to achievements page' do
          post :create, params: { achievement_id: achievement.id, encouragement: encouragement_params }
          expect(response).to redirect_to(achievement_path(achievement))
        end
        it 'assigns encouragement to current user and achievement' do
          post :create, params: { achievement_id: achievement.id, encouragement: encouragement_params }
          enc = Encouragement.last
          expect(enc.user).to eq(user)
          expect(enc.achievement).to eq(achievement)
        end
        it 'assigns flash message' do
          post :create, params: { achievement_id: achievement.id, encouragement: encouragement_params }
          expect(flash[:notice]).to eq('Thank you for encouragement')
        end
      end
      context 'invalid data' do
        let(:invalid_params) { FactoryBot.attributes_for(:encouragement, message: nil) }
        it 'renders :new template' do
          post :create, params: { achievement_id: achievement.id, encouragement: invalid_params }
          expect(response).to render_template(:new)
        end
      end
    end

    context 'guest user' do
      it 'is redirect back to achievement page' do
        post :create, params: { achievement_id: achievement.id, encouragement: encouragement_params }
        expect(response).to redirect_to(achievement_path(achievement))
      end
      it 'assigns flash message' do
        post :create, params: { achievement_id: achievement.id, encouragement: encouragement_params }
        expect(flash[:alert]).to eq('You must be logged in to encourage people')
      end
    end
    context 'achievement author' do
      before { sign_in(author) }

      it 'is redirect back to achievement page' do
        post :create, params: { achievement_id: achievement.id, encouragement: encouragement_params }
        expect(response).to redirect_to(achievement_path(achievement))
      end

      it 'assings flash message' do
        post :create, params: { achievement_id: achievement.id, encouragement: encouragement_params }
        expect(flash[:alert]).to eq("You can't encourage yourself")
      end
    end

    context 'user who already left encouragment for this achievment' do
      before :each do
        sign_in(user)
        FactoryBot.create(:encouragement, user: user, achievement: achievement)
      end
      it 'is redirect back to achievement page' do
        post :create, params: { achievement_id: achievement.id, encouragement: encouragement_params }
        expect(response).to redirect_to(achievement_path(achievement))
      end
      it 'assings flash message' do
        post :create, params: { achievement_id: achievement.id, encouragement: encouragement_params }
        expect(flash[:alert]).to eq("You already encouraged it. You ca't be so generous!")
      end
    end
  end
end

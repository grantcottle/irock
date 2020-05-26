# frozen_string_literal: true

require 'rails_helper'

describe AchievementsController do
  describe 'GET index' do
    it 'renders :index template' do
      get :index
      expect(response).to render_template(:index)
    end
    it 'assigns only public achievements to template' do
      public_achievement = FactoryBot.create(:public_achievement)
      _private_achievement = FactoryBot.create(:private_achievement)
      get :index
      expect(assigns(:achievements)).to match_array([public_achievement])
    end
  end

  describe 'GET edit' do
    let(:achievement) { FactoryBot.create(:public_achievement) }
    it 'renders :edit template' do
      get :edit, params: { id: achievement }
      expect(response).to render_template(:edit)
    end
    it 'assigns the requested achievement to template' do
      get :edit, params: { id: achievement }
      expect(assigns(:achievement)).to eq(achievement)
    end
  end

  describe 'PUT update' do
    let(:achievement) { FactoryBot.create(:public_achievement) }
    context 'valid data' do
      let(:valid_data) { FactoryBot.attributes_for(:public_achievement, title: 'New Title') }

      it 'redirects to achievement#show' do
        put :update, params: { id: achievement, achievement: valid_data }
        expect(response).to redirect_to(achievement)
      end
      it 'updates achievement in the database' do
        put :update, params: { id: achievement, achievement: valid_data }
        achievement.reload
        expect(achievement.title).to eq('New Title')
      end
    end
    context 'invalid data' do
      let(:invalid_data) { FactoryBot.attributes_for(:public_achievement, title: '', description: 'new') }

      it 'renders :edit template' do
        put :update, params: { id: achievement, achievement: invalid_data }
        expect(response).to render_template(:edit)
      end
      it "doesn't update achievment in the database" do
        put :update, params: { id: achievement, achievement: invalid_data }
        expect(achievement.description).not_to eq('new')
      end
    end
  end

  describe 'GET new' do
    it 'renders :new template' do
      get :new
      expect(response).to render_template(:new)
    end
    it 'assigns new Achievement to @achievement' do
      get :new
      expect(assigns(:achievement)).to be_a_new(Achievement)
    end
  end

  describe 'GET show' do
    let(:achievement) { FactoryBot.create(:public_achievement) }
    it 'renders :show template' do
      get :show, params: { id: achievement }
      expect(response).to render_template(:show)
    end

    it 'assigns requested achievement to @achievement' do
      get :show, params: { id: achievement }
      expect(assigns(:achievement)).to eq(achievement)
    end
  end

  describe 'POST create' do
    context 'valid data' do
      let(:valid_data) { FactoryBot.attributes_for(:public_achievement) }
      it 'redirects to achievements#show' do
        post :create, params: { achievement: valid_data }
        expect(response).to redirect_to(achievement_path(assigns[:achievement]))
      end
      it 'creates new achievement in database' do
        expect do
          post :create, params: { achievement: valid_data }
        end.to change(Achievement, :count).by(1)
      end
    end
    context 'invalid data' do
      let(:invalid_data) { FactoryBot.attributes_for(:public_achievement, title: '') }
      it 'reders :new template' do
        post :create, params: { achievement: invalid_data }
        expect(response).to render_template(:new)
      end
      it "doesn't creates new achievement in database" do
        expect do
          post :create, params: { achievement: invalid_data }
        end.not_to change(Achievement, :count)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:achievement) { FactoryBot.create(:public_achievement) }

    it 'redirects to achievements#index' do
      delete :destroy, params: { id: achievement }
      expect(response).to redirect_to(achievement_path)
    end

    it 'deletes achievements from database' do
      delete :destroy, params: { id: achievement }
      expect(Achievement.exists?(achievement.id)).to be_falsy
    end
  end
end

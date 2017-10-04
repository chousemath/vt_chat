require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #home' do
    it 'responds with 200' do
      get :home, :format => :html
      expect(response).to have_http_status(200)
    end

    context 'when rendering view' do
      render_views

      it 'renders the view' do
        expect { get :home, :format => :html }.to_not raise_error
      end
    end
  end
end

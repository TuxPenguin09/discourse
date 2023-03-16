# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChatMessageUserSerializer do
  subject do
    user = Fabricate(:user, **params)
    guardian = Guardian.new(user)
    described_class.new(user, scope: guardian, root: nil).as_json
  end

  let(:params) do
    { trust_level: TrustLevel[1], admin: false, moderator: false, primary_group_id: nil }
  end

  context "with default user" do
    it "displays user as regular" do
      expect(subject[:new_user]).to eq(false)
      expect(subject[:staff]).to eq(false)
      expect(subject[:admin]).to eq(false)
      expect(subject[:moderator]).to eq(false)
      expect(subject[:primary_group_name]).to be_blank
    end
  end

  context "when user is TL0" do
    before { params[:trust_level] = TrustLevel[0] }

    it "displays user as new" do
      expect(subject[:new_user]).to eq(true)
    end
  end

  context "when user is staff" do
    before { params[:admin] = true }

    it "displays user as staff" do
      expect(subject[:staff]).to eq(true)
    end
  end

  context "when user is admin" do
    before { params[:admin] = true }

    it "displays user as admin" do
      expect(subject[:admin]).to eq(true)
    end
  end

  context "when user is moderator" do
    before { params[:moderator] = true }

    it "displays user as moderator" do
      expect(subject[:moderator]).to eq(true)
    end
  end

  context "when user has a primary group" do
    fab!(:group) { Fabricate(:group) }

    before { params[:primary_group_id] = group.id }

    it "displays user as moderator" do
      expect(subject[:primary_group_name]).to eq(group.name)
    end
  end
end

require 'rails_helper'

describe User::DiscountCheckScheduler do
  describe "perform" do
    let(:user) do
      FG.create(:user,
        timezone: "America/Tijuana",
        sandbox: false
      )
    end

    before do
      3.times do
        FG.create(:product, user: user)
      end
    end

    subject do
      User::DiscountCheckScheduler.new.perform(user.id)
    end

    context "user is not sleeping" do
      before do
        travel_to Time.zone.local(2016, 11, 11, 1, 00, 00)
      end

      after { travel_back }

      it "schedules discount check jobs for each of user products" do
        expect(Product::DiscountChecker).to receive(:perform_in).exactly(user.products.count).times
        subject
      end
    end

    context "user is sleeping" do
      before do
        travel_to Time.zone.local(2016, 11, 11, 11, 00, 00)
      end

      after { travel_back }

      it "does not schedule any checks" do
        expect(Product::DiscountChecker).not_to receive(:perform_in)
        subject
      end

      context "but he is a system user" do
        before do
          allow_any_instance_of(User).to receive(:is_system_user?) { true }
        end

        it "schedules the checks anyway" do
          expect(Product::DiscountChecker).to receive(:perform_in).exactly(user.products.count).times
          subject
        end
      end
    end
  end
end

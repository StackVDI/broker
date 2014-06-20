require "spec_helper"

describe GeneralMailer do
  describe 'mailError' do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    user1.add_role :admin
    mail = GeneralMailer.errorMail("Error creating machine")

    it "subject is StackVDI Error" do
      expect(mail.subject).to eql("StackVDI Error")
    end

    it "contains error description" do
      expect(mail.body).to match("Error creating machine")
    end

    it "send mail to all admins" do
      expect(mail.to).to eql([user1.email])
    end

  end
end

class GeneralMailer < ActionMailer::Base
  default from: "exception@stackvdi.com"
  
  def errorMail(msg)
    @message = msg
    mail to: User.admins.map{|u| u.email}, subject: 'StackVDI Error'
  end

end

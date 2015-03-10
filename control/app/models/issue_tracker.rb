class IssueTracker < ActiveRecord::Base
  has_many :enviroments
  
  validates :weblink, format: { with: /:issue/, message: "must contain ':issue' for substitution" }, allow_blank: true
  validates :title, length: {in: 1..100}, uniqueness: true
  
  def full_weblink(issue)
    unless self.weblink.nil?
      self.weblink.sub(":issue", issue)
    else
      nil
    end
  end
  
end

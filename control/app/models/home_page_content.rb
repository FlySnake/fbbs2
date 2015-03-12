class HomePageContent < ActiveRecord::Base
  validates :title, length: {in: 1..100}
  validates :link, length: {in: 1..2048}, allow_blank: true
end

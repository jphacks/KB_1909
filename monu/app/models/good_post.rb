class GoodPost < ApplicationRecord
  validates :user_id,:uniqueness => {scope: :post_id }
end

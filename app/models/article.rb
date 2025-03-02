class Article < ApplicationRecord
  belongs_to :category
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true, length: {minimum: 10}
  validates :category, presence: true

  paginates_per 10

  scope :desc_order, -> { order(created_at: :desc) }
  scope:without_highlights, ->(ids) {where("id NOT IN(#{ids})")if ids.present? }
  scope :filter_by_category, ->(category) {where(category_id: category.id)if category.present? }
  scope :filter_by_archive, lambda { |month_year|
      if month_year.present?
        begin
          date = Date.strptime(month_year, "%B %Y")
          where(created_at: date.beginning_of_month..date.end_of_month.next_day)
        rescue ArgumentError
          none # Retorna uma relação vazia se a data não puder ser interpretada
        end
      end
    }
end

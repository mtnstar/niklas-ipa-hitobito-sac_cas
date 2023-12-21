# frozen_string_literal: true

#  Copyright (c) 2012-2023, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

module ::SacCas::RoleBeitragskategorie
  extend ActiveSupport::Concern
  include I18nEnums

  included do
    include I18nEnums
    i18n_enum :beitragskategorie,
              ::SacCas::Beitragskategorie::Calculator::BEITRAGSKATEGORIEN,
              i18n_prefix: 'roles.beitragskategorie'

    attr_readonly :beitragskategorie

    before_validation :set_beitragskategorie, unless: :beitragskategorie

    validates :beitragskategorie, presence: true

    ::SacCas::Beitragskategorie::Calculator::BEITRAGSKATEGORIEN.each do |category|
      scope category, -> { where(beitragskategorie: category) }
    end
  end

  def beitragskategorie
    value = read_attribute(:beitragskategorie)
    value.inquiry if value
  end

  def to_s(format = :default)
    if beitragskategorie_label
      "#{super(:short)} (#{beitragskategorie_label})"
    else
      super
    end
  end

  private

  def set_beitragskategorie
    category =
      ::SacCas::Beitragskategorie::Calculator
      .new(person).calculate
    self.beitragskategorie = category
  rescue
    # let's not break the `before_validation` chain in case of an error
  end
end

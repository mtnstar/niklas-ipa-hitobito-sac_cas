# frozen_string_literal: true

#  Copyright (c) 2023, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

module SacCas::Beitragskategorie
  class Calculator < Base

    def initialize(person)
      @person = person
    end

    def calculate
      case age
      when 22..199
        :einzel
      when 6..21
        :jugend
      end
    end

    private

    def age
      @person.years
    end
  end
end

# frozen_string_literal: true

#  Copyright (c) 2012-2023, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

module TableDisplays::People
  class MembershipYearsColumn < TableDisplays::Column

    def required_permission(attr)
      :show
    end

    def required_model_attrs(_attr)
      []
    end

    def render(attr)
      super do |target, target_attr|
        template.format_attr(target, target_attr) if target.respond_to?(target_attr)
      end
    end

    def sort_by(attr)
      nil
    end
  end
end

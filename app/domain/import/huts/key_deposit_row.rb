# frozen_string_literal: true

#  Copyright (c) 2023, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

require Rails.root.join('lib', 'import', 'xlsx_reader.rb')

module Import::Huts
  class KeyDepositRow
    include RemovingPlaceholderContactRole

    def self.can_process?(row)
      row[:verteilercode].to_s == '4011.0'
    end

    def initialize(row)
      @row = row
    end

    def import! # rubocop:disable Metrics/MethodLength
      person = person_for(@row)
      set_person_name(@row, person)
      huette = huette(@row)
      unless huette
        # TODO fix bugs in data export, where not all huts are exported
        puts "Skipping key deposit for unknown hut #{huette_navision_id(@row)}"
        return
      end
      person.roles.where(
        type: Group::SektionsHuette::Andere.name,
        label: role_label(@row),
        group_id: huette.id,
      ).destroy_all
      person.roles.build(
        type: Group::SektionsHuette::Andere.name,
        label: role_label(@row),
        created_at: created_at(@row),
        group_id: huette.id,
      )

      remove_placeholder_contact_role(person)

      person.save!
    end

    private

    def person_for(row)
      Person.find_by(id: owner_navision_id(row))
    end

    def set_person_name(row, person)
      person.first_name = first_name(row)
      person.last_name = last_name(row)
    end

    def huette(row)
      # TODO handle nonexistent group
      @huette ||= Group.find_by(type: Group::SektionsHuette.name,
                                navision_id: huette_navision_id(row))
    rescue NoMethodError
      puts "Failed to find existing hut with navision id #{huette_navision_id(row)}"
    end

    def huette_navision_id(row)
      row[:contact_navision_id].to_s.sub(/^[0]*/, '')
    end

    def owner_navision_id(row)
      Integer(row[:related_navision_id].to_s.sub(/^[0]*/, ''))
    end

    def first_name(row)
      row[:related_first_name]
    end

    def last_name(row)
      row[:related_last_name]
    end

    def created_at(row)
      row[:created_at]
    end

    def role_label(row)
      t(row, 'activerecord.models.group/sektions_huette/schluesseldepot.one')
    end

    def t(row, key)
      I18n.with_locale(locale(row)) do
        I18n.translate(key)
      end
    end

    def locale(row)
      sektion(row).language.downcase
    end

    def sektion(row)
      @sektion ||= Group::SektionsHuettenkommission.find(huette(row).parent_id).parent
    end
  end
end

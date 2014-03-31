class Pallet < ActiveRecord::Base
  belongs_to :order
  belongs_to :cookie

  LOCATIONS = ['deep_freeze', 'delivered', 'delivery_truck']
  BOX_CAPACITY = 10
  BAG_CAPACITY = 15
  PALLET_CAPACITY = 36

  validates_presence_of :order, :cookie
  validates_inclusion_of :location, in: LOCATIONS, allow_nil: false

  def self.find_by_id(id)
    sql_query = %{
      SELECT `pallets`.* FROM `pallets`
          WHERE `pallets`.`id` = #{id}
      LIMIT 1
    }
    Pallet.connection.execute(sql_query).each(as: :hash).first
  end

  def self.search_sql date_range, only_blocked, cookie_id, pallet_id
    sql_query = %{
      SELECT `pallets`.*, `customers`.name as customer_name, `cookies`.name as cookie_name, `orders`.* FROM `pallets`
        INNER JOIN `orders` ON `pallets`.order_id = `orders`.id
        INNER JOIN `customers` ON `orders`.customer_id = `customers`.id
        INNER JOIN `cookies` ON `pallets`.cookie_id = `cookies`.id
        WHERE
          (`pallets`.`created_at`
            BETWEEN '#{date_range.first}'
            AND '#{date_range.last}'
          )
    }
    sql_query << " AND `pallets`.`cookie_id` = #{cookie_id}" unless cookie_id.blank?
    sql_query << " AND `pallets`.`is_blocked` = 1" if only_blocked
    sql_query << " AND `pallets`.`id` = #{pallet_id} LIMIT 1" unless pallet_id.blank?
    Pallet.connection.execute(sql_query)
  end

  def self.block! date_range, cookie_id, block
    sql_query = %{
      UPDATE `pallets` SET `pallets`.`is_blocked` = #{block}
        WHERE `pallets`.`cookie_id` = #{cookie_id}
        AND (`pallets`.`created_at`
          BETWEEN '#{date_range.first}'
          AND '#{date_range.last}'
        )
    }
    Pallet.connection.execute(sql_query)
  end

  def self.blocked_pallets
    sql_query = %{
      SELECT * FROM `pallets`
      INNER JOIN `cookies` ON `pallets`.cookie_id = `cookies`.id
        WHERE `pallets`.`is_blocked` = 1
      GROUP BY `cookies`.name
    }
    Pallet.connection.execute(sql_query)
  end

  def self.produce quantity, cookie_id
    cookie_quantity = quantity * Pallet.pallet_cookie_count
    # recipes = cookie.recipes.includes(:substance) # SQL

    recipe_ids_sql = %{
      SELECT `recipes`.*, `substances`.`quantity` as substance_quantity FROM `recipes`
      INNER JOIN `substances` ON `recipes`.`substance_id` = `substances`.`id`
      WHERE `recipes`.`cookie_id` = #{cookie_id}
    }

    updated_substances = Array.new
    Substance.transaction do # SQL Transaction

      Pallet.connection.execute(recipe_ids_sql).each(as: :hash) do |cookie_ingredient|
        updated_substances << self.produce_cookie(
          cookie_quantity,
          cookie_ingredient['substance_quantity'],
          cookie_ingredient['substance_id']
        )
      end

      if updated_substances.include?(false)
        raise ActiveRecord::Rollback, "Not enough #{'substance.name'} missing: #{'cookie_quantity - substance.quantity'} (g)"
      end

    end
    updated_substances.reject(&:blank?).size.eql? updated_substances.size
  end


  private

    def self.produce_cookie cookie_quantity, substance_quantity, substance_id
      if enough_substance?(cookie_quantity, substance_quantity)
        sql_query = %{
          UPDATE `substances` SET `quantity` = #{substance_quantity - cookie_quantity}
          WHERE `substances`.`id` = #{substance_id}
        }
        Pallet.connection.execute(sql_query)
        true
      else
        false
      end
    end

    def self.enough_substance? quantity, substance_quantity
      substance_quantity > quantity  ? true : false
    end

    def self.pallet_cookie_count
      BOX_CAPACITY * BAG_CAPACITY * PALLET_CAPACITY
    end

end

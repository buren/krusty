class Pallet < ActiveRecord::Base
  belongs_to :order
  belongs_to :cookie

  LOCATIONS = ['deep_freeze', 'delivered', 'delivery_truck']
  BOX_CAPACITY = 10
  BAG_CAPACITY = 15
  PALLET_CAPACITY = 36

  validates_presence_of :order, :cookie
  validates_inclusion_of :location, in: LOCATIONS, allow_nil: false

  # SELECT * FROM `pallets`
  # INNER JOIN `orders` ON `pallets`.order_id = `orders`.id
  # INNER JOIN `cookies` ON `pallets`.cookie_id = `cookies`.id
  # WHERE `pallets`.`cookie_id` = ?
  #         AND (`pallets`.`created_at`
  #       BETWEEN '?'
  #       AND '?'
  #     )
  def self.search date_range, only_blocked, cookie_id
    results = Pallet.all
    results = results.includes(:order).includes(:cookie)

    results = where(created_at: date_range)
    results = results.where(is_blocked: true)     if only_blocked
    results = results.where(cookie_id: cookie_id) unless cookie_id.blank?
    results
  end

  def self.search_sql date_range, only_blocked, cookie_id
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
    sql_query << "AND `pallets`.`cookie_id` = #{cookie_id}" unless cookie_id.blank?
    sql_query << " AND `pallets`.`is_blocked` = 1" if only_blocked
    Pallet.connection.execute(sql_query)
  end

  # UPDATE `pallets` SET `pallets`.`is_blocked` = 1
  #   WHERE `pallets`.`cookie_id` = 3
  #   AND (`pallets`.`created_at`
  #     BETWEEN '2014-02-27'
  #     AND '2014-03-29'
  #   )
  def self.block date_range, cookie
    where(cookie_id: cookie.id)
    .where(created_at: date_range)
    .update_all(is_blocked: true)
  end

  # SELECT `pallets`.* FROM `pallets`
  #   WHERE `pallets`.`is_blocked` = 1
  def self.blocked_pallets
    where(is_blocked: true)
  end

  # BEGIN
  #   SELECT `recipes`.* FROM `recipes` WHERE `recipes`.`cookie_id` = 3
  #   SELECT `substances`.* FROM `substances` WHERE `substances`.`id` IN (3, 4, 5, 6)
  #   UPDATE `substances` SET `quantity` = 73795, `updated_at` = '2014-03-26 08:31:42' WHERE `substances`.`id` = 4
  #   UPDATE `substances` SET `quantity` = 33795, `updated_at` = '2014-03-26 08:31:42' WHERE `substances`.`id` = 5
  #   UPDATE `substances` SET `quantity` = 8795, `updated_at` = '2014-03-26 08:31:42' WHERE `substances`.`id` = 6
  # ROLLBACK
  def self.produce quantity, cookie
    cookie_quantity = quantity * Pallet.pallet_cookie_count
    recipes = cookie.recipes.includes(:substance)
    updated_substances = Array.new
    Substance.transaction do
      recipes.each do |cookie_ingredient|
        substance = cookie_ingredient.substance
        updated_substances << self.produce_cookie(cookie_quantity, substance)
      end

      if updated_substances.include?(false)
        raise ActiveRecord::Rollback, "Not enough #{'substance.name'} missing: #{'cookie_quantity - substance.quantity'} (g)"
      end
    end
    updated_substances.reject(&:blank?).size.eql? updated_substances.size
  end


  private

    def self.produce_cookie cookie_quantity, substance
      if enough_substance?(cookie_quantity, substance)
        substance.update(quantity: substance.quantity - cookie_quantity) # SQL
      else
        false
      end
    end

    def self.enough_substance? quantity, substance
      substance.quantity > quantity  ? true : false
    end

    def self.pallet_cookie_count
      BOX_CAPACITY * BAG_CAPACITY * PALLET_CAPACITY
    end

end

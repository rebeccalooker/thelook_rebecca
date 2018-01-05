view: products {
  sql_table_name: public.products ;;

  dimension: id {
    label: "Product ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: cost_bracket {
    case: {
      when: {
        sql: ${cost} < 1.00 ;;
        label: "Pennies"
      }
      when: {
        sql: ${cost} >= 1.00 and ${cost} < 15.00 ;;
        label: "Cheap Wares"
      }
      when: {
        sql: ${cost} >= 15.00 and ${cost} < 40.00 ;;
        label: "Average Goods"
      }
      when: {
        sql: ${cost} >= 40.00 and ${cost} < 100.00 ;;
        label: "Pricy Stuff"
      }
      else: "Big Spender!"
    }
    drill_fields: [id, category, cost]
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}

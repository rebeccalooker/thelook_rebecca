view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    hidden: yes
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: returned_at {
    type: date
    sql: ${TABLE}.returned_at ;;
    hidden: yes
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: order_distance {
    description: "Distance from customer's device IP address to physical delivery address"
    type: distance
    start_location_field: events.user_location
    end_location_field: users.delivery_location
    units: miles
  }

  dimension: shipment_distance {
    description: "Distance from distribution center to customer's delivery address"
    type: distance
    start_location_field: distribution_centers.dc_location
    end_location_field: users.delivery_location
    units: miles
  }

  dimension: shipment_prep_period {
    description: "Number of days from order creation to shipment"
    type: number
    sql: DATEDIFF(day, ${created_date}, ${shipped_date}) ;;
    value_format_name: decimal_0
  }

  dimension: item_trial_period {
    description: "Number of days from item delivery to return"
    type: number
    sql: DATEDIFF(day, ${TABLE}.returned_at, ${TABLE}.delivered_at) / 24 ;;
    value_format_name: "decimal_1"
    drill_fields: [detail*, delivered_date, returned_date]
  }

  measure: count {
    type: count
    filters: {
      field: order_id
      value: ">= 1"
    }
    drill_fields: [detail*]
  }

  measure: total_order_revenue {
    type: sum
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
    filters: {
      field: returned_at
      value: "NULL"
    }
    filters: {
      field: sale_price
      value: ">0"
    }
    drill_fields: [detail*]
  }

  measure: average_order_revenue {
    type: number
    sql: ${total_order_revenue} / ${count} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  # ----- Gets error about dividing by zero -----
  measure: order_ratio {
    label: "Total-to-Average Ratio"
    description: "Ratio of total order amount to average order amount"
    type: number
    sql: ${total_order_revenue} / (${average_order_revenue}+0.00001) ;;
    value_format_name: decimal_3
    drill_fields: [detail*, -inventory_items.id, -inventory_items.product_name]
  }

  measure: total_shipment_distance {
    description: "Total shipment distance across all orders, in miles"
    type: sum
    sql: ${shipment_distance} ;;
    value_format_name: decimal_1
    drill_fields: [detail*]
  }

  # ----- Gets error about inventory_items table -----
##  measure: item_profit {
##    type: sum
##    sql: (${sale_price} - inventory_items.product_retail_price)*100 /
##          inventory_items.product_retail_price ;;
##    value_format_name: decimal_2
##    drill_fields: [order_id,
##      inventory_items.id,
##      inventory_items.product_name,
##      inventory_items.product_retail_price,
##      sale_price]
##  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      order_id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}

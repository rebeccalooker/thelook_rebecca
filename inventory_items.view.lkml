view: inventory_items {
  sql_table_name: public.inventory_items ;;

  dimension: id {
    label: "Inventory Item ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
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

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension_group: sold {
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
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    drill_fields: [id, product_name, order_items.count]
  }

  measure: total_retail_price {
    type: sum
    sql: ${product_retail_price} ;;
    drill_fields: [id, product_name, order_items.count]
  }

  measure: markup_percentage {
    type: number
    sql: (100 * (${total_retail_price} - ${total_cost})) / ${total_cost} ;;
    value_format_name: decimal_2
    drill_fields: [id, product_name, order_items.count]
  }

  set: product_details {
    fields: [
      product_brand,
      product_category,
      product_department,
      product_name,
      product_sku
    ]
  }

  set: cost_details {
    fields: [
      cost,
      product_retail_price
    ]
  }
}

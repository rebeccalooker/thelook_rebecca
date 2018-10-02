connection: "thelook_events"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: thelook_rebecca_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "4 hours"
}

persist_with: thelook_rebecca_default_datagroup

explore: events {
  join: users {
    view_label: "Customers"
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_sessions {
    view_label: "Customer Session Details"
    type:  inner
    sql_on: ${events.user_id} = ${user_sessions.user_id} ;;
    relationship:  one_to_one
  }
}

explore: inventory_items {
  always_filter: {
    filters: {
      field: product_distribution_center_id
      value: "6"
    }
    }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
    fields: [distribution_centers.name,
             distribution_centers.dc_location]
  }
}

explore: order_items {
  always_filter: {
    filters: {
      field: created_time
      value: "7 days"
    }
  }
  sql_always_where: ${created_date} >= '2015-01-01' ;;

  join: users {
    view_label: "Customers"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: events {
    type: left_outer
    sql_on: ${users.id} = ${events.user_id} ;;
    relationship: one_to_many
    view_label: "Order Activities"
    fields: [events.geographic_details*]
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  view_label: "Customers"
}

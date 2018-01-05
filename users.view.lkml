view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    label: "Customer ID"
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: tier
    tiers: [10, 18, 36, 66]
    style:  integer
    sql: ${TABLE}.age ;;
  }

  dimension: age_bracket {
    case: {
      when: {
        sql: ${age} < 18 ;;
        label: "Minor"
      }
      when: {
        sql: ${age} between 18 and 35 ;;
        label: "18-35"
      }
      when: {
        sql: ${age} between 36 and 55 ;;
        label: "36-65"
      }
      else: "Senior"
    }
    drill_fields: [id, age]
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
    hidden: yes
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
    hidden: yes
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: delivery_location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: average {
    type: average
    precision: 2
    drill_fields: [id, first_name, last_name, age]
  }
}

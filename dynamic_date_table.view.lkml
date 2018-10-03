
view: dt_month {
  # this builds once a month
  derived_table: {
    sql:
    SELECT DATE_TRUNC('month', order_items.created_at) as dt_date, count(*) as dt_count
    FROM order_items
    GROUP BY 1
    ;;
  }

}

view: dt_week {
  # this builds once a week
  derived_table: {
    sql:
    SELECT DATE_TRUNC('week', order_items.created_at) as dt_date
    FROM order_items

    GROUP BY 1
    ;;
  }

}

view: dt_day {
  # this builds once a day
  derived_table: {
    sql:
    SELECT DATE_TRUNC('day', order_items.created_at) as dt_date
    , count(*) as dt_count
    FROM order_items

    GROUP BY 1
    ;;
  }

}

view: dt_diff_helper {
  # this builds once a day
  derived_table: {
    sql: SELECT DATEDIFF(day, {% date_start dynamic_time_dt.date_filter %}, {% date_end dynamic_time_dt.date_filter %}) as days
                , {% assign var = _filters['dynamic_time_dt.date_filter'] | split: ' ' %} {{ var[0] | date: "%Y/%b/%d"  }}
    ;;
  }

  dimension: days {
    type: number
  }

}


explore: dynamic_time_dt {
  join: dt_diff_helper {type:cross}

}

view: dynamic_time_dt {
    sql_table_name: (SELECT * FROM ${dt_day.SQL_TABLE_NAME})
                   ;;

#  /*{% if dt_diff_helper.days._value > 30 %} (SELECT * FROM ${dt_month.SQL_TABLE_NAME})
#                     {% elsif dt_diff_helper.days._value > 7 %} (SELECT * FROM ${dt_week.SQL_TABLE_NAME})
#                     {% else %} (SELECT * FROM ${dt_day.SQL_TABLE_NAME}) {% endif %}*/


# {% asssign var =  %} 10/22
  filter: date_filter {type: date}

  dimension: dynamic_time_dimension {
    sql: 1 ;;

  }

  dimension_group: all_of_the_times {
    # hidden: yes
    type: time
    sql: ${TABLE}.dt_date ;;
  }

  dimension: dt_date {
    sql: ${TABLE}.dt_date;;
  }

  dimension: dt_count {}

  measure: total_dt_count {
    type: sum
    sql: ${TABLE}.dt_count ;;
  }

}

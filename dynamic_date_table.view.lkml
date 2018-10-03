
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
    SELECT DATE_TRUNC('week', order_items.created_at) as dt_date, count(*) as dt_count
    FROM order_items

    GROUP BY 1
    ;;
  }

}

view: dt_day {
  # this builds once a day
  derived_table: {
    sql:
    SELECT DATE_TRUNC('day', order_items.created_at) as dt_date, count(*) as dt_count
    FROM order_items

    GROUP BY 1
    ;;
  }
}


view: dynamic_time_dt {
    sql_table_name: {% if date_filter_diff.value > 30 %} (SELECT * FROM ${dt_month.SQL_TABLE_NAME})
                    {% elsif date_filter_diff.value > 7 %} (SELECT * FROM ${dt_week.SQL_TABLE_NAME})
                    {% else %} (SELECT * FROM ${dt_day.SQL_TABLE_NAME}) {% endif %};;


  filter: date_filter {type: date}

  dimension: date_filter_diff {
    hidden: yes
    type: number
    sql: DATEDIFF(day, {% date_start date_filter %}, {% date_end date_filter %}) ;;
  }

  dimension: dynamic_time_dimension {
    sql: {% if date_granularity.value =='Month' %} ${all_of_the_times_month}
          {% elsif date_granularity.value =='Week' %} ${all_of_the_times_week}
          {% elsif date_granularity.value =='Day' %} ${all_of_the_times_date} {% endif %} ;;
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

view: date_granularity {
  derived_table: {
  sql:
      {% if dynamic_time_dt.date_filter_diff.value > 30 %} (SELECT 'Month' UNION SELECT 'Week')
      {% elsif dynamic_time_dt.date_filter_diff.value > 7 %} (SELECT 'Week' UNION SELECT 'Day')
      {% else %} (SELECT 'Day' UNION SELECT 'Hour') {% endif %}
      ;;
}
dimension: date_granularity {}
}

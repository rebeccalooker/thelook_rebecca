view: user_sessions {
  derived_table: {
    sql:
      SELECT b.user_id, a.event_date,
        a.first_event_number, b.event_type as first_event_type,
        c.last_event_number, d.event_type as last_event_type
      FROM (
        SELECT user_id, TRUNC(created_at) AS event_date,
          MIN(sequence_number) AS first_event_number
        FROM events
        GROUP BY user_id, event_date) a
      JOIN events b ON a.user_id = b.user_id
        AND a.event_date = TRUNC(b.created_at)
        AND a.first_event_number = b.sequence_number
      JOIN (
        SELECT user_id, TRUNC(created_at) AS event_date,
          MAX(sequence_number) AS last_event_number
        FROM events
        GROUP BY user_id, event_date) c
        ON b.user_id = c.user_id
        AND TRUNC(b.created_at) = c.event_date
      JOIN events d ON c.user_id = d.user_id
        AND c.event_date = TRUNC(d.created_at)
        AND c.last_event_number = d.sequence_number
      ORDER BY a.event_date asc;;
  }

  dimension: user_id {
    label: "Customer ID"
    description: "Unique ID for each website user"
    type: number
    sql: ${TABLE}.user_id ;;
    hidden:  yes
  }

  dimension: ip_address {
    description: "IP address of the user"
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  dimension: event_date {
    label: "Website Activity Timestamp"
    description: "Date of user activity"
    type: date
    sql:  ${TABLE}.event_date ;;
  }

  dimension: first_event_number {
    label: "First Activity #"
    description: "User's first event sequence number of the day"
    type:  number
    sql:  ${TABLE}.first_event_number ;;
  }

  dimension: first_event_type {
    label: "First Activity Type"
    description: "User's first event type of the day"
    type:  string
    sql:  ${TABLE}.first_event_type ;;
  }

  dimension: last_event_number {
    label: "Last Activity #"
    description: "User's last event sequence number of the day"
    type:  number
    sql:  ${TABLE}.last_event_number ;;
  }

  dimension: last_event_type {
    label: "Last Activity Type"
    description: "User's last event type of the day"
    type:  string
    sql:  ${TABLE}.last_event_type ;;
  }

  measure: count {
    type: count
    drill_fields: [user_id, ip_address]
  }

}

- dashboard: dc_information
  title: DC Information
  layout: static
  tile_size: 100

  filters:
    - name: order_destination
      title: 'Order Destination'
      type: field_filter
      explore: users
      field: users.country
      default_value: 'USA'

  elements:
    - name: dc_funnel
      title: 'DC Utilization'
      model: thelook_rebecca
      explore: products
      type: looker_funnel
      fields: [products.distribution_center_id, products.count, distribution_centers.name]
      sorts: [products.count desc]
      limit: 50
      leftAxisLabelVisible: false
      leftAxisLabel: ''
      rightAxisLabelVisible: false
      rightAxisLabel: ''
      barColors: ["#003eff", "#ff0000"]
      smoothedBars: false
      orientation: automatic
      labelPosition: left
      percentType: total
      percentPosition: inline
      valuePosition: right
      labelColorEnabled: false
      labelColor: "#FFF"
      show_view_names: true
      show_row_numbers: true
      truncate_column_names: false
      hide_totals: false
      hide_row_totals: false
      table_theme: editable
      limit_displayed_rows: false
      enable_conditional_formatting: false
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      series_types: {}
      hidden_fields: [products.distribution_center_id]

    - name: dc_average_revenue
      title: 'Average Revenue from each DC'
      model: thelook_rebecca
      explore: order_items
      type: looker_pie
      left: 6
      fields: [distribution_centers.name, order_items.average_order_revenue]
      sorts: [order_items.average_order_revenue desc]
      limit: 500
      value_labels: legend
      label_type: labPer
      stacking: ''
      show_value_labels: false
      label_density: 25
      legend_position: center
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: true
      limit_displayed_rows: false
      y_axis_combined: true
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      y_axis_tick_density_custom: 5
      show_x_axis_label: true
      show_x_axis_ticks: true
      x_axis_scale: auto
      y_axis_scale_mode: linear
      ordering: none
      show_null_labels: false
      show_totals_labels: false
      show_silhouette: false
      totals_color: "#808080"
      series_types: {}

    - name: dc_total_revenue
      title: 'Total Revenue from each DC'
      model: thelook_rebecca
      explore: order_items
      type: looker_pie
      top: 4
      left: 6
      fields: [distribution_centers.name, order_items.total_order_revenue]
      sorts: [order_items.total_order_revenue desc]
      limit: 500
      value_labels: legend
      label_type: labPer
      stacking: ''
      show_value_labels: false
      label_density: 25
      legend_position: center
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: true
      limit_displayed_rows: false
      y_axis_combined: true
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      y_axis_tick_density_custom: 5
      show_x_axis_label: true
      show_x_axis_ticks: true
      x_axis_scale: auto
      y_axis_scale_mode: linear
      ordering: none
      show_null_labels: false
      show_totals_labels: false
      show_silhouette: false
      totals_color: "#808080"
      series_types: {}

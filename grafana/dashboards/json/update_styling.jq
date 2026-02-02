# Update all timeseries panels with better styling
.panels |= map(
  if .type == "timeseries" then
    # Update custom field config
    .fieldConfig.defaults.custom.fillOpacity = (
      if .fieldConfig.defaults.custom.drawStyle == "bars" then 100
      else 15
      end
    ) |
    .fieldConfig.defaults.custom.showPoints = "never" |
    .fieldConfig.defaults.custom.pointSize = 5 |
    .fieldConfig.defaults.custom.lineWidth = 2 |
    
    # Update legend to show calcs as table at bottom
    .options.legend.calcs = ["last", "mean", "max"] |
    .options.legend.displayMode = "table" |
    .options.legend.placement = "bottom" |
    .options.legend.showLegend = true |
    
    # Update tooltip
    .options.tooltip.mode = "multi" |
    .options.tooltip.sort = "desc"
  else
    .
  end
)

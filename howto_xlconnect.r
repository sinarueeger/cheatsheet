library(XLConnect)

name <- "cl4"
wbFilename <- paste("results", name ,".xlsx", sep = "")
wb <- loadWorkbook(wbFilename, create = TRUE)

sheet <- "data"
dataName <- "iris"
createSheet(wb, name = sheet)
dat <- iris

if(file.exists(wbFilename))
  file.remove(wbFilename)
writeNamedRegionToFile(wbFilename, data = dat, name = dataName,
	                   formula = paste(sheet, "$A$1", sep = "!"),
                     header = TRUE)

saveWorkbook(wb)

wb = loadWorkbook(wbFilename)


# Create a date cell style with a custom format for the Time column
118  # (only show year, month and day without any time fields)
119	csDate = createCellStyle(wb, name = "date")
120	setDataFormat(csDate, format = "yyyy-mm-dd")
121	# Create a time/date cell style for the prediction records
122	csPrediction = createCellStyle(wb, name = "prediction")
123	setDataFormat(csPrediction, format = "yyyy-mm-dd")
124	setFillPattern(csPrediction, fill = XLC$FILL.SOLID_FOREGROUND)
125	setFillForegroundColor(csPrediction, color = XLC$COLOR.GREY_25_PERCENT)
126	# Create a percentage cell style
127	# Number format: 2 digits after decimal point
128	csPercentage = createCellStyle(wb, name = "currency")
129	setDataFormat(csPercentage, format = "0.00%")
130	# Create a highlighting cell style
131	csHlight = createCellStyle(wb, name = "highlight")
132	setFillPattern(csHlight, fill = XLC$FILL.SOLID_FOREGROUND)
133	setFillForegroundColor(csHlight, color = XLC$COLOR.CORNFLOWER_BLUE)
134	setDataFormat(csHlight, format = "0.00%")

wb = loadWorkbook(wbFilename)

# Stack currencies into a currency variable (for use with ggplot2 below)
gcurr = reshape(curr, varying = currencies, direction = "long",
	                v.names = "Value", times = currencies, timevar = "Currency")
# Also add a discriminator column to differentiate between actual and
# prediction values
gcurr[["Type"]] = ifelse(gcurr$Time %in% currFit$Time, "prediction", "actual")
 
# Create a png graph showing the currencies in the context of the Swiss Franc
png(filename = "swiss_franc.png", width = 800, height = 600)
ggplot(gcurr, aes(Time, Value, colour = Currency, linetype = Type)) +
  geom_line() + stat_smooth(method = "loess") + xlab("") +
  scale_y_continuous("Change to baseline", formatter = "percent") +
  opts(title = "Currencies vs Swiss Franc",
       axis.title.y = theme_text(size = 10, angle = 90, vjust = 0.3))
dev.off()

# Define where the image should be placed via a named region;
# let's put the image two columns left to the data starting in the 5th row
createName(wb, name = "graph",
           formula = paste(sheet, idx2cref(c(5, ncol(curr) + 2)), sep = "!"))
# Note: idx2cref converts indices (row, col) to Excel cell references

# Put the image created above at the corresponding location
addImage(wb, filename = "swiss_franc.png", name = "graph",
	         originalSize = TRUE)
request_logs_code <- sprintf(request_logs_str,1020, 1:25)

output <- lapply(seq_along(request_logs_code), function(i) {

  response <- WCL_API2_request(request_logs_code[i]
  )$data$reportData$reports$data

  if (i %% 5 == 0) {
    cat("Processed", i, "out of", length(request_logs_code), "\n")
  }

  return(response)
})

output <- do.call(bind_rows, output)

logs_code_df <- output %>%
  distinct(code, .keep_all = TRUE) %>%
  rename(logID = code) %>%
  mutate(startTime = as_datetime(as.POSIXct(startTime/1000, origin="1970-01-01")),
         endTime = as_datetime(as.POSIXct(endTime/1000, origin="1970-01-01")),
         logNote ="Sample")


write.csv(logs_code_df,paste0("./raw_data/response_logs_code_df_",format(Sys.time(), "%Y_%m_%d_h%H_m%M"),".csv"))

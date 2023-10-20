output <- lapply(seq_along(request_logs_code), function(i) {

  response <- WCL_API2_request(request_logs_code[i]
  )$data$reportData$report$events$data

  if (!is.null(response) & length(response)>0) {
    response <- response %>%
      mutate(logID = as.character(df_query$logID[i]))
  } else {
    response <- data.frame(timestamp=-1,
                           logID = as.character(df_query$logID[i]))
  }

  if (i %% 25 == 0) {
    cat("Processed log",i, "out of", n_loop," PTR logs\n")
  }

  return(response)
})

output2 <- do.call(bind_rows, output)

write.csv(output2,paste0("./raw_data/output_dmg_taken_",format(Sys.time(), "%Y_%m_%d_h%H_m%M"),".csv"))

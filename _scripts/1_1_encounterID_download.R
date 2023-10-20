
output <- lapply(seq_along(request_encounter), function(i) {

  response <- WCL_API2_request(request_encounter[i])$data$reportData$report$fights

  if (i %% 50 == 0) {
    cat("Processed", i, "out of", length(request_encounter), "\n")
  }

  if(!is.null(response) & length(response)>0) {

    response <- mutate(response,
                       duration = endTime - startTime,
                       duration_s = duration/1000,
                       logID = as.character(logIDs[i])
    )

    response <- rename(response,fightID = id)

  } else {
    response <- data.frame(logID = character(0),
                           fightID=integer(0),
                           encounterID=integer(0),
                           difficulty =integer(0),
                           hardModeLevel =integer(0),
                           averageItemLevel =integer(0),
                           size =integer(0),
                           kill =character(0),
                           lastPhase =integer(0),
                           startTime=integer(0) ,
                           endTime =integer(0),
                           fightPercentage=integer(0) ,
                           bossPercentage=integer(0) ,
                           completeRaid =character(0),

                           duration=integer(0)  ,
                           duration_s=integer(0)

    )
  }
  return(response)
})

encounter_data <- do.call(rbind, output)

write.csv(encounter_data,paste0("./raw_data/encounter_data_ICC_",format(Sys.time(), "%Y_%m_%d_h%H_m%M"),".csv"))

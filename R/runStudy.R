runStudy <- function(cdm_bbdd,
                     cdm_schema,
                     results_sc,
                     cohortTable){
  cohortInfo <- CreateSQL_T2DM(cdm_bbdd,
                               cdm_schema,
                               results_sc,
                               cohortTable)
  outcomeInfo <- CreateSQL_T2DM_outcome(cdm_bbdd,
                                        cdm_schema,
                                        results_sc,
                                        cohortTable)
  n_cohort <- createCohort(cdm_bbdd,
                           cdm_schema,
                           results_sc,
                           cohortTable,
                           cohortInfo,
                           outcomeInfo)
  return(n_cohort)
}

#' Run all the study
#'
#' @param cdm_bbdd A connection for a OMOP database via DatabaseConnector
#' @param cdm_schema A name for OMOP schema
#' @param results_sc A name for result schema
#' @param cohortTable A name of the result cohort
#' @param rundiag Logical.
#' @param exportFolder Directory to save Diagnostic
#'
#' @return A complete study
#' @export
#'
#' @examples
#' # Not yet
runStudy <- function(cdm_bbdd,
                     cdm_schema,
                     results_sc,
                     cohortTable,
                     rundiag = FALSE,
                     exportFolder){
  cohortInfo <- CreateSQL_T2DM(cdm_bbdd,
                               cdm_schema,
                               results_sc,
                               cohortTable)
  outcomeInfo <- CreateSQL_T2DM_outcome(cdm_bbdd,
                                        cdm_schema,
                                        results_sc,
                                        cohortTable)
  cohortDefinitionSet <- data.frame(atlasId = rep(NA, 2),
                                    cohortId = 1:2,
                                    cohortName = c("SIDIAP T2DM-WP5: Entrada",
                                                   "SIDIAP T2DM-WP5: Outcome"),
                                    sql = c(cohortInfo$ohdiSQL,
                                            outcomeInfo$ohdiSQL),
                                    json = c(cohortInfo$circeJson,
                                             outcomeInfo$circeJson),
                                    logicDescription = rep(as.character(NA), 2),
                                    generateStats = rep(TRUE, 2))
  n_cohort <- createCohort(cdm_bbdd,
                           cdm_schema,
                           results_sc,
                           cohortTable,
                           cohortDefinitionSet)

  if(rundiag){
    fet_diag <- runDiagnostic(cdm_bbdd,
                              cdm_schema,
                              results_sc,
                              cohortTable,
                              cohortDefinitionSet)
  }
  return(n_cohort)
}

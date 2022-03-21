createCohort <- function(cdm_bbdd,
                         cdm_schema,
                         results_sc,
                         cohortTable,
                         cohortInfo = cohortInfo,
                         outcomeInfo = outcomeInfo,
                         cohortTable = cohortTable){
  cohortDefinitionSet <- data.frame(atlasId = rep(NA, 2),
                                    cohortId = 1:2,
                                    cohortName = c("SIDIAP T2DM-WP5: Entrada",
                                                   "SIDIAP T2DM-WP5: Outcome"),
                                    sql = c(cohortInfo$ohdiSQL,
                                            outcomeInfo$ohdiSQL),
                                    json = c(cohortInfo$circeJson,
                                             outcomeInfo$circeJson),
                                    logicDescription = rep(as.character(NA), 2),
                                    generateStats = rep(T, 2)) %>%

    cohortTableNames <- getCohortTableNames(cohortTable = cohortTable)
    createCohortTables(connection = cdm_bbdd,
                       cohortTableNames = cohortTableNames,
                       cohortDatabaseSchema = results_sc,
                       incremental = FALSE)
    generateCohortSet(connection = cdm_bbdd,
                      cdmDatabaseSchema = cdm_schema,
                      cohortDatabaseSchema = results_sc,
                      cohortTableNames = cohortTableNames,
                      cohortDefinitionSet = cohortDefinitionSet,
                      incremental = FALSE)
    cohortCounts <- getCohortCounts(connection = cdm_bbdd,
                                    cohortDatabaseSchema = results_sc,
                                    cohortTable = cohortTableNames$cohortTable)
    return(cohortCounts)
}

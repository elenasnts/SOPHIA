#' Title
#'
#' @param cdm_bbdd A connection for a OMOP database via DatabaseConnector
#' @param cdm_schema A name for OMOP schema
#' @param results_sc A name for result schema
#' @param cohortTable A name of the result cohort
#' @param cohortDefinitionSet Object including SQL and JSON for create Cohort
#' @param exportFolder Directory to save Diagnostic
#'
#' @return Character
#' @export
#'
#' @examples
#' Sys.setenv("DATABASECONNECTOR_JAR_FOLDER" = "~idiap/projects/SOPHIA_codi/data/jdbcDrivers/")
#' dbms = Sys.getenv("DBMS")
#' user <- if (Sys.getenv("DB_USER") == "") NULL else Sys.getenv("DB_USER")
#' password <- if (Sys.getenv("DB_PASSWORD") == "") NULL else Sys.getenv("DB_PASSWORD")
#' server = Sys.getenv("DB_SERVER")
#' port = Sys.getenv("DB_PORT")
#' connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
#'                                                                 server = server,
#'                                                                 user = user,
#'                                                                 password = password,
#'                                                                 port = port)
#' cdm_bbdd <- DatabaseConnector::connect(connectionDetails = connectionDetails)
#' cdm_schema <- 'omop21t2_test'
#' results_sc <- 'sophia_test'
#' cohortTable <- 'prova_Capr'
#' cohortInfo <- CreateSQL_T2DM(cdm_bbdd, cdm_schema, results_sc, cohortTable)
#' outcomeInfo <- CreateSQL_T2DM_outcome(cdm_bbdd, cdm_schema, results_sc, cohortTable)
#' cohortDefinitionSet <- data.frame(atlasId = rep(NA, 2),
#'                                   cohortId = 1:2,
#'                                   cohortName = c("SIDIAP T2DM-WP5: Entrada",
#'                                                  "SIDIAP T2DM-WP5: Outcome"),
#'                                   sql = c(cohortInfo$ohdiSQL,
#'                                           outcomeInfo$ohdiSQL),
#'                                   json = c(cohortInfo$circeJson,
#'                                            outcomeInfo$circeJson),
#'                                   logicDescription = rep(as.character(NA), 2),
#'                                   generateStats = rep(TRUE, 2))
#' # cohortCounts <- createCohort(cdm_bbdd, cdm_schema, results_sc, cohortTable,
#' #                              cohortDefinitionSet)
#' # fet_diag <- runDiagnostic(cdm_bbdd, cdm_schema, results_sc, cohortTable,
#' #                           cohortDefinitionSet)
runDiagnostic <- function(cdm_bbdd,
                          cdm_schema,
                          results_sc,
                          cohortTable,
                          cohortDefinitionSet,
                          exportFolder = 'export'){
  CohortDiagnostics::executeDiagnostics(cohortDefinitionSet,
                                        connection = cdm_bbdd,
                                        cohortTable = cohortTable,
                                        cohortDatabaseSchema = results_sc,
                                        cdmDatabaseSchema = cdm_schema,
                                        exportFolder = exportFolder,
                                        databaseId = "T2DM",
                                        minCellCount = 0)
  cohortTableNames <- CohortGenerator::getCohortTableNames(cohortTable = cohortTable)
  CohortGenerator::dropCohortStatsTables(connection = cdm_bbdd,
                                         cohortDatabaseSchema = results_sc,
                                         cohortTableNames = cohortTableNames)
  CohortDiagnostics::createMergedResultsFile(exportFolder)
  return("Fet")
}

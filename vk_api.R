getVK <- function(acc_id, cli_id, startdate, ...)
{
  library("jsonlite")
  dots <- list(...)
  if("lib" %in% names(dots))
  {
    library("httr", lib.loc = dots[["lib"]])
  }
  else
  {
    library("httr")
  }
  if("enddate" %in% names(dots))
  {
    end = dots[["enddate"]]
  }
  else
  {
    end <- as.Date(Sys.Date(), "DD-MM-YYYY")
  }
  if("token" %in% names(dots))
  {
    vk_token = dots[["token"]]
  }
  else
  {
    browseURL(oauth)
    vk_token <- readline(prompt = "Enter #access_token value from URL: ")
  }
  oauth = "https://oauth.vk.com/authorize?client_id=5671690&display=page&redirect_uri=https://vk.com/&scope=ads,offline&response_type=token&v=5.60"
  
  vk_camp <- GET("https://api.vk.com/method/ads.getCampaigns", query = list(
    access_token = vk_token,
    account_id = acc_id,
    client_id = cli_id,
    include_deleted = 1
  ))
  camp_list <- content(vk_camp)
  vk_digest <- data.frame(do.call(rbind, camp_list$response))
  vk_digest <- vk_digest[, c(1,2,3)]
  vk_digest <- unique(vk_digest)
  vk_stats <- GET("https://api.vk.com/method/ads.getStatistics", query = list(
    access_token = vk_token,
    account_id = acc_id,
    ids_type = "campaign",
    ids = toString(vk_digest$id),
    period = "day",
    date_from = startdate,
    date_to = end
  ))
  vk_stats = content(vk_stats)
  vk_stats = vk_stats$response
  vk_json <- jsonlite::toJSON(vk_stats)
  vk_stats_df <- data.frame(do.call(rbind, vk_stats))
  return(list(digest = vk_digest, stats = vk_stats))
}
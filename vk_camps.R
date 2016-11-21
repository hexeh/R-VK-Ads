campaignsVK <- function(vk_token, acc_id, cli_id, archive = 1,...)
{
  dots <- list(...)
  if("lib" %in% names(dots)){
    library("httr", lib.loc = dots[["lib"]])
  }
  else
  {
    library("httr")
  }
  vk_camp <- GET("https://api.vk.com/method/ads.getCampaigns", query = list(
    access_token = vk_token,
    account_id = acc_id,
    client_id = cli_id,
    include_deleted = archive
  ))
  camp_list <- content(vk_camp)
  vk_digest <- data.frame(do.call(rbind, camp_list$response))
  vk_digest <- unique(vk_digest)
  return(camp_list)
}


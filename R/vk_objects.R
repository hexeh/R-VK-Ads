objectsVK <- function(vk_token, acc_id, cli_id, o_type, ...)
{
  dots <- list(...)
  if("lib" %in% names(dots)){
    library("httr", lib.loc = dots[["lib"]])
  }
  else
  {
    library("httr")
  }
  switch(o_type,
         "campaign" = {
           vk_o <- GET("https://api.vk.com/method/ads.getCampaigns", query = list(
             access_token = vk_token,
             account_id = acc_id,
             client_id = cli_id,
             include_deleted = ifelse("archive" %in% dots, dots[["archive"]], 1)
           ))
          },
         "ad" = {
           vk_o <- GET("https://api.vk.com/method/ads.getAds", query = list(
             access_token = vk_token,
             account_id = acc_id,
             client_id = cli_id,
             include_deleted = ifelse("archive" %in% dots, dots[["archive"]], 1),
             campaign_ids = ifelse("campaign_ids" %in% dots, dots[["campaign_ids"]], "NULL"),
             ad_ids = ifelse("ad_ids" %in% dots, dots[["ad_ids"]], "NULL"),
             limit = ifelse("limit" %in% dots, dots[["limit"]], 0),
             offset = ifelse("offset" %in% dots, dots[["offset"]], 0)
           ))
          },
         "client" = {
           vk_o <- GET("https://api.vk.com/method/ads.getClients", query = list(
             access_token = vk_token,
             account_id = acc_id
           ))
         },
         "office" = {
           vk_o <- GET("https://api.vk.com/method/ads.getAccounts", query = list(
             access_token = vk_token,
             account_id = acc_id
           ))
         }
         )
  camp_o <- content(vk_o)
  vk_digest <- data.frame(do.call(rbind, camp_o$response))
  vk_digest <- unique(vk_digest)
  return(list(details = camp_o$response, digest = vk_digest))
}

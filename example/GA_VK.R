#Combine VKontakte and Google Analytics stats by weeks

library("httr")
library("RGA")

client.id = "Google OAuth2.0 identifier from Google Analytics API Console"
client.secret = "Google OAuth2.0 secret from Google Analytics API Console"
authorize(username = "YourMailFrom@gmail.com", client.id = client.id, client.secret = client.secret, reauth = TRUE)
start = "2016-11-1"
week = 44
if(file.exists("vk_analytics.csv"))
{
  vk_an_exist <- read.csv("vk_analytics.csv", stringsAsFactors = FALSE)
  vk_an_exist[,1] <- NULL
  vk_lastd <- vk_an_exist[length(vk_an_exist$date), 2]
  week = vk_an_exist[length(vk_an_exist$date), 12]
  vk_lastd = max(as.Date(start), as.Date(vk_lastd))
} else
{
  write.csv(x = data.frame(empty=character(), stringsAsFactors = FALSE),"vk_analytics.csv")
  vk_lastd <- start
  vk_an_exist <- read.csv("vk_analytics.csv", stringsAsFactors = FALSE)
}
vk_all <- vk_ass <-data.frame(Hello=character(),
                              From=character(), 
                              Google=character(), 
                              stringsAsFactors=FALSE)
start = max(as.Date(start), as.Date(vk_lastd) + 1)
end = as.Date(start) + 7

# Google Query Explorer - https://ga-dev-tools.appspot.com/query-explorer/

while(as.Date(end) <= as.Date(format(Sys.Date(), "%Y-%m-%d")) - 1)
{
  vk_an <- get_ga(start.date = start,
                  end.date = end,
                  dimensions = "ga:campaign,ga:date",
                  metrics = "ga:percentNewSessions,ga:sessions,ga:bounceRate,ga:impressions,ga:adClicks,ga:adCost,ga:goal14Completions,ga:transactions,ga:transactionRevenue",
                  filters = "ga:source=~vk",
                  fetch.by = "day",
                  profileId = "GET THIS FROM QUERY EXPLORER")
  vk_mcf <- get_mcf(profileId = "GET THIS FROM QUERY EXPLORER", 
                    start.date = start, 
                    end.date = end, 
                    dimensions = "mcf:campaignName,mcf:conversionDate",
                    filters = "mcf:source=~vk",
                    metrics = "mcf:assistedConversions",
                    fetch.by = "day")
  vk_an$week <- vk_mcf$week <- week;
  vk_all <- rbind(vk_all, vk_an)
  vk_ass <- rbind(vk_ass, vk_mcf)
  start = as.Date(end) + 1
  end = as.Date(start) + 6
  week = week + 1
}

# Get VK stats
my_token <- tokenVK(store = TRUE)
my_account_id = "1234567890"
my_client_id = "123456"
list_of_campaigns <- objectsVK(vk_token, acc_id = my_account_id, cli_id = my_client_id, o_type = "campaign")
camp_list <- content(vk_camp)
vk_digest <- data.frame(do.call(rbind, camp_list$response))
vk_digest <- vk_digest[, c(1,2,3)]
vk_digest <- unique(vk_digest)
ids_list <- list_of_campaigns$digest[,1]
ids_list <- toString(unique(ids_list))
my_ads_stats <- statsVK(my_token, my_account_id, startdate = "2016-11-1", enddate = start - 1, campaign_ids = ids_list)

#Store Info
write(my_ads_stats, "vk.json")
write.csv(x = vk_ass, file = 'vk_associated.csv', append = FALSE)
write.csv(x = rbind(vk_an_exist,vk_all), file = 'vk_analytics.csv', append = FALSE)

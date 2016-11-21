tokenVK <- function(save = FALSE, scope = "ads", ...)
{
  if("token" %in% names(dots))
  {
    vk_token = dots[["token"]]
  }
  else
  {
    oauth = paste0(
      paste0(
        "https://oauth.vk.com/authorize?client_id=5671690&display=page&redirect_uri=https://vk.com/&scope=",
        scope),
      ",offline&response_type=token&v=5.60")
    browseURL(oauth)
    vk_token <- readline(prompt = "Enter #access_token value from URL: ")
  }
  if(save)
  {
    save(vk_token, file = "VK_token")
  }
  return(vk_token)
}

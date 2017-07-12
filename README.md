# VK Ads API
### R Language

---
 
# Получение токена
 
```R
# Simply get token
my_token <- tokenVK()
# Get and store token into file
my_token <- tokenVK(store = TRUE)
# Store existing token into file
tokenVK(store = TRUE, token = my_token)
```

Возможные входные параметры:
 - **save** - нужно ли сохранить полученный токен в файл, *TRUE/FALSE*;
 - **scope** - уровень доступа токена к личной информации, [подробности](https://vk.com/dev/permissions). Значение по умолчанию - *ads*;
 - **token** - строка токена
 
К уровню доступа токена добавляется бит *offline*, так что получение можно произвести всего один раз, а далее просто загружать значение сохраненного токена из файла.

---

# Получение списка объектов
 
```R
my_account_id = "1234567890"
my_client_id = "123456"
list_of_campaigns <- objectsVK(vk_token, acc_id = my_account_id, cli_id = my_client_id, o_type = "campaign")
 ```

Возможные входные параметры:
 - **vk_token**;
 - **acc_id**;
 - **cli_id**;
 - **archive** - включать или нет заархивированные кампании в список, [подробнее](https://vk.com/dev/ads.getCampaigns);
 - **lib** - расположение библиотеки *httr*, по умолчанию будет произведена попытка подключить библиотеки из стандартного расположения;
 - **o_type** - тип возвращаемого объекта - "campaign", "ad", "client", "office";
 - **campaign_ids** - параметр фильтрации по ID кампаний, может использоваться при получении списка объявлений;
 - **ad_ids** - параметр фильтрации по ID объявлений, может использоваться при получении списка объявлений;
 - **limit** - параметр ограничения количества возвращаемых элементов, может использоваться при получении списка объявлений;
 - **offset** - параметр смещения в массиве возвращаемых элементов, может использоваться при получении списка объявлений;
 
 
Описание возвращаемого [объекта](https://vk.com/dev/ads.getCampaigns)

---

# Получение статистики

```R
ids_list <- list_of_campaigns$digest[,1]
ids_list <- toString(unique(ids_list))
my_ads_stats <- statsVK(my_token, my_account_id, startdate = "2016-10-20", campaign_ids = ids_list)
write(my_ads_stats, file = "my_stats.json")
```

Возможные входные параметры функции:
 - **vk_token**;
 - **acc_id**;
 - **startdate** - дата начала сбора статистики в формате *YYYY-MM-DD*;
 - **enddate** - дата окончания сбора статистики в формате *YYYY-MM-DD*, значение по умолчанию - (%текущий день% - 1);
 - **campaign_ids** - список идентификаторов рекламных объектов, статистику которых нужно получить;
 - **o_type** - тип рекламного объекта, [подробности](https://vk.com/dev/ads.getStatistics);
 - **stat_period** - детализация статистики: по дням, месяцам или за весь период;
 - **lib** - расположение библиотеки *httr*, по умолчанию будет произведена попытка подключить библиотеки из стандартного расположения
 
 
Описание возвращаемого [объекта](https://vk.com/dev/ads.getStatistics)
 
---
 
# Получение данных о демографии

```R
ids_list <- list_of_campaigns$digest[,1]
ids_list <- toString(unique(ids_list))
my_dmg_stats <- demographVK(my_token, my_account_id, startdate = "2016-10-20", campaign_ids = ids_list)
write(my_dmg_stats, file = "my_stats.json")
```

Возможные входные параметры функции полностью совпадают с параметрами для получения статистики.

Описание возвращаемого [объекта](https://vk.com/dev/ads.getDemographics)
 
---

# Зависимости 

[R-3.3.2](https://cran.r-project.org/)

## Пакеты:
 - [Jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html)
 - [httr](https://cran.r-project.org/web/packages/httr/index.html)

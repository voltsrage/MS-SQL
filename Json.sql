DECLARE @json nvarchar(MAX) = '{
   "eBooks":[
      {
         "language":"Pascal",
         "edition":"third"
      },
      {
         "language":"Python",
         "edition":"four"
      },
      {
         "language":"SQL",
         "edition":"second"
      }
   ]
}'

SELECT * FROM openjson(@json,'$.eBooks')
		WITH (Language varchar(10) '$.language',Edition varchar(10) '$.edition')


DECLARE @json2 nvarchar(MAX) = '{
   "book":[
      {
         "id":"444",
         "language":"C",
         "edition":"First",
         "author":"Dennis Ritchie "
      },
      {
         "id":"555",
         "language":"C++",
         "edition":"second",
         "author":" Bjarne Stroustrup "
      }
   ]
}  '

SELECT * FROM openjson(@json2,'$.book')
		WITH (id int '$.id', Language varchar(4) '$.language',Edition varchar(10) '$.edition',Author varchar(10) '$.edition')


DECLARE @json3 nvarchar(MAX) = '{"menu": {
    "header": "SVG Viewer",
    "items": [
        {"id": "Open"},
        {"id": "OpenNew", "label": "Open New"},
        null,
        {"id": "ZoomIn", "label": "Zoom In"},
        {"id": "ZoomOut", "label": "Zoom Out"},
        {"id": "OriginalView", "label": "Original View"},
        null,
        {"id": "Quality"},
        {"id": "Pause"},
        {"id": "Mute"},
        null,
        {"id": "Find", "label": "Find..."},
        {"id": "FindAgain", "label": "Find Again"},
        {"id": "Copy"},
        {"id": "CopyAgain", "label": "Copy Again"},
        {"id": "CopySVG", "label": "Copy SVG"},
        {"id": "ViewSVG", "label": "View SVG"},
        {"id": "ViewSource", "label": "View Source"},
        {"id": "SaveAs", "label": "Save As"},
        null,
        {"id": "Help"},
        {"id": "About", "label": "About Adobe CVG Viewer..."}
    ]
}}'

SELECT * FROM openjson(@json3,'$.menu.items')
	WITH(id varchar(10),label varchar(10))
		
DECLARE @youtube nvarchar(max) = '{
  "kind": "youtube#searchListResponse",
  "etag": "\"m2yskBQFythfE4irbTIeOgYYfBU/PaiEDiVxOyCWelLPuuwa9LKz3Gk\"",
  "nextPageToken": "CAUQAA",
  "regionCode": "KE",
  "pageInfo": {
    "totalResults": 4249,
    "resultsPerPage": 5
  },
  "items": [
    {
      "kind": "youtube#searchResult",
      "etag": "\"m2yskBQFythfE4irbTIeOgYYfBU/QpOIr3QKlV5EUlzfFcVvDiJT0hw\"",
      "id": {
        "kind": "youtube#channel",
        "channelId": "UCJowOS1R0FnhipXVqEnYU1A"
      }
    },
    {
      "kind": "youtube#searchResult",
      "etag": "\"m2yskBQFythfE4irbTIeOgYYfBU/AWutzVOt_5p1iLVifyBdfoSTf9E\"",
      "id": {
        "kind": "youtube#video",
        "videoId": "Eqa2nAAhHN0"
      }
    },
    {
      "kind": "youtube#searchResult",
      "etag": "\"m2yskBQFythfE4irbTIeOgYYfBU/2dIR9BTfr7QphpBuY3hPU-h5u-4\"",
      "id": {
        "kind": "youtube#video",
        "videoId": "IirngItQuVs"
      }
    }
  ]
}'

SELECT * FROM openjson(@youtube,'$')
	WITH(
	--kind varchar(30),etag varchar(100),kind varchar(20),kind varchar(20) '$.id.kind'
	--,channelId varchar(30) '$.id.channelId',videoId varchar(30) '$.id.videoId')
	kind varchar(30),etag varchar(100),nextPageToken varchar(20),
	regionCode varchar(3),totalResults int '$.pageInfo.totalResults'
	,resultsPerPage int '$.pageInfo.resultsPerPage',
	items nvarchar(MAX) '$.items' AS JSON )
	OUTER APPLY openjson(items)
	WITH(kind varchar(30) '$.kind',
	etag varchar(100),kind varchar(20),kind varchar(20) '$.id.kind'
	,channelId varchar(30) '$.id.channelId',videoId varchar(30) '$.id.videoId')
	
DECLARE @source nvarchar(MAX) = '{
  "created_at": "Thu Jun 22 21:00:00 +0000 2017",
  "id": 877994604561387500,
  "id_str": "877994604561387520",
  "text": "Creating a Grocery List Manager Using Angular, Part 1: Add &amp; Display Items https:''//t.co/xFox78juL1 #Angular",
  "truncated": false,

  "entities": {

    "hashtags": [{
      "text": "Angular",
      "indices": [103, 111]
    }],

    "symbols": [], 
	"user_mentions": [], 

	"urls": [{ "url": "https:''//t.co/xFox78juL1", "expanded_url": "http''://buff.ly/2sr60pf", "display_url": "buff.ly/2sr60pf",
      "indices": [79, 102]  }]
  },
  "source": "<a href=\"http://bufferapp.com\" rel=\"nofollow\">Buffer</a>",

  "user": { "id": 772682964,"id_str": "772682964",
  "name": "SitePoint JavaScript",
  "screen_name": "SitePointJS",
    "location": "Melbourne, Australia",
	"description": "Keep up with JavaScript tutorials, tips, tricks and articles at SitePoint.",
	 "url": "http''://t.co/cCH13gqeUK"
	},
	"entities": {
    "url": {"urls": [{"display_url": "sitepoint.com/javascript" ,
	 "display_url": "sitepoint.com/javascript","indices": [0, 22] }]}   
	},
	 "description": {"urls": []},
	  "protected": false,"followers_count": 2145,"friends_count": 18,"listed_count": 328,
	  "created_at": "Wed Aug 22 02:06:33 +0000 2012","favourites_count": 57, "utc_offset": 43200,  "time_zone": "Wellington"
	 }'

  SELECT * FROM openjson(@source)		
   WITH(id_str varchar(20),
	text varchar(150),
	truncated bit,
	entities nvarchar(MAX) '$.entities.hashtags' AS JSON,
	symbols nvarchar(MAX) '$.entities.symbols' AS JSON,
	user_mentions nvarchar(MAX) '$.entities.user_mentions' AS JSON,
	urls nvarchar(MAX) '$.entities.urls' AS JSON)
	OUTER APPLY openjson(entities)
	WITH(text varchar(10),indices nvarchar(MAX) AS JSON)
	OUTER APPLY openjson(urls)
	WITH([url] varchar(30),expanded_url varchar(30),display_url varchar(30),indices nvarchar(MAX) AS JSON)


	


	
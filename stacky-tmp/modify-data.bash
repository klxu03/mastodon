curl http://localhost:3000/inject-data/modify/23 -H "Content-Type: application/json"  -d '{ "text": "This is the content", "actor_id": 1234567890, "username": "tom_from_reddit", "domain": "my-reddit.com", "json":  {"inbox": "http://my-reddit.com/user/tom_from_reddit/fake_inbox", "outbox": "http://my-reddit.com/user/tom_from_reddit/fake_outbox", "name": "TOM_RED_DISPLAYYYY" } }' -X POST

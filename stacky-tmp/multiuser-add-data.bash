curl http://localhost:3000/inject-data/add \
  -H "Content-Type: application/json" \
  -d '{
    "text": "This is the content",
    "actor_id": 1234567890,
    "users": [
      {
        "username": "tom_from_reddit",
        "domain": "my-reddit.com",
        "json": {
          "id": "https://my-reddit.com/tom_from_reddit",
          "inbox": "http://my-reddit.com/user/tom_from_reddit/fake_inbox",
          "outbox": "http://my-reddit.com/user/tom_from_reddit/fake_outbox",
          "name": "TOM_RED_DISPLAYYYY"
        }
      },
      {
        "username": "another_user",
        "domain": "another-domain.com",
        "json": {
          "id": "https://another-domain.com/another_user",
          "inbox": "http://another-domain.com/user/another_user/fake_inbox",
          "outbox": "http://another-domain.com/user/another_user/fake_outbox",
          "name": "ANOTHER_USER_DISPLAY"
        }
      },
      {
        "username": "third_user",
        "domain": "third-domain.org",
        "json": {
          "id": "https://third-domain.org/third_user",
          "inbox": "http://third-domain.org/user/third_user/fake_inbox",
          "outbox": "http://third-domain.org/user/third_user/fake_outbox",
          "name": "THIRD_USER_DISPLAY"
        }
      }
    ]
  }' \
  -X POST


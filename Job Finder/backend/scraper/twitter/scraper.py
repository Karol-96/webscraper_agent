import httpx
from bs4 import BeautifulSoup
from fastapi import HTTPException

class TwitterTrends:
    def __init__(self):
        self.base_url = "https://twitter-trends.vercel.app/api/trends"
        
    async def get_global_trends(self):
        try:
            async with httpx.AsyncClient() as client:
                response = await client.get(f"{self.base_url}/world")
                return self._parse_trends(response.json())
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))

    def _parse_trends(self, data):
        return [{
            'name': item['name'],
            'tweet_volume': item['tweet_volume'],
            'url': item['url'],
            'country': 'Global'
        } for item in data.get('trends', [])[:20]] 
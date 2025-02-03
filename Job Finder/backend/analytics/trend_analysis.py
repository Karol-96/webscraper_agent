from datetime import datetime, timedelta
import numpy as np

class TrendAnalyzer:
    def __init__(self):
        self.weights = {
            'twitter': 0.3,
            'google': 0.25,
            'news': 0.2,
            'youtube': 0.15,
            'instagram': 0.1
        }

    def calculate_trend_score(self, trends):
        """Calculate composite trend score using weighted algorithm"""
        time_decay = np.exp(-(datetime.now() - trends['timestamp']).total_seconds() / 3600)
        engagement = trends.get('engagement', 1)
        return (self.weights[trends['source']] * trends['volume'] * engagement * time_decay) 
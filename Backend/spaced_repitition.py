from datetime import datetime, timedelta

def calculate_review(quality: int, previous_interval: int, ease_factor: float):
    """
    Returns: (new_interval, new_ease_factor, next_review_date)
    """
    # 1. If forgot (Quality < 3), reset interval
    if quality < 3:
        return 1, ease_factor, datetime.now() + timedelta(days=1)

    # 2. Calculate Interval
    if previous_interval == 0:
        new_interval = 1
    elif previous_interval == 1:
        new_interval = 6
    else:
        new_interval = int(previous_interval * ease_factor)

    # 3. Calculate Ease Factor (Standard SM-2 Formula)
    new_ease = ease_factor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    new_ease = max(1.3, new_ease) # Floor at 1.3

    next_review = datetime.now() + timedelta(days=new_interval)
    
    return new_interval, new_ease, next_review
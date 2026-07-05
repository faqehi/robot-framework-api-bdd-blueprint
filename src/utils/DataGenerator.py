from faker import Faker
from datetime import datetime, timedelta
from typing import Dict, Any, List, Optional
from robot.api.deco import keyword

class DataGenerator:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    
    def __init__(self):
        self.fake = Faker()

    @keyword("Generate Dynamic Booking Payload")
    def generate_booking_payload(self, 
                                 firstname: Optional[str] = None, 
                                 lastname: Optional[str] = None) -> Dict[str, Any]:
        """
        Generates a complete, structured JSON payload matching the Restful-Booker contract.
        Allows overriding names to test specific query filters easily.
        """
        # Ensure checkout is logically after checkin
        checkin_date = self.fake.date_between(start_date="-1y", end_date="today")
        checkout_date = checkin_date + timedelta(days=self.fake.random_int(min=1, max=14))
        
        needs_pool = ["Breakfast", "Extra Towels", "Late Checkout", "Baby Cot", "Wi-Fi"]

        return {
            "firstname": firstname if firstname else self.fake.first_name(),
            "lastname": lastname if lastname else self.fake.last_name(),
            "totalprice": self.fake.random_int(min=50, max=1500),
            "depositpaid": self.fake.boolean(chance_of_getting_true=75),
            "bookingdates": {
                "checkin": checkin_date.strftime("%Y-%m-%d"),
                "checkout": checkout_date.strftime("%Y-%m-%d")
            },
            "additionalneeds": self.fake.random_element(elements=needs_pool)
        }

import requests
from typing import Dict, Any, Optional
from robot.api.deco import keyword

class BookingClient:
    ROBOT_LIBRARY_SCOPE = 'SUITE'

    def __init__(self, base_url: str):
        """
        Initializes the Booking HTTP client SDK abstraction.
        Uses a dedicated requests.Session instance to manage global cookies/headers.
        """
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
        # Default header state for a clean REST interface
        self.session.headers.update({
            "Content-Type": "application/json",
            "Accept": "application/json"
        })

    @keyword("Create Authentication Token")
    def create_authentication_token(self, payload: Dict[str, str]) -> requests.Response:
        """
        POST /auth - Exposes credential submission to generate authorization sessions.
        """
        url = f"{self.base_url}/auth"
        return self.session.post(url, json=payload)
    
    @keyword("Inject Session Authentication Token")
    def inject_session_auth_token(self, token_value: str) -> None:
        """
        Appends the session security context directly to the active client connection.
        Restful-Booker natively relies on Cookie-based authentication headers for mutations.
        """
        self.session.headers.update({"Cookie": f"token={token_value}"})

    @keyword("Clear Session Authentication Token")
    def clear_session_auth_token(self) -> None:
        """
        Purges security tokens to allow negative access-control validation testing.
        """
        if "Cookie" in self.session.headers:
            del self.session.headers["Cookie"]

    @keyword("Create New Booking Record")
    def create_booking(self, payload: Dict[str, Any]) -> requests.Response:
        """
        POST /booking - Submits structural registration metrics to form a new booking asset.
        """
        url = f"{self.base_url}/booking"
        return self.session.post(url, json=payload)

    @keyword("Execute Full Booking Mutation")
    def update_booking(self, booking_id: int, payload: Dict[str, Any]) -> requests.Response:
        """
        PUT /booking/{id} - Implements absolute modification over an active entry.
        Requires valid authentication credentials to be previously injected.
        """
        url = f"{self.base_url}/booking/{booking_id}"
        return self.session.put(url, json=payload)

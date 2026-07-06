import os

ENVIRONMENTS = {
    "test": {
        "base_url": "https://restful-booker.herokuapp.com",
        "api_timeout": 5,
        "debug_mode": True,
        # Reads securely from system variables; falls back to public mock credentials locally
        "admin_user": os.getenv("TEST_ADMIN_USER", "admin"),
        "admin_pass": os.getenv("TEST_ADMIN_PASS", "password123")
    },
    "uat": {
        "base_url": "https://restful-booker.herokuapp.com",
        "api_timeout": 10,
        "debug_mode": True,
        "admin_user": os.getenv("UAT_ADMIN_USER", "admin"),
        "admin_pass": os.getenv("UAT_ADMIN_PASS", "password123")
    },
    "live": {
        # Pro-Tip: In a real enterprise system, never hardcode live secrets as fallback values!
        "base_url": "https://restful-booker.herokuapp.com",
        "api_timeout": 15,
        "debug_mode": False,
        "admin_user": os.getenv("PROD_ADMIN_USER", "admin"),
        "admin_pass": os.getenv("PROD_ADMIN_PASS", "password123")
    }
}

def get_env_config(env_name: str) -> dict:
    env_lower = env_name.lower()
    if env_lower not in ENVIRONMENTS:
        raise ValueError(f"❌ Invalid environment '{env_name}'. Choose from: {list(ENVIRONMENTS.keys())}")
    return ENVIRONMENTS[env_lower]

ENVIRONMENTS = {
    "test": {
        "base_url": "https://restful-booker.herokuapp.com",
        "api_timeout": 5,
        "debug_mode": True,
        "admin_user": "admin",
        "admin_pass": "password123"
    },
    "uat": {
        "base_url": "https://restful-booker.herokuapp.com",
        "api_timeout": 10,
        "debug_mode": True,
        "admin_user": "admin",
        "admin_pass": "password123"
    },
    "live": {
        "base_url": "https://restful-booker.herokuapp.com",
        "api_timeout": 15,
        "debug_mode": False,
        "admin_user": "admin",
        "admin_pass": "password123"
    }
}

def get_env_config(env_name: str) -> dict:
    env_lower = env_name.lower()
    if env_lower not in ENVIRONMENTS:
        raise ValueError(f"❌ Invalid environment '{env_name}'. Choose from: {list(ENVIRONMENTS.keys())}")
    return ENVIRONMENTS[env_lower]
import paho.mqtt.client as mqtt
import json
import time
import random

client = mqtt.Client()

client.connect("localhost", 1883, 60)

driver_id = "driver1"

def generate_data():

    return {
        "driverId": driver_id,
        "lat": 28.45 + random.uniform(-0.01, 0.01),
        "lng": 77.02 + random.uniform(-0.01, 0.01),
        "speed": random.randint(20, 80),
        "acceleration": random.uniform(-3, 3),
        "timestamp": time.time()
    }

while True:

    data = generate_data()

    client.publish("vehicle/data", json.dumps(data))

    print("Published:", data)

    time.sleep(2)
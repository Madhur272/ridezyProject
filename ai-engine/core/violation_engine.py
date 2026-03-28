import time
import requests

class ViolationEngine:

    def __init__(self):

        self.buffer = []
        self.last_sent = time.time()
        self.cooldown = 5  # seconds
        self.batch_interval = 10  # seconds

        self.last_violation_time = {}

    def add_violation(self, driver, violation_type, penalty):

        current_time = time.time()

        # Cooldown per violation type
        key = f"{driver}-{violation_type}"

        if key in self.last_violation_time:
            if current_time - self.last_violation_time[key] < self.cooldown:
                return

        self.last_violation_time[key] = current_time

        self.buffer.append({
            "driver": driver,
            "type": violation_type,
            "penalty": penalty
        })

    def send_batch(self):

        if not self.buffer:
            return

        try:
            requests.post(
                "http://localhost:4007/violation/batch",
                json={"violations": self.buffer}
            )
            print("Batch sent:", self.buffer)

            self.buffer = []

        except Exception as e:
            print("Batch failed:", e)

    def run(self):

        while True:

            if time.time() - self.last_sent > self.batch_interval:
                self.send_batch()
                self.last_sent = time.time()

            time.sleep(1)
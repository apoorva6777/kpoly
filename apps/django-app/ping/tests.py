from django.test import TestCase

# Create your tests here.

# Run following command to run the test cases - py manage.py test

class TestViews(TestCase):
    def test_ping_url_returns_success_code(self):
        response = self.client.get('/api/ping/')
        self.assertEqual(response.status_code, 200)

    def test_ping_url_returns_ping_message(self):
        response = self.client.get('/api/ping/')
        self.assertEqual(response.json()['message'], 'Ping Successful!!')

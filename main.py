from google import genai
from google.genai import types
import PIL.Image

# Load the receipt image
image = PIL.Image.open('C://Users//Lucius//Documents//Projects//pythonBackend//Screenshot 2025-02-19 094141.png')

# Initialize Gemini client with API key
client = genai.Client(api_key="AIzaSyDdEbCr1y6Azff9_vsWHtvDPk0yMJzW1T4")

# Define the structured prompt
prompt = """
Extract the expense details from the following receipt image.

Return the result in **valid JSON format** with the following structure:
{
  "expenseCategory": "<category>",
  "totalAmount": <amount>,
  "description": "<short description>"
}

### **Instructions:**
- **expenseCategory**: Identify the most suitable category from the following:
  - "Groceries"
  - "Subscription"
  - "Food"
  - "Shopping"
  - "Healthcare"
  - "Transportation"
  - "Utilities"
  - "Housing"
  - If the category does not match any of the above, classify it as **"Miscellaneous"**.

- **totalAmount**: Extract the **final total amount paid** from the receipt. Look for keywords such as:
  - "Total"
  - "Grand Total"
  - "Amount Due"
  - "Balance Due"
  - "Subtotal" (only if no total amount is found)
  If multiple amounts are listed, **prioritize the one associated with "Total" or "Grand Total"** rather than just the last number.

- **description**: Provide a concise description summarizing the transaction based on the extracted text.

Ensure that the JSON output is correctly formatted and does not contain extra explanations.
"""

# Send the request to Gemini API
response = client.models.generate_content(
    model="gemini-2.0-flash",
    contents=[prompt, image]
)

# Print the extracted JSON response
print(response.text)




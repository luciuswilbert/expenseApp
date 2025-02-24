from google import genai 
from google.genai import types
import PIL.Image
import io
import base64
import json

def parse_response_text(response_text):
    """Parse the response text into a structured format."""
    response_text = response_text.strip()
    if response_text.startswith("```json"):
        response_text = response_text[7:].strip()  # Remove ```json at the start

    if response_text.endswith("```"):
        response_text = response_text[:-3].strip()  # Remove ``` at the end

    # Replace any non-printable characters
    response_text = ''.join(ch if ch.isprintable() else '' for ch in response_text)

    return json.loads(response_text)



if __name__ == "__main__":
    # Load the receipt image
    image = PIL.Image.open('C://Users//tanwa//source//repos//expenseApp//Screenshot 2025-02-19 094141.png')

    # Initialize Gemini client with API key
    client = genai.Client(api_key="AIzaSyDsGO_-v4GZ9uYyqpt8yWjWuFLagfXhjDg")

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

    try:
      
      extracted_data = parse_response_text(response.text)
      # Print the extracted JSON response
      print(response.text)
      # Save to json file
      json_file_path = "C://Users//tanwa//source//repos//expenseApp//extracted_data.json"
      with open(json_file_path, "w", encoding="utf-8") as json_file:
        json.dump(extracted_data, json_file, indent=4)
        print(f"JSON file saved successfully at: {json_file_path}")

    except Exception as e:
      print("Error parsing response:", e)

    



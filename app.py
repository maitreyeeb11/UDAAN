from flask import Flask, request, jsonify
import smtplib
import io
from email.message import EmailMessage
from reportlab.pdfgen import canvas
from flask_cors import CORS

#Application Programming Interfaces (APIs) are needed because they allow software applications to communicate with each other. 
#This communication enables the sharing of data, features, and functionality. 
#Flask is a Python web framework that helps developers build web applications. 
#It's a lightweight, extensible framework that provides tools and libraries for web development. 


#Flask: The main framework to create a web server.
#request: To handle incoming API requests.
#jsonify: To send JSON responses.
#smtplib: Used for sending emails via SMTP (Simple Mail Transfer Protocol).
#io: Helps create an in-memory file object for storing the PDF receipt.
#EmailMessage: Helps structure and send emails.
#canvas: Used to generate a PDF receipt dynamically.
#CORS: Allows requests from different origins (cross-origin resource sharing). Not used in this script, but useful if connecting from a frontend.

app = Flask(__name__)# Enable CORS for all routes
CORS(app) 
#Flask(__name__)  This creates an instance of the Flask application, which allows us to define routes (API endpoints).


# Razorpay & Email Credentials
SENDER_EMAIL = "maitreyeeb2004@gmail.com"
SENDER_PASSWORD = "lrtw gvzt fwvn fdwg"  # Use an App Password

def generate_receipt(amount, payment_id):
    """Generate a PDF receipt and return it as a BytesIO object."""
    pdf_buffer = io.BytesIO() # Creates an in-memory buffer for the PDF
    p = canvas.Canvas(pdf_buffer) # Initializes a PDF canvas
    p.drawString(100, 750, "Donation Receipt")
    p.drawString(100, 730, f"Payment ID: {payment_id}")
    p.drawString(100, 710, f"Amount Paid: Rs.{amount}")
    p.drawString(100, 690, "Thank you for your generous donation!")
    p.showPage()  # Finalizes the page
    p.save() # Saves the PDF data
    pdf_buffer.seek(0)  # Resets pointer to the start of the file
    return pdf_buffer # Returns the generated PDF as a BytesIO object

def send_email(receiver_email, amount, payment_id):
    """Send the receipt PDF via email."""
    pdf_data = generate_receipt(amount, payment_id).getvalue()

    msg = EmailMessage()
    msg["Subject"] = "Your Donation Receipt - UDAAN"
    msg["From"] = SENDER_EMAIL
    msg["To"] = receiver_email
    msg.set_content(f"Dear Donor,\n\nThank you for your donation of ₹{amount}.\nPlease find your receipt attached.\n\nBest regards,\nTeam Udaan")
     # Attaching the generated PDF
    msg.add_attachment(pdf_data, maintype="application", subtype="pdf", filename="receipt.pdf")

    try:
        server = smtplib.SMTP("smtp.gmail.com", 587) # Connecting to Gmail's SMTP server
        server.set_debuglevel(1)  
        server.starttls() # Starting TLS encryption
        server.login(SENDER_EMAIL, SENDER_PASSWORD) # Logging in using email and app password
        server.send_message(msg) # Sending the email
        server.quit() #Closing the connection
        print("Email sent successfully!") 
        return True # Returning success status
    except Exception as e:
        print(f"SMTP Error: {e}") 
        return f"Error: {e}"

"""Receives a POST request at /send-receipt.
Reads the JSON data (amount, payment ID, and email).
Validates the data:
If any field is missing, returns an HTTP 400 error.
Calls send_email(email, amount, payment_id).
Returns success/failure response as JSON."""


@app.route('/send-receipt', methods=['POST'])
def send_receipt():
    """API endpoint to generate and send receipt."""
    data = request.json
    amount = data.get('amount')
    payment_id = data.get('paymentId')
    email = data.get('email')

    if not amount or not payment_id or not email:
        return jsonify({"success": False, "message": "Missing required fields"}), 400

    result = send_email(email, amount, payment_id)
    
    if result is True:
        return jsonify({"success": True, "message": "Receipt sent successfully"})
    else:
        return jsonify({"success": False, "message": result}), 500


@app.route('/')
def home():
    return "Flask server is running!"


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)
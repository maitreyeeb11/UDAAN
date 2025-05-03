const express = require('express');
const { Pool } = require('pg');
const bodyParser = require("body-parser");
const fetch = require("node-fetch");
const path = require('path');
const cors = require('cors');

// Middleware to parse incoming requests
const app = express();
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.json()); // Parse JSON bodies
app.use(express.urlencoded({ extended: true })); // Parse URL-encoded form data
app.use(express.static('public'));

const port = process.env.PORT || 3000; // Keep a single port for handling all forms


// PostgreSQL connection setup
const pool = new Pool({
    user: process.env.DB_USER || 'postgres',
    host: process.env.DB_HOST || 'localhost',
    database: process.env.DB_NAME || 'udaan',
    password: process.env.DB_PASSWORD || 'neymar11',
    port: process.env.DB_PORT || 5432,
});

function convertToWesternNumbers(input) {
    if (!input) return input; // Return as is if null or empty

    const hindiToWesternMap = {
        '०': '0', '१': '1', '२': '2', '३': '3', '४': '4',
        '५': '5', '६': '6', '७': '7', '८': '8', '९': '9'
    };

    return input.replace(/[०-९]/g, (match) => hindiToWesternMap[match]);
}

function isHindiNumber(input) {
    return /[०-९]/.test(input); // Checks if input contains any Hindi numerals
}

// Function to detect and translate Hindi text if needed
async function translateIfHindi(text) {
    // Check if text contains Hindi characters
    const hindiRegex = /[\u0900-\u097F\uA8E0-\uA8FF]/;  
    return hindiRegex.test(text) ? await translateText(text, "hi", "en") : text;
}

const translateText = async (text, sourceLang = "hi", targetLang = "en") => {
    try {
        const response = await fetch("https://libretranslate.com/translate", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ q: text, source: sourceLang, target: targetLang, format: "text" }),
        });

        if (!response.ok) throw new Error(`HTTP Error: ${response.status}`);
        const data = await response.json();
        return data.translatedText || text;
    } catch (error) {
        console.error("Translation failed:", error.message || error);
        return text;
    }
};


// Serve HTML pages dynamically
const pages = ['sponsor', 'mentor', 'volunteer', 'child'];
pages.forEach(page => {
    app.get(`/${page}`, (req, res) => {
        res.sendFile(path.join(__dirname, 'public', `${page}.html`));
    });
});

// Generic function to handle database insertion
const registerEntity = async (req, res, tableName, columns, values) => {
    try {
        const query = `INSERT INTO ${tableName} (${columns.join(', ')}) VALUES (${values.map((_, i) => `$${i + 1}`).join(', ')}) RETURNING *`;
        const result = await pool.query(query, values);
        res.json({ message: `${tableName} registered successfully!`, data: result.rows[0] });
    } catch (err) {
        console.error(`Error registering ${tableName}:`, err);
        res.status(500).json({ error: `Error registering ${tableName}` });
    }
};

// Handle donor registration
app.post('/register-donor', async (req, res) => {
    let { fullName, pan, sponsor_contact, sponsor_email, flat_street, area, pincode, city, state, amt } = req.body;
    console.log("Received data:", req.body);

    try {
        amt = parseFloat(amt);
        if (isNaN(amt) || amt <= 0) {
            return res.json({ success: false, message: "Invalid donation amount." });
        }
        // Translate potential Hindi text to English
        fullName = await translateIfHindi(fullName);
        flat_street = await translateIfHindi(flat_street);
        area = await translateIfHindi(area);
        city = await translateIfHindi(city);
        state = await translateIfHindi(state);

         // Convert Hindi numbers to English if detected
         if (isHindiNumber(pincode)) pincode = convertToWesternNumbers(pincode);
         if (isHindiNumber(amt)) amt = convertToWesternNumbers(amt);
         if (!city || !state) {
            return res.json({ success: false, message: "Invalid pincode. City and State not found." });
        }

        const address = `${flat_street}, ${area}`; // Combine flat_street and area into address

        const result = await pool.query(
            `INSERT INTO sponsor (sponsor_name, pan_number, sponsor_contact, sponsor_email, amt, address, pincode, city, state) 
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING sponsor_id`,
            [fullName, pan, sponsor_contact, sponsor_email, amt, address, pincode, city, state]
        );

         console.log("Donor registered successfully:", result.rows[0]);

        // ✅ Return JSON response instead of HTML
        return res.json({
            success: true,
            message: "Donor registered successfully!",
            sponsor_id: result.rows[0].sponsor_id
        });

    } catch (err) {
        console.error("Error registering donor:", err);
        res.status(500).send(`
            <div class="message-box" style="background-color:#FFDDC1; color:#D72638; border:2px solid #D72638;">
                <h2>⚠️ Oops! Something went wrong.</h2>
                <p>Please try again or contact support.</p>
            </div>
        `);
    }
});



// Handle mentor registration
app.post('/register-mentor', async (req, res) => {
    let { mentor_name, expertise, mentor_avail, mentor_email, contact_no } = req.body;

    try {
         // Debugging: Log received data
         console.log("Received data:", req.body);

        // Translate only if input is in Hindi (Handled globally in server.js)
        mentor_name = await translateIfHindi(mentor_name);
        expertise = await translateIfHindi(expertise);
        mentor_avail = await translateIfHindi(mentor_avail); // Added translation for availability
        if (isHindiNumber(contact_no)) contact_no = convertToWesternNumbers(contact_no);

        const result = await pool.query(
            `INSERT INTO mentor (mentor_name, expertise, mentor_avail, mentor_email, contact_no) 
             VALUES ($1, $2, $3, $4, $5) RETURNING mentor_id`,
            [mentor_name, expertise, mentor_avail, mentor_email, contact_no]
        );

        res.status(200).send(`
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Mentor Registration Successful</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        height: 100vh;
                        background-color: #f4f7f6;
                    }
                    .message-box {
                        padding: 25px;
                        border-radius: 12px;
                        text-align: center;
                        width: 80%;
                        max-width: 600px;
                        font-size: 18px;
                        font-weight: 500;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                        background-color: #E0F2E9; /* Light green */
                        color: #1E5631; /* Dark green text */
                        border: 3px solid #A7E9AF; /* Green border */
                    }
                    h2 {
                        font-size: 24px;
                        font-weight: bold;
                    }
                </style>
            </head>
            <body>
                <div class='message-box'>
                    <h2>Mentor Registration Successful!</h2>
                    <p>Thank you for becoming a mentor at <b>Udaan</b>! Your registration has been completed successfully. 
                    We are thrilled to have you as a mentor in our mission to guide and inspire.</p>
                    <p>We will be in touch with you shortly with more details about your role.</p>
                </div>
            </body>
            </html>
        `);

    } catch (err) {
        console.error("Error registering mentor:", err);
        res.status(500).send(`
            <div class="message-box" style="background-color:#FFDDC1; color:#D72638; border:2px solid #D72638;">
                <h2>⚠️ Oops! Something went wrong.</h2>
                <p>Please try again or contact support.</p>
            </div>
        `);
    }
});


//Handle volunteer registration
app.post('/register-volunteer', async (req, res) => {
    try {
        let { fullName, age, gender, skills, interest, availability, email, phone } = req.body;

        // Debugging: Log received data
         console.log("Received data:", req.body);
        // Validate required fields
        if (!fullName || !age || !gender || !skills || !interest || !availability || !email || !phone) {
            return res.status(400).send(renderErrorMessage("⚠️ Please fill in all required fields."));
        }

        // Ensure age is a valid number and within allowed range
        age = parseInt(age);
        if (isNaN(age) || age < 18 || age > 100) {
            return res.status(400).send(renderErrorMessage("⚠️ Age must be a number between 18 and 100."));
        }

        // Validate gender against allowed values
        const validGenders = ["Male", "Female", "Other", "Prefer Not to Answer"];
        if (!validGenders.includes(gender)) {
            return res.status(400).send(renderErrorMessage("⚠️ Invalid gender selection."));
        }

        // Translate Hindi inputs if needed
        fullName = await translateIfHindi(fullName);
        skills = await translateIfHindi(skills);
        interest = await translateIfHindi(interest);
        availability = await translateIfHindi(availability);

        // Convert phone number only if it contains Hindi numerals
        if (isHindiNumber(phone)) phone = convertHindiToEnglishNumber(phone);

        // Insert into database
        const result = await pool.query(
            `INSERT INTO volunteer (full_name, age, gender, skills, interest, volunteer_avail, volunteer_email, volunteer_contact) 
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING volunteer_id`,
            [fullName, age, gender, skills, interest, availability, email, phone]
        );

        // Success response
        res.status(200).send(renderSuccessMessage());

    } catch (err) {
        console.error("Error registering volunteer:", err);
        res.status(500).send(renderErrorMessage("⚠️ Oops! Something went wrong. Please try again or contact support."));
    }
});

// Function to generate success message
function renderSuccessMessage() {
    return `
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Volunteer Registration Successful</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    background-color: #f4f7f6;
                }
                .message-box {
                    padding: 25px;
                    border-radius: 12px;
                    text-align: center;
                    width: 80%;
                    max-width: 600px;
                    font-size: 18px;
                    font-weight: 500;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                    background-color: #E0F2E9; /* Light green */
                    color: #1E5631; /* Dark green text */
                    border: 3px solid #A7E9AF; /* Green border */
                }
                h2 {
                    font-size: 24px;
                    font-weight: bold;
                }
            </style>
        </head>
        <body>
            <div class='message-box'>
                <h2>Volunteer Registration Successful!</h2>
                <p>Thank you for joining <b>Udaan</b>! Your registration has been completed successfully. 
                We are thrilled to have you as a volunteer in our mission to make a positive impact.</p>
                <p>We will be in touch with you shortly with more details about your role.</p>
            </div>
        </body>
        </html>
    `;
}

// Function to generate error message
function renderErrorMessage(message) {
    return `
        <div class="message-box" style="background-color:#FFDDC1; color:#D72638; border:2px solid #D72638;">
            <h2>⚠️ Oops! Something went wrong.</h2>
            <p>${message}</p>
        </div>
    `;
}



//Handle child registration
app.post("/register-child", async (req, res) => {
    try {
        let {
            childName,
            dateOfBirth,
            gender,
            currentEducation,
            eduAspiration,
            skillsInterest,
            otherNeed,
            behavioralChallenges,
            emo_status,
            ngoName, ngoContact, ngoAddress,
            parentName, parentContact, parentAddress,
            guardianName, guardianContact, guardianAddress,
            relationship
        } = req.body;

        // Debugging: Log received data
        console.log("Received data:", req.body);

         // **Manual Validation**
         if (
            !childName || 
            !gender || 
            !( 
                (ngoName && ngoContact && ngoAddress) || 
                (guardianName && guardianContact && guardianAddress) || 
                (parentName && parentContact && parentAddress) 
            )
        ) {
            return res.status(400).json({ 
                error: "Child name, gender, and complete details (name, contact, and address) of at least one entity (NGO, Guardian, or Parent) are required." 
            });
        }
        
        // Assign values dynamically (Ensure at least one entity has details)
        let finalGuardianName = ngoName || guardianName || parentName;
        let finalGuardianContact = ngoContact || guardianContact || parentContact;
        let finalGuardianAddress = ngoAddress || guardianAddress || parentAddress;

        if (!/^\d{4}-\d{2}-\d{2}$/.test(dateOfBirth)) {
            return res.status(400).json({ error: "Invalid date format (use YYYY-MM-DD)." });
        }

        // Convert Hindi numbers in guardian contact if detected
        if (isHindiNumber(guardianContact)) {
            guardianContact = convertHindiToEnglishNumber(guardianContact);
        }

        // if (!/^\d{10}$/.test(guardianContact)) {
        //     return res.status(400).json({ error: "Invalid guardian contact number." });
        // }

        // **Trim & sanitize inputs**
        childName = childName.trim();
        guardianName = guardianName.trim();
        guardianContact = guardianContact.trim();
        guardianAddress = guardianAddress?.trim() || "";
        relationship = relationship?.trim() || "Guardian"; // Default value

        currentEducation = currentEducation?.trim() || null;
        eduAspiration = eduAspiration?.trim() || null;
        skillsInterest = skillsInterest?.trim() || null;
        otherNeed = otherNeed?.trim() || null;
        behavioralChallenges = behavioralChallenges?.trim() || null;
        emo_status = emo_status?.trim() || null;

        // **Validate 'Other' skill training input**
        if (skillsInterest?.toLowerCase() === "other" && !otherNeed) {
            return res.status(400).json({ error: "Please specify the 'Other' skill training." });
        }

        //*Convert date format from DD/MM/YYYY to YYYY-MM-DD*
        //const [day, month, year] = dateOfBirth.split("/");
        //dateOfBirth = ${year}-${month}-${day};
        
        
        // // **Convert date format from DD/MM/YYYY to YYYY-MM-DD**
        // const [day, month, year] = dateOfBirth.split("/");
        // dateOfBirth = `${year}-${month}-${day}`;

        // **Translate text if it contains Hindi**
        childName = await translateIfHindi(childName);
        currentEducation = await translateIfHindi(currentEducation);
        eduAspiration = await translateIfHindi(eduAspiration);
        skillsInterest = await translateIfHindi(skillsInterest);
        otherNeed = await translateIfHindi(otherNeed);
        behavioralChallenges = await translateIfHindi(behavioralChallenges);
        emo_status = await translateIfHindi(emo_status);

        // **Analyze behavioral & emotional state**
        let stateHint = "Stable"; // Default state
        const lowCaseBehavior = behavioralChallenges?.toLowerCase() || "";
        const lowCaseEmotion = emo_status?.toLowerCase() || "";

        if (lowCaseBehavior.includes("anxious") || lowCaseEmotion.includes("stress")) {
            stateHint = "Anxious";
        } else if (lowCaseBehavior.length > 20 || lowCaseEmotion.length > 30) {
            stateHint = "Requires Help";
        } else if (eduAspiration?.length > 20) {
            stateHint = "Improving";
        }

        // **Insert or update guardian details**
        guardianResult = await pool.query(
            `INSERT INTO guardian (name, contact, rel_with_child, address) 
             VALUES ($1, $2, $3, $4)  
             RETURNING guardian_id`,
             [finalGuardianName, finalGuardianContact, relationship, finalGuardianAddress]
        );

        if (!guardianResult.rows.length) {
            return res.status(500).json({ error: "Guardian insertion failed" });
        }

        const guardianId = guardianResult.rows[0].guardian_id;

        // **Insert child details**
        const childResult = await pool.query(
            `INSERT INTO child (child_name, dob, gender, edu_level, career_asp, skills_interest, behavioral_challenges, emo_status, guardian_id) 
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) 
             RETURNING enrol_id`,
            [
                childName,
                dateOfBirth,
                gender,
                currentEducation,
                eduAspiration,
                skillsInterest,
                behavioralChallenges,
                emo_status,
                guardianId
            ]
        );

        if (!childResult.rows.length) {
            return res.status(500).json({ error: "Child registration failed." });
        }

        res.status(200).send(`
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Registration Successful</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        height: 100vh;
                        background-color: #f4f7f6;
                    }
                    .message-box {
                        padding: 25px;
                        border-radius: 12px;
                        text-align: center;
                        width: 80%;
                        max-width: 600px;
                        font-size: 18px;
                        font-weight: 500;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                        background-color: #D4EDDA; /* Udaan green */
                        color: #155724;
                        border: 3px solid #A7E9AF;
                    }
                    h2 {
                        font-size: 24px;
                        font-weight: bold;
                    }
                </style>
            </head>
            <body>
                <div class='message-box'>
                    <h2>Child Registration Successful!</h2>
                    <p>Thank you for enrolling your child in <b>Udaan</b>!</p>
                    <p><strong>Emotional & Behavioral Status: ${stateHint}</strong></p>
                </div>
            </body>
            </html>
        `);
    } catch (err) {
        console.error("Error registering child:", err);
        res.status(500).send(`
            <div class="message-box" style="background-color:#FFDDC1; color:#D72638; border:2px solid #D72638;">
                <h2>⚠️ Oops! Something went wrong.</h2>
                <p>Please try again or contact support.</p>
            </div>
        `);
    }
});

// Start the server
app.listen(port, () => {
    console.log(`✅ Server running on http://localhost:${port}`);
});
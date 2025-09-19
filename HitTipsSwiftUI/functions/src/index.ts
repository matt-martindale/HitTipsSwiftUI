/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//import {setGlobalOptions} from "firebase-functions";
//import {onRequest} from "firebase-functions/https";
//import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
//setGlobalOptions({ maxInstances: 10 });

import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import axios from "axios";

admin.initializeApp();

const API_URL = "https://api.openai.com/v1/responses";

export const callExternalApi = onCall(
                                      { secrets: ["OPENAI_API_KEY"],
                                          timeoutSeconds: 10
                                      }, // inject secret
  async (request) => {
      const uid = request.auth?.uid;
          if (uid) {
            console.log("Authenticated user UID:", uid);
          } else {
            console.log("Unauthenticated request");
          }

    const prompt: string | undefined = request.data?.prompt;
    const model: string = request.data?.model ?? "gpt-4o-mini";

    if (!prompt || typeof prompt !== "string") {
      throw new HttpsError("invalid-argument", "Missing prompt");
    }

    const apiKey = process.env.OPENAI_API_KEY;
      console.log(apiKey)
    if (!apiKey) {
        console.error("OPENAI_API_KEY not set!");
      throw new HttpsError("internal", "Missing OpenAI API key");
    }

    console.log("Prompt received:", prompt);

    try {
      const jsonSchema = {
        type: "object",
        strict: true,
        additionalProperties: false,
        properties: {
          comment: { type: "string" },
        },
        required: ["comment"],
      };

      const payload = {
        model,
        input: [
          {
            role: "system",
            content: [
              {
                type: "input_text",
                text: "Response should be short, creative and have one property",
              },
            ],
          },
          {
            role: "user",
            content: [{ type: "input_text", text: prompt }],
          },
        ],
        text: {
          format: {
            name: "comment_schema",
            type: "json_schema",
            schema: jsonSchema,
          },
        },
      };

      const response = await axios.post(API_URL, payload, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${apiKey}`,
        },
          timeout: 5000
      });

      console.log("Full API Response:", JSON.stringify(response.data, null, 2));

      const text = response.data?.output?.[0]?.content?.[0]?.text;
      if (!text) {
        throw new HttpsError("internal", "No text found in OpenAI response");
      }

      let parsed;
      try {
        parsed = JSON.parse(text);
      } catch (e) {
        console.error("Failed to parse OpenAI text as JSON:", text);
        throw new HttpsError("internal", "Invalid JSON returned from OpenAI");
      }

      console.log(parsed.comment);
      return parsed.comment;
    } catch (error: any) {
      console.error("External API error:", error.response?.data || error.message);
      throw new HttpsError(
        "internal",
        error.response?.data?.error?.message || "Failed to call external API"
      );
    }
  }
);

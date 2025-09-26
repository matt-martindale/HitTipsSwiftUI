

import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import axios from "axios";

admin.initializeApp();

const API_URL = "https://api.openai.com/v1/responses";

// Prod function
export const callExternalApi = onCall(
                                      { secrets: ["OPENAI_API_KEY"],
                                          timeoutSeconds: 10
                                      },
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
          timeout: 10000
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

/**
 * Development function (safe playground)
 * 👉 You can freely tweak model, prompts, schema, etc.
 */
export const callExternalApiDev = onCall(
  { secrets: ["OPENAI_API_KEY"], timeoutSeconds: 10 },
  async (request) => {
      
    const prompt: string | undefined = request.data?.prompt;
    const model: string = request.data?.model ?? "gpt-4o-mini";
      
    if (!prompt) {
      throw new HttpsError("invalid-argument", "Missing prompt");
    }

    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      throw new HttpsError("internal", "Missing OpenAI API key");
    }

    console.log("[DEV] Prompt received:", prompt);

    try {
      const payload = {
          model: model,
        input: [
          {
            role: "system",
            content: [
              {
                type: "input_text",
                text: "You are a tipping calculator that will Roast the following restaurant tip. Response should be 1-2 sentences.",
              },
            ],
          },
          {
            role: "user",
            content: [{ type: "input_text", text: prompt }],
          },
        ],
      };

      const response = await axios.post(API_URL, payload, {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${apiKey}`,
        },
        timeout: 10000,
      });

      const text = response.data?.output?.[0]?.content?.[0]?.text;
      if (!text) {
          console.warn("[DEV] No text in response, using fallback.");
          return `[DEV - fallback] Alas, no roast could be conjured this time, dear patron.`;
      }

      return `[DEV] ${text}`;
    } catch (error: any) {
        console.error("[DEV] External API error:", error.response?.data || error.message);
        return `[DEV - fallback] The roast gods are silent, but bravely tip nonetheless.`;
    }
  }
);

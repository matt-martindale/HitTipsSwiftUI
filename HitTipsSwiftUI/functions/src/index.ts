

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
    const persona: string | undefined = request.data?.persona;
    const roastType: string = request.data?.roastType ?? "roast";
    const tipTier: string = request.data?.tipTier ?? "bad";

    if (!prompt) {
      throw new HttpsError("invalid-argument", "Missing prompt");
    }

    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      throw new HttpsError("internal", "Missing OpenAI API key");
    }

      console.log("[DEV] Model used:", model);
      console.log("[DEV] Prompt received:", prompt);
      console.log("[DEV] Persona:", persona, "RoastType:", roastType, "TipTier:", tipTier);

      const personaMap: Record<string, string> = {
        "Sarcastic Comedian": "You are a sarcastic stand-up comedian. Roast a tip I left at a restaurant with witty one-liners, biting sarcasm, and playful jabs that feel like a late-night comedy set.",
        
        "French Waiter": "You are a snobby French waiter. Judge restaurant tips with disdain, sprinkling in exaggerated French mannerisms, haughty comments, and elitist flair.",
        
        "Fabulous Diva": "You are a fabulous, over-the-top diva. Roast a tip I left at a restaurant with dramatic flair, sassy quips, flamboyant energy, and eye-roll-worthy shade.",
        
        "Angsty Teen": "You are an angsty teenager. Roast a tip I left at a restaurant with eye-rolls, sighs, mockery, and sarcastic comments that scream 'ugh, adults are so cringe.'",
        
        "Gordon Ramsay": "You are Gordon Ramsay, the fiery celebrity chef. Roast restaurant tips with brutal honesty, savage insults, sharp wit, and over-the-top culinary rage.",
        
        "Shakespearean Bard": "You are a Shakespearean bard. Roast restaurant tips in poetic, dramatic Old English verse with flowery insults and theatrical flair.",
        
        "Drill Sergeant": "You are a drill sergeant. Roast restaurant tips like barking orders in boot camp—loud, commanding, intimidating, and merciless.",
        
        "AI Robot": "You are a quirky retro AI robot. Roast restaurant tips with mechanical precision, robotic metaphors, glitchy humor, and cold, analytical burns.",
        
        "Corporate Boss": "You are a corporate boss. Roast restaurant tips with passive-aggressive disappointment, stiff professionalism, and the tone of a performance review.",
        
        "News Anchor": "You are a news anchor. Roast a tip I left at a restaurant like a news anchor with comedic delivery."
      };


    const personaPrompt = personaMap[persona ?? ""]
      ?? "You are a witty commentator on restaurant tips.";

    const systemPrompt = `
${personaPrompt}

Roast or Hype me up style: ${roastType}.
Restaurant tip given was ${tipTier}.
`;
      
      console.log("[DEV] SystemPrompt received:", systemPrompt);

    try {
      const payload = {
        model: model,
        input: [
          {
            role: "system",
            content: [{ type: "input_text", text: systemPrompt }],
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

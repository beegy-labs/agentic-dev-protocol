/**
 * OpenAI Provider for API-based Compilation and Translation
 */

import type { LLMProvider, GenerateOptions } from './index.ts';

export class OpenAIProvider implements LLMProvider {
  readonly name = 'openai';
  readonly type = 'api' as const;
  readonly capabilities = ['compile', 'translate', 'edit'] as const;

  private endpoint: string;
  private apiKey: string;
  private defaultModel: string;

  constructor(
    apiKey?: string,
    defaultModel = 'gpt-4o-mini',
    endpoint = 'https://api.openai.com/v1',
  ) {
    this.apiKey = apiKey ?? process.env.OPENAI_API_KEY ?? '';
    this.endpoint = endpoint;
    this.defaultModel = defaultModel;
  }

  async healthCheck(): Promise<boolean> {
    if (!this.apiKey) {
      return false;
    }
    try {
      const response = await fetch(`${this.endpoint}/models`, {
        headers: {
          Authorization: `Bearer ${this.apiKey}`,
        },
      });
      return response.ok;
    } catch {
      return false;
    }
  }

  async listModels(): Promise<string[]> {
    if (!this.apiKey) {
      return [];
    }
    try {
      const response = await fetch(`${this.endpoint}/models`, {
        headers: {
          Authorization: `Bearer ${this.apiKey}`,
        },
      });
      if (!response.ok) {
        return [];
      }
      const data = (await response.json()) as {
        data: { id: string }[];
      };
      return data.data
        .map((m) => m.id)
        .filter((m) => m.startsWith('gpt'));
    } catch {
      return [];
    }
  }

  async generate(prompt: string, options?: GenerateOptions): Promise<string> {
    if (!this.apiKey) {
      throw new Error('OPENAI_API_KEY is not set');
    }

    const model = options?.model ?? this.defaultModel;
    const url = `${this.endpoint}/chat/completions`;

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.apiKey}`,
      },
      body: JSON.stringify({
        model,
        messages: [
          {
            role: 'user',
            content: prompt,
          },
        ],
        temperature: options?.temperature ?? 0.1,
        max_tokens: options?.maxTokens ?? 8192,
      }),
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`OpenAI API error: ${response.status} - ${error}`);
    }

    const data = (await response.json()) as {
      choices: { message: { content: string } }[];
    };

    return data.choices[0]?.message?.content ?? '';
  }
}

export function createOpenAIProvider(apiKey?: string, defaultModel?: string): OpenAIProvider {
  return new OpenAIProvider(apiKey, defaultModel);
}

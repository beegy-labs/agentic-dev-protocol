/**
 * Claude Provider for API-based Compilation and Translation
 */

import type { LLMProvider, GenerateOptions } from './index.ts';

export class ClaudeProvider implements LLMProvider {
  readonly name = 'claude';
  readonly type = 'api' as const;
  readonly capabilities = ['compile', 'translate', 'edit'] as const;

  private endpoint: string;
  private apiKey: string;
  private defaultModel: string;

  constructor(
    apiKey?: string,
    defaultModel = 'claude-3-haiku-20240307',
    endpoint = 'https://api.anthropic.com/v1',
  ) {
    this.apiKey = apiKey ?? process.env.ANTHROPIC_API_KEY ?? '';
    this.endpoint = endpoint;
    this.defaultModel = defaultModel;
  }

  async healthCheck(): Promise<boolean> {
    if (!this.apiKey) {
      return false;
    }
    // Claude doesn't have a simple health check endpoint, so we just verify API key exists
    return true;
  }

  async listModels(): Promise<string[]> {
    // Claude doesn't have a list models endpoint
    return [
      'claude-3-opus-20240229',
      'claude-3-sonnet-20240229',
      'claude-3-haiku-20240307',
      'claude-3-5-sonnet-20241022',
    ];
  }

  async generate(prompt: string, options?: GenerateOptions): Promise<string> {
    if (!this.apiKey) {
      throw new Error('ANTHROPIC_API_KEY is not set');
    }

    const model = options?.model ?? this.defaultModel;
    const url = `${this.endpoint}/messages`;

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': this.apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: JSON.stringify({
        model,
        max_tokens: options?.maxTokens ?? 8192,
        messages: [
          {
            role: 'user',
            content: prompt,
          },
        ],
      }),
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`Claude API error: ${response.status} - ${error}`);
    }

    const data = (await response.json()) as {
      content: { type: string; text: string }[];
    };

    return data.content[0]?.text ?? '';
  }
}

export function createClaudeProvider(apiKey?: string, defaultModel?: string): ClaudeProvider {
  return new ClaudeProvider(apiKey, defaultModel);
}

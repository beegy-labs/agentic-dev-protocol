/**
 * Shared utilities for documentation scripts
 */

import * as fs from 'node:fs';
import * as path from 'node:path';
import { createOllamaProvider } from './providers/ollama.ts';
import { createGeminiProvider } from './providers/gemini.ts';
import { createClaudeProvider } from './providers/claude.ts';
import { createOpenAIProvider } from './providers/openai.ts';
import type { LLMProvider } from './providers/index.ts';

/**
 * Failed file tracking interface
 */
export interface FailedFile {
  relativePath: string;
  error: string;
  timestamp: string;
}

/**
 * File group for merging RAG-split files
 */
export interface FileGroup {
  baseName: string;
  mainFile: string;
  companionFiles: string[];
}

/**
 * Create LLM provider by name
 */
export function createProvider(name: string, model?: string): LLMProvider {
  switch (name) {
    case 'ollama':
      return createOllamaProvider(undefined, model);
    case 'gemini':
      return createGeminiProvider(undefined, model);
    case 'claude':
      return createClaudeProvider(undefined, model);
    case 'openai':
      return createOpenAIProvider(undefined, model);
    default:
      throw new Error(`Unknown provider: ${name}. Available: ollama, gemini, claude, openai`);
  }
}

/**
 * Get all markdown files in a directory recursively
 */
export function getMarkdownFiles(dir: string): string[] {
  const files: string[] = [];

  if (!fs.existsSync(dir)) {
    return files;
  }

  function walk(currentDir: string) {
    const entries = fs.readdirSync(currentDir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(currentDir, entry.name);
      if (entry.isDirectory()) {
        walk(fullPath);
      } else if (entry.name.endsWith('.md')) {
        files.push(fullPath);
      }
    }
  }

  walk(dir);
  return files;
}

/**
 * Load failed files from previous run
 */
export function loadFailedFiles(failedFilesPath: string): FailedFile[] {
  if (!fs.existsSync(failedFilesPath)) {
    return [];
  }
  try {
    const content = fs.readFileSync(failedFilesPath, 'utf-8');
    return JSON.parse(content);
  } catch {
    return [];
  }
}

/**
 * Save failed files for retry
 */
export function saveFailedFiles(failedFilesPath: string, failedFiles: FailedFile[]): void {
  if (failedFiles.length === 0) {
    // Remove file if no failures
    if (fs.existsSync(failedFilesPath)) {
      fs.unlinkSync(failedFilesPath);
    }
    return;
  }
  fs.writeFileSync(failedFilesPath, JSON.stringify(failedFiles, null, 2), 'utf-8');
}

/**
 * Clear failed files history
 */
export function clearFailedFiles(failedFilesPath: string): boolean {
  if (fs.existsSync(failedFilesPath)) {
    fs.unlinkSync(failedFilesPath);
    return true;
  }
  return false;
}

/**
 * Check if target file needs regeneration based on modification time
 */
export function needsRegeneration(sourcePath: string, targetPath: string, force: boolean): boolean {
  if (force) return true;
  if (!fs.existsSync(targetPath)) return true;

  const sourceStat = fs.statSync(sourcePath);
  const targetStat = fs.statSync(targetPath);

  return sourceStat.mtime > targetStat.mtime;
}

/**
 * Group files for merging RAG-split files into single Tier 3 documents
 *
 * Pattern: foo.md + foo-impl.md + foo-testing.md → merged foo.md
 *
 * Companion patterns:
 * - {name}-impl.md
 * - {name}-implementation.md
 * - {name}-testing.md
 * - {name}-test.md
 * - {name}-examples.md
 * - {name}-advanced.md
 * - {name}-details.md
 */
export function groupFilesForMerge(files: string[]): FileGroup[] {
  const companionPatterns = [
    '-impl',
    '-implementation',
    '-testing',
    '-test',
    '-examples',
    '-advanced',
    '-details',
  ];

  const fileMap = new Map<string, string>();
  for (const file of files) {
    const basename = path.basename(file, '.md');
    fileMap.set(basename, file);
  }

  const groups: FileGroup[] = [];
  const processed = new Set<string>();

  for (const file of files) {
    const basename = path.basename(file, '.md');

    // Skip if already processed as companion
    if (processed.has(basename)) continue;

    // Check if this is a companion file
    const isCompanion = companionPatterns.some((pattern) => basename.endsWith(pattern));
    if (isCompanion) continue;

    // Find companion files
    const companionFiles: string[] = [];
    for (const pattern of companionPatterns) {
      const companionName = `${basename}${pattern}`;
      if (fileMap.has(companionName)) {
        companionFiles.push(fileMap.get(companionName)!);
        processed.add(companionName);
      }
    }

    processed.add(basename);
    groups.push({
      baseName: basename,
      mainFile: file,
      companionFiles,
    });
  }

  return groups;
}

/**
 * Merge multiple markdown files into a single content
 */
export function mergeFiles(mainFile: string, companionFiles: string[]): string {
  let content = fs.readFileSync(mainFile, 'utf-8');

  for (const companionFile of companionFiles) {
    const companionContent = fs.readFileSync(companionFile, 'utf-8');
    const basename = path.basename(companionFile, '.md');

    // Add separator and companion content
    content += `\n\n---\n\n`;
    content += `<!-- Merged from: ${basename}.md -->\n\n`;
    content += companionContent;
  }

  return content;
}

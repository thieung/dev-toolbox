#!/usr/bin/env node
/**
 * happy-ccs - Cross-platform bridge between CCS profiles and Happy CLI
 * Enables seamless AI provider switching while retaining Happy CLI features
 */

import { readFileSync, existsSync, readdirSync } from 'fs';
import { spawn } from 'child_process';
import { homedir } from 'os';
import { join } from 'path';
import { parse as parseYaml } from 'yaml';

const CCS_CONFIG = join(homedir(), '.ccs', 'config.yaml');

function loadCcsConfig() {
  if (!existsSync(CCS_CONFIG)) {
    console.error(`Error: CCS config not found at ${CCS_CONFIG}`);
    console.error('Install CCS first: https://github.com/kaitranntt/ccs');
    process.exit(1);
  }
  return parseYaml(readFileSync(CCS_CONFIG, 'utf8'));
}

function scanSettingsFiles() {
  const ccsDir = join(homedir(), '.ccs');
  if (!existsSync(ccsDir)) return {};

  const profiles = {};
  const files = readdirSync(ccsDir);

  for (const file of files) {
    if (file.endsWith('.settings.json')) {
      const name = file.replace('.settings.json', '');
      const path = join(ccsDir, file);
      profiles[name] = { settings: path };
    }
  }
  return profiles;
}

function loadAllProfiles() {
  const config = loadCcsConfig();
  const fileProfiles = scanSettingsFiles();

  // Merge: config.yaml profiles override file profiles
  return { ...fileProfiles, ...config.profiles };
}

function loadProfileEnv(settingsPath) {
  const resolved = settingsPath.replace(/^~/, homedir());
  if (!existsSync(resolved)) {
    console.error(`Error: Settings file not found: ${resolved}`);
    process.exit(1);
  }
  const settings = JSON.parse(readFileSync(resolved, 'utf8'));
  return settings.env || {};
}

function listProfiles(config) {
  console.log('Available profiles:\n');
  const profiles = config.profiles || {};
  for (const [name, profile] of Object.entries(profiles)) {
    const settings = profile.settings?.replace(/^~/, homedir()) || 'N/A';
    console.log(`  ${name.padEnd(12)} -> ${settings}`);
  }
  console.log('\nUsage: happy-ccs <profile> [happy-cli-args...]');
}

function main() {
  const args = process.argv.slice(2);

  if (args.length === 0 || args[0] === '--help' || args[0] === '-h') {
    console.log('happy-ccs - Bridge CCS profiles to Happy CLI\n');
    console.log('Usage: happy-ccs <profile> [happy-cli-args...]');
    console.log('       happy-ccs --list\n');
    console.log('Examples:');
    console.log('  happy-ccs agy              # Start with AGY');
    console.log('  happy-ccs glm --resume        # GLM with resume');
    console.log('  happy-ccs minimax daemon start   # Minimax daemon mode');
    process.exit(0);
  }

  const profiles = loadAllProfiles();

  if (args[0] === '--list' || args[0] === '-l') {
    listProfiles({ profiles });
    process.exit(0);
  }

  const profileName = args[0];
  const happyArgs = args.slice(1);

  if (!profiles[profileName]) {
    console.error(`Error: Profile '${profileName}' not found`);
    console.error('Use --list to see available profiles');
    process.exit(1);
  }

  const profile = profiles[profileName];
  const envVars = loadProfileEnv(profile.settings);

  // Build happy CLI args with --claude-env flags
  const claudeEnvArgs = Object.entries(envVars).flatMap(
    ([key, value]) => ['--claude-env', `${key}=${value}`]
  );

  const finalArgs = [...claudeEnvArgs, ...happyArgs];

  // Dry-run mode for debugging
  if (happyArgs.includes('--dry-run')) {
    console.log(`Profile: ${profileName}`);
    console.log(`Command: happy ${finalArgs.filter(a => a !== '--dry-run').join(' ')}`);
    process.exit(0);
  }

  console.log(`Starting Happy CLI with profile: ${profileName}`);

  const child = spawn('happy', finalArgs, {
    stdio: 'inherit',
    shell: process.platform === 'win32',
  });

  child.on('error', (err) => {
    console.error(`Error starting happy: ${err.message}`);
    process.exit(1);
  });

  child.on('close', (code) => {
    process.exit(code || 0);
  });
}

main();

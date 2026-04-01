# Foley AI for Godot

Foley AI is an editor plugin for Godot that generates and imports Foley AI sound
effects directly inside the editor.

## Requirements

- Godot 4.6
- A Foley AI API key from [foley-ai.com](https://www.foley-ai.com/)

## Features

- Docked generator panel for full generation workflows
- Quick Generate dialog from the FileSystem context menu
- Batch prompt generation and retry tools
- Prompt presets and recent prompt history
- Metadata sidecars for regeneration and variations
- Direct import back into `res://`

## Installation

1. Copy `addons/foley_ai` into your Godot project.
2. Enable the plugin in `Project Settings > Plugins`.
3. Get an API key from [foley-ai.com](https://www.foley-ai.com/), then save it in the plugin panel or set `foley_ai/api_key`.

## Repository Notes

- The repository is configured so Asset Library ZIP downloads export only
  `addons/foley_ai`.
- A copy of the license and readme is included inside the addon folder for
  Asset Library users.

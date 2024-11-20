import * as fs from 'fs'
import { stdin, exit } from 'process'

// Define the structure of the JSON input
interface PackageInfo {
  name: string
  version: string
}

// Read and process stdin
const inputFile = stdin
let data = ''

inputFile.setEncoding('utf8')

inputFile.on('data', (chunk: string) => {
  data += chunk
})

inputFile.on('end', async () => {
  try {
    // Extract JSON array from the input
    const startIndex = data.indexOf('[')
    const endIndex = data.lastIndexOf(']')
    if (startIndex === -1 || endIndex === -1) {
      console.error('Error: No valid JSON array found in the input.')
      exit(1)
    }

    const jsonData = data.substring(startIndex, endIndex + 1)

    let packages: PackageInfo[]
    try {
      packages = JSON.parse(jsonData)
    } catch (parseError) {
      console.error(
        'Error: Failed to parse JSON data.',
        (parseError as Error).message
      )
      exit(1)
    }

    if (!Array.isArray(packages)) {
      console.error('Error: Parsed JSON is not an array.')
      exit(1)
    }

    // Generate Markdown
    const markdown = [
      '| Package | Version |',
      '|:-------:|:-------:|',
      ...packages
        .map((pkg) => {
          if (typeof pkg.name !== 'string' || typeof pkg.version !== 'string') {
            console.warn('Warning: Invalid package format. Skipping.')
            return null
          }
          return `| ${pkg.name} | ${pkg.version} |`
        })
        .filter((line): line is string => line !== null)
    ].join('\n')

    const outputFile = 'pip_list.md'

    try {
      await fs.promises.writeFile(outputFile, markdown, 'utf8')
      console.log(`Markdown file successfully generated: ${outputFile}`)
    } catch (writeError) {
      console.error(
        'Error: Failed to write to file.',
        (writeError as Error).message
      )
      exit(1)
    }
  } catch (error) {
    console.error('Unexpected error:', (error as Error).message)
    exit(1)
  }
})

inputFile.on('error', (error) => {
  console.error('Error reading input:', error.message)
  exit(1)
})

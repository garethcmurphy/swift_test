# PubChem Data Fetcher

This repository contains Swift scripts to fetch data from the PubChem API. The scripts fetch compound data and gene summaries and print the results.

## Files

- `fetchcompounds.swift`: Fetches data for a specific compound (CID 2244) from the PubChem API and prints the compound's CID and properties.
- `fetchGeneSummaries.swift`: Fetches gene summaries from the PubChem database using the PubChem REST API.

## Usage

### Fetching Compound Data

To fetch compound data, run the `fetchcompounds.swift` script:

```sh
swift fetchcompounds.swift


/* 
This script fetches gene summaries from the
 PubChem database using the PubChem REST API.    
*/

import Foundation

// MARK: - Models
struct GeneSummaryResponse: Decodable {
    let GeneSummaries: GeneSummaries
}

struct GeneSummaries: Decodable {
    let GeneSummary: [Gene]
}

struct Gene: Decodable {
    let GeneID: Int
    let Symbol: String
    let Name: String
    let TaxonomyID: Int
    let Taxonomy: String
    let Description: String
    let Synonym: [String]
}

// MARK: - Networking
func fetchGenes(completion: @escaping ([Gene]?) -> Void) {
    guard let url = URL(string: "https://pubchem.ncbi.nlm.nih.gov/rest/pug/gene/geneid/1956,13649/summary/JSON") else {
        print("Invalid URL")
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            completion(nil)
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response Code: \(httpResponse.statusCode)")
            if !(200...299).contains(httpResponse.statusCode) {
                print("Unexpected response code")
                completion(nil)
                return
            }
        }
        if let data = data {
            print("Data received")
            do {
                let decodedResponse = try JSONDecoder().decode(GeneSummaryResponse.self, from: data)
                completion(decodedResponse.GeneSummaries.GeneSummary)
            } catch {
                print("Decoding failed: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    print("Starting task")
    task.resume()
}

// MARK: - Main Program
let semaphore = DispatchSemaphore(value: 0) // To keep the program running

fetchGenes { genes in
    if let genes = genes {
        print("Fetched \(genes.count) genes:")
        for gene in genes {
            print("""
            \(gene.Symbol) (\(gene.Name)):
            Taxonomy: \(gene.Taxonomy)
            Description: \(gene.Description.prefix(100))...
            Synonyms: \(gene.Synonym.joined(separator: ", "))
            """)
        }
    } else {
        print("Failed to fetch genes")
    }
    semaphore.signal() // Signal the program to continue
}

semaphore.wait() // Wait until the asynchronous task completes
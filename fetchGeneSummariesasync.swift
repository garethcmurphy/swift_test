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
func fetchGenes() async throws -> [Gene] {
    guard let url = URL(string: "https://pubchem.ncbi.nlm.nih.gov/rest/pug/gene/geneid/1956,13649/summary/JSON") else {
        throw URLError(.badURL)
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    if let httpResponse = response as? HTTPURLResponse {
        print("HTTP Response Code: \(httpResponse.statusCode)")
        if !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
    }

    print("Data received")
    let decodedResponse = try JSONDecoder().decode(GeneSummaryResponse.self, from: data)
    return decodedResponse.GeneSummaries.GeneSummary
}

// MARK: - Main Program
    static func  main() async{
        do {
            let genes = try await fetchGenes()
            print("Fetched \(genes.count) genes:")
            for gene in genes {
                print("""
                \(gene.Symbol) (\(gene.Name)):
                Taxonomy: \(gene.Taxonomy)
                Description: \(gene.Description.prefix(100))...
                Synonyms: \(gene.Synonym.joined(separator: ", "))
                """)
            }
        } catch {
            print("Failed to fetch genes: \(error.localizedDescription)")
        }
    }

main()
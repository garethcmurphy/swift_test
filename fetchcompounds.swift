
/*
 This script fetches data from the PubChem API
  for a specific compound (CID 2244) and prints
   the compound's CID and properties.
*/
import Foundation

// MARK: - Models
struct PubChemResponse: Decodable {
    let PC_Compounds: [Compound]
}

struct Compound: Decodable {
    let id: CompoundID
    let props: [Property]?
}

struct CompoundID: Decodable {
    let id: CID
}

struct CID: Decodable {
    let cid: Int
}

struct Property: Decodable {
    let urn: URN
    let value: Value
}

struct URN: Decodable {
    let label: String
    let name: String?
}

struct Value: Decodable {
    let sval: String?
    let fval: Double?
    let ival: Int?
}

// MARK: - Fetch Data Function
func fetchCompoundData() {
    let semaphore = DispatchSemaphore(value: 0) // Semaphore to wait for the async task
    
    guard let url = URL(string: "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/2244/record/JSON") else {
        print("Invalid URL")
        return
    }
    
    // URLSession task
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            semaphore.signal()
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Response Code: \(httpResponse.statusCode)")
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected HTTP response")
                semaphore.signal()
                return
            }
        }
        
        if let data = data {
            do {
                let decodedResponse = try JSONDecoder().decode(PubChemResponse.self, from: data)
                print("Data fetched successfully.")
                
                // Print basic compound data
                if let compound = decodedResponse.PC_Compounds.first {
                    print("Compound CID: \(compound.id.id.cid)")
                    
                    // Print properties
                    if let properties = compound.props {
                        for prop in properties {
                            print("Property: \(prop)")
                            //if let label = prop.urn.label, let value = prop.value.sval {
                            //    print("\(label): \(value)")
                            //}
                        }
                    }
                }
            } catch {
                print("Decoding failed: \(error)")
            }
        }
        semaphore.signal() // Signal completion
    }
    
    print("Starting fetch...")
    task.resume() // Start the task
    semaphore.wait() // Wait for the task to complete
}

// MARK: - Main Program
fetchCompoundData()
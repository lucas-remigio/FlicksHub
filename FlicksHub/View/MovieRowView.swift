import SwiftUI

struct MovieRowView: View {
    let movie: MovieProtocol
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let posterPath = movie.posterPath,
               let imageUrl = URL(string: "\(NetworkConstant.shared.imageServerAddress)\(posterPath)") {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 70, height: 105)
                                .cornerRadius(8)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 105)
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 105)
                                .cornerRadius(8)
                                .foregroundColor(.red)
                        @unknown default:
                            Image(systemName: "questionmark")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 105)
                                .cornerRadius(8)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                
            }
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)  // Restrict title to one line

                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 8)
            
        Spacer()  // Allows content to push left, eliminating any space to the right

        }
        .padding(8)  // Slight padding around the card content
        .background(Color("MidnightGrayColor").opacity(0.9).cornerRadius(12))
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 4)
        .listRowBackground(Color("MidnightColor"))  // Consistent row background
    }
}

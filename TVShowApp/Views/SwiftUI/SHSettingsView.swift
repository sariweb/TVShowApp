//
//  SHSettingsView.swift
//  TVShowApp
//
//  Created by Sergei on 17.10.2023.
//

import SwiftUI

struct SHSettingsView: View {
    let viewModel: SHSettingsViewViewModel
    
    init(viewModel: SHSettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(uiColor: viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
        
    }
}

struct SHSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SHSettingsView(viewModel: SHSettingsViewViewModel(
            cellViewModels: SHSettingsOption.allCases.compactMap {
                return SHSettingsCellViewModel(type: $0) { option in
                    
                }
            }
        ))
    }
}

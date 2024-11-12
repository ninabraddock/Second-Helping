//
//  InputView.swift
//  Second-Helping
//
//  Created by Nina Braddock on 10/3/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(title)
                .font(.custom("StudyClash", size: 18))
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.custom("StudyClash", size: 18))
                
            } else {
                TextField(placeholder, text: $text)
                    .font(.custom("StudyClash", size: 18))
            }
            Divider()
        }
    }
}

#Preview {
    InputView(text: .constant(""),
              title: "Email Address",
              placeholder: "name@example.com")
}

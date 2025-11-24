//
//  SettingsView.swift
//  POLARIS ARENA
//
//  Settings and preferences
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("showHints") private var showHints = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ColorPalette.background(for: colorScheme)
                    .ignoresSafeArea()

                List {
                    Section("Audio & Haptics") {
                        Toggle("Sound Effects", isOn: $soundEnabled)
                            .onChange(of: soundEnabled) { _, newValue in
                                SoundManager.shared.setMuted(!newValue)
                            }

                        Toggle("Haptic Feedback", isOn: $hapticsEnabled)
                    }

                    Section("Gameplay") {
                        Toggle("Show Hints", isOn: $showHints)
                    }

                    Section("Legal") {
                        Button(action: {
                            if let url = URL(string: "https://yourwebsite.com/terms") {
                                openURL(url)
                            }
                        }) {
                            HStack {
                                Text("Terms of Use")
                                    .foregroundColor(ColorPalette.text(for: colorScheme))
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .font(.system(size: 14))
                                    .foregroundColor(ColorPalette.textSecondary(for: colorScheme))
                            }
                        }

                        Button(action: {
                            if let url = URL(string: "https://yourwebsite.com/privacy") {
                                openURL(url)
                            }
                        }) {
                            HStack {
                                Text("Privacy Policy")
                                    .foregroundColor(ColorPalette.text(for: colorScheme))
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .font(.system(size: 14))
                                    .foregroundColor(ColorPalette.textSecondary(for: colorScheme))
                            }
                        }
                    }

                    Section("About") {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("\(appVersion) (\(buildNumber))")
                                .foregroundColor(ColorPalette.textSecondary(for: colorScheme))
                        }

                        HStack {
                            Text("© 2025 Polaris Arena")
                                .font(Typography.caption)
                                .foregroundColor(ColorPalette.textSecondary(for: colorScheme))
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(ColorPalette.text(for: colorScheme))
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}

import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var timeLeft = 30
    @State private var isPlaying = false
    @State private var bestScore = UserDefaults.standard.integer(forKey: "bestScore")
    @State private var showResult = false
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.07, green: 0.08, blue: 0.16),
                                    Color(red: 0.15, green: 0.10, blue: 0.28)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Text("TAP MASTER")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                HStack(spacing: 14) {
                    statCard(title: "СЧЁТ", value: "\(score)")
                    statCard(title: "ВРЕМЯ", value: "\(timeLeft)")
                    statCard(title: "РЕКОРД", value: "\(bestScore)")
                }

                Spacer()

                Button {
                    if isPlaying {
                        score += 1
                    } else if timeLeft == 30 && !showResult {
                        startGame()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(isPlaying ? Color.pink : Color.purple)
                            .frame(width: 220, height: 220)
                            .shadow(color: .purple.opacity(0.45), radius: 24, y: 10)
                        Circle()
                            .stroke(.white.opacity(0.35), lineWidth: 5)
                            .frame(width: 198, height: 198)
                        Text(isPlaying ? "ЖМИ!" : "СТАРТ")
                            .font(.system(size: 34, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }
                .disabled(showResult)

                Text(isPlaying ? "Нажимай как можно быстрее!" : "Набери максимум очков за 30 секунд")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.75))
                    .multilineTextAlignment(.center)

                Spacer()

                if showResult {
                    VStack(spacing: 10) {
                        Text("ВРЕМЯ ВЫШЛО!")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                        Text("Твой результат: \(score)")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.85))
                        Button("ИГРАТЬ СНОВА") { resetGame() }
                            .font(.headline.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(Color.purple, in: Capsule())
                    }
                } else {
                    Button("Сбросить") { resetGame() }
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.bottom, 8)
                }
            }
            .padding(24)
        }
        .preferredColorScheme(.dark)
        .onDisappear { timer?.invalidate() }
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Text(title).font(.caption.bold()).foregroundStyle(.white.opacity(0.65))
            Text(value).font(.system(size: 25, weight: .heavy, design: .rounded)).foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 18))
    }

    private func startGame() {
        score = 0
        timeLeft = 30
        showResult = false
        isPlaying = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if timeLeft > 1 {
                timeLeft -= 1
            } else {
                timeLeft = 0
                t.invalidate()
                isPlaying = false
                showResult = true
                if score > bestScore {
                    bestScore = score
                    UserDefaults.standard.set(bestScore, forKey: "bestScore")
                }
            }
        }
    }

    private func resetGame() {
        timer?.invalidate()
        score = 0
        timeLeft = 30
        isPlaying = false
        showResult = false
    }
}

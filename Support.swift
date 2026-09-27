import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            AboutContent().toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Готово") { dismiss() } } }
        }
    }
}
struct AboutContent: View {
    @EnvironmentObject var theme: ThemeStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Brand(size: 68)
                Text("Ближе к людям").font(.largeTitle.bold())
                Text("NextU соединяет людей поблизости: встречайтесь, находите компанию, помогайте соседям и открывайте события Минска.").font(.title3)
                Label("Карта жизни рядом", systemImage: "map.fill")
                Label("Помощь и общие интересы", systemImage: "person.2.fill")
                Label("Афиша и избранное", systemImage: "star.fill")
                Text("Версия 0.3 · iPhone, iOS 17+").font(.caption).foregroundStyle(.secondary)
                Text("В этой версии профиль, публикации, чаты и отзывы хранятся на вашем устройстве. Геопозиция используется по вашему разрешению. Общий сервер и проверка доверия участниками пока не подключены.").font(.subheadline).foregroundStyle(.secondary)
                Link("Афиша: Ticketpro", destination: URL(string: "https://www.ticketpro.by/")!)
                Text("Изображения и сведения афиши принадлежат соответствующим правообладателям. NextU не является билетным оператором.").font(.caption).foregroundStyle(.secondary)
                NavigationLink { SupportView() } label: { Label("Помощь и обратная связь", systemImage: "questionmark.bubble").card() }
            }.padding(24)
        }.background(theme.selected.background).navigationTitle("О приложении").navigationBarTitleDisplayMode(.inline)
    }
}
struct SupportView: View {
    @EnvironmentObject var theme: ThemeStore
    @Environment(\.openURL) var openURL
    @State private var issue = ""
    private var report: String {
        "NextU 0.3 — обращение\niOS: \(UIDevice.current.systemVersion)\nУстройство: \(UIDevice.current.model)\n\nОписание:\n\(issue)"
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Поможем разобраться").font(.largeTitle.bold())
                DisclosureGroup("Карта не находит меня") {
                    Text("Разрешите NextU доступ к геопозиции в настройках iPhone, затем нажмите «Где я?» справа внизу карты. На симуляторе задайте Location вручную.").padding(.top, 8)
                    Button("Открыть настройки iPhone") { if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) } }.padding(.top, 8)
                }.card()
                DisclosureGroup("Почему не видно события?") { Text("Проверьте район, категорию и временной фильтр. В афише отключите «Период» для просмотра всех ближайших дат. Потяните список вниз, чтобы обновить Ticketpro.").padding(.top, 8) }.card()
                DisclosureGroup("Как выделить область?") { Text("В выборе места нажмите для точки или обведите местность пальцем. Чтобы сдвинуть и приблизить карту, включите «Перемещать и приближать карту», затем выключите для выделения.").padding(.top, 8) }.card()
                Text("Сообщить о проблеме").font(.title2.bold())
                TextField("Что произошло и как повторить ошибку?", text: $issue, axis: .vertical).lineLimit(5...10).padding(16).background(theme.selected.surface, in: RoundedRectangle(cornerRadius: 18))
                    .onChange(of: issue) { _, value in issue = String(value.prefix(4000)) }
                ShareLink(item: report) { Label("Поделиться обращением", systemImage: "square.and.arrow.up").frame(maxWidth: .infinity).padding(16).background(theme.selected.gradient, in: RoundedRectangle(cornerRadius: 18)).foregroundStyle(theme.selected.dark ? Color.black : Color.white) }.disabled(issue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Text("Выберите получателя в меню iOS. Обращение не отправляется автоматически; отдельная служба поддержки пока не подключена. В отчёт не добавляются геопозиция и данные профиля.").font(.caption).foregroundStyle(.secondary)
            }.padding(20)
        }.background(theme.selected.background).navigationTitle("Поддержка").navigationBarTitleDisplayMode(.inline)
    }
}

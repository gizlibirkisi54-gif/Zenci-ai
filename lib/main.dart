import 'package:flutter/material.dart';

void main() {
runApp(const ZenciAI());
}

class ZenciAI extends StatefulWidget {
const ZenciAI({super.key});

@override
State<ZenciAI> createState() => _ZenciAIState();
}

class _ZenciAIState extends State<ZenciAI> {
bool whiteTheme = false;

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Zenci AI',
theme: ThemeData(
brightness: whiteTheme ? Brightness.light : Brightness.dark,
scaffoldBackgroundColor:
whiteTheme ? const Color(0xffeeeeee) : const Color(0xff050505),
colorScheme: ColorScheme.fromSeed(
seedColor: const Color(0xffed1c35),
brightness: whiteTheme ? Brightness.light : Brightness.dark,
),
),
home: HomePage(
whiteTheme: whiteTheme,
onThemeChanged: (value) {
setState(() => whiteTheme = value);
},
),
);
}
}

class HomePage extends StatefulWidget {
final bool whiteTheme;
final ValueChanged<bool> onThemeChanged;

const HomePage({
super.key,
required this.whiteTheme,
required this.onThemeChanged,
});

@override
State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
with SingleTickerProviderStateMixin {
final TextEditingController controller = TextEditingController();
final List<String> messages = [];

late AnimationController animation;

Color get red => const Color(0xffed1c35);

@override
void initState() {
super.initState();
animation = AnimationController(
vsync: this,
duration: const Duration(seconds: 2),
)..repeat(reverse: true);
}

@override
void dispose() {
animation.dispose();
controller.dispose();
super.dispose();
}

void sendMessage(String value) {
if (value.trim().isEmpty) return;

setState(() {
  messages.add(value.trim());
  controller.clear();
});

}

@override
Widget build(BuildContext context) {
final foreground = widget.whiteTheme ? Colors.black : Colors.white;

return Scaffold(
  appBar: AppBar(
    title: Row(
      children: [
        Icon(Icons.workspace_premium, color: red),
        const SizedBox(width: 8),
        const Text(
          'ZENCİ',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        Text(' AI', style: TextStyle(color: red)),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SettingsPage(
                whiteTheme: widget.whiteTheme,
                onThemeChanged: widget.onThemeChanged,
              ),
            ),
          );
        },
      ),
    ],
  ),
  body: Column(
    children: [
      Expanded(
        child: messages.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + animation.value * 0.035,
                          child: child,
                        );
                      },
                      child: Icon(
                        Icons.pest_control,
                        size: 170,
                        color: red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'ZENCİ AI',
                      style: TextStyle(
                        color: foreground,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'LAN ZENCİ DİYEREK SESLEN',
                      style: TextStyle(
                        color: red,
                        letterSpacing: 2,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: red.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: red),
                      ),
                      child: Text(messages[index]),
                    ),
                  );
                },
              ),
      ),
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: red.withOpacity(0.6))),
        ),
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.send,
          onSubmitted: sendMessage,
          decoration: InputDecoration(
            hintText: 'Mesajını yaz...',
            filled: true,
            fillColor: widget.whiteTheme
                ? Colors.white
                : const Color(0xff171717),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: red),
            ),
          ),
        ),
      ),
    ],
  ),
);

}
}

class SettingsPage extends StatelessWidget {
final bool whiteTheme;
final ValueChanged<bool> onThemeChanged;

const SettingsPage({
super.key,
required this.whiteTheme,
required this.onThemeChanged,
});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Ayarlar')),
body: ListView(
padding: const EdgeInsets.all(20),
children: [
const Text(
'ARAYÜZ SEÇİMİ',
style: TextStyle(fontWeight: FontWeight.bold),
),
const SizedBox(height: 15),
SegmentedButton<bool>(
segments: const [
ButtonSegment(
value: false,
label: Text('Siyah'),
),
ButtonSegment(
value: true,
label: Text('Beyaz'),
),
],
selected: {whiteTheme},
onSelectionChanged: (value) {
onThemeChanged(value.first);
},
),
const SizedBox(height: 25),
const ListTile(
leading: Icon(Icons.key),
title: Text('API anahtarı'),
subtitle: Text('Sonraki geliştirme aşamasında eklenecek'),
),
const ListTile(
leading: Icon(Icons.extension),
title: Text('Eklentiler'),
),
const ListTile(
leading: Icon(Icons.folder),
title: Text('Projeler'),
),
const ListTile(
leading: Icon(Icons.smart_toy),
title: Text('Ajan ayarları'),
),
],
),
);
}
}

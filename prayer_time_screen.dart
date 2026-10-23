import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../modal/Prayer.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  List<Prayer> monthData = [];

  String url =
      "https://api.aladhan.com/v1/calendarByCity?city=Karachi&country=Pakistan&state=Sindh&month=9&year=2026&method=3";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7F5),

      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          "Prayer Timing App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: monthData.isEmpty
          ? Center(
        child: ElevatedButton.icon(
          onPressed: getPrayerData,
          icon: const Icon(Icons.mosque),
          label: const Text("Load Prayer Times"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        itemCount: monthData.length,
        itemBuilder: (context, index) {
          Prayer p = monthData[index];

          return prayerCard(p);
        },
      ),
    );
  }

  Widget prayerCard(Prayer p) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 18),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // ================= DATE =================

            Row(
              children: [

                Container(
                  height: 48,
                  width: 48,

                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.green.shade700,
                  ),
                ),

                const SizedBox(width: 14),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      p.day,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      "Rawalpindi, Pakistan",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            Divider(
              color: Colors.grey.shade200,
            ),

            const SizedBox(height: 5),

            // ================= FAJR =================

            prayerRow(
              icon: Icons.nightlight_round,
              name: "Fajr",
              time: p.fajar ,
            ),

            prayerDivider(),

            // ================= DHUHR =================

            prayerRow(
              icon: Icons.wb_sunny_outlined,
              name: "Dhuhr",
              time: p.dhuhr ,
            ),

            prayerDivider(),

            // ================= ASR =================

            prayerRow(
              icon: Icons.wb_twilight,
              name: "Asr",
              time: p.asr ,
            ),

            prayerDivider(),

            // ================= MAGHRIB =================

            prayerRow(
              icon: Icons.wb_twilight_outlined,
              name: "Maghrib",
              time: p.maghrib ,
            ),

            prayerDivider(),

            // ================= ISHA =================

            prayerRow(
              icon: Icons.nightlight,
              name: "Isha",
              time: p.isha,
            ),
          ],
        ),
      ),
    );
  }

  // ================= PRAYER ROW =================

  Widget prayerRow({
    required IconData icon,
    required String name,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),

      child: Row(
        children: [

          Container(
            height: 42,
            width: 42,

            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: Colors.green.shade700,
              size: 21,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(
            time,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // ================= DIVIDER =================

  Widget prayerDivider() {
    return Divider(
      height: 1,
      thickness: 0.7,
      color: Colors.grey.shade200,
    );
  }

  // ================= API =================

  void getPrayerData() async {
    Uri uri = Uri.parse(url);

    var response = await http.get(uri);

    Map<String, dynamic> prayerData = jsonDecode(response.body);

    setState(() {
      monthData = Prayer.parseMonthData(prayerData);
    });
  }

}
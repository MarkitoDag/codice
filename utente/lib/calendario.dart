import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:utente/prenota.dart';

class Calendario extends StatefulWidget {
  final String codiceFiscale;
  const Calendario({Key? key, required this.codiceFiscale}) : super(key: key);

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Calendario',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'di conferimento dei rifiuti',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                  'I sacchi vanno depositati\ndavanti al proprio portone',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600)),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text('dalle ore 20:00 alle ore 24:00',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(
              height: 475,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  physics: const PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? _lunedi(context)
                        : index == 1
                            ? _martedi(context)
                            : index == 2
                                ? _mercoledi(context)
                                : index == 3
                                    ? _giovedi(context)
                                    : index == 4
                                        ? _venredi(context)
                                        : index == 5
                                            ? _sabato(context)
                                            : _domenica(context);
                  }),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: Prenota(codiceFiscale: widget.codiceFiscale,)));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        center: Alignment.topRight,
                        radius: 15,
                        colors: [
                          Colors.orange,
                          Color(0xFF666666),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(CupertinoIcons.ticket),
                          SizedBox(
                            width: 20,
                          ),
                          Text('Prenota ritiro straordinario'),
                        ])),
              ),
            ),
          ]),
        ),
      );
}

Widget _lunedi(context) {
  return Padding(
    padding: const EdgeInsets.all(18),
    child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 200,
        width: MediaQuery.of(context).size.width - 37,
        child: Padding(
            padding: const EdgeInsets.all(18),
            child: Stack(children: [
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/sigaretta.png',
                      colorBlendMode: BlendMode.hue,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const Text(
                    'Lunedì',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Rifiuto non riciclabile',
                    style: TextStyle(fontSize: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width - 37,
                      color: Colors.grey,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18, left: 18),
                      child: Text(
                        'cosa si:',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'Assorbenti, stracci sporchi, spugne, spazzolini, oggetti di gomma,posate monouso, mozziconi di sigari esigarette, carta plastificata, gommeda masticare, polvere e sacchetti aspirapolvere.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width - 37,
                      color: Colors.grey,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 18, left: 18),
                      child: Text(
                        'cosa no:',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'Tutti i materiali riciclabili (organico, plastica e metalli, carta, cartone ecartoncino, vetro), rifiuti urbani pericolosi,ingombranti, RAEE (Rifiuti da Apparecchiature Elettriche ed Elettroniche).',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ]))),
  );
}

Widget _martedi(context) {
  return Padding(
    padding: const EdgeInsets.all(18),
    child: Container(
        decoration: BoxDecoration(
          color: Colors.brown.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 200,
        width: MediaQuery.of(context).size.width - 37,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Stack(children: [
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 150,
                width: 150,
                child: ClipRRect(
                  child: Image.asset(
                    'assets/egg.png',
                    colorBlendMode: BlendMode.hue,
                    color: Colors.brown.shade100,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const Text(
                  'Martedì',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Rifiuto organico',
                  style: TextStyle(fontSize: 10),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width - 37,
                    color: Colors.grey,
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 18, left: 18),
                    child: Text(
                      'cosa si:',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "Scarti da cucina vegetali e animali, guscid'uovo, fondi di caffè e tè, tovaglioli di carta sporchi di cibo, foglie, fiori secchi,piccoli scarti di potatura (diametro inferiore a 5 cm), tappi di sughero, lettiere compostabili.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width - 37,
                    color: Colors.grey,
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 18, left: 18),
                    child: Text(
                      'cosa no:',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "Lettiere sintetiche, assorbenti e pannolini, oli esausti, rami di potatura (diametro superiore a 5 cm), mozziconi di sigari e sigararette, polvere e sacchetti aspirapolvere, gomme da masticare.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        )),
  );
}

Widget _mercoledi(context) {
  return Padding(
    padding: const EdgeInsets.all(18),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      width: MediaQuery.of(context).size.width - 37,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 150,
              width: 150,
              child: ClipRRect(
                child: Image.asset(
                  'assets/plastic.png',
                  colorBlendMode: BlendMode.hue,
                  color: Colors.yellow.shade100,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const Text(
                'Mercoledì',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Plastica e lattine',
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 37,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 18, left: 18),
                  child: Text(
                    'cosa si:',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Bottiglie di plastica, vasetti per alimenti e yogurt, pellicole da imballaggi e polistirolo, flaconi di prodotti per la casa e igiene personale, piatti e bicchieri usa e getta, tubetti di crema e dentifricio vuoti in plastica e metallo, blister, stampelle per abiti in plastica e metallo, lattine, scatolette, barattoli, carta e vaschette in alluminio, cartoni per bevande e alimenti (brick del latte, succhi di frutta e simili), bombolette spray vuote.",
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 37,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 18, left: 18),
                  child: Text(
                    'cosa no:',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Beni ingombranti di plastica (bacinelle e secchi), giocattoli, elettrodomestici e loro parti, contenitori di colle, smalti e vernici, posate monouso di plastica, oggetti di gomma, CD, DVD, videocassette compresi i contenitori esterni, tubi in plastica e/o gomma, cavi e elementi di impianti elettrici, pellicole e lastre fotografiche.",
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    ),
  );
}

Widget _giovedi(context) {
  return Padding(
    padding: const EdgeInsets.all(18),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      width: MediaQuery.of(context).size.width - 37,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 150,
              width: 150,
              child: ClipRRect(
                child: Image.asset(
                  'assets/paper.png',
                  colorBlendMode: BlendMode.hue,
                  color: Colors.blue.shade100,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const Text(
                'Giovedì',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Carta e cartone',
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 37,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 18, left: 18),
                  child: Text(
                    'cosa si:',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Quaderni, libri, riviste e quotidiani, volantini pubblicitari, cartoni, scatole di cartoncino, cartone della pizza non sporco, carta,da disegno o per fotocopie.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 37,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 18, left: 18),
                  child: Text(
                    'cosa no:',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Fotografie, carta unta, sporca di cibo, carta oleata, tovaglioli sporchi, carta da forno, fazzoletti usati, carta chimica (scontrini), ogni tipo di carta, cartone e cartoncino sporchi.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    ),
  );
}

Widget _venredi(context) {
  return Padding(
    padding: const EdgeInsets.all(18),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      width: MediaQuery.of(context).size.width - 37,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 150,
              width: 150,
              child: ClipRRect(
                child: Image.asset(
                  'assets/egg.png',
                  colorBlendMode: BlendMode.hue,
                  color: Colors.brown.shade100,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const Text(
                'Venerdì',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Rifiuto organico',
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 37,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 18, left: 18),
                  child: Text(
                    'cosa si:',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Scarti da cucina vegetali e animali, guscid'uovo, fondi di caffè e tè, tovaglioli di carta sporchi di cibo, foglie, fiori secchi,piccoli scarti di potatura (diametro inferiore a 5 cm), tappi di sughero, lettiere compostabili.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 37,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 18, left: 18),
                  child: Text(
                    'cosa no:',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Lettiere sintetiche, assorbenti e pannolini, oli esausti, rami di potatura (diametro superiore a 5 cm), mozziconi di sigari e sigararette, polvere e sacchetti aspirapolvere, gomme da masticare.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    ),
  );
}

Widget _sabato(context) {
  return Padding(
    padding: const EdgeInsets.all(18),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      width: MediaQuery.of(context).size.width - 37,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 150,
              width: 150,
              child: ClipRRect(
                child: Image.asset(
                  'assets/glass.png',
                  colorBlendMode: BlendMode.hue,
                  color: Colors.green.shade100,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const Text(
                'Sabato',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Vetro',
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 37,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 18, left: 18),
                  child: Text(
                    'cosa si:',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Bottiglie, vasetti e barattoli di vetro svuotati del contenuto e privati degli accessori dell'imballaggio facilmente asportabili.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 37,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 18, left: 18),
                  child: Text(
                    'cosa no:',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Le lastre, gli specchi e tutti quegli oggetti in vetro che non sono imballaggi, bicchieri e oggetti di cristallo, la ceramica e la porcellana, il pyrex, le lampadine e i neon, tubi e schermi tv, monitor computer.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    ),
  );
}

Widget _domenica(context) {
  return Padding(
    padding: const EdgeInsets.all(18),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.brown.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      width: MediaQuery.of(context).size.width - 37,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 150,
              width: 150,
              child: ClipRRect(
                child: Image.asset(
                  'assets/egg.png',
                  colorBlendMode: BlendMode.hue,
                  color: Colors.brown.shade100,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const Text(
                'Domenica',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Rifiuto organico',
                style: TextStyle(fontSize: 10),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 37,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 18, left: 18),
                  child: Text(
                    'cosa si:',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Scarti da cucina vegetali e animali, guscid'uovo, fondi di caffè e tè, tovaglioli di carta sporchi di cibo, foglie, fiori secchi,piccoli scarti di potatura (diametro inferiore a 5 cm), tappi di sughero, lettiere compostabili.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 37,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 18, left: 18),
                  child: Text(
                    'cosa no:',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Lettiere sintetiche, assorbenti e pannolini, oli esausti, rami di potatura (diametro superiore a 5 cm), mozziconi di sigari e sigararette, polvere e sacchetti aspirapolvere, gomme da masticare.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    ),
  );
}

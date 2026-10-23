"""Build the curated, Spanish-first V0.1 question bank."""

import json
import random
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "assets" / "questions.json"
RNG = random.Random(20261022)

# Each row is (display name, release/first-use year, Spanish noun, verb).
# Two complementary question forms are generated for each fact: recall the
# year from the item, and identify the item from its year.
FACTS = {
    "television": {
        1980: [
            ("Verano azul", 1981, "serie", "se estrenó"),
            ("Los gozos y las sombras", 1982, "serie", "se estrenó"),
            ("Cheers", 1982, "serie", "se estrenó"),
            ("El coche fantástico", 1982, "serie", "se estrenó"),
            ("El equipo A", 1983, "serie", "se estrenó"),
            ("He-Man y los Masters del Universo", 1983, "serie", "se estrenó"),
            ("Fraggle Rock", 1983, "serie", "se estrenó"),
            ("V", 1983, "serie", "se estrenó"),
            ("La bola de cristal", 1984, "programa", "se estrenó"),
            ("Miami Vice", 1984, "serie", "se estrenó"),
            ("Las chicas de oro", 1985, "serie", "se estrenó"),
            ("MacGyver", 1985, "serie", "se estrenó"),
            ("ALF", 1986, "serie", "se estrenó"),
            ("Dragon Ball", 1986, "serie", "se estrenó"),
            ("Turno de oficio", 1986, "serie", "se estrenó"),
            ("Padres forzosos", 1987, "serie", "se estrenó"),
            ("Star Trek: La nueva generación", 1987, "serie", "se estrenó"),
            ("Patoaventuras", 1987, "serie", "se estrenó"),
            ("Aquellos maravillosos años", 1988, "serie", "se estrenó"),
            ("Los Simpson", 1989, "serie", "se estrenó"),
            ("Baywatch", 1989, "serie", "se estrenó"),
        ],
        1990: [
            ("Twin Peaks", 1990, "serie", "se estrenó"),
            ("El príncipe de Bel-Air", 1990, "serie", "se estrenó"),
            ("Mr. Bean", 1990, "serie", "se estrenó"),
            ("Sensación de vivir", 1990, "serie", "se estrenó"),
            ("Ley y orden", 1990, "serie", "se estrenó"),
            ("Farmacia de guardia", 1991, "serie", "se estrenó"),
            ("Rugrats", 1991, "serie", "se estrenó"),
            ("Expediente X", 1993, "serie", "se estrenó"),
            ("Frasier", 1993, "serie", "se estrenó"),
            ("Power Rangers", 1993, "serie", "se estrenó"),
            ("Friends", 1994, "serie", "se estrenó"),
            ("Urgencias", 1994, "serie", "se estrenó"),
            ("Médico de familia", 1995, "serie", "se estrenó"),
            ("Sabrina, cosas de brujas", 1996, "serie", "se estrenó"),
            ("Buffy, cazavampiros", 1997, "serie", "se estrenó"),
            ("South Park", 1997, "serie", "se estrenó"),
            ("Compañeros", 1998, "serie", "se estrenó"),
            ("Periodistas", 1998, "serie", "se estrenó"),
            ("Sexo en Nueva York", 1998, "serie", "se estrenó"),
            ("Los Soprano", 1999, "serie", "se estrenó"),
            ("Plats bruts", 1999, "serie", "se estrenó"),
        ],
        2000: [
            ("CSI: Las Vegas", 2000, "serie", "se estrenó"),
            ("Las chicas Gilmore", 2000, "serie", "se estrenó"),
            ("Malcolm", 2000, "serie", "se estrenó"),
            ("Cuéntame cómo pasó", 2001, "serie", "se estrenó"),
            ("Smallville", 2001, "serie", "se estrenó"),
            ("Scrubs", 2001, "serie", "se estrenó"),
            ("24", 2001, "serie", "se estrenó"),
            ("Ana y los 7", 2002, "serie", "se estrenó"),
            ("The Wire", 2002, "serie", "se estrenó"),
            ("Aquí no hay quien viva", 2003, "serie", "se estrenó"),
            ("Los Serrano", 2003, "serie", "se estrenó"),
            ("Perdidos", 2004, "serie", "se estrenó"),
            ("House", 2004, "serie", "se estrenó"),
            ("Mujeres desesperadas", 2004, "serie", "se estrenó"),
            ("Aída", 2005, "serie", "se estrenó"),
            ("Camera Café", 2005, "serie", "se estrenó"),
            ("Física o Química", 2008, "serie", "se estrenó"),
            ("El internado", 2007, "serie", "se estrenó"),
            ("La que se avecina", 2007, "serie", "se estrenó"),
            ("The Big Bang Theory", 2007, "serie", "se estrenó"),
            ("Águila Roja", 2009, "serie", "se estrenó"),
        ],
    },
    "music": {
        1980: [
            ("La chica de ayer", 1980, "canción", "se publicó"),
            ("Enamorado de la moda juvenil", 1980, "canción", "se publicó"),
            ("Hoy no me puedo levantar", 1981, "canción", "se publicó"),
            ("Me colé en una fiesta", 1982, "canción", "se publicó"),
            ("No controles", 1983, "canción", "se publicó"),
            ("Barco a Venus", 1983, "canción", "se publicó"),
            ("Escuela de calor", 1984, "canción", "se publicó"),
            ("Lobo hombre en París", 1984, "canción", "se publicó"),
            ("Ni tú ni nadie", 1984, "canción", "se publicó"),
            ("Devuélveme a mi chica", 1985, "canción", "se publicó"),
            ("Sufre mamón", 1985, "canción", "se publicó"),
            ("Hijo de la luna", 1986, "canción", "se publicó"),
            ("A quién le importa", 1986, "canción", "se publicó"),
            ("Cruz de navajas", 1986, "canción", "se publicó"),
            ("La puerta de Alcalá", 1986, "canción", "se publicó"),
            ("Bailando", 1987, "canción", "se publicó"),
        ],
        1990: [
            ("Ven, devórame otra vez", 1990, "canción", "se publicó"),
            ("Veneno en la piel", 1990, "canción", "se publicó"),
            ("Losing My Religion", 1991, "canción", "se publicó"),
            ("Smells Like Teen Spirit", 1991, "canción", "se publicó"),
            ("All My Loving (versión de Los Manolos)", 1991, "canción", "se publicó"),
            ("Tractor amarillo", 1992, "canción", "se publicó"),
            ("Macarena", 1993, "canción", "se publicó"),
            ("Chup Chup", 1993, "canción", "se publicó"),
            ("El canario", 1994, "canción", "se publicó"),
            ("Wonderwall", 1995, "canción", "se publicó"),
            ("El tiburón", 1995, "canción", "se publicó"),
            ("Wannabe", 1996, "canción", "se publicó"),
            ("María", 1996, "canción", "se publicó"),
            ("La flaca", 1997, "canción", "se publicó"),
            ("Believe", 1998, "canción", "se publicó"),
            ("La copa de la vida", 1998, "canción", "se publicó"),
            ("Libre", 1999, "canción", "se publicó"),
        ],
        2000: [
            ("Color esperanza", 2001, "canción", "se publicó"),
            ("Ave María", 2002, "canción", "se publicó"),
            ("Aserejé", 2002, "canción", "se publicó"),
            ("A Dios le pido", 2002, "canción", "se publicó"),
            ("Obsesión", 2002, "canción", "se publicó"),
            ("Rosas", 2003, "canción", "se publicó"),
            ("Puedes contar conmigo", 2003, "canción", "se publicó"),
            ("20 de enero", 2003, "canción", "se publicó"),
            ("Crazy in Love", 2003, "canción", "se publicó"),
            ("Dragostea din tei", 2003, "canción", "se publicó"),
            ("Bulería", 2004, "canción", "se publicó"),
            ("Antes muerta que sencilla", 2004, "canción", "se publicó"),
            ("La tortura", 2005, "canción", "se publicó"),
            ("La camisa negra", 2005, "canción", "se publicó"),
            ("Hips Don't Lie", 2006, "canción", "se publicó"),
            ("Me voy", 2006, "canción", "se publicó"),
            ("Colgando en tus manos", 2008, "canción", "se publicó"),
        ],
    },
    "cinema": {
        1980: [
            ("El crack", 1981, "película", "se estrenó"),
            ("Función de noche", 1981, "película", "se estrenó"),
            ("Volver a empezar", 1982, "película", "se estrenó"),
            ("Demonios en el jardín", 1982, "película", "se estrenó"),
            ("El sur", 1983, "película", "se estrenó"),
            ("Los santos inocentes", 1984, "película", "se estrenó"),
            ("Tasio", 1984, "película", "se estrenó"),
            ("¿Qué he hecho yo para merecer esto?", 1984, "película", "se estrenó"),
            ("Las bicicletas son para el verano", 1984, "película", "se estrenó"),
            ("Padre nuestro", 1985, "película", "se estrenó"),
            ("Réquiem por un campesino español", 1985, "película", "se estrenó"),
            ("El viaje a ninguna parte", 1986, "película", "se estrenó"),
            ("La ley del deseo", 1987, "película", "se estrenó"),
            ("Mujeres al borde de un ataque de nervios", 1988, "película", "se estrenó"),
            ("Amanece, que no es poco", 1989, "película", "se estrenó"),
            ("Esquilache", 1989, "película", "se estrenó"),
        ],
        1990: [
            ("¡Ay, Carmela!", 1990, "película", "se estrenó"),
            ("Amantes", 1991, "película", "se estrenó"),
            ("Belle Époque", 1992, "película", "se estrenó"),
            ("Jamón, jamón", 1992, "película", "se estrenó"),
            ("Vacas", 1992, "película", "se estrenó"),
            ("Tacones lejanos", 1991, "película", "se estrenó"),
            ("Días contados", 1994, "película", "se estrenó"),
            ("Nadie hablará de nosotras cuando hayamos muerto", 1995, "película", "se estrenó"),
            ("Hola, ¿estás sola?", 1995, "película", "se estrenó"),
            ("El día de la bestia", 1995, "película", "se estrenó"),
            ("Familia", 1996, "película", "se estrenó"),
            ("Tesis", 1996, "película", "se estrenó"),
            ("Secretos del corazón", 1997, "película", "se estrenó"),
            ("La niña de tus ojos", 1998, "película", "se estrenó"),
            ("Abre los ojos", 1997, "película", "se estrenó"),
            ("La lengua de las mariposas", 1999, "película", "se estrenó"),
            ("Todo sobre mi madre", 1999, "película", "se estrenó"),
        ],
        2000: [
            ("Gladiator", 2000, "película", "se estrenó"),
            ("La comunidad", 2000, "película", "se estrenó"),
            ("Los otros", 2001, "película", "se estrenó"),
            ("El señor de los anillos: La comunidad del anillo", 2001, "película", "se estrenó"),
            ("Harry Potter y la piedra filosofal", 2001, "película", "se estrenó"),
            ("Shrek", 2001, "película", "se estrenó"),
            ("Hable con ella", 2002, "película", "se estrenó"),
            ("Los lunes al sol", 2002, "película", "se estrenó"),
            ("El señor de los anillos: Las dos torres", 2002, "película", "se estrenó"),
            ("Te doy mis ojos", 2003, "película", "se estrenó"),
            ("El señor de los anillos: El retorno del rey", 2003, "película", "se estrenó"),
            ("Mar adentro", 2004, "película", "se estrenó"),
            ("Volver", 2006, "película", "se estrenó"),
            ("El laberinto del fauno", 2006, "película", "se estrenó"),
            ("Vicky Cristina Barcelona", 2008, "película", "se estrenó"),
            ("Celda 211", 2009, "película", "se estrenó"),
            ("Up", 2009, "película", "se estrenó"),
        ],
    },
    "video_games_technology": {
        1980: [
            ("Pac-Man", 1980, "videojuego", "se lanzó"),
            ("Donkey Kong", 1981, "videojuego", "se lanzó"),
            ("IBM PC", 1981, "ordenador", "se lanzó"),
            ("Mario Bros.", 1983, "videojuego", "se lanzó"),
            ("Famicom", 1983, "consola", "se lanzó"),
            ("Apple Macintosh", 1984, "ordenador", "se lanzó"),
            ("Tetris", 1984, "videojuego", "se lanzó"),
            ("Super Mario Bros.", 1985, "videojuego", "se lanzó"),
            ("Windows 1.0", 1985, "sistema operativo", "se lanzó"),
            ("The Legend of Zelda", 1986, "videojuego", "se lanzó"),
            ("Street Fighter", 1987, "videojuego", "se lanzó"),
            ("Game Boy", 1989, "consola", "se lanzó"),
        ],
        1990: [
            ("Doom", 1993, "videojuego", "se lanzó"),
            ("Myst", 1993, "videojuego", "se lanzó"),
            ("Sony PlayStation en Japón", 1994, "consola", "se lanzó"),
            ("Windows 95", 1995, "sistema operativo", "se lanzó"),
            ("Pokémon Rojo y Verde en Japón", 1996, "videojuego", "se lanzó"),
            ("Tamagotchi", 1996, "juguete electrónico", "se lanzó"),
            ("Nintendo 64", 1996, "consola", "se lanzó"),
            ("Age of Empires", 1997, "videojuego", "se lanzó"),
            ("Google", 1998, "buscador", "se lanzó"),
            ("StarCraft", 1998, "videojuego", "se lanzó"),
            ("Half-Life", 1998, "videojuego", "se lanzó"),
            ("Sega Dreamcast en Japón", 1998, "consola", "se lanzó"),
        ],
        2000: [
            ("PlayStation 2", 2000, "consola", "se lanzó"),
            ("Los Sims", 2000, "videojuego", "se lanzó"),
            ("Xbox", 2001, "consola", "se lanzó"),
            ("Game Boy Advance", 2001, "consola", "se lanzó"),
            ("iPod", 2001, "reproductor digital", "se lanzó"),
            ("Wikipedia", 2001, "enciclopedia en línea", "se lanzó"),
            ("Xbox Live", 2002, "servicio de juego en línea", "se lanzó"),
            ("Steam", 2003, "plataforma de videojuegos", "se lanzó"),
            ("Skype", 2003, "servicio de comunicación", "se lanzó"),
            ("Nintendo DS", 2004, "consola portátil", "se lanzó"),
            ("Facebook", 2004, "red social", "se lanzó"),
            ("YouTube", 2005, "plataforma de vídeo", "se lanzó"),
            ("iPhone", 2007, "teléfono móvil", "se lanzó"),
            ("Nintendo Wii", 2006, "consola", "se lanzó"),
        ],
    },
    "everyday_culture": {
        1980: [
            ("el cubo de Rubik llegó a las tiendas de Estados Unidos", 1980, "juguete", "se popularizó"),
            ("la cadena CNN inició sus emisiones", 1980, "canal de televisión", "comenzó a emitir"),
            ("la cadena MTV inició sus emisiones", 1981, "canal musical", "comenzó a emitir"),
            ("el disco compacto salió al mercado", 1982, "formato musical", "se lanzó"),
            ("el programa La bola de cristal llegó a TVE", 1984, "programa", "se estrenó"),
            ("la muñeca Cabbage Patch Kids causó furor", 1983, "juguete", "se popularizó"),
            ("la marca Swatch presentó sus primeros relojes", 1983, "producto", "se lanzó"),
            ("Live Aid reunió conciertos simultáneos", 1985, "concierto benéfico", "se celebró"),
            ("Coca-Cola presentó New Coke", 1985, "producto", "se lanzó"),
            ("la explosión de Chernóbil conmocionó Europa", 1986, "acontecimiento", "ocurrió"),
            ("España ingresó en las Comunidades Europeas", 1986, "acontecimiento", "ocurrió"),
            ("las obras de acondicionamiento de la Expo 92 en Sevilla comenzaron", 1987, "obras", "comenzaron"),
            ("el gusano Morris se propagó por Internet", 1988, "incidente tecnológico", "ocurrió"),
            ("la caída del Muro de Berlín fue retransmitida en directo", 1989, "acontecimiento", "ocurrió"),
            ("Torrespaña se inauguró en Madrid", 1982, "edificio", "se inauguró"),
            ("el teletexto de TVE llegó a los televisores españoles", 1988, "servicio", "se estrenó"),
            ("el programa El precio justo llegó a TVE", 1988, "concurso", "se estrenó"),
        ],
        1990: [
            ("se envió el primer mensaje SMS", 1992, "hito tecnológico", "ocurrió"),
            ("se celebraron los Juegos Olímpicos de Barcelona", 1992, "acontecimiento", "se celebró"),
            ("la Expo 92 abrió sus puertas en Sevilla", 1992, "acontecimiento", "se celebró"),
            ("Amazon abrió su tienda en línea", 1994, "servicio", "se lanzó"),
            ("eBay comenzó a funcionar", 1995, "servicio", "se lanzó"),
            ("los Beanie Babies aparecieron en las tiendas", 1993, "juguete", "se lanzó"),
            ("el Tamagotchi salió a la venta en Japón", 1996, "juguete electrónico", "se lanzó"),
            ("Netflix comenzó como servicio de alquiler por correo", 1997, "servicio", "se lanzó"),
            ("Google fue fundado como empresa", 1998, "empresa", "se fundó"),
            ("el juguete Furby llegó al mercado", 1998, "juguete", "se lanzó"),
            ("el euro nació como moneda contable", 1999, "moneda", "se introdujo"),
            ("Madrid fue Capital Europea de la Cultura", 1992, "acontecimiento cultural", "se celebró"),
            ("se inauguró el Museo Guggenheim Bilbao", 1997, "museo", "se inauguró"),
            ("Antena 3 comenzó sus emisiones en España", 1990, "canal de televisión", "comenzó a emitir"),
            ("el AVE inició el servicio entre Madrid y Sevilla", 1992, "servicio ferroviario", "se inauguró"),
            ("el Teatro Real reabrió tras su reforma", 1997, "teatro", "se reabrió"),
        ],
        2000: [
            ("los billetes y monedas de euro entraron en circulación", 2002, "moneda", "se introdujo"),
            ("el canal MTV España inició sus emisiones", 2000, "canal musical", "comenzó a emitir"),
            ("el Festival de Eurovisión de 2002 se celebró en Tallin", 2002, "acontecimiento", "se celebró"),
            ("España legalizó el matrimonio entre personas del mismo sexo", 2005, "cambio legislativo", "se aprobó"),
            ("España ganó el Mundial de baloncesto en Japón", 2006, "acontecimiento deportivo", "se celebró"),
            ("España ganó la Eurocopa de fútbol", 2008, "acontecimiento deportivo", "se celebró"),
            ("se inauguró la T4 del aeropuerto de Madrid-Barajas", 2006, "infraestructura", "se inauguró"),
            ("el AVE llegó a Barcelona desde Madrid", 2008, "infraestructura", "se inauguró"),
            ("el Museo del Prado abrió la ampliación de Rafael Moneo", 2007, "museo", "se inauguró"),
            ("España aprobó la Ley de Dependencia", 2006, "cambio legislativo", "se aprobó"),
            ("se inauguró la ampliación del Museo Reina Sofía", 2005, "museo", "se inauguró"),
            ("la ciudad de Valencia acogió la Copa América", 2007, "acontecimiento deportivo", "se celebró"),
            ("España celebró el Año de la Ciencia", 2007, "acontecimiento", "se celebró"),
            ("se inauguró el aeropuerto de Ciudad Real", 2008, "infraestructura", "se inauguró"),
            ("España conmemoró el 30.º aniversario de la Constitución de 1978", 2008, "acontecimiento", "se celebró"),
            ("se inauguró el circuito urbano de Fórmula 1 de Valencia", 2008, "infraestructura deportiva", "se inauguró"),
            ("Barcelona celebró el Año Internacional de la Astronomía", 2009, "acontecimiento", "se celebró"),
        ],
    },
}

# Leave one TV fact and one games/technology fact in one-question form so the
# requested category totals are odd (125 and 75) while all other facts are
# asked in both complementary forms.
SINGLE_QUESTIONS = {
    ("television", 2000, "Águila Roja"),
    ("video_games_technology", 2000, "Nintendo Wii"),
}

CATEGORY_LABELS = {
    "television": "serie",
    "music": "canción",
    "cinema": "película",
    "video_games_technology": "producto o videojuego",
    "everyday_culture": "referente cultural",
}


def localized(text):
    return {"es-ES": text}


def main():
    questions = []
    category_counts = Counter()
    decade_counts = Counter()
    decade_category_counts = Counter()
    serials = Counter()
    for category, decades in FACTS.items():
        for decade, facts in decades.items():
            decade_facts = [fact for fact in facts if (category, decade, fact[0]) not in SINGLE_QUESTIONS]
            for fact in facts:
                name, year, noun, verb = fact
                forms = 1 if (category, decade, name) in SINGLE_QUESTIONS else 2
                for form in range(forms):
                    serials[(category, decade)] += 1
                    qid = f"{category}-{decade}-{serials[(category, decade)]:04d}"
                    correct = str(year) if form == 0 else name
                    if form == 0:
                        prompt = (
                            f"¿En qué año ocurrió este hecho: {name}?"
                            if category == "everyday_culture"
                            else f"¿En qué año {verb} «{name}»?"
                        )
                        distractors = [str(candidate) for candidate in range(decade, decade + 10) if candidate != year]
                        choice_texts = RNG.sample(distractors, 3) + [str(year)]
                    else:
                        prompt = f"¿Qué {noun} {verb} en {year}?"
                        distractor_facts = [candidate for candidate in decade_facts if candidate[1] != year and candidate[0] != name]
                        wrong = RNG.sample(distractor_facts, 3)
                        choice_texts = [candidate[0] for candidate in wrong] + [name]
                    RNG.shuffle(choice_texts)
                    answers = []
                    for i, text in enumerate(choice_texts):
                        is_correct = text == correct
                        answers.append({"id": f"answer-{i + 1}", "text": localized(text), "isCorrect": is_correct})
                    explanation_text = (
                        f"En {year}, {name}."
                        if category == "everyday_culture"
                        else f"{noun.capitalize()} «{name}» {verb} en {year}."
                    )
                    explanation = localized(explanation_text)
                    questions.append({
                        "id": qid,
                        "categoryId": category,
                        "decade": decade,
                        "prompt": localized(prompt),
                        "answers": answers,
                        "explanation": explanation,
                    })
                    category_counts[category] += 1
                    decade_counts[decade] += 1
                    decade_category_counts[(category, decade)] += 1

    expected_categories = {
        "television": 125,
        "music": 100,
        "cinema": 100,
        "video_games_technology": 75,
        "everyday_culture": 100,
    }
    if category_counts != Counter(expected_categories):
        raise SystemExit(f"Unexpected category counts: {category_counts}")
    if len(questions) != 500 or len({q["id"] for q in questions}) != 500:
        raise SystemExit("Expected exactly 500 unique question IDs.")
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps({"schemaVersion": 1, "questions": questions}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Created {len(questions)} questions; decades: {dict(sorted(decade_counts.items()))}")
    for category in sorted(expected_categories):
        print(category, {decade: decade_category_counts[(category, decade)] for decade in (1980, 1990, 2000)})


if __name__ == "__main__":
    main()

#import "@preview/unify:0.5.0": *
#import "@preview/codly:0.2.0": *
#import "@preview/tablex:0.0.8": *
#import "@preview/physica:0.9.3": *
#import "@preview/indenta:0.0.3": fix-indent
#import "@preview/great-theorems:0.1.1": *
#import "@preview/rich-counters:0.2.2": *
#import "./glossarium.typ": *

#let to-str(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to-str).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

// Счетчики
#let part_count = counter("parts")
#let total_part = context[#part_count.final().at(0)]
#let appendix_count = counter("appendix")
#let total_appendix = context[#appendix_count.final().at(0)]
#let total_page = context[#counter(page).final().at(0)]
#let total_fig = context[#counter(figure).final().at(0)]
#let total_table = context[#counter(figure.where(kind:table)).final().at(0)]
#let total_bib = context(
  query(selector(ref)).filter(it => it.element == none).map(it => it.target).dedup().len()
)

// Это входная точка - общий шаблон
#let template(
  author-first-name: "Имя Отчество",
  author-last-name: "Фамилия",
  author-group: "И.О.",
  title: "Длинное-длинное название диссертации из достаточно большого количества сложных и непонятных слов",
  city: "Город",
  year: datetime.today().year(),

  organization: [МИНИСТЕРСТВО НАУКИ И ВЫСШЕГО ОБРАЗОВАНИЯ РОССИЙСКОЙ ФЕДЕРАЦИИ],
  in-organization: [Федеральное государственное автономное образовательное учреждение высшего образования "Длинное название образовательного учреждения "АББРЕВИАТУРА"],
  faculty: "Название института или факультета",
  department: "Название кафедры",

  specialty-number: "XX.XX.XX",
  specialty-title: "Название направления подготовки",
  specialty-profile: "Название профиля подготовки",

  supervisor-first-name: "Имя Отчество",
  supervisor-last-name: "Фамилия",
  supervisor-regalia: "уч. степень, уч. звание",

  font-type: "Times New Roman",
  font-size: 12pt,
  link-color: blue.darken(60%),
  languages: (:), 
  logo: "",
  body,
) = {

  // Определение новых переменных
  let author-name = to-str[#author-last-name #author-first-name]
  let supervisor-name = to-str[#supervisor-last-name #supervisor-first-name]

  // Установка свойств к PDF файлу
  set document(author: author-name, title: title)

  // Установки шрифта
  set text(
    font: font-type,
    lang: "ru",
    size: font-size,
    fallback: true,
    hyphenate: false,
  )
  
  // Установка свойств страницы
  set page(
    // размер полей (ГОСТ 7.0.11-2011, 5.3.7)
    // ННГУ: Правый отступ 15мм
    margin: (top:2cm, bottom:2cm, left:2.5cm, right:1.5cm),
  )

  // Установка свойств параграфа
  set par(
    justify: true, 
    linebreaks: "optimized",
    // Абзацный отступ. Одинаков по всему тексту и равен пяти знакам (ГОСТ Р 7.0.11-2011, 5.3.7).
    first-line-indent: 2.5em,
    // Полуторный интервал (ГОСТ 7.0.11-2011, 5.3.6)
    leading: 1em,
  ) 
    
  // форматирование заголовков
  set heading(numbering: "1.", outlined: true, supplement: [Раздел])
  show heading: it => {
    set align(center)
    set text(font: font-type, size: font-size)
    // Заголовки отделяют от текста сверху и снизу тремя интервалами (ГОСТ Р 7.0.11-2011, 5.3.5)
    
    set block(above: 3em, below: 3em)
    if it.level == 1 {
      pagebreak() // новая страница для разделов 1 уровня
      counter(figure).update(0) // сброс значения счетчика рисунков
      counter(math.equation).update(0) // сброс значения счетчика уравнений
    }
    it
  }

  // Отображение ссылок на figure (рисунки и таблицы) - ничего не отображать
  set ref(supplement: it => {
    if it.func() == figure {}
  })

  // Настройка блоков кода 
  show: codly-init.with()
  codly(languages: languages)
  
  // Инициализация глоссария 
  show: make-glossary
  show link: set text(fill: link-color)

  // Нумерация уравнений 
  let eq_number(it) = {
    let part_number = counter(heading.where(level:1)).get()
    part_number
    it
  }
  set math.equation(
    numbering: num => (
      "(" + (counter(heading.where(level:1)).get() + (num,)).map(str).join(".") + ")"
    ),
    supplement: [Уравнение],
  )
  
  // Настройка рисунков 
  show figure: align.with(center)
  set figure(supplement: [Рисунок])
  set figure.caption(separator: [ -- ])
  set figure(numbering: num => (
    (counter(heading.where(level:1)).get() + (num,)).map(str).join(".")
  ))

  // Настройка таблиц
  show figure.where(kind:table): set figure.caption(position: top)
  show figure.where(kind:table): set figure(supplement: [Таблица])
  show figure.where(kind:table): set figure(numbering: num => (
    (counter(heading.where(level:1)).get() + (num,)).map(str).join(".")
  ))
  // Разбивать таблицы по страницам 
  show figure: set block(breakable: true)

  // Настройка списков 
  set enum(indent: 2.5em)

  state("section").update("body")

  // титульный лист 
  set align(center)
  organization
  v(0em)
  in-organization

  v(2em)
  [*#faculty*]

  v(0.5em)
  [*Кафедра: #department*]

  v(1em)
  [Направление подготовки: #specialty-number -- «#specialty-title»]
  v(0em)
  [Профиль подготовки: «#specialty-profile»]

  v(3em)
  set text(size:font-size + 4pt)
  [*КУРСОВАЯ РАБОТА*]
  v(1em)
  set text(size:font-size + 2pt)
  [Тема: \ *«#title»*]
  set text(size:font-size)

  v(4fr)
  set align(right)
  table(
    columns: (19em),
    stroke: none,
    inset: 1pt,
    align: left,

    [Выполнил:],

    v(0.2em),
    [студент группы #author-group],

    v(0.2em),
    [#author-name],
    v(0em),
    line(length: 100%, stroke: 0.5pt),
    text(size: 10pt)[#align(center)[ф.и.о.]],

    v(1em + 0.2em),
    line(length: 100%, stroke: 0.5pt),
    text(size: 10pt)[#align(center)[подпись]],
  )
  table(
    columns: (19em),
    stroke: none,
    inset: 1pt,
    align: left,

    [Научный руководитель:],

    v(0.2em),
    [#supervisor-regalia, #supervisor-name],
    v(0em),
    line(length: 100%, stroke: 0.5pt),
    text(size: 10pt)[#align(center)[учёная степень, учёное звание, ф.и.о.]],

    v(1em + 0.2em),
    line(length: 100%, stroke: 0.5pt),
    text(size: 10pt)[#align(center)[подпись]],
  )

  v(4em)
  set align(center)
  [#city \ #year]
  set align(left)
  // конец титульной страницы

  set page(
    numbering: "1", // Установка сквозной нумерации страниц 
    number-align: center + bottom, 
  )
  counter(page).update(1)
  
  // Содержание 
  outline(title: "Содержание", indent: 1.5em, depth: 3)

  body
}

// Нужно начать первый абзац в разделе с этой функции для отступа первой строки 
#let indent-par(it) = par[#h(2.5em)#it]

#let mathcounter = rich-counter(
  identifier: "mathblocks",
  inherited_levels: 1
)
#let theorem = mathblock(
  blocktitle: "Теорема",
  counter: mathcounter,

  titlix: t => emph[(#t):],
  inset: 7pt,
  radius: 5pt,
  stroke: rgb(200, 200, 200),
)
#let lemma = mathblock(
  blocktitle: "Лемма",
  counter: mathcounter,
  
  titlix: t => emph[(#t):],
  inset: 7pt,
  radius: 5pt,
  stroke: rgb(200, 200, 200),
)
#let statement = mathblock(
  blocktitle: "Утверждение",
  counter: mathcounter,

  titlix: t => emph[(#t):],
  inset: 7pt,
  radius: 5pt,
  stroke: rgb(200, 200, 200),
)
#let corollary = mathblock(
  blocktitle: "Следствие",

  titlix: t => emph[(#t):],
  inset: 7pt,
  radius: 5pt,
  stroke: rgb(200, 200, 200),
)
#let remark = mathblock(
  blocktitle: "Замечание",
)
#let definition = mathblock(
  blocktitle: "Определение",
)
#let proof = proofblock(
  prefix: [_Доказательство._]
)
#let proofsketch = proofblock(
  prefix: [_Схема доказательства._]
)

#let hl-r(x) = text(fill: red, $#x$)
#let hl-g(x) = text(fill: rgb("#298E89"), $#x$)
#let half = h(0.5em)
#let eq-nonum = math.equation.with(
  block: true,
  numbering: none,
)

// Set up the styling of the appendix.
#let phd-appendix(body) = {
  // Reset the title numbering.
  counter(heading).update(0)

  // Number headings using letters.
  show heading.where(level: 1): set heading(numbering: "Приложение A. ", supplement: [Приложение])
  show heading.where(level: 2): set heading(numbering: "A.1 ", supplement: [Приложение])

  // Set the numbering of the figures.
  set figure(numbering: (x) => context {
    let idx = numbering("A", counter(heading).get().first())
    [#idx.#numbering("1", x)]
  })

  // Additional heading styling to update sub-counters.
  show heading: it => {
    appendix_count.step() // Обновление счетчика приложений
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: math.equation)).update(0)
    counter(figure.where(kind: raw)).update(0)

    it
  }

  // Set that we're in the annex
  state("section").update("annex")

  body
}

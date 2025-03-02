#import "lib.typ": *

#show: template.with(
  organization: "МИНИСТЕРСТВО НАУКИ И ВЫСШЕГО ОБРАЗОВАНИЯ РОССИЙСКОЙ ФЕДЕРАЦИИ",
  in-organization: [Федеральное государственное автономное образовательное учреждение \ высшего образования \ *"Национальный исследовательский \ Нижегородский государственный университет им. Н.И. Лобачевского" \ (ННГУ)*],
  faculty: "Институт информационных технологий, математики и механики",
  department: "Алгебры, геометрии и дискретной математики",
  specialty-number: "01.03.01",
  specialty-title: "Математика",
  specialty-profile: "Общий профиль",

  title: "Нейронные сети Колмогорова-Арнольда",

  author-group: "3822Б1МА1",
  author-last-name: "Никитин",
  author-first-name: "И. И.",
  supervisor-regalia: "д.ф.-м.н., доцент",
  supervisor-last-name: "Золотых",
  supervisor-first-name: "Н. Ю.",
  
  city: "Нижний Новгород",
  year: "2024",
)

// Основные части документа 
#include "./parts/intro.typ"

#show heading.where(level: 1): set heading(numbering: "Глава 1.")
#show: great-theorems-init

#include "./parts/part1.typ"

#include "./parts/part2.typ"

#include "./parts/part3.typ"

// Выключить нумерацию выходных данных
#show heading: set heading(numbering: none)

// Заключение 
#include "./parts/conclusion.typ"

// Выходные данные
// = Список сокращений и условных обозначений 
// #import "./common/acronyms.typ": acronyms-entries
// #import "./common/symbols.typ": symbols-entries
// #print-glossary(acronyms-entries + symbols-entries)

= Словарь терминов 
#import "./common/glossary.typ": glossary-entries
#print-glossary(glossary-entries)

#bibliography(
  title: "Список литературы", ("./common/external.bib", "./common/author.bib"),
  style: "gost-r-705-2008-numeric"
)

// #show outline: set heading(outlined: true)

// #outline(title: "Список рисунков", target: figure.where(kind: image))

// #outline(title: "Список таблиц", target: figure.where(kind: table))

// Приложения 
// #include "./parts/appendix.typ"

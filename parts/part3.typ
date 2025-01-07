#import "../lib.typ": *

#part_count.step() // Обновление счетчика разделов 
= Вёрстка таблиц <ch3>

Вставить одиночное изображение можно следующим образом: 
// #figure(
//   image("../images/typst.png", width: 5%),
//   caption: [Typst]
// ) <fig:typst>

// И сослаться на него: @fig:typst

== Таблица обыкновенная <ch3:sect1>

Так можно вставить таблицу: 

#figure(
  table(
    columns: (auto,auto, auto),
    inset: 10pt,
    align: horizon,
    table.header(
      [*Фигура*],[*Площадь*],[*Параметр*],
    ),
    [Цилиндр],
    $pi h (D^2 - d^2) / 4$,
    [
      $h$: высота \
      $D$: внешний радиус \
      $d$: внутренний радиус \
    ],
    [Пирамида],
    $sqrt(2) / 12 a^3$,
    [$a$: длина ребра основания]
  ),
  caption: [Площади основания фигур]
) <t1>

На все таблицы в тексте диссертации необходимо приводить ссылки: @t1. Подробнее о таблицах здесь: https://typst.app/docs/reference/model/table/. 


== Проверка нумерации уравнений по разделам 
Уравнение в третьем разделе. 
$ z^2 = x^2 + y^2 $

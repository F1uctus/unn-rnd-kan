#import "../lib.typ": *

#part_count.step()

= Нейронные сети Колмогорова-Арнольда

== Структура нейронной сети

#indent-par[
  Мы рассмотрим конструкцию сети, предложенную в работе @Liu1.
]

#definition(title: "Слой", titlix: t => [_ #t _ --])[
  матрица $bold(Phi) = { phi.alt_(q,p) }$, где $ p=1,2,...,n#sub[out], quad q=1,2,n#sub[in]$,
  а функции $phi.alt$ имеют параметры, изменяемые в процессе обучения сети.
] <def1>

#definition(title: "Сигнатура сети", titlix: t => [_ #t _ --])[
  для сети из $L$ слоёв -- упорядоченный набор $(n_0, ..., n_L) subset NN$,
  где $n_i$ - число узлов в $i$-м слое сети.
]

#indent-par[
  Обозначим $i$-й узел в $l$-м слое сети как $(l,i)$, а его численное значение - $x_(l,i)$.
  Между слоями $l$ и $l+1$ находится $n_l*n_(l+1)$ функций $phi.alt$.
  Функцию, связывающую узел $(l,i)$ c узлом $(l+1,j)$ обозначим
  $ phi.alt_(l,j,i), quad l=0,...,L-1, quad i = 1,...,n_l, quad j = 1,...,n_(l+1). $
  Аргумент функции $phi.alt_(l,j,i)$ мы назовём "входным сигналом" $x_(l,i)$,
  а её значение -- "выходным сигналом".
  Затем определим выходной сигнал узла $(l+1,j)$:
  $x_(l+1,j) = sum_(i=1)^(n_l) phi.alt_(l,j,i)(x_(l,i)), quad j = 1,...,n_(l+1)$.
  В матричной записи выходной сигнал слоя сети будет иметь вид:
]

$ bold(x)_(l+1) = bold(Phi)_l bold(x)_l =
  mat(
  phi.alt_(l,1,1)(dot),       ..., phi.alt_(l,1,n_l)(dot);
  dots.v,                        , dots.v;
  phi.alt_(l,n_(l+1),2)(dot), ..., phi.alt_(l,n_(l+1),n_l)(dot)
  ) bold(x)_l. $

Полностью сеть, как и в случае с @mlp, описывается как композиция слоёв.
Для вектора входных данных $bold(x)_0 in RR^(n_0)$:
$ "kan"(bold(x_0)) = (bold(Phi)_(L-1)
            compose bold(Phi)_(L-2)
            compose ...
            compose bold(Phi)_0) bold(x_0), \
  "mlp"(bold(x_0)) = (upright(W)_(L-1)
            compose sigma
            compose upright(W)_(L-2)
            compose sigma
            compose ...
            compose upright(W)_0) bold(x_0). $

#indent-par[
  @th:kat показывает, что
  внутренние функции образуют слой, где $n_"in" = n$ и $n_"out" = 2n+1$,
  а внешние функции образуют слой, где $n_"in" = 2n+1$ и $n_"out" = 1$.
  Таким образом, справедливо следующее
]

#statement[
  Выражения Колмогорова-Арнольда в уравнении @eq:kar являются частным случаем сети из 2 слоёв.
]
#proof[
  Используя общую формулу:
  #eq-nonum[ $
  f(x_0, ..., x_(n_0)) =
  (y_0, ..., y_n_L), \
  y_i_L =
  sum_(i_(L-1)=1)^(n_(L-1)) phi.alt_(L-1,i_L,i_(L-1)) (
    sum_(i_(L-2)=1)^(n_(L-2)) phi.alt_(L-2,i_(L-1),i_(L-2)) (
    dots.h.c (
      sum_(i_0=1)^(n_0) phi.alt_(0,i_1,i_0)(x_i_0)
    ) dots.h.c
    )
  )
  $ ]
  для сигнатуры $(n_0,n_1,n_2) eq.triple (n,2n+1,1),
  half i_1 eq.triple q,
  half i_0 eq.triple p,
  half phi.alt_(1,1,q) eq.triple Phi_q,
  half phi.alt_(0,q,p) eq.triple phi.alt_(q,p)$:
  #eq-nonum[ $
  y_i_2 =
    sum_(i_1=1)^(n_1) phi.alt_(1,1,i_1) (
    sum_(i_0=1)^(n_0) phi.alt_(0,i_1,i_0) (
      x_i_0
    )
  ) => f(x_1, ..., x_n) = y_1 =
    sum_(q=1)^(2n+1) Phi_q (
    sum_(p=1)^(n) phi.alt_(0,q,p) (
      x_p
    )
  ).
  $ ]
]


== Оценка ограничений архитектуры

#indent-par[
  Целью этого раздела является проверка предложения, данного в работе @Liu1 о том,
  что предложенная структура нейронной сети позволяет избежать "проклятия размерности".
  В теории глубокого обучения этот термин может иметь следующее
]

#definition(title: [Проклятие размерности (@cod)], titlix: t => [_ #t _ --])[
  экспоненциальная зависимость количества параметров $P(n)$
  приближающей $f(x_1, ..., x_n)$ функции $accent(f, ~)$ от размерности многообразия,
  на котором задана функция $f$.
] <def:cod>

#theorem[
  Пусть $f in C(II^n)$ имеет представление вида
  $ f(bold(x)) eq.triple "kan"(bold(x)) = (Phi_(L-1) compose
                                           Phi_(L-2) compose
                                           thin dots.h.c thin compose
                                           Phi_0) bold(x), $
  причём $bold(Phi) in C^k (II)$.
  Тогда @kan, соответствующая этому представлению,
  имеет $P(n) = n^(2 + 2 "/" k) dot epsilon.alt^(-1 "/" k)$ параметров.
]

#proof[
  Разбиение $[a,b] subset RR$ осуществляется с помощью набора узлов
  $bold(tau) := (tau_i)_1^(n+k)$.
  Определим мелкость разбиения $abs(bold(tau))$ и размер сетки $G$:
  $ abs(bold(tau)) := max_i Delta tau_i, quad G := abs(bold(tau))^(-1). $

  Пусть $Phi_q^G, phi.alt_(q,p)^G$ -- приближения функций $Phi_q, phi.alt_(q,p)$ B-сплайнами.
  Тогда погрешность приближения функции $f$ сетью будет ограничена следующим образом:

  $ norm(f - "kan") <= sum_(q=1)^(2n+1) ( A_q (n,G) + B_q (G) ), \
    A_q (n,G) = abs( Phi_q ( sum_(p=1)^n phi.alt_(q,p) )
           - Phi_q ( sum_(p=1)^n phi.alt_(q,p)^G ) ), quad
    B_q (G) = abs( Phi_q - Phi_q^G ). $

  Предположим, что функции $Phi_q$ -- $L_q$-липшицевы, тогда:
  $ A_q (n,G) = L_q sum_(p=1)^n abs( phi.alt_(q,p) - phi.alt_(q,p)^G ). $

  Обозначим погрешности приближения и определим $L$:
  $ epsilon.alt_Phi = max_(q,G) abs( Phi_q - Phi_q^G ), quad
    epsilon.alt_phi.alt = max_(q,p,G) abs( phi.alt_(q,p) - phi.alt_(q,p)^G ), quad
    L = max_q L_q, $
  тогда
  $ norm(f - "kan") <= (2n+1) dot (epsilon.alt_Phi + L dot n dot epsilon.alt_phi.alt). $

  Таким образом,
  $ norm(f - "kan") <= epsilon.alt quad
  ==> quad epsilon.alt_Phi = O(epsilon.alt / n),
  quad epsilon.alt_phi.alt = O(epsilon.alt / n^2). $ <eq:f-kan-eps>

  Из теории приближений @DeBoor1 известно, что
  для функции $g in C^k (II)$ B-сплайнами порядка $k$
  выполняется следующее неравенство типа Джексона — Стечкина:
  $ norm(g - g^G) <= accent(C, hat)_k dot G^(-k) dot norm(D^k g)
           = C_k dot G^(-k), $
  где $G$-число функций в базисе сплайна.
  Отсюда получаем оценку для числа узлов $G$:
  $ epsilon.alt_g ~ C_k G^(-k) quad
  ==> quad G &~ root(k, C_k / epsilon.alt_g). $

  Из @eq:f-kan-eps получаем, что
  $ G_Phi ~ root(k, C_k / epsilon.alt_Phi), quad
    G_phi.alt ~ root(k, C_k / epsilon.alt_phi.alt) quad
  ==> quad G_Phi ~ root(k, (C_k n) / epsilon.alt),
    quad G_phi.alt ~ root(k, (C_k n^2) / epsilon.alt). $

  Оценим количество параметров в представлении:
  $ P(n) half &= half
         (2n+1)(G_Phi + n G_phi.alt)
         half ~ half
         (2n+1)( root(k, (C_k n) / epsilon.alt) + n root(k, (C_k n^2) / epsilon.alt) )
         half ~ \ &~ half
         ( n^(1 + 1 "/" k) + n^(2 + 2 "/" k) ) dot epsilon.alt^(-1 "/" k)
         half ~ half
         #box(
           $n^(2 + 2 "/" k) dot epsilon.alt^(-1 "/" k)$,
           outset: 5pt,
           stroke: 0.4pt + gray
         ). $
]

#indent-par[
  Из теории приближений в многомерных пространствах @Pin1 известно,
  что нижняя граница погрешности выразима в виде
]
$ epsilon.alt >= C dot P(n) ^ (-k "/" n). $

Таким образом, если при $n -> infinity$ фиксировать $epsilon.alt$,
мы получим полиномиальный рост количества параметров: $P(n) = n^(2 + 2 "/" k)$. Так действительно можно предотвратить @cod.
Однако, чтобы применение приближения было практически полезно,
необходимо, чтобы $epsilon.alt -> 0$ при $n -> infinity$, в силу
того, что для пространств большой размерности данные становятся
более разреженными.
Поэтому, положив, к примеру, $epsilon.alt = n^(-alpha)$ мы будем иметь:
$ P(n) = O(n^(2+1 "/" k + alpha "/" k)). $
Если взять $alpha = k ==> P(n) = O(n^3) $, и @cod не наблюдается.
Но это ограничение на $alpha$ возможно только для малого класса функций, предположительно, гладких (например такого, в котором @th:kat даёт представление с количеством слагаемых $S << n$).
Для функций общего вида обыкновенно необходимо, чтобы $alpha prop n$, и @cod сохраняется.


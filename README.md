
# MVP

* Assim como no MVVM, o MVP garante uma camada de apresentação cross-platform
* Variante do MVC (assim como o MVVM)
* Ao invés do Controller do MVC, temos o Presenter
* Assim como no MVC, o Presenter guarda uma referência para a View. Mas no MVP a referência para uma abstração (em forma de protocolo). Essa abstração pertence ao Presenter para garantir que não haja acoplamento entre Presenter e View.
* Ao contrário do MVC em que a View não conhece o Controller, no MVP a View tem uma referência concreta para o Presenter criando uma comunicação bidirecional. 
* Essa comunicacão bidirecional pode criar um "retain cycle" gerando memory leak - Solução usual é que no presenter a referencia para a view abstrata seja fraca. (ex: )
* Presenter conhece o Model e faz as transformações necessárias antes de enviar para a View por meio de uma estrutura de dados sem comportamento só com dados (chamada geralmente de ViewModel, ViewData, PresentableModel)
* Soluções para views UIKit (ex: UIRefreshControl) que não possuem referencia para um presenter: 

* 1) Subclass (ex: CustomRefreshControl herda de UIRefreshControl) 
* 2) Usar o ViewController como um supervisor. O ViewController implementa a abstração da view do Presenter e traduzir os eventos da UIView em eventos do Presenter. Nada muda nas camadas de Apresentação e Modelo. E a View fica mais fácil pois não temos que utilizar herança. 


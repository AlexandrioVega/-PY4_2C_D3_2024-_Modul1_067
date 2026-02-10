class CounterController {
  int _counter = 0; // Variabel private (Enkapsulasi)

  int get value => _counter; // Getter untuk akses data

  int _step = 10;


  void increment(){
    _counter += _step;
  } 

  void changeStep(int newStep){
    if(newStep > 0){
      _step = newStep;
    }
  }

  void decrement() { 
    if (_counter > 0){
      _counter -= _step;
    }
    if(_counter < 0 ){
      reset();
    }  
  }

  void reset(){
    _counter = 0;
  }
}

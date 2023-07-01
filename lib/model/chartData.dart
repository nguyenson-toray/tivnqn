class ChartData {
  String date;
  num qty1st;
  num qty1stOK;
  num qty1stNOK;
  num qtyAfterRepaire;
  num qtyOKAfterRepaire;
  num rationDefect1st;
  num rationDefectAfterRepaire;
  get getDate => this.date;

  set setDate(date) => this.date = date;

  get getQty1st => this.qty1st;

  set setQty1st(qty1st) => this.qty1st = qty1st;

  get getQty1stOK => this.qty1stOK;

  set setQty1stOK(qty1stOK) => this.qty1stOK = qty1stOK;

  get getQty1stNOK => this.qty1stNOK;

  set setQty1stNOK(qty1stNOK) => this.qty1stNOK = qty1stNOK;

  get getQtyAfterRepaire => this.qtyAfterRepaire;

  set setQtyAfterRepaire(qtyAfterRepaire) =>
      this.qtyAfterRepaire = qtyAfterRepaire;

  get getQtyOKAfterRepaire => this.qtyOKAfterRepaire;

  set setQtyOKAfterRepaire(qtyOKAfterRepaire) =>
      this.qtyOKAfterRepaire = qtyOKAfterRepaire;

  get getRationDefect1st => this.rationDefect1st;

  set setRationDefect1st(rationDefect1st) =>
      this.rationDefect1st = rationDefect1st;

  get getRationDefectAfterRepaire => this.rationDefectAfterRepaire;

  set setRationDefectAfterRepaire(rationDefectAfterRepaire) =>
      this.rationDefectAfterRepaire = rationDefectAfterRepaire;

  ChartData({
    required this.date,
    required this.qty1st,
    required this.qty1stOK,
    required this.qty1stNOK,
    required this.qtyAfterRepaire,
    required this.qtyOKAfterRepaire,
    required this.rationDefect1st,
    required this.rationDefectAfterRepaire,
  });

  @override
  String toString() {
    return 'ChartData(date: $date, qty1st: $qty1st, qty1stOK: $qty1stOK, qty1stNOK: $qty1stNOK, qtyAfterRepaire: $qtyAfterRepaire, qtyOKAfterRepaire: $qtyOKAfterRepaire, rationDefect1st: $rationDefect1st, rationDefectAfterRepaire: $rationDefectAfterRepaire)';
  }
}

~maj = [0,4,7];
~min = [0,3,7];
~dim = [0,3,6];

// Cmajor
~cMChords = [
  0+~maj, // CM, 0
  2+~min, // Dm, 1
  4+~min, // Em, 2
  5+~maj, // FM, 3
  7+~maj, // GM, 4
  9+~min, // Am, 5
  11+~dim // Bdim, 6
];

// Aminor
~amChords = [
  9+~min,  // Am
  11+~dim, // Bdim
  13+~maj, // CM
  14+~min, // Dm
  16+~min, // Em
  17+~maj, // FM
  19+~maj  // GM
];
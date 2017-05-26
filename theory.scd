(
~notes = ['c','cs','d','ds','e','f','fs','g','gs','a','as','b'];
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
~dMChords = Array.fill(~cMChords.size, { |i| ~cMChords[i]+2; });
~eMChords = Array.fill(~cMChords.size, { |i| ~cMChords[i]+4; });
~fMChords = Array.fill(~cMChords.size, { |i| ~cMChords[i]+5; });
~gMChords = Array.fill(~cMChords.size, { |i| ~cMChords[i]+7; });
~aMChords = Array.fill(~cMChords.size, { |i| ~cMChords[i]+9; });
~bMChords = Array.fill(~cMChords.size, { |i| ~cMChords[i]+11; });

// Cminor
~cmChords = [
  0+~min, // m
  2+~dim, // dim
  4+~maj, // M
  5+~min, // m
  7+~min, // m
  9+~maj, // M
  11+~maj // M
];
~dmChords = Array.fill(~cmChords.size, { |i| ~cmChords[i]+2; });
~emChords = Array.fill(~cmChords.size, { |i| ~cmChords[i]+4; });
~fmChords = Array.fill(~cmChords.size, { |i| ~cmChords[i]+5; });
~gmChords = Array.fill(~cmChords.size, { |i| ~cmChords[i]+7; });
~amChords = Array.fill(~cmChords.size, { |i| ~cmChords[i]+9; });
~bmChords = Array.fill(~cmChords.size, { |i| ~cmChords[i]+11; });
)
const admin = require('firebase-admin');
const fs = require('fs');
const csv = require('csv-parser');

// Initialize Firebase Admin (make sure you have firebase-admin installed)
const serviceAccount = require('./firebase/serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Read and upload CSV data
const shelters = [];

fs.createReadStream('./lib/admin_dashboard/tay_shelters_bay_area_with_coords.csv')
  .pipe(csv())
  .on('data', (row) => {
    // Skip empty rows
    if (!row.name || row.name.trim() === '') return;
    
    const lat = parseFloat(row.latitude);
    const lng = parseFloat(row.longitude);
    
    // Skip if no valid coordinates
    if (isNaN(lat) || isNaN(lng)) {
      console.log(`Skipping ${row.name} - no valid coordinates`);
      return;
    }
    
    shelters.push({
      name: row.name.trim(),
      phone: row.phone.trim(),
      address: row.address.trim(),
      location: new admin.firestore.GeoPoint(lat, lng),
      notes: row.notes ? row.notes.trim() : '',
      type: 'TAY', // Mark as TAY shelter
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });
  })
  .on('end', async () => {
    console.log(`Found ${shelters.length} TAY shelters to upload`);
    
    // Upload to Firestore
    const batch = db.batch();
    const sheltersCollection = db.collection('shelters');
    
    for (const shelter of shelters) {
      const docRef = sheltersCollection.doc();
      batch.set(docRef, shelter);
      console.log(`Adding: ${shelter.name}`);
    }
    
    try {
      await batch.commit();
      console.log('✅ Successfully uploaded all TAY shelters!');
      process.exit(0);
    } catch (error) {
      console.error('❌ Error uploading shelters:', error);
      process.exit(1);
    }
  });


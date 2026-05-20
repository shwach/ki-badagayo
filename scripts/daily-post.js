const admin = require('firebase-admin');
const posts  = require('../posts-schedule.json');

const ADMIN_UID = 'WS3FQ9JICAYPgibggl2bEgNG3Bv2';

admin.initializeApp({
  credential: admin.credential.cert(
    JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT)
  )
});

const db = admin.firestore();

// 오늘 날짜 기준으로 목록을 순환
const dayIndex = Math.floor(Date.now() / 86400000);
const content  = posts[dayIndex % posts.length];

async function run() {
  await db.collection('posts').add({
    authorId:    ADMIN_UID,
    content,
    kiPool:      9999,
    kiRemaining: 9999,
    isAdmin:     true,
    createdAt:   admin.firestore.FieldValue.serverTimestamp()
  });
  console.log('posted:', content);
}

run().catch(e => { console.error(e); process.exit(1); })
     .finally(() => process.exit(0));

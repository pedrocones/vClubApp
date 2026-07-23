import os
import firebase_admin
import google.auth.credentials
from firebase_admin import firestore

def initialize_db():
    os.environ["FIRESTORE_EMULATOR_HOST"] = "localhost:8080"
    os.environ["GCLOUD_PROJECT"] = "demo-vicinum-project"
    if not firebase_admin._apps:
        cred = google.auth.credentials.AnonymousCredentials()
        firebase_admin.initialize_app(cred, {'projectId': 'demo-vicinum-project'})
    return firestore.client()

def seed_members(db):
    print("\n🚀 SEEDING AMBASSADOR MEMBERS...")
    # These accounts act as the anchors for the Reward Tree (L0-L3)
    mock_members = [
        {"id": "UID_L0", "email": "vicinum_L0@gmail.com", "user": "admin_L0", "status": "Rookie"},
        {"id": "UID_L1", "email": "vicinum_L1@gmail.com", "user": "admin_L1", "status": "Ambassador"},
        {"id": "UID_L2", "email": "vicinum_L2@gmail.com", "user": "admin_L2", "status": "Associated"},
        {"id": "UID_L3", "email": "vicinum_L3@gmail.com", "user": "admin_L3", "status": "Associated"},
        {"id": "UID_JOHN", "email": "john.doe@example.com", "user": None, "status": "Rookie"}
    ]

    for m in mock_members:
        db.collection("members").document(m['id']).set({
            "member_id": m['id'],
            "email": m['email'],
            "username": m['user'], # Stage 2: Optional decorator [1]
            "town_unicode": "US-CA-M0180",
            "member_status": m['status'],
            "vcoin_balance": 100.0 if m['status'] == "Ambassador" else 0.0,
            "reward_tree": {
                "recruiter_id": "admin_L1", # Default anchor per registry [1]
                "coach_id": "admin_L1",
                "mentor_id": "admin_L2",
                "master_id": "admin_L3"
            },
            "member_profile": {
                "is_anonymous": True if m['user'] is None else False,
                "language": "en"
            }
        })
        print(f"  ✅ Member Created: {m['email']} ({m['status']})")

if __name__ == "__main__":
    db = initialize_db()
    seed_members(db)
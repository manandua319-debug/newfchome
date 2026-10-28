# 📱 Staff Operations Guide: Manual Pass Fulfillment

## Overview

This guide explains how to fulfill transit pass requests using the **Token Transit app**. There's no API integration—you'll manually send passes through the Token Transit consumer app.

---

## ✅ Prerequisites

Before starting your shift:

1. **Download Token Transit app** on your staff phone
   - iOS: App Store
   - Android: Google Play

2. **Add payment method** to Token Transit
   - Use organization credit card
   - Keep receipts for reimbursement

3. **Verify agency support**
   - Open Token Transit app
   - Check that VTA, Muni, SamTrans, Caltrain, BART are available
   - Confirm "Send a Pass" / "Gift a Pass" feature exists for each

4. **Get admin access** to FCHome app
   - Your account needs admin custom claim
   - Tap red admin button on Age Verification page

---

## 🔄 Complete Workflow (Step-by-Step)

### Step 1: Check for New Requests (Every 10-15 minutes)

1. Open FCHome app
2. Tap **red admin icon** (top right on Age Verification page)
3. View **pending requests** list
4. Note:
   - Phone number
   - Agency (VTA, Muni, etc.)
   - Fare type (Single Ride, Day Pass, etc.)
   - Destination (optional context)

### Step 2: Verify the Request

✅ **Check:**
- Phone number has 10 digits
- Agency is supported in Token Transit app
- Fare type matches available products
- Request timestamp is recent (< 24 hours)

❌ **Red flags:**
- Same phone requesting multiple times
- Obviously fake phone numbers (all 1s, 9s, etc.)
- Suspicious patterns

### Step 3: Send Pass via Token Transit App

1. **Open Token Transit app**
2. **Select the agency** requested (e.g., VTA)
3. **Tap "Send a Pass"** or "Gift a Pass" or "Buy for Someone Else"
   - (Button name varies by city)
4. **Choose the fare product**
   - Match the request (e.g., "Single Ride", "Day Pass")
   - If exact match unavailable, choose closest equivalent
5. **Enter phone number**
   - MUST match the number in the request
   - Include area code
   - Format: (555) 123-4567 or 5551234567
6. **Review & Pay**
   - Use org credit card
   - Confirm amount
   - Complete purchase
7. **Confirm sent**
   - Token Transit will send SMS to the rider's phone
   - SMS contains link to claim the pass

### Step 4: Update FCHome Dashboard

1. **Return to FCHome admin dashboard**
2. **Find the request** you just fulfilled
3. **Tap "Mark as Sent"**
4. **Add staff note** (optional but recommended):
   - Example: "VTA Day Pass - $5.00 - Sent 3:15pm"
   - Include actual product sent if different from request
5. **Tap "Confirm Sent"**

### Step 5: (Optional) Text the Rider

If you want to provide extra customer service:

```
Hi! We just sent a [AGENCY] transit pass to this number via Token Transit. 
Look for a text message from Token Transit with a link to claim your pass. 
The pass will be in the Token Transit app (not the FCHome app).

If you don't receive it within 5 minutes, please reply.
```

---

## 🚨 Troubleshooting

### Rider says "I didn't get the text"

1. **Verify phone number**
   - Ask rider to confirm their number
   - Check if they entered it correctly in FCHome app

2. **Check spam/blocked messages**
   - Token Transit SMS might be filtered

3. **Resend the pass**
   - Go back to Token Transit app
   - Send again to same number
   - Token Transit usually allows this

4. **Alternative solution**
   - If Token Transit fails repeatedly:
     - Offer physical Clipper card (if available)
     - Use agency's own mobile app (if they have gifting)
     - Provide rideshare voucher as emergency backup

### Agency doesn't support "Send a Pass"

- **VTA**: Should support it
- **Muni**: Check MuniMobile app instead
- **Caltrain**: May use their own app
- **BART**: May not support mobile ticketing in all cases
- **SamTrans**: Check availability

**Backup plan:**
- Create a standard operating procedure (SOP) for each agency
- Document which agencies need alternative fulfillment

### Token Transit purchase fails

1. **Check payment method**
   - Org card may be declined
   - Verify with supervisor

2. **Try different product**
   - Some fare types may be unavailable

3. **Contact Token Transit support**
   - If persistent issues

### Request looks suspicious

❌ **Do NOT fulfill if:**
- Same phone number > 3 requests in 24 hours
- Obvious bot pattern (rapid submissions)
- Phone number on internal block list

✅ **Do:**
- Mark request as "cancelled" in Firestore Console
- Add staff note explaining why
- Report to supervisor

---

## 📊 Daily Checklist

### Start of Shift
- [ ] Open Token Transit app
- [ ] Verify payment method active
- [ ] Check FCHome admin dashboard
- [ ] Note number of pending requests

### During Shift (Every 10-15 min)
- [ ] Check for new pending requests
- [ ] Fulfill oldest requests first
- [ ] Update dashboard after each fulfillment
- [ ] Keep receipts for accounting

### End of Shift
- [ ] Verify all requests marked as sent
- [ ] Tally total passes issued
- [ ] Tally total spent (for reimbursement)
- [ ] Report any issues to supervisor
- [ ] Log out of admin dashboard

---

## 💰 Accounting & Tracking

### What to Track

For each pass fulfilled, note:
- **Request ID** (from FCHome dashboard)
- **Phone number** (last 4 digits for privacy)
- **Agency** (VTA, Muni, etc.)
- **Product** (Single Ride, Day Pass, etc.)
- **Amount paid** ($3.00, $5.00, etc.)
- **Time sent** (timestamp)
- **Staff member** (your name/ID)

### Where to Log

Option 1: **Staff Notes in FCHome**
- When marking as sent, add note: "VTA Day Pass - $5.00"

Option 2: **Separate Spreadsheet**
- Create Google Sheet for tracking
- Columns: Date, Time, RequestID, Phone, Agency, Product, Amount, Staff

Option 3: **Token Transit Receipt**
- Token Transit app has purchase history
- Export weekly for accounting

---

## 🔐 Security & Privacy

### Phone Number Privacy
- ✅ DO: Only use phone numbers to send passes
- ❌ DON'T: Save phone numbers to personal devices
- ❌ DON'T: Call/text riders for non-service reasons
- ❌ DON'T: Share phone numbers with third parties

### Org Card Security
- ✅ DO: Use only for pass purchases
- ❌ DON'T: Share card details with anyone
- ❌ DON'T: Use for personal purchases
- Report lost/stolen cards immediately

### Admin Access
- ✅ DO: Log out after each shift
- ❌ DON'T: Share admin credentials
- ❌ DON'T: Leave admin dashboard open unattended

---

## 📞 Contact & Support

### For Technical Issues
- **Firebase errors**: Contact dev team
- **FCHome app crashes**: Restart app, report to dev
- **Admin access issues**: Contact supervisor

### For Token Transit Issues
- **App crashes**: Reinstall Token Transit app
- **Payment fails**: Check card, contact Token Transit support
- **SMS not delivered**: Wait 5 min, try resending

### For Rider Issues
- **Didn't receive pass**: Follow troubleshooting above
- **Pass not working**: Direct them to Token Transit support
- **Wrong agency**: Explain pass is in Token Transit, not transferable

---

## 📱 Quick Reference Card

**🎯 5-Minute Fulfillment Process:**

1. Open FCHome → Tap admin button
2. Note: Phone, Agency, Fare
3. Open Token Transit → Select agency
4. Tap "Send a Pass" → Enter phone
5. Choose fare → Pay with org card
6. Return to FCHome → "Mark as Sent"
7. Done! (Rider gets SMS from Token Transit)

**⏰ Check dashboard every: 10-15 minutes**

**📞 Rider SMS template:**
> "We sent your [AGENCY] pass via Token Transit. Check your texts for a link to claim it in the Token Transit app."

---

## ✅ Success Metrics

### Good Performance
- < 15 min average fulfillment time
- 95%+ requests fulfilled same-day
- Zero payment errors
- Clear staff notes on all requests

### Red Flags
- Requests sitting > 1 hour
- Multiple failed payments
- Missing staff notes
- Complaints from riders

---

## 📝 Common Questions

**Q: What if rider requests wrong agency?**
A: Send the pass for the agency they requested. If they realize later, they can request again (subject to rate limits).

**Q: Can I send a Day Pass instead of Single Ride?**
A: Yes, if it's a better value for the rider. Note the change in staff notes.

**Q: What if I accidentally send to wrong number?**
A: Note the error in staff notes. Contact Token Transit support to see if pass can be cancelled. Issue new pass to correct number.

**Q: How do I know if the rider claimed the pass?**
A: You won't see confirmation. Token Transit sends SMS; it's up to the rider to claim it.

**Q: What if Token Transit doesn't have the requested agency?**
A: Check the agency's own app (e.g., MuniMobile for Muni). If no option, mark as "cancelled" and add note explaining why.

---

## 🎯 Summary

**Your job:** Connect FCHome requests with Token Transit SMS delivery.

**Tools:**
- FCHome admin dashboard (view requests)
- Token Transit app (send passes)

**Process:**
1. Check requests
2. Send pass via Token Transit
3. Mark as sent in FCHome

**Timeline:** Every 10-15 minutes, process pending requests

**Support:** Contact supervisor for any issues

---

**Ready to start? Open the FCHome app and tap the red admin button!** 🚀







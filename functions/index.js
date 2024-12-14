const functions = require("firebase-functions");
const nodemailer = require("nodemailer");
const admin = require("firebase-admin");

admin.initializeApp();

// Configuration SMTP pour l'envoi d'emails
const transporter = nodemailer.createTransport({
  service: "gmail", // Par exemple, Gmail
  auth: {
    user: "votre-email@gmail.com",
    pass: "votre-mot-de-passe",
  },
});

// Fonction pour envoyer un email
exports.sendReservationEmail = functions.https.onCall((data, context) => {
  const {name, email, phone} = data;

  const mailOptions = {
    from: "votre-email@gmail.com",
    to: email,
    subject: "Confirmation de Réservation",
    text: `Bonjour ${name},
        \n\nVotre réservation a bien été enregistrée avec le numéro ${phone}. 
        Merci de votre confiance !`,
  };

  return transporter.sendMail(mailOptions)
      .then(() => {
        return {success: true};
      })
      .catch((error) => {
        console.error(error);
        throw new functions.https.HttpsError(
            "internal", "Email non envoyé.",
        );
      });
});

// Fonction pour envoyer une notification via Firebase Cloud Messaging
exports.sendNotification = functions.https.onCall((data, context) => {
  const {token, name} = data;

  const message = {
    notification: {
      title: "Réservation Confirmée",
      body: `Merci, ${name}! Votre réservation a bien été confirmée.`,
    },
    token: token,
  };

  return admin.messaging().send(message)
      .then(() => {
        console.log("Notification envoyée avec succès !");
        return {success: true};
      })
      .catch((error) => {
        console.error("Erreur lors de l'envoi de la notification :", error);
        throw new functions.https.HttpsError(
            "internal", "Notification non envoyée.");
      });
});

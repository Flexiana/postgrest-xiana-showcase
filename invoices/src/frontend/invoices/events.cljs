(ns invoices.events
  (:require
   [re-frame.core :as re-frame]
   [invoices.db :as db]))

(re-frame/reg-event-db
 ::initialize-db
 (fn [_ _]
   db/default-db))

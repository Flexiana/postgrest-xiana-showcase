(ns invoices.controllers.index
  (:require [ring.util.response :as ring]))

(defn handle-index
  [state]
  (let [html-content (slurp "/Users/jacobocordova/Documents/GitHub/postgrest-xiana-showcase/frontend/index.html")]
   (assoc state
          :response
          (ring/response html-content))))

(ns invoices.controllers.login
  (:require     [xiana.jwt :as jwt]
                [xiana.route.helpers :as helpers]
                [clojure.java.shell :refer [sh]]))

(defn call-ruby-script [username role]
  (let [result (sh "ruby" "../gen-jwt.rb" username role)]
    (println (:out result))
    (:out result)))

(comment
  (call-ruby-script "user1" "web_user")
  )

(def db
  [{:id         1
    :email      "xiana@test.com"
    :first-name "Xiana"
    :last-name  "Developer"
    :username   "user1"
    :password   "password"}])

(defn find-user
  [email]
  (first (filter (fn [i]
                   (= email (:email i))) db)))

(defn missing-credentials
  [state]
  (assoc state :response {:status 401
                          :body   "Missing credentials"}))

(defn handle-login
  [{request :request :as state}]
  (try (let [rbody (or (:body-params request)
                       (throw (ex-message "Missing body")))
             _ (print rbody)]
         (if true
           (let [jwt-token (call-ruby-script (:username rbody) (:password rbody))]
             (assoc state :response {:status 200 :body {:auth-token jwt-token}}))
           (helpers/unauthorized state "Incorrect credentials")))
       (catch Exception e
         (println e)
         (missing-credentials state))))

#_(defn generate-token [username role]
  (let [payload {:sub username
                 :role role
                 :iss "xiana-api"
                 :aud "api-consumer"
                 :exp (-> (System/currentTimeMillis)
                          (+ (* 3600000000 1000))
                          (/ 1000))}
        secret "xytR2xTLKPZed0rNreboFCBkRjN4ofTV"]
    (jwt/sign payload secret {:alg :hs256})))

#_(defn handle-login
  [state]
  (let [_ (print state)
        html-content (slurp "/Users/jacobocordova/Documents/GitHub/postgrest-xiana-showcase/frontend/index.html")]
    (assoc state
           :response
           (ring/response html-content))))

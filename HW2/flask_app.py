
from flask import Flask
from flask import render_template, request
import numpy as np
import joblib

model = joblib.load(open("output.pkl" , "rb"))

app = Flask(__name__)

@app.route('/hw_tWoFor-CSci--571')
def flask_app():
    return render_template("website.html")


@app.route('/calculateSbp', methods=['POST'])
def calculateSbp():
    features = [float(i) for i in request.form.values()]
    array_features = [np.array(features)]
    sbp_prediction = model.predict(array_features)
    output = sbp_prediction

    return render_template("website.html", calculateSbp = output[0])

if __name__ == '__main__':
#Run the application
    app.run()

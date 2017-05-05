@app.route('/get_identifiers')
def get_identifiers():
    data = storage.get_identifiers()
    resp = make_response(json.dumps(data))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp

@app.route("/sensor_update", methods=['GET'])
def sensor_update():
    return redirect(url_for('static', filename=UPDATE_FILENAME))

@app.route("/get_timestamp")
def get_timestamp():
    initial = request.args.get('initial')
    final = request.args.get('final')
    data = ""
    try:
        data = storage.get_time_interval(initial, final)
    except: 
        pass

    resp = make_response(data)
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route('/get_timestamp_csv')
def get_timestamp_csv():
    initial = request.args.get('initial')
    final = request.args.get('final')
    csvList= storage.get_time_interval_csv(initial,final)
    si = StringIO.StringIO()
    cw = csv.writer(si)
    cw.writerows(csvList)
    output = make_response(si.getvalue())
    output.headers["Content-Disposition"] = "attachment; filename=%s_to_%s.csv" % (initial, final)
    output.headers["Content-type"] = "text/csv"
    return output


@app.route('/get_number_of_macs')
def get_number_of_macs():
    identifier = request.args.get('identifier')
    # identifier = json.loads(identifier)
    minutes = request.args.get('m')
    data = ""
    try:
        data = storage.get_number_of_macs(identifier, minutes)
    except: 
        pass

    # Begin privacy threatment
    if privacy_enabled:
        data["Total"] = privacy.add_laplacian_noise(data["Total"])
    # End privacy threatment

    resp = make_response(json.dumps(data, default=date_handler))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route('/get_last_minutes')
def get_last_minutes():
    minutes = request.args.get('m')
    data = ""
    try:
        data = storage.get_last_minutes(minutes)
    except: 
        pass
    resp = make_response(json.dumps(data, default=date_handler) )
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route('/get_daily_sum_sensor')
def get_daily_sum():
    identifier = request.args.get('identifier')
    # identifier = json.loads(identifier)

    initial = request.args.get('initial')
    final = request.args.get('final')
    data = ""

    try:
        data = storage.get_daily_sum_data_sensor(initial, final, identifier)
    except: 
        pass

    # Begin privacy threatment
    if privacy_enabled:
        mac_counts_privacy = []
        mac_list_privacy = []
        for mac_count in data["macs"]:
            mac_counts_privacy.append(privacy.add_laplacian_noise(mac_count))
        for mac_list in data["macs_list"]:
            mac_list_privacy.append(privacy.generalize_macs(mac_list).values())
        data["macs"] = mac_counts_privacy
        data["macs_list"] = mac_list_privacy
    # End privacy threatment

    resp = make_response(json.dumps(data))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route('/get_hour_sum_sensor')
def get_hour_sum():
    identifier = request.args.get('identifier')
    # identifier = json.loads(identifier)

    initial = request.args.get('initial')
    final = request.args.get('final')
    data = ""
    try:
        data = storage.get_hour_sum_sensor(initial, final, identifier)
    except:
        pass

    # Begin privacy threatment
    if privacy_enabled:
        for i in range(0, len(data)):
            data[i] = privacy.add_laplacian_noise(data[i])
    # End privacy threatment

    resp = make_response(json.dumps(data))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route('/get_last_month_median')
def get_last_month_median():
    identifier = request.args.get('identifier')
    # identifier = json.loads(identifier)

    data = ""
    try:
        data = storage.last_month_median(identifier)
    except:
        pass
    resp = make_response(json.dumps(data))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route('/get_timeline')
def get_timeline():
    identifier = request.args.get('identifier')
    # identifier = json.loads(identifier)

    initial = request.args.get('initial')
    final = request.args.get('final')
    total = request.args.get('total')
    data = ""
    try:
        if total is not None:
            data = storage.generate_top_timeline(initial=initial, final=final, identifier=identifier, total=int(total))
        else:
            data = storage.generate_top_timeline(initial=initial, final=final, identifier=identifier)
    except:
        pass

    # Begin privacy threatment
    macs = []
    if privacy_enabled:
        for time in data["timeline"]:
            if time[0] not in macs:
                macs.append(time[0])
        mac_dict_anonymized = privacy.generalize_macs(macs)
        for i in range(0, len(data["timeline"])):
            data["timeline"][i][0] = mac_dict_anonymized[data["timeline"][i][0]]
        data["timeline"] = sorted(data["timeline"], key=lambda time: int(time[0].split()[0]))
    # End privacy threatment
    else:
        data["timeline"] = sorted(data["timeline"])

    resp = make_response(json.dumps(data))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


# SENSOR_STATUS methods
@app.route("/notify", methods=['POST'])
def notify():
    try:
        dt_offset = datetime.timedelta(hours = offset)
        identifier = request.json["identifier"]
        now = datetime.datetime.now() - dt_offset
        if request.method == 'POST' and not DEV_MODE:
            sensors_status.insert_data(identifier=identifier, timestamp=now)
        elif DEV_MODE:
            print (identifier, now)
    except:
        pass

    resp = make_response()
    resp.headers['Access-Control-Allow-Origin'] = "*"
    resp.headers[SENSOR_VERSION_HEADER] = SENSOR_VERSION_ID

    return resp

@app.route("/get_last_activity")
def get_sensor_last_activity():
    identifier = request.args.get('identifier')
    data = ""
    try:
        data = sensors_status.get_last_activity(identifier)
    except:
        pass
    resp = make_response(json.dumps(data, default=date_handler))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp

@app.route("/get_today_interval")
def get_today_interval():
    today = datetime.datetime.now().replace(hour=0)
    tomorrow = today + datetime.timedelta(days=1)

    initial = today
    final = tomorrow

    identifier = request.args.get('identifier')

    if identifier:
        identifier = identifier.split(',')

    minutes = request.args.get('minutes')

    if not minutes:
        minutes = 10
    else:
        minutes = int(minutes)

    data = storage.get_people_count(initial, final, minutes=minutes, identifier=identifier)

    data = json.dumps(data, default=date_handler)
    resp = make_response(data)
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route("/get_sensor_history")
def get_sensor_history():
    identifier = request.args.get("identifier")
    data = ""
    print "aqui " + datetime.datetime.now().isoformat()
    try:

        data = sensors_status.get_sensor_history(identifier)
        print data
    except:
        pass

    resp = make_response(json.dumps(data, default=date_handler))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route("/is_up")
def is_up():
    identifier = request.args.get('identifier')
    data = None
    try:
        data = sensors_status.is_up(identifier)
    except:
        pass
    
    resp = make_response(json.dumps(data))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route("/sensor_up")
def sensor_up():
    identifier = request.args.get('identifier')
    initial = request.args.get('initial')
    final = request.args.get('final')

    data = None
    try:
        data = sensors_status.sensor_up(identifier, initial, final)
    except:
        pass

    resp = make_response(json.dumps(data, default=date_handler))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route("/get_macs")
def get_macs():
    mac_list = request.args.get('mac_list')
    dict={};
    mac_list = mac_list.split(",");
    for i in mac_list:
        dict[i] = get_brand_by_mac(i)

    resp = make_response(json.dumps(dict))
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route("/get_people_count")
def get_people_count():
    initial = request.args.get('initial')
    final = request.args.get('final')
    identifier = request.args.get('identifier')

    if identifier:
        identifier = identifier.split(',')

    zero_fill = request.args.get('zero_fill')

    minutes = request.args.get('minutes')

    if not minutes:
        minutes = 10
    else:
        minutes = int(minutes)

    if not zero_fill:
        zero_fill = 1
    else:
        zero_fill = int(zero_fill)

    data = storage.get_people_count(initial, final, minutes=minutes, identifier=identifier, zero_fill=zero_fill)

    data = json.dumps(data, default=date_handler)
    resp = make_response(data)
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route("/get_today_people_count")
def get_today_people_count():
    today = datetime.datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    tomorrow = today + datetime.timedelta(days=1)

    initial = today
    final = tomorrow

    identifier = request.args.get('identifier')
    if identifier:
        identifier = identifier.split(',')

    data = storage.get_people_count_interval(initial, final, identifier=identifier, fill_with_zeroes=False)

    data = json.dumps(data, default=date_handler)
    resp = make_response(data)
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


@app.route("/get_people_current_status")
def get_people_current_status():
    minutes = request.args.get('minutes')
    identifier = request.args.get('identifier')

    if identifier:
        identifier = identifier.split(',')

    if not minutes:
        minutes = 10
    else:
        minutes = int(minutes)

    data = storage.get_people_current_status(identifier=identifier, minutes=minutes)

    data = json.dumps(data, default=date_handler)
    resp = make_response(data)
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp


def get_brand_by_mac(mac_address): #mac format: 00:00:00:00:00
    file = open("/home/helder/priviot-sensor/service/src/oui.csv")
    reader = csv.reader(file, delimiter=",")
    mac = "".join(mac_address[0:8].split(":")).upper()
    for row in reader:
        if row[1] == mac:
            file.close()
            return row[2]
    file.close()

@app.route("/get_minutes_median")
def get_minutes_median():
    identifier = request.args.get('identifier')
    data = storage.get_future_median(identifier)
    data = json.dumps(data, default = date_handler)
    resp = make_response(data)
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp

@app.route("/get_past_status")
def get_past_status():
    identifier = request.args.get('identifier')
    data = storage.get_past_status(identifier)
    data = json.dumps(data, default = date_handler)
    resp = make_response(data)
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp

@app.route("/get_local_similarity")
def local_similarity():
    mac = request.args.get('mac')
    identifier = request.args.get('identifier')
    data = storage.local_similarity(mac,identifier)
    data = json.dumps(data, default = date_handler)
    resp = make_response(data)
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp

@app.route("/get_forecast_accuracy")
def get_forecast_accuracy():
    identifier = request.args.get('identifier')
    data = storage.get_forecast_accuracy(identifier)
    data = json.dumps(data, default = date_handler)
    resp = make_response(data)
    resp.headers['Access-Control-Allow-Origin'] = "*"
    return resp
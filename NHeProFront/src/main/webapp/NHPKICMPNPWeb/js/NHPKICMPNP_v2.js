/////////////////////////////////////////////////////////////
/////////////// Connect Core Method Frame ///////////////////
/////////////////////////////////////////////////////////////
function requestPost(async, url, data, sCallback, eCallback) {
	request(async, url, "POST", data, sCallback, eCallback)
}

function requestGet(async, url, data, sCallback, eCallback) {
	request(async, url, "GET", data, sCallback, eCallback)
}

function request(async, url, type, data, sCallback, eCallback) {
	$.ajax({
		async: async,
		dataType: 'json',
		url: url,
		type: type,
		contentType: "application/json;charset=utf-8",
		data: data,
		success: function(response) {
			sCallback(response);
		}, error: function(xhr, status) {
			eCallback(status);
		}
	});
}

/////////////////////////////////////////////////////////////
////////////////// New Methods (WEB/WAS) ////////////////////
/////////////////////////////////////////////////////////////

NHPKICMPNP.callFunction_v2 = function(func, params, callback) {
	NHPKICMPNP.init();
	block_screen();

	var cli_url = NHPKICMPNP.localURL + "/run.html";

	if (func === "certissue") {

		/* 1. request check local policy to WAS */
		var jsonReqGetPolicy = {
			"tag": "getpolicy"
		};

		requestPost(true, NHPKICMPNP.reqURI, JSON.stringify(jsonReqGetPolicy), function(respGetPolicy) {

			/* 2. request write local policy to client */
			var jsonReqCheckPolicy = {
				"func": "checkPolicy",
				"isCorporation": isCorporation + "",
				"policy": JSON.stringify(respGetPolicy)
			};

			requestPost(true, cli_url, JSON.stringify(jsonReqCheckPolicy), function(respCheckPolicy) {
				if (respCheckPolicy.RespCode === 0) {

					/* 3. request challenge to WAS */
					var jsonReqChallege = {
						"tag": "challenge",
						"isCorporation": isCorporation + ""
					};

					requestPost(true, NHPKICMPNP.reqURI, JSON.stringify(jsonReqChallege), function(respChallenge) {
						if (isEmpty(respChallenge)) {
							showAlertModal(respChallenge.tag, "Invalid response received");
							unblock_screen();

						} else {

							/* 4. request generate CSR to client */
							var jsonReqGenCSR = {
								"func": "certissue",
								"challenge": respChallenge.message,
								"strIDN": "1234567890123"
							};

							if (isCorporation === true)
								jsonReqGenCSR.strIDN = document.getElementById("corporation_num").value.trim();;

							requestPost(true, cli_url, JSON.stringify(jsonReqGenCSR), function(respCSR) {

								if (respCSR.RespCode !== 0) {
									showAlertModal(func, respCSR);
									unblock_screen();
									return;
								}

								/* 5. request generate user cert to WAS */
								var jsonReqUserCert = JSON.parse(respCSR.RespMsg);
								jsonReqUserCert.certUseKind = NHPKICMPNP.certUseKind;
								jsonReqUserCert.mpcId = kcbSeq.value;
								jsonReqUserCert.isCorporation = isCorporation + "";
								jsonReqUserCert.tag = func;

								if (isCorporation === false) {
									jsonReqUserCert.userName = document.getElementById("user_name").value.trim();
									jsonReqUserCert.oid = certTypeP;

								} else if (isCorporation === true) {
									jsonReqUserCert.userName = document.getElementById("corporation_name").value.trim();;
									jsonReqUserCert.oid = certTypeC;
								}

								requestPost(true, NHPKICMPNP.reqURI, JSON.stringify(jsonReqUserCert), function(respUserCert) {

									if (respUserCert.rescode === "0") {
										/* 6. request write usercert to client */
										var jsonReqWriteUserCert = {
											"func": "writeCert",
											"writeCertParams": JSON.stringify({
												"message": {
													"signCert": respUserCert.message.signCert
												},
												"rescode": respUserCert.rescode
											})
										};

										requestPost(true, cli_url, JSON.stringify(jsonReqWriteUserCert), function(respWriteUserCert) {
											var result = JSON.stringify(respWriteUserCert);
											if (isEmpty(respWriteUserCert)) {
												Console.log("Cannot parse response to json : " + result);
												alert("Invalid response recieved : " + result);
												unblock_screen();

											}
											else
												showAlertModal("certissue", respWriteUserCert);

											unblock_screen();

										}, function(e) {
											console.log("[ERROR] 'Request Write UserCert' => " + e);
											showAlertModal(func, e);
											unblock_screen();
										});
									}

								}, function(e) {
									console.log("[ERROR] 'Request Gen UserCert' => " + e);
									showAlertModal(func, e);
									unblock_screen();
								});

							}, function(e) {
								console.log("[ERROR] 'Request GenCSR' => " + e);
								showAlertModal(func, e);
								unblock_screen();
							});
						}

					}, function(e) {
						console.log("[ERROR] 'Request Challenge' => " + e);
						showAlertModal(func, e);
						unblock_screen();
					});
				}

			}, function(e) {
				console.log("[ERROR] 'Request CheckPolicy' => " + e);
				showAlertModal(func, e);
				unblock_screen();
			});

		}, function(e) {
			console.log("[ERROR] 'Request GetPolicy' => " + e);
			showAlertModal(func, e);
			unblock_screen();
		});

	} else if (func === "viewcert") {

		/* 1. request viewcert to client */
		var reqUserCert = {
			"func": "viewcert"
		};

		requestPost(true, cli_url, JSON.stringify(reqUserCert), function(respUserCert) {

			if (respUserCert.RespCode === 0) {
				var obj = JSON.parse(respUserCert.RespMsg);

				/* 2. request viewcert to WAS */
				var reqCertVerify = {
					"tag": "certverify",
					"userCert": obj.userCert,
					"isCorporation": obj.isCorporation + ""
				};

				requestPost(true, NHPKICMPNP.reqURI, JSON.stringify(reqCertVerify), function(respCertVerify) {
					if (respCertVerify.rescode === "0") {
						var data = {
							"RespMsg": MSG_PLUGIN_VIEWCERT_SUCCESS
						};
					} else {
						var data = {
								"RespMsg": MSG_PLUGIN_VIEWCERT_ALREADY_REVOKED
							};
					}
						showAlertModal(func, data);
						unblock_screen();
				});

			} else {
				showAlertModal(func, respUserCert);
				unblock_screen();
			}
		}, function(e) {
			console.log("[ERROR] 'Request viewcert' => " + e);
			showAlertModal(func, e);
			unblock_screen();
		});
	}
};



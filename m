Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013053.outbound.protection.outlook.com [40.107.159.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BA72FE585
	for <linux-trace-devel@vger.kernel.org>; Mon,  1 Dec 2025 15:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764603518; cv=fail; b=YykFkmOUbEDZDKlILqPVjFVe6IXiIl9fZc7EGR3imF773jis50FySjVVXdvcWjHwodYL9RE1ksyMEKzQU+EdIu1CXJwBPrLqAOvydqlmj3PORe798nyBl94egMIu9L3RPaegC40zUtFwtd3HEBTyZuDvjmD+JCqVIYhPqOZou34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764603518; c=relaxed/simple;
	bh=0dF155YEHFSCz/mZpcP73Ys90+4XJzZqK2u/9Bs6hMs=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=a53ctNcskeAHXu7faTGt/J8TGtJu7TNS9rJfTsjc8JKGVATt7t3VxgHOlTP030e7mreEWaEzdmejKQTvVIfmhR8gvArcbSAjioLFSuDfCeNA0ygG21h7Piw9yreu4TO1PtMOfEeGWFPEzkwNsnObyLayaUMLzkHAZ5EWk9t6DJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=O0f5VEKX; arc=fail smtp.client-ip=40.107.159.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="O0f5VEKX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eoR10g+bqoekQAIdkFfVAxiY450e0gvoRoRshOpAyj2FECV4hON/IQQNZlS9boyl7UTjzXOYssIf+0pF3bwD02I4LJQMmr897zvG+KV56N5X2S0cKm1YS13GNWZjz/ZVLD4784qt1mPD0VoBYQRvhynWRgH9MLf5/I/zAZu3FYU58tVZuNlolEvyPOj4MsLMYGR7YYpQapZ6hPyacbKKaQlebJ0hyyp78Kai+XV2aqKsnxcFyV60jEvaP689BmBFB+qlvrZwlsPSR0iYjOqw+i7EnmE1JNzasGW5/xh40LFIv4z4Ov+c2d/GjufhDfUoKHcIpKn+v/uWPpUBdp8Mvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dF155YEHFSCz/mZpcP73Ys90+4XJzZqK2u/9Bs6hMs=;
 b=qID8BZbZ83mxxFFN/oqHerM8WiXPamhfnOYz9WlDl++Y9lfBbfHLMmz8sUZ0FzRJ08BKBjUw98VgdQm20qp054QsARqzvLC5fK9hQj9FqBbZEwn78yTU+C1lWVEmaL0CqktrvPFkcUltleacTU0J5f+KJ1gpXWSSglMhGc5UF9euNJwsQb9kgxyUOnaHn8vimg7GjlWp94LRjr8XNrIuEqCDKKZ7qxutCKSxG5P/CokTZc1RwiKebaO9kXbYz2rIx6j41Mavopn/sJS3Sr5r7Z4j3pEH5Do9wpTmpUDEePDAmfFnE0tly3GxmNivIEYL+ywEp8Dklpa0+Am14scgIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dF155YEHFSCz/mZpcP73Ys90+4XJzZqK2u/9Bs6hMs=;
 b=O0f5VEKX5zSqCN02oVETpcUGOp08XPAM5d5z7WzwrR3gvz8J3sjBr+7KAWFRsVCPSddXakvR6UWwxHs0x1ayAYEHlh46fymyZAWLDD4iEYcYpg+awuCcE97w3Nel7GSdh0erQQsTQDXyxpLOABQQWYJYHNOSQxHECjawuxVRJFbgMiNaY7HHUgv6OV0tDj3K3vcxvJBPIVYUvUULQhTF+ITa6GCp67ab0XRy7GTvsMcZUJ1gJSwHCukZkLyhm3yx7T1xg/ZnAFBDEUSQ6bWHdw0ThOKKA2TrjPh5EvfPSoIlMpv+hBWnXcV57FlSa2+Lp0QI84qvQLfeHltZhE442A==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by PAWPR10MB7104.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:2e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 15:38:33 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 15:38:32 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>
CC: "Kiszka, Jan" <jan.kiszka@siemens.com>, "Poljakow, Andre"
	<andre.poljakow@siemens.com>
Subject: libtraceevent | API clarifications needed
Thread-Topic: libtraceevent | API clarifications needed
Thread-Index: AQHcYtiM0Nrfnwz7QkWWTdAr1YLoFw==
Date: Mon, 1 Dec 2025 15:38:32 +0000
Message-ID: <7ce07a566354a6d2233e231a6a7bc760447c7547.camel@siemens.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2-7 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|PAWPR10MB7104:EE_
x-ms-office365-filtering-correlation-id: 5ef689a9-a71c-44bb-8399-08de30efaeee
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?UUY1WEJIcS9uTHhkeDB1U1V4TG0wbFlDSFJjQzNpUGtnRFg1Um81aExHbFNu?=
 =?utf-8?B?UEJqOW1KZ0FJVndMc1IzT3kzVzdtUm94UjNoSUVqbVlBQi9ERHFycE1nZnlZ?=
 =?utf-8?B?R0hwaWlmMW9sWXBTczQ5bTNrRUtkTnNueE92dkZPQzYzY2J2cnpoZlVsTFVN?=
 =?utf-8?B?QlFURnFic29VaXgyNXM2R0JqT01UeUpUeXhCNjEwMDZDbmQ5RnRUZGtmYnh3?=
 =?utf-8?B?cEF0WHZZNEV0ZGNaTzllNEZTc01pUy8rL0JFZEk1Mk4wc2QrUWMxZTl5SjRQ?=
 =?utf-8?B?T0lUZjlZaWRNUzlSUUhIN25scGtCRE83RHNlbW9KbDdsRlppejZ5NnpieG1L?=
 =?utf-8?B?Mm91R1Y2UGdLbWVpcnNyZEVOWjFuWGE3UEFmKzVYWU05Vi9pdDFJRExISXpk?=
 =?utf-8?B?V2JaK0hTSHJ1SEZocGVudTY1VGJJNEN6NUc0YUQ4a09WSlREbXlrNEI2TmxD?=
 =?utf-8?B?ZzYxTkFwblRBaTNLS1hza1BWT3RNV2hRclppbGFXUmliVGpkbTc2eFpZeGlC?=
 =?utf-8?B?U2RsVndIL05rQ0Q0NnIvUDZJVUppOUIyQ3FqSFdnSjJzN0d0aThKT0xvUWRH?=
 =?utf-8?B?Mkd6TjZHdlp4Wm9FVDBUTTU2UHFyUkdxaGsrVXVBRXliU0x3YVJBeERjc0Fo?=
 =?utf-8?B?VGVmc1NMU2EwYllpMW9yZGxabW5JY0hRTS9mcW10QzhueUhwb2drNnk1Zmdv?=
 =?utf-8?B?ejM2MmZJQm9xajI0L29wb0lVVlYranRzV2NmNVVKZng5ampFaC9jRXBJVHY5?=
 =?utf-8?B?Wkt2a0x6L0NDbHZZbENSN2RPMHB2ZzZlRFljZXRYVlRGbzhJSVFWV25meEFT?=
 =?utf-8?B?QzNHcHJnbDBRYkF1S0VtRi95UUFuWlkrQm85M1lKSnN6NHpBdGQ2a0I3Tm9j?=
 =?utf-8?B?RzlRcElTbGJ3U0tKNitQQU56S3huZTFkSTNleFptVnBKelJUamhVVzFiRzRD?=
 =?utf-8?B?YnIya0E0Y3U3V2IrdSt4Z3ZCcnNiU1hldUVZK3RPQUVjZWFvZGdxQUloN2Rx?=
 =?utf-8?B?M2VMSzloVDAwVkJSNlBuUXZuQnZkaWZRUHFoTE1nYm9VQ2xBOVhSaXJneVFU?=
 =?utf-8?B?ekYvM2N5VFNMTjVtRUEwZlNuSWEvRkkzRlJpSXdsWmFHRGtPeDZjQ2xBVzVj?=
 =?utf-8?B?L1MyTGpmWEdGY2crVzloajh2b1JGL0p0bWU4RzlqbHZzbERGTFBMWkQ2cEZa?=
 =?utf-8?B?MjFCZ3FHUndFcGhKSWpGY2pQcU9zVVV5Z2pnVDhpT1ZrbG9QL2oxemxFZ29D?=
 =?utf-8?B?TUVHSWVMVGM0WGhOdnhRUncxR1lkRHZ4b2tYYUg1RlVZWlNMdlJVa3F3NjJR?=
 =?utf-8?B?S1hrcmQxUTNNa2dTRk8rVTV2NlE4WGVhS2VROVFlZG10cTZSeW43YmZpcE1I?=
 =?utf-8?B?USt3ZU9kYThoTlFXWEhJdWFoWklHUCtOY1B6clFVV2dteFJlVURVeTNZNC9Z?=
 =?utf-8?B?aWtRVkw3czJkVWJPdEd2UnZ1NnRkdVBzSS9acVlGQm42dDJTUVhzY05UWTlY?=
 =?utf-8?B?ei81aGdWKzJTdUdMRlJvaDBseFJBYkRQdTBhazNsQ0w4ZC9oeW5TNmkzZzhC?=
 =?utf-8?B?a2pWOEJLOE1nUkVCWjBTNlRVclpRZ1BXZG9XOG5VRHF6cGdNQk0wS3lYRE41?=
 =?utf-8?B?eXlIOFFsRVZyMTNKNC8rc3hBOU02MkhsRUZoMUk5VnkvbnI3ZjJTaWtZamZh?=
 =?utf-8?B?c0hCcVdRb3lSVlhGQUpwUmx5WG56RHJyeFFsL2hZblZXYTRRZWtGRmQ0SFhu?=
 =?utf-8?B?dXVKVHNTMkF4clRKdDFsQjJiVHJqSjlKcDRSeUNPU1NMcldzQmZSNGsxN2Vl?=
 =?utf-8?B?V0JrL1c2Qk9uRk5CcUxabUFZaFVzQTBhQzl3MW9DREliWkh0K2N6d0FSQnZn?=
 =?utf-8?B?TEpuSTJpdFRYaXg5UWdOSVFxOUIwZ3lBWEw4aDZvMGNOSGxMb0pMcHBocS9R?=
 =?utf-8?B?aGFEcStZQVJPajhZUFZJOFh5WUptdW91NzFTblNmREMxUXR4TjkyMVplRGVH?=
 =?utf-8?B?TkRDT2syS2FSR2xEYTJNQmFIU2VyMDNTZ09vWUxPTGN3a0Qxc3NVN1BIRFhG?=
 =?utf-8?Q?NK2+Gp?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QUxabkhBQ2tpdjljOU9hWWNDeVQybnRvUTZlaE9hNWNxUDB6WDIzMFBHMTZa?=
 =?utf-8?B?dFhPUnZyUmRYREU3dCtjZlltR05ya2Flb0Y0cnkxMXJNajZRWlJMQWdBMFdq?=
 =?utf-8?B?M2Zyam9WMnBLS0FHbVhCR1RNSWxHaFkyMWw0ZktoWkEzdGpuY0hBRSthOWlC?=
 =?utf-8?B?QWlRa1NIQWM1UmNRVXpVNXdhT0pnYWt5WWducUU3bVp1N3BQRHQxeml6WmpO?=
 =?utf-8?B?TklwdGliZ3EwS2l1M2VTQlF1dnhzWVYrcHoyVFUxWmRTblFGODZCSURSRWky?=
 =?utf-8?B?dWJmYTFramtXQThycHR6bTVrSnB5ditydFU5SnovNkg5NWpOM245eldOWHpx?=
 =?utf-8?B?QVF0ZEg3QmZWRkZXY2cxUERKUyswSEx3K1pWZnQzVU1QRHlSU09YUlkrUkRF?=
 =?utf-8?B?cy9lZEtRU0tXbWxvMzdybDJwanZDQXNJQ05kRXp1TmVZSjB4cE5RQW54VnFM?=
 =?utf-8?B?YlU1VysxMTR6ZHU5TXJGNWQyLzh3SE5HeVk5NFVnTyt2T1dCS0wzOVJEb3Rm?=
 =?utf-8?B?dVN6eEkyWnZsSW95MU9OaFEveVhZUzVMMGJ1dVJKeUtLcDQvS08yV2Z0MWR6?=
 =?utf-8?B?L2I5eStDUlBqNWViUzVrNGhoK1l0TWV6THZta2Q2Kyt4WW1scGxnVkFqbXk0?=
 =?utf-8?B?aUJZa013ZTlFeU90Tmg0SUNCcWw5SDU3aEJCZDN3RjEzV0tsNVBPSHRDYUNH?=
 =?utf-8?B?NzdYakswdHgvek9pTEZHQUU2UXRpZGtVaXd2NUp3dUJReGNUcFF2N1NMMEJj?=
 =?utf-8?B?V1pKNktTM040U2NTd1czanYvMXlwYk9jZldzWWNJTXZ0WmxNaGRKM3UrSFNy?=
 =?utf-8?B?QXlSSlI2ZXdZeW1sMGdNRUhHb2JuZkk1R3BEalFkazMwLytUZEwwRmtmazFP?=
 =?utf-8?B?cVBvY2hoUDhMaUtPbDNCS2hTcTF5bDNRRkxsdktTeXB0TmNUNkNUUnBOT3lm?=
 =?utf-8?B?SGpSV3FZcS81amlUQkRmeHJmTDNUdjNKMlRHWm1LcHd1OC8yRjczbnFURTdC?=
 =?utf-8?B?S1luOGJWMjJqQmxTV2hQMTNUVVhVOTNBTnhyM2hHVUs2OGdwVit4TldDZUxw?=
 =?utf-8?B?RjgrNy9LSnFDcnhEeXZzWnQwUW5PWWM1MzJiNGN1V3d2VEYrWTk5S0RFN1o4?=
 =?utf-8?B?WVA3bXRyVXZETkEwd1lMZnZTNTRRY1BkajBqQlB3OWFrNjVQcEMzd29oVGk1?=
 =?utf-8?B?NHBrdmNSTGV0YUVZdGI5ZDFKUXJZb3hCT0N0N0duRExKVm9GQ1FDMkRWT1BZ?=
 =?utf-8?B?S0dPaGJaQkhHQzZFZHNwMGJuYzdXSjFBVUc3Vy9oSmhwT0NLZG1LYWFoT012?=
 =?utf-8?B?Z0xsMnpxM0tsZTJSUjFNY0d3MWo3eTUwbzJ3L05Ba0duZjF3QW9wSkpCZlN5?=
 =?utf-8?B?Z2IycDBZWlBJWEdxRFE3aFU2a3MwczR3ODQrMVJPSlhPY1ZFWHdqdi9FWmtP?=
 =?utf-8?B?N01kVFZaMzhTU2lveUZjU1NDc1htRHk2eG16ZVUrQjJZOFQ3THhmN1F6ekRz?=
 =?utf-8?B?dFR1aG05dFhYblVQUytRRVl0NURidWtqQndDaUZkWFJKeklrRGRuZ3ppWVRq?=
 =?utf-8?B?ZFhteGRNWGNrd0Z4VytBTUp0SUpLVHhQQnVaVXFQS0UrN0xma1FQdG9qZ0tL?=
 =?utf-8?B?eTZ6eisyT0dDdHpXNWd4RlNzL0ZoT3gvdnlnckRxdGhXZlZqY0ZkM0hnVW41?=
 =?utf-8?B?ZnJhN0NvR21waUhWUjNYd0RxR3V6TGQ1SUNhblRSWVEzak9RUHFvV3JucXl5?=
 =?utf-8?B?dFhPUVNWRnZsdHBuMGZuS1BneUxyVmdiNkVRd1JsbW1ZbDVESWIwYmJVNUxq?=
 =?utf-8?B?bHp5azNoQlk4dkhyUmRBbm9selBCRHp2TXh5Y1MxU21WMDNTcTBPaWpQY0dV?=
 =?utf-8?B?a2RxV3NOT3AvRjIrL1V2dlZkV2hzSGhWWnd5WWQwQjlLUEFYWWFMUG9KbmVq?=
 =?utf-8?B?R0VCbjI0SHJQbmRPZTNJTUpHZ3dBZ3FoSFJLOXFFUzRRWjRaMkFTV3BaNklM?=
 =?utf-8?B?cXphT2YrQktCYWVFQ0tkbEJJUytQZFNrZTJhYmxiT2J4Z2U0Mm5kNUxJclhW?=
 =?utf-8?B?cFk1UFQzZFh4Uy9Za0tnK0V2QzZqUGdIK1ZyOWxjSXpOemtlQXk0SUx0cDVH?=
 =?utf-8?B?d3o0dlVtQXJpZGVKQ2lCSkp1UWh1dW9YUVJvUk9CTGVKUklXeWRLcmowRWNC?=
 =?utf-8?Q?GUSmtPNUIzzzrtbZD4PsGJc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE710F3CE53FFF4DB48A709ACA38E268@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef689a9-a71c-44bb-8399-08de30efaeee
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2025 15:38:32.3259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0qQkHcGtyMBIBjYpGXH4QUpQnd4m013gl+6+a82R5o+k4gYPJGfNT6roeCqusP9tFjZ6PFlBIr159JEi2Mx5cQ5eVl+GI9zKasoZzr9eVOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR10MB7104

RGVhciB0cmFjZXJzLA0KDQp3aGlsZSBjb250aW51aW5nIHRoZSBkZXZlbG9wbWVudCBvZiB0aGUg
ZnRyYWNlLXRvLWN0ZiBjb252ZXJ0ZXIgWzFdLCBJDQpub3RpY2VkIHRoZSBmb2xsb3dpbmcgaW4g
dGhlIHRyYWNlZXZlbnQgQVBJIHRoYXQgbmVlZHMgc29tZQ0KY2xhcmlmaWNhdGlvbjoNCg0KaGFs
Zi1sZW5ndGggc2lnbmVkIGludGVnZXJzDQoNCldoYXQgaXMgdGhlIHJlY29tbWVuZGVkIHdheSB0
byByZWFkIGEgZmllbGQgdmFsdWUgdGhhdCBpcyBhIGhhbGYtbGVuZ3RoDQooaS5lLiAzMiBiaXQp
IG9yIHNtYWxsZXIgc2lnbmVkIGludGVnZXI/IEN1cnJlbnRseSwgSSdtIHVzaW5nIHRoZQ0KdGVw
X2dldF9maWVsZF92YWwgd2hpY2ggcmV0dXJucyB0aGUgdmFsdWUgYXMgdW5zaWduZWQgbG9uZyBs
b25nDQoodXN1YWxseSA4IGJ5dGUpLiBUaGlzIHZhbHVlIGNvbnRhaW5zIHRoZSByYXcgYml0cyAo
ZW5kaWFuLWNvcnJlY3RlZCksDQpoZW5jZSBhIGludDMyX3QgKC0xKSBpcyByZXByZXNlbnRlZCBh
cyBGRkZGIEZGRkYuIEknbSBjdXJyZW50bHkNCm1hbnVhbGx5IGNvbnZlcnRpbmcgdGhpcywgYnV0
IEknbSB3b25kZXJpbmcgaWYgdGhlcmUgaXMgYSBiZXR0ZXIgd2F5IG9mDQpkb2luZyBpdC4NCg0K
DQphcnJheXMgb2YgaW50ZWdlcnMNCg0KVGhlIG9ubHkgQVBJIEkgZm91bmQgdG8gcmVhZCBpbnRb
eF0gdHlwZXMgKGFycmF5cyBvZiBpbnRlZ2VycykgaXMNCnRlcF9nZXRfZmllbGRfcmF3LiBIb3dl
dmVyLCB0aGlzIGp1c3QgZ2l2ZXMgbWUgdGhlIHJhdyBieXRlcyBvZiB0aGUNCnRyYWNlIGJ1ZmZl
ci4gRG9lcyBpdCBtZWFuIEkgbmVlZCB0byB0YWtlIGNhcmUgb2YgZW5kaWFuIGNvcnJlY3RuZXNz
Pw0KQXJlIHRyYWNlIGJ1ZmZlcnMgYWx3YXlzIGxpdHRsZS1lbmRpYW4sIG9yIGlzIHRoaXMgYW4g
aW1wbGVtZW50YXRpb24NCmRldGFpbD8NCg0KdW5ib3VuZGVkIGFycmF5cw0KDQpUaGVzZSBhcnJh
eXMgaGF2ZSBib3RoIHRoZWlyIHNpemU9IGFuZCBhcnJheWxlbj0gYXR0cmlidXRlcyBzZXQgdG8g
MC4NCkhvdyBkbyBJIGtub3cgaG93IHdpZGUgdGhlIHR5cGVzIGFyZT8gRXNwZWNpYWxseSBnaXZl
biB0aGF0IHRoZSB0eXBlDQpuYW1lcyAoZS5nLiB1bnNpZ25lZCBsb25nKSBhcmUgcGxhdGZvcm0g
c3BlY2lmaWM/IEFuIGV4YW1wbGUgZXZlbnQgaXMNCiJmdW5jZ3JhcGhfZW50cnkiIHdpdGggZm9y
bWF0IC4uLiAiZmllbGQ6dW5zaWduZWQgbG9uZyBhcmdzW107ICAgIA0Kb2Zmc2V0OjI0OyAgICAg
IHNpemU6MDsgc2lnbmVkOjA7Ig0KDQpzeW1ib2xpYyBmaWVsZHMNCg0KSG93IHRvIGdldCB0aGUg
c3ltYm9saWMgcmVwcmVzZW50YXRpb24gb2YgZmllbGRzIHRoYXQgYXJlIG1hcmtlZA0KVEVQX0ZJ
RUxEX0lTX1NZTUJPTElDIChleGFtcGxlOiBzb2Z0aXJxX2VudHJ5LT52ZWMpPyBJIHRyaWVkDQp0
ZXBfcHJpbnRfZmllbGRfY29udGVudCwgYnV0IHRoaXMgY29udmVydHMgdGhlIGRhdGEgdG8gYSBz
dHJpbmcgaW50ZWdlcg0KaW5zdGVhZCBvZiB0aGUgc3ltYm9saWMgcmVwcmVzZW50YXRpb24gKGUu
Zy4gSSBnZXQgYSAiMCIgaW5zdGVhZCBvZiBhIA0KIkhJIikuDQoNClsxXSBodHRwczovL2dpdGh1
Yi5jb20vc2llbWVucy9idDItZnRyYWNlLXRvLWN0Zg0KDQpCZXN0IHJlZ2FyZHMsDQpGZWxpeA0K
DQotLSANClNpZW1lbnMgQUcNCkxpbnV4IEV4cGVydCBDZW50ZXINCkZyaWVkcmljaC1MdWR3aWct
QmF1ZXItU3RyLiAzDQo4NTc0OCBHYXJjaGluZywgR2VybWFueQ0KDQo=

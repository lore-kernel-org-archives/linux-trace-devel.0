Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013036.outbound.protection.outlook.com [52.101.83.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C566430DEBF
	for <linux-trace-devel@vger.kernel.org>; Thu, 20 Nov 2025 12:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763641463; cv=fail; b=Nst3PR6y6rtPAkv6qAdrZ1z6JFi6SMtCijVFWObV+fQ4gTHHR40elvAn/mtKlfnGBKcd7pTi+bdxX2CN/JS/D8uAKmgdvk9RZ4il6mm397r8fG37oVXqJcmr3GfdnNndGc61tMDuyvlnVF5UKkfoLI6VyBA9/EdX9mrZ2fc4IzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763641463; c=relaxed/simple;
	bh=vXYUj0AOJ7apr08m/GjoPlUVeU1pkVxY1DpYrKBcx7A=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=G+UXKbWDrJHlBqU4futi30nSs0g73O4fP2eY5ciRljrHmU4qxnSYPPleTYpvrteKAfCIXeJNVLPu4K0KxOnGxaBFIj77iP1MVWLIqiaRrzaUV9zvRf92GqqeP22ejreSE7mVs3oXhOgXBNweizPkj0Xf/JXuS4IScdG33xUPBrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=uL0zBwG5; arc=fail smtp.client-ip=52.101.83.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="uL0zBwG5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lK9cFW5nzcfESjdn2OP9NHp8/ddLN8HypCfRsnKIEJ4UHPuACp4biZDF04wEe30NweuLBkLA4dERP94SZVMhy15m9fPO0ZTgVDTcZgOhy0M5OY5qMunNfktZ5KYOtwQFzjxILy+4mTnGSLaC0dEoksChAM4vqdLf3ahmwA9Vg5Pk+0xCZjvfGF+oIkL/vWMy9frMFaxq1ldCcz+SMdH4YYobLjFwccILcGINWumm77th4Wsy3ANw8MKXbux/mU9NUs9w35ac7irw5QisXIsUSemRDjySymTe+OvX7R0lfW5qa/5/22MrbrS+S6gH01POtrwnihdZ8jiYagAYWPglTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXYUj0AOJ7apr08m/GjoPlUVeU1pkVxY1DpYrKBcx7A=;
 b=gYsdKofFjakPjK7cj8B/uBvMB3FjyACwXQCPIDQCZ4UqSnLgwrsLu9hcjLAwDsEkh/C47rQUx6tRNqkNYLLUEqSpCZXpuzF72VBCdHYaqV3Q9DWHMRdpjzJeoKmwOASBN1eZWDbVZknpEc9CbEGhVzzw0nRjiErPmXwG/6cKcLJhVC42WNaLPK2cnyWwcQY3ztIeFMYmntVP/NfCotOuDBD5bTBsw8avkJ9rF4RKz+WCQVknwb43HpPTs1YcpMI1SQNXyEFxDSkyGGoFk8o56zzx3dH3bJSOWILTKHk/zz0jTJAtBUpbYQF8/8NUKFI2l8mGy2n6nhXEpZQ3hoOrzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vXYUj0AOJ7apr08m/GjoPlUVeU1pkVxY1DpYrKBcx7A=;
 b=uL0zBwG5ni/Vs4ylnKccrRKw5ktq4AVm12lm8KExii0ghOHqKoEGHw4pIdbEfXCH9g87+KSwJxroJVCPHkw748kxpAtJ3rgzYG/j3KvjA7HxehZd6LXKPV+Dii0jQjVWpg8JWWSNWsuSe31ou8UyMVmvzL30NyiDomEvEFaenumYqyYoDrceK532q9yNwuhxdPecKC1fYbLsADcc7dJZydu7dQKX/VwXMloQr5bqjHUTk/tFs4yBpZiA0bezousExQwv6B/jNbbffEozR2oMdIM2bWf8jLhA5HSlIDHwaMhz+bYUfYg0f2G0zZt+C6VaiJSSqMDZR8vJ71QIWRj52A==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by GV2PR10MB9656.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:303::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 12:24:18 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 12:24:18 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>
CC: "Kiszka, Jan" <jan.kiszka@siemens.com>
Subject: libtracecmd API extensions
Thread-Topic: libtracecmd API extensions
Thread-Index: AQHcWhiXNKfmgiYgakarPgqIPdEdDw==
Date: Thu, 20 Nov 2025 12:24:18 +0000
Message-ID: <ee6cc8b90fb0d71f412645d7671b7130d72fecc2.camel@siemens.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2-7 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|GV2PR10MB9656:EE_
x-ms-office365-filtering-correlation-id: c61c323e-bc87-4e7a-0da7-08de282fba58
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VUtaek1SOU1uNFBka29CZ0h0ci9PUmpWZHZTeS9YME9pVzRlSjFFWjZDNUdj?=
 =?utf-8?B?ZEdIQUZvMEFBZnBXS09EZnU5azRQdFg4NVFyTm02V2kxd2Zxd2svdldtaXln?=
 =?utf-8?B?VjBPREFUTG5BS2xMT011Z0FTeUNTVkNDQWM1TGcxRVZKQjIyV0RQT01CWEVu?=
 =?utf-8?B?cXRvK1pyY0JqaVZqUVhTSnJMY0MwOEJNWVEyL1QzNG5mTmIyZTdTRkY4SXVi?=
 =?utf-8?B?Uk5yck9hQi83OW16WFVxTjRtNlFIRDVJNWE1Yk9KNzU3dnEwdVZtMjJLK0Nm?=
 =?utf-8?B?dkErTDh4U0FmTko5UmN4dUlHNkIrR21GeGVqakkxZGt6UUhIUk9ieXpMd3Zn?=
 =?utf-8?B?c2NvcXl1QklwRWJBekRGdDNyM0prUjgvVUI2Z2VrR3I1cnpQSW9KZFBUNGRB?=
 =?utf-8?B?aExDL3djbFg5cmxuVUhmcHBaVUYxeHZEWHpFdUgvNHl0bHdjNi80UFo5eXRQ?=
 =?utf-8?B?Mm1HMlBWb1JBSjNpclpROVg3cGMyOEtxdXUyOXBSUEFMaU81RFdTQ1h5Mm45?=
 =?utf-8?B?SXpKcTkyYWUrTVBSYWVJZlp6dnVJcjB4S1pacytkL0lmajNEK1dQSWZYSUdU?=
 =?utf-8?B?d09DRE90OTZRWWJXQkd6bk9kQWo4dy9Pd3pqRm4vU3dGWGkzd003b0xDb1Ju?=
 =?utf-8?B?M2NrUld0NXRNKzV5dFZNWHkrQUZkQkJFUmZ6b3h4NzJmeVN1OWNta3Q5NS9F?=
 =?utf-8?B?YVFUbmUxYlVlVlk4SVNKQ3NmZTBjK0F3YUFXMHQ2bmFDc2pGbHFSNHhhcVVI?=
 =?utf-8?B?Ui9VUHFtRERxMUZIbUdvaVFkMklsMGhHMWtSYS9RN3IreSt3NWEzS2RmQUl2?=
 =?utf-8?B?TkNGWWI2VGduS0V1NTFJbC9pOUROTFF5YXVQY2JFMkJFK1F2UHc5bUNQYTBO?=
 =?utf-8?B?MUNyWUE4VVBZVG1NaXBPbHV1cFFxalhVdHFtR1BPYTBSMEVHYjNwWWt2MG9E?=
 =?utf-8?B?RW9ZV1ZaN2ZoZFFqSTdML3Nhd2wwakp1eEpiSUtQa3RpL1ZMRm9SaURYTXZP?=
 =?utf-8?B?UmxmRzQ3OTl0U0RsSDFYWjVReGJlS2ZIcGVMbmdrZ1ZtUW5qaXh0YzIyZno0?=
 =?utf-8?B?aTJpbVZpSTFVQ21rYWZUM1IzQXJvaGc2eGZMczJpRFZzT3d0V2NocDlXRjE4?=
 =?utf-8?B?dEx1MW8vWEFqM3FrMjlLS1V6OGlJMzdhS0poUFltWlZqV2xMaWQra0VUK2VC?=
 =?utf-8?B?OWNPZ0lNTEI4QWFUeXpRQTB6LzI3cml5NDRHM082L09NSEVCL0luM1NjWlBB?=
 =?utf-8?B?a0o1N1g1QjUzS0NxUVA5VkxCOXZMb2Y1cUJqclVvbzBhaVpsQXRvNDJaRksr?=
 =?utf-8?B?R212eklkS0VkTVJwZjVWQmhzeXcxd3o3Z2tBQWszellQdVFXUUtaSlQ1akpW?=
 =?utf-8?B?ZGJLbXZyMCtVYk5Ca1hZMXhRaGxmQmc5ekhIQU9JVmZZRCtKTndDMWxBUW9h?=
 =?utf-8?B?ZjU0S2ZvMHVVbEJXT1JXdWFlWjNHb1RnM2VTNTEvRnZJQnZSMTRDTk5wY2F5?=
 =?utf-8?B?UGRxVFpaNElEQmdsNFpZeW01dkI3SGJhaGh4YklMRVN4M2lCQUVLaUdVSUVz?=
 =?utf-8?B?MGJuUHNiNFZYd0lYZUZXMGdMZisxQ2lVRGk4OHFJYVoyRW1IdzBDbkJQeHJo?=
 =?utf-8?B?clV0U2UrTTZKeTFCV3U0OG5MdmFQR3ltTGxvQVVRbGUzeFZDdjdTZmthdWVQ?=
 =?utf-8?B?SUtTUUw0UkJlNmlWS1Z4Y2pzcW44YTh1UzFDSk5WN2U2YmNGWGxqUHI1d1Jo?=
 =?utf-8?B?M1pWNlRIZmpVQ0xDLzZ5L1d6cGN0NFk4SmN2MjRlNklpTHhISndXL3RraFoz?=
 =?utf-8?B?WktMWGszR1RmR2hqaFhYTzNQcnpOSkZiM3BVeG1CaDlvVTBrYlFvUk9jZXZt?=
 =?utf-8?B?RUcxdEZOWDVSV1U1a1FOeWgrYkEzYTdYaWYvMFowZjZ1YWNkdjdSVURTVEF5?=
 =?utf-8?B?OGUvb1dRQXR4Yk9oVjRrSzB5OXExbldWQ0hGL2xMUzkyaytpd3dla1I0UitO?=
 =?utf-8?B?UkJ0UEgyUXVqR1cyN0hWb3ozUWFrZ2hDU3VoS3FWelZNMFhMSzg2T1ljeGhE?=
 =?utf-8?Q?ybqary?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YkdnVGowRGhQUVpBd1NBaEo1ajRrSm1Gd2FJMS84ZkRpamFhRTE1ejVSM3Ur?=
 =?utf-8?B?ZFJmZysvUHF0OFVBMTJpbmtSRnVma0txS1hsRmtsZm9qZWorbHJUZE9qRG1J?=
 =?utf-8?B?NUlTZ3dDa0NkT3lWLzhkdHgxN3VreCtCWGdHRU90T0FRMWNZdXJvYTdyRHFY?=
 =?utf-8?B?bVVVMmFJTkRQWjBKRGJVSi8wdzg5S0dwTGk4RGhsalhmYmNoWWV5ZnJKaTVv?=
 =?utf-8?B?UlRBY0EwUHBlTTU2eWRSaUFKWld2SUtsMmhNYzEzZ09PYXhHRFYwWVBONXZ6?=
 =?utf-8?B?SEt3eU5MRGxTZTR6L0tvZVdBTVM5NERHMmFXNnFlRHJ2SW5oeWc3NkZkcS9I?=
 =?utf-8?B?MGNZMVU3WGNpYjI4TEpsWmQ0bDUzbWxmVGNiN3duU3dTT0ZXYUxvbmZoV2pv?=
 =?utf-8?B?aWdhakhqUi9SUWIzL0pjQ1FQTVJkSC84WVBoTHExSmZCMk50WnpGUmJ4dk9R?=
 =?utf-8?B?THlBYW9Xbm5DWXY0OUY2SEgxN1lUaTVnVi9yUC9zQnlVMHpRV0R2U25oQ1pK?=
 =?utf-8?B?bFhrTEViVCt2OCtwcEVjTW1NV3EzT3VnUTZwb1g2eTZMNC91QWdOeWw2eGRI?=
 =?utf-8?B?ZjcyVlVGTHZRaGZ0TXJFTGVHZFM0MDA5bVJyL2dHSlBLT0Y2c2phdVdUcTZB?=
 =?utf-8?B?cnVVOHR5SnBNb3phbS8zN1U1d2ZKcWFTQnFkN29ra04vY0Q2Y1N0d3BRZ3VD?=
 =?utf-8?B?MXlneEt6empPNGhzZ2ZZOWllcEVTY3NpMnRWZ0x1WHJNTFJlUTN3c0xITmVX?=
 =?utf-8?B?ekV5eEV2aUFHWFR5SzBpbnlFc2xOWTJOUEw4aDFtVnBTVG54Sjg1YWUzeXI4?=
 =?utf-8?B?NDdzRnRncW45cE9ZVTRpZUJkb3dVVjJWNUtDUi9OSlZ1RVpoZHNQd1JkT3gy?=
 =?utf-8?B?clllZzFiS29xckZTamZ4QWVUZW9KYVY3TVppRXRaZU5RSVhvWG1pOTFRK1dZ?=
 =?utf-8?B?U2pJRUROVlNwZEYyNWxjVUpRM2t5bmZ3SHFWdW03N25tbmhXR2tEVk02VUNh?=
 =?utf-8?B?VGErZjdxa3RFYmhlTVpBZEhLbHVUVGxuM3lRelZCWmhPVGRadkNXNzkxYW8x?=
 =?utf-8?B?RTQzeTN2TDBGQjVaczF3bzB5Sm9JM0VmcG8rUW9LK1pkaWgxSGdCNDRHMVps?=
 =?utf-8?B?emFMOHE0d3FRcmNJazdTYWNpYndoR1Nsa1M3UDRyL051WDNJMzExeDB5Qm1l?=
 =?utf-8?B?OTNLVExoQkhXOEpiM3l2Vkh6ZDJRS0J0SVBRZ1pUajBVWW9QQjNlL2dpTEpF?=
 =?utf-8?B?WjNkSTdDTmFQVEdnMDZhRTVaSklzcDd3bWxlNUlFbDZ3bWNsMmEvM010TnpK?=
 =?utf-8?B?M3Rsc2xwMkQwbXJGcEZMTUN0bEE1SjJxdnkxLzRVbGRXdDhqeHVQMVYwZkJD?=
 =?utf-8?B?TUNSRW8zYzVLNUNzWmYzZ0YyREhjc01Ya3VaS08veUxBWVQ3a0pFMDBOdXdn?=
 =?utf-8?B?Qnd6aU94dnZubEtqa3Z6ZmJicHlEaVMxeGdRMWpTZVppMDB6eWp0VlpGbDQ3?=
 =?utf-8?B?UDZERFpFTmJOZm1yTmtFY1hBSGwzQlNKNDlNaDc1ZE12MEg5OGUrUnhjc0lK?=
 =?utf-8?B?MWlJUGVUMnlxeXRET1N6Zm9DUnlkTUtCdG95cmFRNlMxM0YwYjV2MTlUZlhI?=
 =?utf-8?B?bUdqRHhpeW10ZEtvZW9xM1VCUlN0L05oWFZnbllQOGhCV0ZtcjUxNzhJbjhN?=
 =?utf-8?B?TEFzY0dEUVBRazN0eXFyUXlmZEV5ZHE3cFB4MWxEWmZVY0JIaXJhSWJzNnkz?=
 =?utf-8?B?Ymwra1Z1c0RoK3B1a3JsbzVpbEcySWhEbkNRWWE3TTJVSjU1NDR3YmEwTUNP?=
 =?utf-8?B?bUpCcVZiT1pMQmtHNW5VZ2hXVGs1VVQrcU9WNDBWOXJ0bXJ6dXcvNnVkK0Jq?=
 =?utf-8?B?Z0NhM0NxbWlyanhwaTF1MmhBakZ2MStKbVVaODMxQ0dRWEVxMUFUQzN4ejZC?=
 =?utf-8?B?bFFtcGZmcS9tTlhrTnNmbW5yK1grNFYvTzJlUUQ4RFNzY1pJT3JiOGtBejFs?=
 =?utf-8?B?ajN3QnRpc3pMbDExdmpUVkJwcmZxZTl0Z2tqMXlLQy9wNmkwNzRQNUpuTmFF?=
 =?utf-8?B?MWxUdlBVa1RIYlI5QStoU3g2Vi8rTmdiWkVJVklBUW5mTk1DLzBLeHJXNEVR?=
 =?utf-8?B?UWhCa0N5S3BlSnp6UlhKMTZpaXI5L1ZsZ0oyNGh0VytyTVhpVVhRY0hKRHZW?=
 =?utf-8?Q?jclyCVfoxVf/SeSqRxBQR3k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAABC5235E308C4DA7219E8DEFEF78F8@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c61c323e-bc87-4e7a-0da7-08de282fba58
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2025 12:24:18.7409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rYoHSFsFe33UZ+qkY6bK56NDOhpuiu2mnoL2kqD5yOvoJ6B4fLRPRmoDCk8Xc/C3ws1HY8+MCHGMcM6HItIrxrhHELtPNxuYtvM5a3mduYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR10MB9656

RGVhciBUcmFjZXJzLA0KDQp3aGlsZSBkZXZlbG9waW5nIGEga2VybmVsIGZ0cmFjZSB0byBDb21t
b24gVHJhY2UgRm9ybWF0IChDVEYpIGNvbnZlcnRlcg0KWzFdLCBJIG5vdGljZWQgYSBjb3VwbGUg
b2YgYXNwZWN0cyBvZiB0aGUgbGlidHJhY2VjbWQgQVBJIEkgd291bGQgbGlrZQ0KdG8gZGlzY3Vz
cy4gSW4gZ2VuZXJhbCwgSSBhbSBWRVJZIGhhcHB5IHdpdGggdGhlIGxpYnRyYWNlZnMsDQpsaWJ0
cmFjZWV2ZW50IGFuZCBsaWJ0cmFjZWNtZCBBUEkuIFRoZXNlIGFyZSBncmVhdCBsaWJyYXJpZXMg
d2hpY2gNCnJlYWxseSBoZWxwZWQgdG8gZ2V0IHRoaXMgaW1wbGVtZW50ZWQgZWFzaWx5Lg0KDQpU
cmFjZSBjbG9ja3M6DQoNCi0gSW5mb3JtYXRpb24gYWJvdXQgdGhlIHVzZWQgdHJhY2UgY2xvY2sg
aXMgYXZhaWxhYmxlIGluIHRoZSB0cmFjZS5kYXQsDQpob3dldmVyIHRoZXJlIGlzIG5vIHB1Ymxp
YyBBUEkgdG8gZXh0cmFjdCBpdA0KLSBBIHRyYWNlIGNsb2NrIChlLmcuIG1vbm8pIHRvIHdvcmxk
LWNsb2NrIHNuYXBzaG90IGNvdWxkIGJlIGFkZGVkIHRvDQp0aGUgdHJhY2UuZGF0IHRvIG1vcmUg
ZWFzaWx5IGFsaWduIHRoZSB0cmFjZSB3aXRoIG90aGVyIHRyYWNlcw0KDQpNZXRhZGF0YToNCg0K
LSBzb21lIG1ldGFkYXRhIChsaWtlIHVuYW1lKSBpcyBhbHJlYWR5IGluY2x1ZGVkIGluIHRoZSB0
cmFjZS5kYXQsDQpob3dldmVyIHRoZSBBUElzIHRvIHJldHJpZXZlIGl0IGFyZSBwcml2YXRlOiB0
cmFjZWNtZF9nZXRfdW5hbWUNCi0gZnVydGhlciBtZXRhZGF0YSBsaWtlIGEgZnVsbCAidW5hbWUg
LWEiIG91dHB1dCBhbmQgL3Byb2MvY21kbGluZQ0Kd291bGQgYmUgaGVscGZ1bA0KDQpFdmVudCB0
aW1lIHJhbmdlczoNCg0KLSBpdCB3b3VsZCBiZSBnb29kIHRvIGhhdmUgYW4gQVBJIHRvIGdldCB0
aGUgZmlyc3QgYW5kIGxhc3QgZXZlbnQNCnRpbWVzdGFtcCBwZXIgQ1BVIChJJ20gY3VycmVudGx5
IGZ1bGx5IHdhbGtpbmcgdGhlIGV2ZW50cyB0byBnZXQgdGhhdA0KZGF0YSkNCg0KUFM6DQpXZSBh
cmUgYWxzbyBsb29raW5nIGludG8gd3JpdGluZyBhIGNvbnZlcnRlciBpbiB0aGUgb3Bwb3NpdGUg
ZGlyZWN0aW9uDQooaS5lLiBDVEYgLT4gZnRyYWNlIGJpbmFyeSBmb3JtYXQgLyB0cmFjZS5kYXQp
LCBidXQgaXQgbG9va3MgbGlrZSB0aGUNCmxpYnRyYWNlZXZlbnQgaXMgYSBwdXJlIHBhcnNpbmcg
bGlicmFyeSBhbmQgY2Fubm90IGJlIHVzZWQgZm9yDQpzeW50aGVzaXppbmcuIElzIHRoaXMgdHJ1
ZSwgb3IgZGlkIEkgbWlzcyBzb21ldGhpbmc/DQoNClsxXSBodHRwczovL2dpdGh1Yi5jb20vc2ll
bWVucy9idDItZnRyYWNlLXRvLWN0Zg0KDQpCZXN0IHJlZ2FyZHMsDQpGZWxpeCBNb2Vzc2JhdWVy
DQoNCi0tIA0KU2llbWVucyBBRw0KTGludXggRXhwZXJ0IENlbnRlcg0KRnJpZWRyaWNoLUx1ZHdp
Zy1CYXVlci1TdHIuIDMNCjg1NzQ4IEdhcmNoaW5nLCBHZXJtYW55DQoNCg==

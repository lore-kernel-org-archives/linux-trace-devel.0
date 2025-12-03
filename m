Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011035.outbound.protection.outlook.com [40.107.130.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8316C2DC776
	for <linux-trace-devel@vger.kernel.org>; Wed,  3 Dec 2025 11:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764760839; cv=fail; b=Z2rgt+UTpW7ItB9rXyMaglkIr7kPXTOlNSGs57YRt4If/8gJPnv+ftSa/BaPLz1fO4OVOnLUTD33VL4AnUym82Po5Fbeacbhog5FpbokBCVjvwOhiJ0LwtAuCq2RsDdS1kAsYqvgh0awhfOQ8j/RISv6X4pipykOidVeKTMM++o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764760839; c=relaxed/simple;
	bh=qbGAFaf7QUbw5Quu3y4wQuYfHfey9Tl9opJWmHAHz6M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DhISlWFUUYAZ5rA8ZFyG9uIUIg5pN/2So1FQeGxw6TfV5MI/n5EnXT23cY/7V6mSFCNJTjJ/egqsi+/jLDIB+daUbocPYEudJotG/7iFLTsipnSdnmRqAsFG1bSpEHCHxPN5M55BGzHmF4iQKH7k1/i6p5JmIMQftnwyl5/5PZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=r3p+uYzQ; arc=fail smtp.client-ip=40.107.130.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="r3p+uYzQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDEerQ0cBUoc5uzCQttom7rrLZOUmYT++HBGzNjeJvh8cpWZ/4N8b2MfzKlylfGSMm3JgWWNtH+tfhc2T4IibG7BmAjKjLOMjFMX/nw4LBeBCf3x3OfUF2lc5KXBrHqBLHseiXdiTx7tkdwwUviYeXQBImceQ6I2zJPTc0GWUYeOi1OQnomxbOSjv2ImhDp2Nqsk1Pl08RVMzuVN70/lMo+YkwtFgKrp4mp3fLZqLh+bnxw3XFRn6Wfnd2DL4aQnBE1v5/f1hOvg9oJLe5eDgOQnvGkBkjiaFcz6WPlrIrvfi7EQ0iIyobEWM+cv3iPBBgs4lCjNqMXCiNbmBqTSkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbGAFaf7QUbw5Quu3y4wQuYfHfey9Tl9opJWmHAHz6M=;
 b=WcUshmwZ5n2BP/W7Ezpvgfj7W+hgRwQ8a/rDXp0+vGg0x0pKITGJXrbvkHNkUMryVEXGZ2EJN6Yd/FYxcQy3qTYcg474lDHuO1oM3O8bx0i2BGTW0IdRfP4KL/C/0lSn26n4wqz4dsODi6GRTHFiSTp7bAmEgiiW4fEydh/tHUxrJcmnNgivlW46ZrPisKibqkzt+m8+tkc9e04T2KHhKNRZp3f0Nm26rU5U1kOXd6bcdsTx+MESKD6Lm8Im/RUYBbDzYUIniVeDynSofwxzwuJ3YG+exgCRS0bHGtCTctWbd0PbPUsqMdxaHqrQZ3VXUo+VNjreZZuNBnQn3gMkyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbGAFaf7QUbw5Quu3y4wQuYfHfey9Tl9opJWmHAHz6M=;
 b=r3p+uYzQah6pZSi+fpAIk45jJwS7kd0Nd2fzCaYDjLKLpXgF0Fj3OuYVCLXJoKDI4zOHoHTBAUPNvBSaDrWLe/mIQhOX7216QbY8XlYAP8p0/cSuvqsy174S1I8djZ6COj2HmWzUYdVRhAHpkZQAuCYnyyic2qEr/tsfg7ZeDZAL7xPi5l7W69RSEoyfpFv7NgD55L1CMMooV+Qm0ptMhC11cdopkKaS8eNtpo4XCLT7xqIfQbz+AQ4kBZChQdjnDtmQG6WoJOIMv6h70ISQogH+yFkDvqXWKbFppeCKEo+eeQwesIPG/YTas6hZzv/MlH2JoAhjxJtnjaxLGaodOQ==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by AM9PR10MB4039.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1cd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 11:20:34 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 11:20:34 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Kiszka, Jan" <jan.kiszka@siemens.com>, "Poljakow, Andre"
	<andre.poljakow@siemens.com>, "linux-trace-devel@vger.kernel.org"
	<linux-trace-devel@vger.kernel.org>
Subject: Re: libtraceevent | API clarifications needed
Thread-Topic: libtraceevent | API clarifications needed
Thread-Index: AQHcYtiM0Nrfnwz7QkWWTdAr1YLoF7UOiuaAgAE9FIA=
Date: Wed, 3 Dec 2025 11:20:34 +0000
Message-ID: <a22fa13aad752c43c927ab42b71d8e9caf7bf573.camel@siemens.com>
References: <7ce07a566354a6d2233e231a6a7bc760447c7547.camel@siemens.com>
	 <20251202112539.1e042264@gandalf.local.home>
In-Reply-To: <20251202112539.1e042264@gandalf.local.home>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2-7 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|AM9PR10MB4039:EE_
x-ms-office365-filtering-correlation-id: 79ef4e38-6a33-4893-6182-08de325dfa22
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WDhGS3pmdUo0WWtsRVhkWUFPSUt0bVlHYUtXaHZNajhwTnA0UThHb2dIKzU3?=
 =?utf-8?B?aFJvN1FGZ0lWbGxlWUo1YjVvS2tHRlJTaEZjMEdyR1dMa0lvNDlTSjRpM2V4?=
 =?utf-8?B?WVZrem5IQ2ZWK3VTV1pFYk5xTzBOM0hGSEF5UUtqSDlqdjJkazhpSldwWWZi?=
 =?utf-8?B?WmQ5UDZJRkxWbEZianhTMWNXcGQ1YU14OHAyWlhFTGFwdkV3SUlnbW1IMEJ0?=
 =?utf-8?B?MElPaGs5UFRiUGl1M2ZmVW85dCt2OVZndTRFR1M4cEVqYkh1T2pMLzlkR1c3?=
 =?utf-8?B?Z2lBZVhnMjN4dzNJUm9rUXh2OFY1NUxOZVBETXlnTWpKUkxjUXkxVkFYQThj?=
 =?utf-8?B?R0kzTVRuVThRcGlNVzBlRkQ1Y3RLYy9WMDI1TzNJUHpkblRXbVdzSGVWc014?=
 =?utf-8?B?d0xpUnFCTUlJNWpzUHNTNU5IemtGWXZKUllMWWpxSUg5YlNvTFFtMzdVZ3BM?=
 =?utf-8?B?ZHZ3aUZEQkkxczZjRE9GaFZFdkFkaXY5SWdpNUhBN3Y3dUdsbG5keU1Rb3lL?=
 =?utf-8?B?dTJiYldHYmFpTU9NbEw2NW43WXdTMGNZNEZCYWZ5T0l1bXRJNXdpa20ybE9F?=
 =?utf-8?B?Y0dlcDVwdTIyU0Frems0NXU2cTdvc3ErY0tZRGE1cHRwVmdxS3RWOXNoekV0?=
 =?utf-8?B?bzYrWGdHd2llWWlMY1RNY3lOYU5YSnZ5THNCVWJySTR4U1ZZTTgrWElUZkRR?=
 =?utf-8?B?Z2R4STlMd2YxTHRCblE3WFk0TFowVDdaM2plVzRxU1hRRFNJUFNtMDFRN1dC?=
 =?utf-8?B?bzRHNUhvM2pEbVY3V0ZVYkJvY2xhR0lrWmJpS1BERUJhSkIwTUpHWENSUXhv?=
 =?utf-8?B?U053d1Jia0xoK0tJQkNwZFBrc0laS01XVWkwbyt5SVhGeUNTZkVDbG5WVkxw?=
 =?utf-8?B?ZTYzeDUvUnlpODRtU25GTENCaWNXVitMcmw3b3dnRGMvSVVHNEV0L3dneGhE?=
 =?utf-8?B?YUxNSWFZMWU0SXVtRnkvOHc2YUkzbFhNU3NPcFREMzNPWGpEMnR2RGtyQ2Ew?=
 =?utf-8?B?UDlZazBUNjJHemZZelhrNFZ0ajF6NjBUb3J4TWxpS2U3dlFoVXdFVUVRUklO?=
 =?utf-8?B?WjdNOUFoOFQ1cXZmOEpuaW4ra21SMXdMRzNtL2pYZTlJYWhtclFXMWMyT2hW?=
 =?utf-8?B?dXhlTU9SdjJEVnRnZDBXbWlsdUNVSHhiVmhzUUEzQWU2dnh0RW44Y2lla244?=
 =?utf-8?B?eCs0UmhuTEowQkFra0dtUHl1QjlDbXMwRE92c0FTejl0dVQxTzBMbkxLOWJW?=
 =?utf-8?B?SEcxaldHU1JqSTltbDVLNTYvVkgrNDcrQnJmMHBKRkliSXc0amNPSitNdVli?=
 =?utf-8?B?Q3FHVjFLY2YrY0dLQUpqUVRIZXAycnhxVkk1ZDV2QTZHbjJwUC90c280cjY4?=
 =?utf-8?B?ZHBjTlQ1Und1WVppSUhkSHQ1Ym9sYVU5VzVWZkZCb1V0L2lLelNuNkdweXV3?=
 =?utf-8?B?Z1NocndQblV1UkxlN0dYdzRVaEk3WjVMSGxkODNTRkFlK25xWFlaN09NWnNO?=
 =?utf-8?B?THZUQWlrTUFQSmN5QUl2azcwaWlVUjhTNTg5UDMwT1hjWFNGME5ja1dQNHdB?=
 =?utf-8?B?bFBtaWxYbVV0c1Q2ZHpiYmUxc3BIU0w3Q2VRNk9JOHpPWHdoSXRERldsd0I0?=
 =?utf-8?B?d01yZzNuU05tQUpJNjhTeTlncmFGbDRLQXlrSEVJelVPcWFMY1NFUmk1V0h5?=
 =?utf-8?B?S3BPUFNCLzZiVVg4eDZ3OVEzekQwcjFtUHZqb1JQd3o4cXhwUlBDTCtnbmFj?=
 =?utf-8?B?TkVHanQxbld0NjRycHE2bmE2VngxWjJFdTE4blhGVCt6QzZMNVhUM3licXpH?=
 =?utf-8?B?RzdneWExN05hMEdJQU4vUTNoRzBjRkkzdjNtOFJnak1vRFZuYStkQjRnekEx?=
 =?utf-8?B?RmM5UmhxYlpjYm9XYTlrMjJlakN3Nzl3REo1d0haaXVERUM5R0xkRWxUZkxk?=
 =?utf-8?B?ZCtNb0xNejRlZk5XRGxsc0Q5ZEk4NzVsY3VoSTBXeFl4MFk0aWluVnFLOVFx?=
 =?utf-8?B?bUkxcm1idlpKdkhHdTBwOS82ZDBEYzdpWmZXNGpLZTVWUisydFFPcE84N3JQ?=
 =?utf-8?Q?YPTjLg?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T3dLaVlCc1VsQ01IQ3l0M01IT2xNSkVwM2NWaGpHd0JpL1JTYlF2MjdhSTly?=
 =?utf-8?B?QUF1VXhFVngyN0M5Yzd3UW0ycm4wZXBCeXVvdGR6SmFSZkdhWmZtU051NmJp?=
 =?utf-8?B?bjJ0azQ5Sk1qTTZDMTFYQ28vNE5aVzNKSm9FM25NbGhiNzl5b3lzUU1iaTJE?=
 =?utf-8?B?MXJVU2phR3ZCRWpja3lGalphU3h6MDM5OFpXTlduM2VHdHFTQjBVTy9SK1Bn?=
 =?utf-8?B?YzdPNzZHdVN3QitvdXo1N3hjRzJMOFBnb3Bza0RTcVl5bVBBSXFFc2l1clRV?=
 =?utf-8?B?ZkdkS3Z3dTBwZzZHVW1PcDk4REl2TmUzMlBlbTZGRGN2NWFrdGpBU2RQSkJw?=
 =?utf-8?B?U0dEWmZyUS8rOGg0R3VmM1hNUDJ0UzhPRFliOHNEQjl5TC9QSkRVQ0UxSVJV?=
 =?utf-8?B?RXNXNWxPUkU4RDBmZUpWUEMycmlzV09YbCs1NUtJYUY2K1FaSmI4eVl6MldZ?=
 =?utf-8?B?YXlGZzlORjl2R2xtVG5PNzJRRHFSQXE5ZUdlN0IvZUZHYVNRaHJQN3d4T0F3?=
 =?utf-8?B?YUFJN3gxWGdacXVuQUtKbGpTYWVDUVBaOGRUbWNveVIxaEErOFUwbmxBV3Zx?=
 =?utf-8?B?SFVVUWVnMTQ2UlJJSXMySFhDSys3RnBKaVlTMm52T0dhdTFMVkZaV1JQYVRP?=
 =?utf-8?B?RVh6Vis2TDMxdkdmOWxzbVIwdkx5aUpVWkNFdFRrT01neVI0L1BHQVpRRTBX?=
 =?utf-8?B?b2VvMTVqL1M2Rnl0T3JoZ0ovd0VUd2N3b0pJRHNpdzA5YU1RU0VRNWMvelNS?=
 =?utf-8?B?eHZvUmEreWFsZURBMmtCT3c2ZnZLR1pFZWlLUFpJYzJtQW1NVFVqa05oSWF0?=
 =?utf-8?B?ZlYxdXNqcm5hbTRZTU9UVU5XWk1ZWGFjTEZpZjVVcml2TVlqK3hRSFRuS2xW?=
 =?utf-8?B?dEViS0lVN3NXcVRxamdVYVZmVkkvQTljVFNVamRWZFhlRXJXWStwSGtSWmNU?=
 =?utf-8?B?RDFncEJscTRiYm1WL2RTcmV2MmJDQ1MweE4wdEdaZi9Tc1pYNDROTHFoT0pm?=
 =?utf-8?B?L09ucGJyUTlUME1yV1ZoREZIM2dEd3Z2NG8yZDIzOXlSeFhYTng0ZXdoNHkz?=
 =?utf-8?B?UFQ2M3c2SWlXbXFoTU9IUkZQcmFMSnR0OVAxQThlemM1dEx5U1BzYUJBbU43?=
 =?utf-8?B?Ty8rWDNGUGVJYWMwVW9ydy9OUTlwQ296cjFJVlY3bU1TUEUrS2pxLys5eXpm?=
 =?utf-8?B?bENncjVyRGdoN2NFdVZHOW5MN1FhdHh0b05FYTNWN0hSUXl0cmpsV1hZNWpI?=
 =?utf-8?B?R29wRHpNMHVxK0xPemdlU3FxcC9zaGR3c0FpTmp0eitpSWFrS1ZHWjBaeDRk?=
 =?utf-8?B?cjlRYXdERUFHd0IxVEdGellRYk1SQ3N5SFVSdVpzckpUeDFyMHl3V0REZjEz?=
 =?utf-8?B?SUxhRExpT1lwZUIwQzlhdlAvSmZDVWJrdWhDQm9VRGpWZEhUTjAzc2JyNDI0?=
 =?utf-8?B?ZVUwUWc1UUlDc08xR09leG1jbEt3d3NOYXIvcTQyUkxtbHNoUWx1NnpYbkY3?=
 =?utf-8?B?OG1BbkVjZWhhbHVQcklsb1pERVI5WXgxL2x0UmlWbG5Sc0xmbnhoWkZRM2V0?=
 =?utf-8?B?S1h0U0NBWmpWOVpEVzdmelFmaTQ2enB6WFo3eVpvdGxjSThWK0xXWEtMNDFv?=
 =?utf-8?B?MFBwQTY2dFRJM3VvU2tXclJCR3RyWDN0YXJvdEFKZmxQZHhtaVFWNHNEVXVz?=
 =?utf-8?B?ZlJ1QkNWNm1wM1VDMUZ0SEFSZ3VXaVJwR3YxTFB3d1IrVnBuTEhvVVgxRU55?=
 =?utf-8?B?UTlmTDV2eGR6VVkxSkRvc3lyVW1kUWtvVjdFY0hGSVVZWVVGcVlYS3UxcEJp?=
 =?utf-8?B?Y05qb3FONlRyQXFqL3Btd2NXUjN5TDhCelZtdldKR2RaK0E0eGVIQnBxZXpB?=
 =?utf-8?B?cGdUMUFQYUZOaDlRcTdBaGxGam9ZMDR3Y25wUmxkeUIvUzFqWVVoNXJrWXNw?=
 =?utf-8?B?cDZJMGZLU0w3eGUvdVp5UkZ2WkowTUlaOERPelY4dWtCZzVwQ08xMVlFWUEw?=
 =?utf-8?B?MXJoUXowaWxnVnp5bjROY1dkajY4K3VDN2NoSm5OdHM5Z2t3eVE0N0Fmam1I?=
 =?utf-8?B?c1JNYzNFMmk0WTArTEpHSm9xb0pHV0NWL2lFN0xtQ2hSeWVKSFhQRlluYjBH?=
 =?utf-8?B?cTFwVEYybkYyc20vU1pWbVAyc1BkZVI3ZnIyekhrbDRTQ291QUZqZk9sN1pR?=
 =?utf-8?Q?8q/t0yrkAPXowspEl19J7No=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7ECDBA2605032408378895AE60538FE@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ef4e38-6a33-4893-6182-08de325dfa22
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2025 11:20:34.2882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Phy41HK0x2EQl88NGvvtQIOknL55u4hZZVRNB4nVBZ7ITn3XnDX968oX0UdIWurH/pgFFyLLJC3NAjgZ44gXr+9Xt29YZ44oBsmV0Jrxm88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4039

T24gVHVlLCAyMDI1LTEyLTAyIGF0IDExOjI1IC0wNTAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gTW9uLCAxIERlYyAyMDI1IDE1OjM4OjMyICswMDAwDQo+ICJNT0VTU0JBVUVSLCBGZWxp
eCIgPGZlbGl4Lm1vZXNzYmF1ZXJAc2llbWVucy5jb20+IHdyb3RlOg0KPiANCj4gPiBEZWFyIHRy
YWNlcnMsDQo+ID4gDQo+ID4gd2hpbGUgY29udGludWluZyB0aGUgZGV2ZWxvcG1lbnQgb2YgdGhl
IGZ0cmFjZS10by1jdGYgY29udmVydGVyIFsxXSwgSQ0KPiA+IG5vdGljZWQgdGhlIGZvbGxvd2lu
ZyBpbiB0aGUgdHJhY2VldmVudCBBUEkgdGhhdCBuZWVkcyBzb21lDQo+ID4gY2xhcmlmaWNhdGlv
bjoNCj4gPiANCj4gPiBoYWxmLWxlbmd0aCBzaWduZWQgaW50ZWdlcnMNCj4gPiANCj4gPiBXaGF0
IGlzIHRoZSByZWNvbW1lbmRlZCB3YXkgdG8gcmVhZCBhIGZpZWxkIHZhbHVlIHRoYXQgaXMgYSBo
YWxmLWxlbmd0aA0KPiA+IChpLmUuIDMyIGJpdCkgb3Igc21hbGxlciBzaWduZWQgaW50ZWdlcj8g
Q3VycmVudGx5LCBJJ20gdXNpbmcgdGhlDQo+ID4gdGVwX2dldF9maWVsZF92YWwgd2hpY2ggcmV0
dXJucyB0aGUgdmFsdWUgYXMgdW5zaWduZWQgbG9uZyBsb25nDQo+ID4gKHVzdWFsbHkgOCBieXRl
KS4gVGhpcyB2YWx1ZSBjb250YWlucyB0aGUgcmF3IGJpdHMgKGVuZGlhbi1jb3JyZWN0ZWQpLA0K
PiA+IGhlbmNlIGEgaW50MzJfdCAoLTEpIGlzIHJlcHJlc2VudGVkIGFzIEZGRkYgRkZGRi4gSSdt
IGN1cnJlbnRseQ0KPiA+IG1hbnVhbGx5IGNvbnZlcnRpbmcgdGhpcywgYnV0IEknbSB3b25kZXJp
bmcgaWYgdGhlcmUgaXMgYSBiZXR0ZXIgd2F5IG9mDQo+ID4gZG9pbmcgaXQuDQo+IA0KPiBGaXJz
dCBJJ2xsIHNheSB0aGF0IEkgYWJzb2x1dGVseSBoYXRlIHRoZSBsaWJ0cmFjZWV2ZW50IGludGVy
ZmFjZS4NCj4gVW5mb3J0dW5hdGVseSwgaXQgd2FzIHBvcnRlZCBvdmVyIHRvIHBlcmYgYmVmb3Jl
IGl0IHdhcyAic2FuaXRpemVkIi4gQnV0IG9oDQo+IHdlbGwsIEkgaGF2ZSB0byBsaXZlIHdpdGgg
aXQuIEkgd291bGQgbG92ZSB0byBjb21lIHVwIHdpdGggYSBuZXcgaW50ZXJmYWNlDQo+IHRoYXQg
d291bGQgbWFrZSBhbGwgdGhpcyBlYXNpZXIuDQoNCk5vIG5lZWQgZm9yIGV4Y3VzZXMuIFRoZSBs
aWJyYXJ5IGlzIGdyZWF0IGFuZCB0cmVtZW5kb3VzbHkgc2ltcGxpZmllcw0Kd29ya2luZyB3aXRo
IHRyYWNlIGV2ZW50cy4gVGhhbmsgeW91IQ0KDQo+IA0KPiBZZXMsIHRoZSBjYWxsZXIgb2YgdGVw
X2dldF9maWVsZF92YWwoKSBuZWVkcyB0byBrbm93IHRoZSBzaWduIGFuZCBoYW5kbGUNCj4gdGhl
IHJlc3VsdC4gSG1tLCBJIHdvbmRlciBpZiB3ZSBkaWQgbG9vayBhdCB0aGUgZmllbGQgdG8gZGV0
ZXJtaW5lIGlmIGl0IGlzDQo+IHNpZ25lZCBvciBub3QgYW5kIHNpZ24gZXh0ZW5kIGlmIGl0IGlz
LCBpZiB0aGF0IHdvdWxkIGJyZWFrIGFueQ0KPiBhcHBsaWNhdGlvbnMgOi0vDQoNClRoZSBpbmZv
cm1hdGlvbiBpcyBhdCBsZWFzdCBwYXJzZWQgYXMgdGhlIGZpZWxkIGZsYWcNClRFUF9GSUVMRF9J
U19TSUdORUQgaXMgc2V0Lg0KDQo+IA0KPiANCj4gDQo+ID4gDQo+ID4gDQo+ID4gYXJyYXlzIG9m
IGludGVnZXJzDQo+ID4gDQo+ID4gVGhlIG9ubHkgQVBJIEkgZm91bmQgdG8gcmVhZCBpbnRbeF0g
dHlwZXMgKGFycmF5cyBvZiBpbnRlZ2VycykgaXMNCj4gPiB0ZXBfZ2V0X2ZpZWxkX3Jhdy4gSG93
ZXZlciwgdGhpcyBqdXN0IGdpdmVzIG1lIHRoZSByYXcgYnl0ZXMgb2YgdGhlDQo+ID4gdHJhY2Ug
YnVmZmVyLiBEb2VzIGl0IG1lYW4gSSBuZWVkIHRvIHRha2UgY2FyZSBvZiBlbmRpYW4gY29ycmVj
dG5lc3M/DQo+ID4gQXJlIHRyYWNlIGJ1ZmZlcnMgYWx3YXlzIGxpdHRsZS1lbmRpYW4sIG9yIGlz
IHRoaXMgYW4gaW1wbGVtZW50YXRpb24NCj4gPiBkZXRhaWw/DQo+IA0KPiBDb3JyZWN0LCBpdCdz
IHNpbXBseSBhIHBvaW50ZXIgdG8gdGhlIHJhdyB2YWx1ZSBpbiB0aGUgZGF0YSByZWNvcmQuIFRo
ZQ0KPiBjYWxsZXIgaXMgcmVzcG9uc2libGUgZm9yIGhhbmRsaW5nIGVuZGlhbmVzcy4gVGhlIGVu
ZGlhbmVzcyBvZiB0aGUgc291cmNlDQo+IGNhbiBiZSBmb3VuZCB3aXRoOiB0ZXAtPmZpbGVfYmln
ZW5kaWFuOw0KPiANCj4gSWYgdGVwLT5maWxlX2JpZ2VuZGlhbiAhPSB0ZXBfaXNfYmlnZW5kaWFu
KCkgdGhlbiBhIHN3YXAgaXMgbmVlZGVkLg0KDQpPaywgYnV0IEkganVzdCBmb3VuZCB0aGUgdGVw
X3JlYWRfbnVtYmVyKCkgaW50ZXJmYWNlIHdoaWNoIEknbSBub3cNCnVzaW5nIGFzIGZvbGxvd2lu
ZzoNCg0KZGF0YV9yYXc9dGVwX2dldF9maWVsZF9yYXcoTlVMTCwgdHJhY2VfZXZlbnQsIGZpZWxk
LT5uYW1lLCByZWMsICZsZW4sDQowKTsNCml0ZW1fc2l6ZT1sZW4gLyBmaWVsZC0+YXJyYXlsZW47
DQp2YWw9dGVwX3JlYWRfbnVtYmVyKGZpZWxkLT5ldmVudC0+dGVwLCAmZGF0YV9yYXdbaSAqIGl0
ZW1fc2l6ZV0sIGxlbik7DQoNClRoaXMgc2hvdWxkIGFsc28gZG8gdGhlIGpvYiwgYXMgdGVwX3Jl
YWRfbnVtYmVyKCkgdGFrZXMgY2FyZSBvZiB0aGUNCmVuZGlhbmVzcyBoYW5kbGluZy4NCg0KPiAN
Cj4gPiANCj4gPiB1bmJvdW5kZWQgYXJyYXlzDQo+ID4gDQo+ID4gVGhlc2UgYXJyYXlzIGhhdmUg
Ym90aCB0aGVpciBzaXplPSBhbmQgYXJyYXlsZW49IGF0dHJpYnV0ZXMgc2V0IHRvIDAuDQo+ID4g
SG93IGRvIEkga25vdyBob3cgd2lkZSB0aGUgdHlwZXMgYXJlPyBFc3BlY2lhbGx5IGdpdmVuIHRo
YXQgdGhlIHR5cGUNCj4gPiBuYW1lcyAoZS5nLiB1bnNpZ25lZCBsb25nKSBhcmUgcGxhdGZvcm0g
c3BlY2lmaWM/IEFuIGV4YW1wbGUgZXZlbnQgaXMNCj4gPiAiZnVuY2dyYXBoX2VudHJ5IiB3aXRo
IGZvcm1hdCAuLi4gImZpZWxkOnVuc2lnbmVkIGxvbmcgYXJnc1tdOyAgICANCj4gPiBvZmZzZXQ6
MjQ7ICAgICAgc2l6ZTowOyBzaWduZWQ6MDsiDQo+IA0KPiBOb3RlLCB0aGUgdW5ib3VuZGVkIGFy
cmF5cyBhcmUgb25seSBmb3IgZnRyYWNlIG1hbnVhbGx5IGRlZmluZWQgZXZlbnRzLg0KPiBUaGV5
IGFyZSBub3QgYXZhaWxhYmxlIGZvciBub3JtYWwgdHJhY2UgZXZlbnRzIChldmVudCBjcmVhdGVk
IGJ5IHRoZQ0KPiBUUkFDRV9FVkVOVCgpIG1hY3JvKS4gVGhleSBkbyBuZWVkIHRvIGJlIG1hbnVh
bGx5IGhhbmRsZWQuDQoNCk9rLCB0aGFua3MgZm9yIHRoZSBjbGFyaWZpY2F0aW9uLg0KDQo+IA0K
PiA+IA0KPiA+IHN5bWJvbGljIGZpZWxkcw0KPiA+IA0KPiA+IEhvdyB0byBnZXQgdGhlIHN5bWJv
bGljIHJlcHJlc2VudGF0aW9uIG9mIGZpZWxkcyB0aGF0IGFyZSBtYXJrZWQNCj4gPiBURVBfRklF
TERfSVNfU1lNQk9MSUMgKGV4YW1wbGU6IHNvZnRpcnFfZW50cnktPnZlYyk/IEkgdHJpZWQNCj4g
PiB0ZXBfcHJpbnRfZmllbGRfY29udGVudCwgYnV0IHRoaXMgY29udmVydHMgdGhlIGRhdGEgdG8g
YSBzdHJpbmcgaW50ZWdlcg0KPiA+IGluc3RlYWQgb2YgdGhlIHN5bWJvbGljIHJlcHJlc2VudGF0
aW9uIChlLmcuIEkgZ2V0IGEgIjAiIGluc3RlYWQgb2YgYSANCj4gPiAiSEkiKS4NCj4gDQo+IFRo
aXMgaXMgc29tZXRoaW5nIEkgZXZlbiB3YW50ZWQsIGJ1dCB0aGVyZSdzIG5vdCByZWFsbHkgYSBn
b29kIHdheSB0byBkbw0KPiBpdC4gQWx0aG91Z2gsIEkgd2FudGVkIGEgZ2VuZXJpYyB3YXksIGJ1
dCBpZiBhIGZpZWxkIGlzIG1hcmtlZCBzeW1ib2xpYywgd2UNCj4gY291bGQgdXNlIHRoYXQuIFRo
YXQgaXMsIHdlIHdvdWxkIG5lZWQgdG8gcGFyc2UgdGhlIHByaW50X2ZtdCBhcnJheSBpdHNlbGYs
DQo+IGFuZCBmaW5kIHRoZToNCj4gDQo+ICAiX19wcmludF9zeW1ib2xpYyhSRUMtPnZlYywgeyAw
LCAiSEkiIH0sIHsgMSwgIlRJTUVSIiB9LCB7IDIsICJORVRfVFgiIH0sIHsgMywgIk5FVF9SWCIg
fSwgeyA0LCAiQkxPQ0siIH0sIHsgNSwgIklSUV9QT0xMIiB9LCB7IDYsICJUQVNLTEVUIiB9LCB7
IDcsICJTQ0hFRCIgfSwgeyA4LCAiSFJUSU1FUiIgfSwgeyA5LCAiUkNVIiB9KSINCj4gDQo+IFRo
YXQgaXMsIGxvb2sgZm9yIHRoZSAiX19wcmludF9zeW1ib2xpYyhSRUMtPltGSUVMRC1OQU1FXSwg
Li4uIiBhbmQgcGFyc2UgdGhhdC4NCg0KVGhlIHRyYWNlLWNtZCByZXBvcnQgc2VlbXMgdG8gYmUg
YWJsZSB0byBzeW1ib2xpemUgdGhpcywgYXMgd2VsbCBhcw0Kc3ltYm9saXppbmcgaW5zdHJ1Y3Rp
b24gcG9pbnRlcnMgKGUuZy4gdGhlIGNhbGxlciBmaWVsZCBvZiB0aGUgZnRyYWNlDQprZXJuZWxf
c3RhY2spLiBOb3QgdGhhdCBJIGN1cnJlbnRseSBuZWVkIHRoaXMsIGJ1dCBJJ20gd29uZGVyaW5n
IGhvdw0KdHJhY2UtY21kIGlzIGFibGUgdG8gZG8gdGhpcy4gUHJvYmFibHkgbmVlZCB0byBjaGVj
ayB0aGUgc291cmNlcy4NCg0KQmVzdCByZWdhcmRzLA0KRmVsaXgNCg0KPiANCj4gSG1tLA0KPiAN
Cj4gLS0gU3RldmUNCj4gDQoNCi0tIA0KU2llbWVucyBBRw0KTGludXggRXhwZXJ0IENlbnRlcg0K
RnJpZWRyaWNoLUx1ZHdpZy1CYXVlci1TdHIuIDMNCjg1NzQ4IEdhcmNoaW5nLCBHZXJtYW55DQoN
Cg==

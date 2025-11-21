Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011063.outbound.protection.outlook.com [52.101.70.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716052D7D59
	for <linux-trace-devel@vger.kernel.org>; Fri, 21 Nov 2025 10:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763722616; cv=fail; b=bx8+ezjTtKkvXkWT7RvuPPvuBbQ/DUFg4JsZlqb8dxgRA1oZzVzDTObtFbm6Ry/lmEriLrZDRGW50NsQ5KQmsJAeReyJ4AWNWVBPwjBqDAF64gTDODP10wqxE85dN/oikRFPfD/iGuswKpbAcKWLuhSyqNrASzARPs0nDFz5LzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763722616; c=relaxed/simple;
	bh=0dYE6AWcOkCFXS50+BnEI3gJ6uitP0ZnynwTGGmi0uM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YeHvvvUd16IHE5ANhY2xcsAgen22ozm8oczXDXHlf1u0CQyJvwYd1k8LwslPeiNoM61e6qzWAn50PLIUj2GeK+lAYHgVkR83BPorqPAI1neodpDS2q/PtekkOa9qr/VJcxbSPsuh3K+IVly5NCGWnltsl+kNfQCZnsXiTs2KC08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=swLomYLH; arc=fail smtp.client-ip=52.101.70.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="swLomYLH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MbQnBH3XoMUHkFEETwNkvuySGfzBTmfS/914amCaexOSZtmsMCZo9IrZT6sZfXzbigN0RMnwJnJwIAhn3KwxgCn2CFfvsuGnRH88q3faK3NQwg5pTkCdghlEr3x3fHzGQh4p5y9013jfpyzJPaUeWegF/35ScV+iU8Ora6sFOsSh15QYM9ssYicTWn/z/jKekPHg6z372NHs81L+S4kikXVu1k4BD7WqiJeIcV9J2ceC0MKxDZgE1CukDoM0LPgiXb/L8MeW/UNWe8uxHZtRdTrhgk08CQPWbNJZqBu401TYjVgR4l1CvBxnaSQrl/Ao7jJdDVYHm+Ajq4qhB3t/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dYE6AWcOkCFXS50+BnEI3gJ6uitP0ZnynwTGGmi0uM=;
 b=evSs4UqztNl1ojixQ5imP+GtU9STR/eG1M7bRqAT4io0ZY+2wtBebsenKGvyCux+m2iR0mEOCUIxGxp00eCDVluYVCLPjEnrZQzEEezMvyuhFmTFzOpO/ONwpbsKGiGqz3wALwgay6wV7C/N2JCXh4sb6Cv6TBVrZuXWZZ8QVmf4TMPnLMVOum2je+mvPH+0nbNT5t7ZERzd/2pBGY8TMRxM+ChMamHcbbPhp3qQ8DzD3pzBeG+rK3XeyJYu2DOi1FEjed4W3LiX6q/L8v5pICwy2ewqxbbHgrrCIGmzl92VXbx8M5Je0Av6K32z/J5mRg6IvIAMHgVXv2I7ghusLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dYE6AWcOkCFXS50+BnEI3gJ6uitP0ZnynwTGGmi0uM=;
 b=swLomYLHt6wQQL3hecU9LRLLGwLv4OMmMCftJ8STLLWdAVUpWP7GjwjHfj8+YylWzJgio2R6dnkBn5YKO6OlY0exmv59HeZlASyFEYLlLbQxADHGvrltTkYeTIGJXuZkFEeG1vBAxBAwv7JqcWVv/SzD8wBzuptHekA1jmIvhs1KpFVc2CIysJa17vWs/zxoo9c5XJLxYOoztZ/H6e7JPBjJu92BMLYJgY2Qt9KzytuugVbjDSNah5GX8n/10D9x523xaj5NMIGhLjHT/gM1DN6mEYLFtllznOUVumjchbt6fLjtxlaVP0+n9r41R7KEQn0R1/FFaS9tySpHYbgIQA==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by DB9PR10MB5306.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:338::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Fri, 21 Nov
 2025 10:56:51 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 10:56:51 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Kiszka, Jan" <jan.kiszka@siemens.com>,
	"linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>
Subject: Re: libtracecmd API extensions
Thread-Topic: libtracecmd API extensions
Thread-Index: AQHcWhiXNKfmgiYgakarPgqIPdEdD7T73TQAgAEZrgA=
Date: Fri, 21 Nov 2025 10:56:51 +0000
Message-ID: <0b4fb4b774a8754ed86a9212f0a253304a41245c.camel@siemens.com>
References: <ee6cc8b90fb0d71f412645d7671b7130d72fecc2.camel@siemens.com>
	 <20251120130840.357cbca6@gandalf.local.home>
In-Reply-To: <20251120130840.357cbca6@gandalf.local.home>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2-7 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|DB9PR10MB5306:EE_
x-ms-office365-filtering-correlation-id: 29a33d9e-5d07-4e98-ef23-08de28ecad23
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?NElhd2xuREsrS0d4QjdnbXdINHh2VHdSQmN6cHBEMFBLZ2lCVHYrL0JSc2hJ?=
 =?utf-8?B?Z2FxNFpIV0RHdzBMbG5NdkRUaHFiR1BrNnU1NGlMUjJ5b1Qrek92Nmo2Qk56?=
 =?utf-8?B?ZVdsWlJicmg4c2pBdEpMV01qUmNjVGhhNVI3cWhiNVNqTEcxcDZVQk1yazda?=
 =?utf-8?B?WnB1RWoxOEpNTG1laXd4STVZVHVEQjFDVXgzNUtDRkhKMTZKQmxtcCthZjFX?=
 =?utf-8?B?M2NONThTWGhDWU1kQkJBTm80MkovQVN6clhYQW5uU3FGRUI0VXVsc2c2NlN1?=
 =?utf-8?B?bWNXekltbngzaUxoSDJ5cDdJbEhpelcrU3Uxd2Y2dnFiTWNrSGNQWW5BRnFi?=
 =?utf-8?B?UXdRMzgxS2MvTEtqclgxd1hXWFV1S1pLQUtZQWsyKytCU0ZpTXFhcGVJL25l?=
 =?utf-8?B?eXo0dnEwVlVpc3lLMEp3dStyZUQyNGtiT1Q4ZUh0NitsVDBKOVMyTnBHOGV4?=
 =?utf-8?B?WFpxUXBQRlJlWWRVaXloUkl2REgvZ2NETlVIZk1rcjJhYmRjdW9KVGsxcWEv?=
 =?utf-8?B?Q0djK2FMSWZYTVpjd1ltVm00ZW1qa1Rna0wwc3J3SUVmZi9jajBheWsrb1lN?=
 =?utf-8?B?OGxEY0Q2My9laEhkTG11a3A3bnQ3Z0l6TlRlZUxXY0tYZk5JejFubHZiK3Jm?=
 =?utf-8?B?V0lNOWM2eHR6UEJ6NWFFSml4UkQ0dUlDeXFlbTh3WGZ0eUNEaHY0Ni9TNUQv?=
 =?utf-8?B?d2ZOdHc3S2tqMURnMEp3VEl5Znh6OGxXTFlrVzB1OTA5ODUwdUdDTk53cWxE?=
 =?utf-8?B?WGlOZkU3NkZPSFBXQXF2VXA2MHJKQmdONmNnRmhMT0RndUlBSEhFaVJUS2V2?=
 =?utf-8?B?bE5MK2N6T085UFNQSUVXUTVWZGpsZC9GVUFRRU92RWJtREJzSVN4eGtzazZy?=
 =?utf-8?B?ditxMGY4VUcwbU1DVVJ0MFYvZ2pzeVRlNWIxVDhacFVXU2sxa3NyM09ZbmM1?=
 =?utf-8?B?NUxockFCUFh3K0F5bUlLV082Q0JUWWdsM3AyWmV4QXQ0OEk2dGtkaldySUtk?=
 =?utf-8?B?K1FYbmNtS05iSnk5S3dSc2xWeWU0MkRKcTFjRDRyUWNhT0pHVWYwaWJGTjdN?=
 =?utf-8?B?dng2bFVRMkZNdE1xRDl2UWx0T09WRXMwV0x6ZGkyQVloSUhXZmZsL0h2Ym1J?=
 =?utf-8?B?WGhob3B6dUJUYmFIZ2xFajVraUdsaTlGMFdpNjR4V3V6ZDEraE9wT2xxYVJP?=
 =?utf-8?B?RDVRL2hRSnhoMTYyOThEZ2tTQXl0K2FaTHZ0eDhSbWZmQlA2R2l4SCtTWVVv?=
 =?utf-8?B?bUJnTzROeG4yM3BPTkhHVS9ScXBNMmxzaDNyTXp5Z3VPeVNvNlVhUW1ZWmVs?=
 =?utf-8?B?a1N0Yk9OYjZnczZuZHRhY3l2eXpLVnpKaXh2bllWK1N6dVBhMFhNMzBJWVdu?=
 =?utf-8?B?VGxCbFo0bkxUaDlQQytFTkFhTWFkRllTdHF6aUVvNVluSzNwUDhKYlVjUHdr?=
 =?utf-8?B?RlBhRVJiR08veEhuaXFVOHZRR0RoekQ0a0M0ZFhzbElQbUxWUzNNdkk4SWpj?=
 =?utf-8?B?SFB2MUxCUTEwOWZPVWkyWFBVNDk1T2ZXVW9iOFNMaUlzMS9lQ2I5R2xIYnFp?=
 =?utf-8?B?RllhVTRIakZjQnFmbGkyeE9LdDhtb1Z1L3pPTzlaTXFvVFNQZmJvaStxbjdq?=
 =?utf-8?B?QjJLQTI5UWpicUpXQ3hiRHlHNWxranRXbjBTbHErWVpkM2tselQwVkdGVW9R?=
 =?utf-8?B?S0ZORnVNN2tuUml1T2Y0NlluN1NaQzhGcTJyUHpqVEF1enZPbjZ3dDFBb0lJ?=
 =?utf-8?B?Z0kweVNaTklHUEt3ZXM2WlczQWhSdHZmNE9sTnptMyttK3BYWDNUUXUyczlS?=
 =?utf-8?B?U0xpcm5NRno5SFlTOUQ0bmd3b3FqRGN4QjFieTU1di9LTkNOR0pSM2lXT284?=
 =?utf-8?B?azNjWmJoY0FMTFRtaERiVDByamR0Nkd6NEtqeEF0RWJ0QjlVUDJEbE1uc3NR?=
 =?utf-8?B?NEZoOVdMM0o0aGxBd0l4aVNGc0grVXpycUNqTThXb0x4Ni8zRnhKOGFrYnZo?=
 =?utf-8?B?a1oxaVVYUGNURzBiTlIwM0ozUUJUSlFOcDB6YzdGRHRNdEpHUFVZYzkzeUlQ?=
 =?utf-8?Q?7/uX5c?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V3J3QnlpTXQzdzJpa092eHRady9ISEpMb3BUa2F1emlZWENTRldrcDdveGl0?=
 =?utf-8?B?cU9ZYlMyK2hDeFhEZU9jTUpBY2FNYWh3VjRubktqU1NtZytaYUNseUhuWXNu?=
 =?utf-8?B?M1RsWnJucS9SdzN5REtOY08vRWk0MzZKNk9BYkZEellvbDlqdVU4M0Rmanp2?=
 =?utf-8?B?aVB4VXcySWt6VFVDWGJ6Nk43dG9iTktOR3RwYzJUdnZsQnhnVWhjbXdVTDRB?=
 =?utf-8?B?Vml2dU0vK0VxM0dXbjdkbEdRNUpacVI5eEQrUGJnbi9ERXJ3SUxqdVRPUnlx?=
 =?utf-8?B?VTJjRktkZ2ZFLzNIeHZnenN5dWJSUTdkVXR0UWxoczFlQmUyM0JWSjRyY0hm?=
 =?utf-8?B?ME14dUluenkweTZ5bzdkWFZpZDlZY2czZkhSSlNGWEdBRDRXQTVrZm1WbUph?=
 =?utf-8?B?cHhacjV6VUF6Vk5TcWsxbFBsMXdjUk9vc0JDKzd3SmlCcW1pNlhBTjZlNHVB?=
 =?utf-8?B?cnhmZmRPamp1dElaQ3BTNEdWdUhzOVdYQjM5Q3N0bENnNkFNMlJzaFdBWmpy?=
 =?utf-8?B?VjVtcHZOUGZiMGNpcUFTV0VEK1Y4bExRMDdBQWdJSWtEVWFKb3dxTDJBeUJW?=
 =?utf-8?B?eS9Qa2JkWkUwamNudFk3bXl5MFFUUTc2WkZLdmt3OW5TZm5zRnZIZzNQM3V1?=
 =?utf-8?B?UzVRWnhuRWlscFI5RHd3TkZFbEk1eDNqUW84SUV2UE1LSDI3K3hUT0xRVXJR?=
 =?utf-8?B?Y2VLNENURjE2NEJRTGEweHJzYnBjKzZtK0o4OHA2bHZhZFlBWktrUWZqbHFq?=
 =?utf-8?B?TzJ5NXlYQWNwOHVYNHhocFpLazFNQy96QzZURkt6YlRsbzc5RVdwUTdxQ2Fa?=
 =?utf-8?B?SlVwSU5mblRScmZkZG85eVl2Zm1jRHdDQk1IdkszNG1sYkRUQVJBQ3lwb3Zp?=
 =?utf-8?B?YmRsTFZ1NE9NTVRoOXJEbjlwVDdONTFEYVpiMm52VXFwSDZvYTlZbG5GQ1o1?=
 =?utf-8?B?cG4vajBpUGdkM1BlU2NOSWNBQmoyV1RHOWNjSHhMckN3VzZPb3BvckJsNkdO?=
 =?utf-8?B?Rk8xQWFFWjF5VTAvUWNyRG56YWxOT1Fzc0RKdHFib2hEcGh2bHlmMnBHWWl6?=
 =?utf-8?B?V3BZUXlnQlZEV2JLTmtFM1VIN2VCMFlyb2Ivc2V5OEp4Ly9XUFRoSUpRT3ha?=
 =?utf-8?B?U0IvY010dStTU0FoaHJ0YW1zbVQweXRrKzh1bS9WNFMxTGIzcUZwQTBuQVNr?=
 =?utf-8?B?OVYzRSs2WFlOZnlPUVBYbEUyTVY1QmZ6MDZEMzJOdTBwM1R2MzlTN2Jza3Ix?=
 =?utf-8?B?RjF2dndPVlhvL2pGZkhrMWRQaEZwS1FwR2hwU3U4WHJPMy9uY3pVamtVM0VP?=
 =?utf-8?B?Zk9oaHdXYTJ1SDBGY0dKdmdxZCtxb2hTRDdTM3o1SHNoWmVoV0FpdE9XMWxU?=
 =?utf-8?B?TGhmVVUxWnNHOEsxcWcwUXhVcHlxdTlFVTZPVlNYKzZxaTBFMmttTzRqK2xP?=
 =?utf-8?B?SkpNbEkxaC9rZlJBa05CTkZTVEpkYzNyMUZkMFd5TVBCaEJCRHArK0xIbmRj?=
 =?utf-8?B?eFBnRGYxNUdrdVNtamorREhISDVpcWh0K2JpQ3JqWGtZLzA1QmRzN0ptZWlD?=
 =?utf-8?B?ZDUyQ2s0ZDdLMktHNWw1ZHluUHNzcTR4R1NBVGdxN1ByZFdsNWRNRDNhbEo2?=
 =?utf-8?B?TFVRNFNWQjVUbGY3UXh3QUNCd1dNc1ZpNklYZjI1VFdkV1hiRllzd01WVHpt?=
 =?utf-8?B?L0RiVFlxc0JpTmRLc3AzOFRFZm40bjVDLzlHM0wrRUdhWFdQdFlYa3dYRmNI?=
 =?utf-8?B?am85OVo1UHoyQ2V5UWZuaGowN2RNakFpVEpKQ0hkNmc2V1Q1cnE0ZnZZbTI0?=
 =?utf-8?B?QXBBUnhXenFrd2YzSTUwaWdCdUN2WWFIYWVBRGhDMlNqWklUQVN5eHBVTkxi?=
 =?utf-8?B?NzlzN0VscFhocElCQzU4NGVKcnNud2YxT0lRNE8ybkdHTkIwRE5kWERpT0Zi?=
 =?utf-8?B?MkdzeDNWRFVNMGEwTFplUHRCbGtTNFRaUUU2dlRwbm1HWUNhd1dBL3ZKZlAr?=
 =?utf-8?B?THh2V09aMm9HaHJzdng3Vm80bmZaNDNVTG9VT2ZMU3JHN2J0Zkp0a3hqdElz?=
 =?utf-8?B?dFpLTjBSWE1xVE9oVVJYa3BmNkUwOWJrbHpKYXFiUDlDNjdqSjBYSXlaQytM?=
 =?utf-8?B?R2ZoYVZGT1c1VFArUC9qQjVzaVR6dUp3cnduMjJlc1hMU0FHazc4d1RhWVpH?=
 =?utf-8?B?OTc5Q2hOV1ZYSUZDWjdQc0VwTDE0UU11dTNSYkpHQlpmTEFJaUtYWHk1NUNQ?=
 =?utf-8?B?NTU1ZExEcUEyMU5nVGxwTEVhaWhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42345E295BEC4744956E2F35AF508FA1@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a33d9e-5d07-4e98-ef23-08de28ecad23
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2025 10:56:51.4787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O40Om/9paulQ1ixesWUZjlYQj4rPeEJ8T2rl67VjjxnPr41m62OU1Dh8sA86BWZPw+y3maULsudWZRiZqfkOOueCAcozdsMj4C41MUhJ02o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR10MB5306

T24gVGh1LCAyMDI1LTExLTIwIGF0IDEzOjA4IC0wNTAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gVGh1LCAyMCBOb3YgMjAyNSAxMjoyNDoxOCArMDAwMA0KPiAiTU9FU1NCQVVFUiwgRmVs
aXgiIDxmZWxpeC5tb2Vzc2JhdWVyQHNpZW1lbnMuY29tPiB3cm90ZToNCj4gDQo+ID4gRGVhciBU
cmFjZXJzLA0KPiANCj4gSGVsbG8hDQo+IA0KPiA+IA0KPiA+IHdoaWxlIGRldmVsb3BpbmcgYSBr
ZXJuZWwgZnRyYWNlIHRvIENvbW1vbiBUcmFjZSBGb3JtYXQgKENURikgY29udmVydGVyDQo+ID4g
WzFdLCBJIG5vdGljZWQgYSBjb3VwbGUgb2YgYXNwZWN0cyBvZiB0aGUgbGlidHJhY2VjbWQgQVBJ
IEkgd291bGQgbGlrZQ0KPiA+IHRvIGRpc2N1c3MuIEluIGdlbmVyYWwsIEkgYW0gVkVSWSBoYXBw
eSB3aXRoIHRoZSBsaWJ0cmFjZWZzLA0KPiA+IGxpYnRyYWNlZXZlbnQgYW5kIGxpYnRyYWNlY21k
IEFQSS4gVGhlc2UgYXJlIGdyZWF0IGxpYnJhcmllcyB3aGljaA0KPiA+IHJlYWxseSBoZWxwZWQg
dG8gZ2V0IHRoaXMgaW1wbGVtZW50ZWQgZWFzaWx5Lg0KPiA+IA0KPiA+IFRyYWNlIGNsb2NrczoN
Cj4gPiANCj4gPiAtIEluZm9ybWF0aW9uIGFib3V0IHRoZSB1c2VkIHRyYWNlIGNsb2NrIGlzIGF2
YWlsYWJsZSBpbiB0aGUgdHJhY2UuZGF0LA0KPiA+IGhvd2V2ZXIgdGhlcmUgaXMgbm8gcHVibGlj
IEFQSSB0byBleHRyYWN0IGl0DQo+ID4gLSBBIHRyYWNlIGNsb2NrIChlLmcuIG1vbm8pIHRvIHdv
cmxkLWNsb2NrIHNuYXBzaG90IGNvdWxkIGJlIGFkZGVkIHRvDQo+ID4gdGhlIHRyYWNlLmRhdCB0
byBtb3JlIGVhc2lseSBhbGlnbiB0aGUgdHJhY2Ugd2l0aCBvdGhlciB0cmFjZXMNCj4gPiANCj4g
PiBNZXRhZGF0YToNCj4gPiANCj4gPiAtIHNvbWUgbWV0YWRhdGEgKGxpa2UgdW5hbWUpIGlzIGFs
cmVhZHkgaW5jbHVkZWQgaW4gdGhlIHRyYWNlLmRhdCwNCj4gPiBob3dldmVyIHRoZSBBUElzIHRv
IHJldHJpZXZlIGl0IGFyZSBwcml2YXRlOiB0cmFjZWNtZF9nZXRfdW5hbWUNCj4gPiAtIGZ1cnRo
ZXIgbWV0YWRhdGEgbGlrZSBhIGZ1bGwgInVuYW1lIC1hIiBvdXRwdXQgYW5kIC9wcm9jL2NtZGxp
bmUNCj4gPiB3b3VsZCBiZSBoZWxwZnVsDQo+IA0KPiBTbywgbGlidHJhY2VjbWQgaXMgc3RpbGwg
dmVyeSBtdWNoIGEgd29yayBpbiBwcm9ncmVzcywgb2Ygc29tZXRoaW5nIEkgbmV2ZXINCj4gc2Vl
bSB0byBoYXZlIHRoZSB0aW1lIHRvIHdvcmsgb24gOi1wwqAgSSBkb24ndCB3YW50IHRvIG1ha2Ug
dGhlIG1pc3Rha2UgSQ0KPiBtYWRlIHdpdGggbGlidHJhY2VldmVudCwgYW5kIGhhdmUgQVBJcyBl
eHBvc2VkIGJlZm9yZSB0aGV5IGFyZSByZWFkeS4gSSBoYXRlDQo+IG1vc3Qgb2YgdGhlIGxpYnRy
YWNlZXZlbnQgQVBJcywgYnV0IHRoYXQncyBiZWNhdXNlIGl0IHdhcyBwb3J0ZWQgb3ZlciB0bw0K
PiBwZXJmIGJlZm9yZSBpdCB3YXMgY29tcGxldGUsIGFuZCB3ZSBnb3Qgc3R1Y2sgd2l0aCB3aGF0
IHdlIGhhdmUuDQo+IA0KPiBsaWJ0cmFjZWZzIHdhcyBtdWNoIG1vcmUgcGxhbm5lZCwgYW5kIGhh
cyBhIGJldHRlciBBUEkgYmVjYXVzZSBvZiB0aGF0Lg0KPiANCj4gSSBoYXZlIGxvdHMgb2YgaWRl
YXMgZm9yIGxpYnRyYWNlY21kLiBJbiBmYWN0LCB0aGUgZ29hbCBpcyB0byBtYWtlDQo+IHRyYWNl
LWNtZCBhIHNpbXBsZSBzaGVsbCBvZiB0aGUgbGlicmFyeSwgYW5kIGhhdmUgZXZlcnkgZmVhdHVy
ZSBvZg0KPiB0cmFjZS1jbWQgZXhwb3NlZCB0byBvdGhlciB0b29scy4gVW5mb3J0dW5hdGVseSwg
SSBqdXN0IGRvbid0IGhhdmUgdGhlIHRpbWUNCj4gdG8gd29yayBvbiBpdC4NCg0KWWVzLCB0aGF0
IHdvdWxkIGJlIGV4YWN0bHkgd2hhdCB3ZSBuZWVkLg0KDQo+IA0KPiBIZW5jZSwgaWYgeW91IHdh
bnQgdG8gYWRkIHRoZXNlIEFQSXMsIEknbSBtb3JlIHRoYW4gaGFwcHkgdG8gcmV2aWV3IGFueQ0K
PiBwYXRjaGVzIHlvdSBzZW5kIG15IHdheSENCg0KSSdsbCBzZW5kIHBhdGNoZXMgdG8gdGhlIE1M
Lg0KDQo+IA0KPiA+IA0KPiA+IEV2ZW50IHRpbWUgcmFuZ2VzOg0KPiA+IA0KPiA+IC0gaXQgd291
bGQgYmUgZ29vZCB0byBoYXZlIGFuIEFQSSB0byBnZXQgdGhlIGZpcnN0IGFuZCBsYXN0IGV2ZW50
DQo+ID4gdGltZXN0YW1wIHBlciBDUFUgKEknbSBjdXJyZW50bHkgZnVsbHkgd2Fsa2luZyB0aGUg
ZXZlbnRzIHRvIGdldCB0aGF0DQo+ID4gZGF0YSkNCj4gDQo+IEhtbSwgSSBjb3VsZCBoYXZlIHN3
b3JuIEkgaW1wbGVtZW50ZWQgc29tZXRoaW5nIGxpa2UgdGhpcyBpbiB0aGUgcGFzdC4NCj4gUGVy
aGFwcyBJIG9ubHkgZGlkIGl0IHRvIG15IGxvY2FsIHRyZWUuIEkgaGF2ZSBsb3RzIG9mIHVwZGF0
ZXMgdG8gdHJhY2UtY21kDQo+IHRoYXQgaGF2ZW4ndCBtYWRlIGl0IG91dCB0byBwdWJsaWMgKHNp
bXBseSBiZWNhdXNlIHRoZXkgYXJlIHN0aWxsIGluIGRlYnVnDQo+IGZvcm0pLg0KPiANCj4gVGhl
cmUgaXMgYSB3YXkgdG8gaXRlcmF0ZSBiYWNrd2FyZHM6DQo+IA0KPiDCoCB0cmFjZWNtZF9pdGVy
YXRlX2V2ZW50c19yZXZlcnNlKCkNCj4gDQo+IFRoYXQgd291bGQgZ2l2ZSB5b3UgdGhlIGxhc3Qg
ZXZlbnQgd2l0aG91dCB3YWxraW5nIGFsbCBldmVudHMuDQoNCkkganVzdCB0cmllZCBpdCBhbmQg
aW4gcHJpbmNpcGxlIGl0IHNob3VsZCB3b3JrLCBqdXN0IHR3byB0aGluZ3M6DQoNCjEuIHRoZSBp
bnRlcmZhY2Ugd2FzIGp1c3QgcmVjZW50bHkgYWRkZWQgKDMuMywgc28gdGhhdCdzIHRvbyBuZXcg
Zm9yDQpib29rd29ybSkNCjIuIHdlIGxlYWsgb25lIHJlY29yZCBwZXIgQ1BVIHdoZW4gbm90IGZ1
bGx5IGl0ZXJhdGluZyAoaS5lLiB3aGVuDQpyZXR1cm5pbmcgIT0gMCBmcm9tIHRoZSBjYWxsYmFj
aykuIFRoaXMgbGVhayB1bmZvcnR1bmF0ZWx5IGdlbmVyYXRlcw0Kb3V0cHV0IHdoaWNoIEkgbXVz
dCBub3QgaGF2ZS4NCg0KSSBzdGlsbCBkb24ndCBmdWxseSB1bmRlcnN0YW5kIHdoeSB3ZSBsZWFr
LCBidXQgaXQgaXMgc29tZXdoZXJlIGFyb3VuZA0KdGhpcyBsb2NhdGlvbjoNCmh0dHBzOi8vZ2l0
aHViLmNvbS9yb3N0ZWR0L3RyYWNlLWNtZC9ibGFtZS8zNjRmYWVjNDc0ZTRlNGUwMjM2YzIxYWY4
OTI3MTg2ZTBlMjE0ZTdmL2xpYi90cmFjZS1jbWQvdHJhY2UtaW5wdXQuYyNMMzA2MA0KDQpUaGUg
Y29ycmVzcG9uZGluZyB2YWxncmluZCBjYWxsc3RhY2sgbG9va3MgbGlrZSB0aGlzOg0KDQotc25p
cC0NCj09MTQ5NzYxMD09IDEsMDI0IGJ5dGVzIGluIDE2IGJsb2NrcyBhcmUgZGVmaW5pdGVseSBs
b3N0IGluIGxvc3MgcmVjb3JkDQoyNDEgb2YgMjQ5DQo9PTE0OTc2MTA9PSAgICBhdCAweDQ4ODNC
QTM6IGNhbGxvYyAodmdfcmVwbGFjZV9tYWxsb2MuYzoxNjc1KQ0KPT0xNDk3NjEwPT0gICAgYnkg
MHg1RDEzOUY0OiBhbGxvY2F0ZV9wYWdlICh0cmFjZS1pbnB1dC5jOjE1NzQpDQo9PTE0OTc2MTA9
PSAgICBieSAweDVEMTRDOEE6IGdldF9wYWdlICh0cmFjZS1pbnB1dC5jOjE4OTEpDQo9PTE0OTc2
MTA9PSAgICBieSAweDVEMTc4ODI6IGxvYWRfcmVjb3JkcyAodHJhY2UtaW5wdXQuYzoyODk3KQ0K
PT0xNDk3NjEwPT0gICAgYnkgMHg1RDE5Q0Q2OiBpbml0aWFsaXplX2xhc3RfZXZlbnRzICh0cmFj
ZS0NCmlucHV0LmM6Mjk1NykNCj09MTQ5NzYxMD09ICAgIGJ5IDB4NUQxOUNENjogdHJhY2VjbWRf
aXRlcmF0ZV9ldmVudHNfcmV2ZXJzZSAodHJhY2UtDQppbnB1dC5jOjMwMzYpDQotc25pcC0NCg0K
PiANCj4gPiANCj4gPiBQUzoNCj4gPiBXZSBhcmUgYWxzbyBsb29raW5nIGludG8gd3JpdGluZyBh
IGNvbnZlcnRlciBpbiB0aGUgb3Bwb3NpdGUgZGlyZWN0aW9uDQo+ID4gKGkuZS4gQ1RGIC0+IGZ0
cmFjZSBiaW5hcnkgZm9ybWF0IC8gdHJhY2UuZGF0KSwgYnV0IGl0IGxvb2tzIGxpa2UgdGhlDQo+
ID4gbGlidHJhY2VldmVudCBpcyBhIHB1cmUgcGFyc2luZyBsaWJyYXJ5IGFuZCBjYW5ub3QgYmUg
dXNlZCBmb3INCj4gPiBzeW50aGVzaXppbmcuIElzIHRoaXMgdHJ1ZSwgb3IgZGlkIEkgbWlzcyBz
b21ldGhpbmc/DQo+ID4gDQo+IA0KPiBZZWFoLCBsaWJ0cmFjZWV2ZW50IHdhcyBtYWRlIHRvIGJl
IHB1cmVseSBwYXJzaW5nLiBJbiBmYWN0LCB0aGVyZSB3YXMgYW4NCj4gZWZmb3J0IHRvIGNvbnZl
cnQgaXQgb3ZlciB0byBmbGV4L2Jpc29uLiBCdXQgYWdhaW4sIHRpbWUgcmFuIG91dC4NCg0KVGhh
dCdzIHJlYXNvbmFibGUuIEhhdmluZyB0aGUgQ1RGIHRvIGZ0cmFjZSB3YXkgaXMgYWxzbyBub3Qg
b2YgaGlnaGVzdA0KcHJpb3JpdHkgZm9yIHVzLCBidXQgaXQgd291bGQgaGVscCBvdXIgWGVub21h
aSB1c2VycyB0byB2aWV3IGNvbWJpbmVkDQp0cmFjZXMgaW4gdGhlIGtlcm5lbHNoYXJrLCBhcyB0
aGV5IGFscmVhZHkgaGF2ZSBjdXN0b20gcGx1Z2lucyBmb3IgdGhlDQp2aXN1YWxpemF0aW9uLg0K
DQo+IA0KPiBUaGF0IHNhaWQsIGlmIHlvdSB3YW50IHRvIGFkZCBhIGZlYXR1cmUgdG8gY3JlYXRl
IGZvcm1hdHMsIHRoYXQgY291bGQNCj4gZGVmaW5pdGVseSBiZSBhZGRlZC4NCg0KR29vZCB0byBr
bm93LiBJJ2xsIGhhdmUgYSBkZWVwZXIgbG9vayB3aGF0IGV4YWN0bHkgd2UgbmVlZC4NCg0KQ2hl
ZXJzIQ0KRmVsaXgNCg0KPiANCj4gQ2hlZXJzLA0KPiANCj4gLS0gU3RldmUNCg0KLS0gDQpTaWVt
ZW5zIEFHDQpMaW51eCBFeHBlcnQgQ2VudGVyDQpGcmllZHJpY2gtTHVkd2lnLUJhdWVyLVN0ci4g
Mw0KODU3NDggR2FyY2hpbmcsIEdlcm1hbnkNCg0K

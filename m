Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013024.outbound.protection.outlook.com [52.101.83.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D262E7F1D
	for <linux-trace-devel@vger.kernel.org>; Mon, 24 Nov 2025 09:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763975484; cv=fail; b=sazJxGSNKNBbmEwbh8P4Ql5aG0Pbs2YciD23/HsffBwUO9Hknm1n7K0O6M2ASNIfU4ALIGGf70bVTUmu/cC7hbkS0S0QMrpywdyQmRKp4a53wuUotQIdVxTMJL38oTzK/lUMKixJCploiQBbfN8yj548xQC/09QcARha5pZcrUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763975484; c=relaxed/simple;
	bh=WZ3Kne0omb5+fabNiOUil2SQMWVgZubcSDS6R40y3rE=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IoJ6ako7MXb9R/42DxeLwFjURMizq1GuEST4OlfjiG2QN3hpf4wSwilQxycnQAjErUgnkL/rt5EgberTn2PBpcSqAuY4DevTPj6OtdvD3VrZ85VtBb1D0occEBfdIFKvVvk5AW1vCsY+JYX7GAR0mtig59ew3MrkHrU+np0CNzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=Wz3xjDX0; arc=fail smtp.client-ip=52.101.83.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="Wz3xjDX0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hO7UtNGJQYchMuC64sZX1EIf3g6SwfjJjaITvrnD6xLjiywnNeB7DgctSj7T8qQMApyn/bhmHjRZSi66qK9dlRhZB/JR8sw5nTDagCHsrESnjSG1YgAEf2UmI0OeVDOobB4LFxAtlrOVolAp67dBcDSv2lN78zbYbiZHUjtovnFhBztXdVjHWKcL3cBm9sSk0RSIRVSNEigQHLt/fiGT18jYPxUQEYqH6BTfOQggg4e2VrNJCKRwKUR9Y7RRBFFTLpJ/M1yn6pF+TRBz0N+sbLMmc3F0jxNSRB12muEM+VUT7OQgkN1ikmfDI+JAzDSUX/hy6LBr7b/3ira+hCBOvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZ3Kne0omb5+fabNiOUil2SQMWVgZubcSDS6R40y3rE=;
 b=vthai42gHyab1iTJc902jQ7ZfC34aAjOT/g7E/hoSE75OMxzrLqjBOg8PhrFiHVe1GyA5IyNvwaVEGaZa/7k0rBA6LD9LS2tZUr7exXLys6OOfmgYXumeJhgms2RYBctluDi0PGyj1VfCHohksArBGr3pFMX8AfL3iijxpW7V/+QPCN6CvqFQKHqBb6kT5933vR4AUifjHdLl4dlOu62dwUARmpid6OwKwMPE5kUHCpeB5sFVXdr0dlrKwvhxwZdJwYMHGS0AZs0ZtSrVHus3vCtEeY3C9jcDjQ9bgD1bCGe/cxM1Av2sNfvtVbaPsnjiatZUjR4XwkSU/5YLISY6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZ3Kne0omb5+fabNiOUil2SQMWVgZubcSDS6R40y3rE=;
 b=Wz3xjDX0YpuYioUok/jws0Ff2UfJ81U8/gDzn0JXdWiZCqnzV3ug949XoOfVR2RCjgEb7jSTKoqAfU4+GPb1ZG7/mx/xRFo6f1WlmilKbbMbxEqWWDsXSU2PgSHlumCN2g+QmAoqA5+3PfIPhUArjzV4WP+s+jE/s9zvJsyq9bPWmA2LHaXG2cLGsavp4GRQuvSEZ6h5sYc/gOuQMLkXCKAGhIWNxBNrg1CgWV0KjtZDINRFyl/qvztH/OS//uof4lRno6uD2MjAQYGrYxK9V/QblrQYJyI4+z94RRE2oyp8bJbZ2rFt0dRztBO63J6D3lmklAz8KIG9vdFNzwDeOA==
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by PAXPR10MB7927.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:24d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 09:10:06 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 09:10:06 +0000
From: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracecmd: Fix continuing in
 tracecmd_iterate_events_reverse()
Thread-Topic: [PATCH] libtracecmd: Fix continuing in
 tracecmd_iterate_events_reverse()
Thread-Index: AQHcWwmSdV43CAuvnUmS3oLeo2udNrUBjiuA
Date: Mon, 24 Nov 2025 09:10:06 +0000
Message-ID: <6418211fd4d5673020b94a75b1ce8e7781b80d9d.camel@siemens.com>
References: <20251121120947.368ad1bd@gandalf.local.home>
In-Reply-To: <20251121120947.368ad1bd@gandalf.local.home>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2-7 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB6828:EE_|PAXPR10MB7927:EE_
x-ms-office365-filtering-correlation-id: c3338032-8b46-40e1-8e2b-08de2b3942d0
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SUVOM0pPZDhYK2xBbW1sN01PN1JtcTNiWEZMNkRuNGRrWWFnK3VKMVNkdXVI?=
 =?utf-8?B?cGxJTWhRbFE0V0dOUXlVOVY2YVRuT3Nsbk81RlNpQWxWWEVROGdCMVhLNmtW?=
 =?utf-8?B?bmJWcVY0SjliSzFHTEp0aVBjU001RFJ5eVMzTDJ3U1UzVndPWHVoVUZJMkpo?=
 =?utf-8?B?d29KZ0Y0REpXWTkwdTNSZUcxZDRwcys2L3M2b0R2YW9hdXJIS1RCbXZvQnov?=
 =?utf-8?B?czR5QzJ1NTNLczdXd01VSkdUN0NQc2FuNHdmQmFwRnZOWUp1QXUvcTlYY0NZ?=
 =?utf-8?B?M0xKZVhidkt5SUM3UzZwZjV6aHIyeGZNTVk4a24zV2tqU0lLSnQ1SmUraGRF?=
 =?utf-8?B?ZGVpQ0dqbHBDR0ZaRHlmdXlOK3ErRmtJTERvOW5YMFp5RmxTRDFKMlhUYzJJ?=
 =?utf-8?B?U1BxNTBURHNjNU5kck5UN2tnOFFtK3BOVDdERlJTK1VkUi9qRDM2dnlNTjFn?=
 =?utf-8?B?QlB3Mkk0dUVSUlBlQ24wVTRlRDQ5OUx6TjdNU0FmOVg3dmo1RmcyQUlBZVZ4?=
 =?utf-8?B?bEdwVXRoRXJTaFF0NDIxZU5IZ0hCMVZ6QkptT1pvVXdxYmRQU1QzOHNZdHpy?=
 =?utf-8?B?QkJ5dUFKUTE2WFdRRTVJUEZ2SlRjK3JQQnNva0h0SmZraHpCWEUxMmtMdU9Q?=
 =?utf-8?B?K09vOGdlMVNJRVVhRyttMkhYWVVnRStxVWpBWENTMzFVRjFuYU90b3hFdjZr?=
 =?utf-8?B?bm5uaVlwSFZrU005bmMvV0hmRU91ZWFaOFRIRUZPRjBTTXhoV05ZN0NrekV5?=
 =?utf-8?B?bExLL0tLNFgwT2tFdGFVWTNVRkFFb09BME5kaUVEa3Q1UGk4L05DOEYxVmlE?=
 =?utf-8?B?d2Z0MGZLdXNnS2FYMTlHYVVBWFdIaDZnL3pYSlNrRkdTS3FTWUlqb3NEYUFD?=
 =?utf-8?B?ZzJzaDJDYTlhVTlGRmF0UnZxako2WStLNmJpOTM4dGswU2Y4OEV5NzRscFpp?=
 =?utf-8?B?dElZUHlzQXFuWGhVdEFlb05KT0gwc0FNZmpnY2tzTDFMM3d6SS81WUMreFdD?=
 =?utf-8?B?OVB4bXBOSXo5N0hsNjczMHdVTWxBbGh1WWlBL2d2UzdHMUpJeVFsUzBZQzhE?=
 =?utf-8?B?UXVIVXdvYm5FQ0FaR2NqSkdKN2J1M2p2d2tYaDBkRjZhSWRod1I4dGo2ekN3?=
 =?utf-8?B?QXVLdUVlajJBZEVBWVZ5Tk8yRmVNVTZRMEE2dytyZDQ5YTlMalZxZU5YNEMz?=
 =?utf-8?B?RUJHVE1RNzFNczJ0RitlR0tibnNWa2dqT0pRTDdYSWNuZkdRZVdyZW8rcW9Q?=
 =?utf-8?B?Qm9USXJnMVZqQStyUDB6c3k5ZmdCdVpNOG96MURMZUcyd2VBSFcwYSt0YXNQ?=
 =?utf-8?B?RElpU2lCK1VZZWNjU3Bsb1ppZldQaWJIbzhKQ2hjWjIzcTBCRXZvSzh4cEhV?=
 =?utf-8?B?d0NsaldXeXpBcUlQSGk1WFV5d3JUYzM0UlBjVUMzaUlzTm5qamVzbjY5UGsw?=
 =?utf-8?B?RS9RUUlkWlhCb1BZc25icmpnZ3RURldUVjhKcTJHVUpiUklPK1k3VU5VbGRl?=
 =?utf-8?B?VmxVZm1zOEpPeTE0OWowL0JWSWV1WGJvTFQ0dUZjbnhUQ0lkY0RtTjZaTFhF?=
 =?utf-8?B?UDhYcm5FdGM4Ly9YTENwckk1OHMrU0M2TFRMaUc4SnBDdjRBbWF4WEpzUyth?=
 =?utf-8?B?V0cwWVZrM1dra1J5cTVqZVZUM2NqY2RGa3hmU1AxWkxTMC8zK0FSY2EwdTJn?=
 =?utf-8?B?SWFDeURkcHpraXVnTDdMMGJ4ZTMwN3E3cGtONHN2Qmtmdk1nMVJBenBPVTcz?=
 =?utf-8?B?UUhqZ1NLOXZ6M3IwNXRESWoxTU05RzVUUnFST05UT29wcGRZOGgwRXA1U2hK?=
 =?utf-8?B?TnBlc2s1M1VaWjQ3SXpyMEZ6TTFEcjhQOHA1Q3JYaUZKb29mS0hHMU1pNVRR?=
 =?utf-8?B?VU5WbDVFblhTV0JYYldZK2dKTHNjZWdXa2FUVzBOaCtNR1M5ck8wT1hVaHZB?=
 =?utf-8?B?SEtNaVJTS3kxYmRiL1BZemNLenFKTENid1FWdTFiTWpxWUZyVGR6ZXVudUZa?=
 =?utf-8?B?SXRYRG5GbGdWVFhTOXNiVWRidHpBYUFxT2hpWUFxc0xKbVQ2SzhnaWx5cjNJ?=
 =?utf-8?Q?1uan9P?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NlI4UmIyOG40VWlMSGFlSHVsSHRlamNWUE95T2l5dkIySStSN25RL3ExUmxE?=
 =?utf-8?B?elhBMm5MbVdvRHFHOHFuQXNSN2RnVko4cGlFQi9EZXJWaFM2Nk9kNHpsTndy?=
 =?utf-8?B?Q3duMk1oaGZOUmNoWEF5NnFUTE1OeUlhVzVjZVJ6QmlxamdIMFVOU2liYUR5?=
 =?utf-8?B?VFYwYm5YNTh3ZHd6RmtIZVJNOGl3UUpIWGJzM3JldVJPUEdYcHhOTWJzMmNC?=
 =?utf-8?B?UE01cjRacTN2TVdJT2Q2QXJ1SlBtbkFWQVN5UDd6V3c4WGFPcXE4d1F0OFJV?=
 =?utf-8?B?elZHYThPZXRMQ0N2K2RreWhBVlNVTG1xTDI4bkwvVVRXcEUrNlQ2OGJxTG9E?=
 =?utf-8?B?WnNKKzNCMmpnbnNQcnU4VEQ3SGgzZk9vOC9kRTR1eVQrZmoyNGtGU1RkaHVh?=
 =?utf-8?B?ZkU4UnRMby9pZUNVV3RUeGI2WG5pdHd3VkN5T05OZWhvaEhXWjh2eS92MGEy?=
 =?utf-8?B?V25rNVRTS1NSWHlXVzc3bWRaekxhOHBtaHJzdm1oWnNnRzc2MW9QWVNFRVl6?=
 =?utf-8?B?WXBDZjRNTnpScDZyMXVYWkJJdjVRbmQydVEzeGdDZ2Y1dHdrYTZzVUtvdnV1?=
 =?utf-8?B?OUNVSWpTY3ZlZHFDVG1JYkhxMXRaUTJBN3dBeE9TMU9aajhLdDA5cXRuVk8x?=
 =?utf-8?B?SDhIcE1aSkFuSHROZnhhOW1rc0I3dVp4UEdjOUZHbGt2RVVLd25Pcmh2bHNC?=
 =?utf-8?B?cnd1U3NLNFpoSVpIR3dLVEN3SFVWOHRHcUlLdnVHZkhmT2xobzdsZDNwQmVX?=
 =?utf-8?B?aGN4TVpxbDlKU2JndEFKOWZocGlqY01BdXE2MHhzaDBQTXhKSU40ZEFDbDFw?=
 =?utf-8?B?SzRDaXJGL3FVRkFIV2lCZHVRNzhYZ3h5aGZObEhiKzFNWnRiQXREU1pGekJw?=
 =?utf-8?B?Qkx0dGk3cVQ3ai9XLzV0RHE5VktTa2tkVkVxZU5lN2NLYzhEdDhrVnkrZFhG?=
 =?utf-8?B?Y2ppckkvOXp6bTNHbi9JeXdTNnh5MmNhK3dLN0pWbUdBdnhXUFRrYVlrZXdW?=
 =?utf-8?B?RGYxQVZBUGtpQWcrTnRwV0hRZ25RanBrMGl6NDRMekx6ZjRwbVA1Z2hhS1NB?=
 =?utf-8?B?THdUWG5SZjhCOXVsQjU5c1VZTzMvUUxhK2RQUGdnT2RPYlhzVnZnaTlLL1pW?=
 =?utf-8?B?K29jMUxNR2ZXUzRKcXc1YjFGSnNBT2lKZHdmaWdUVmpBNWFPUUZpelA5SWQy?=
 =?utf-8?B?VEVDbnlaK1JteEp4eExvSTRNTGp6Z1JYc1pORjUwbmk5dFFhLzRFUllKZ1Rr?=
 =?utf-8?B?NHRNUnhtVExKQmdIV1h4NlNya1g0Z1hGYlo5ZUs0d3Vrb25MY0kybHVHc1FP?=
 =?utf-8?B?cmZMOE0rc0FYQ2RnZ1I2VnYwTmdnU0VnTlJnY2tjTGZhNElnUDJvYSs4WUNW?=
 =?utf-8?B?R0QyM0F6NnUyTlYrMWd6OHJ1bDRRckRVRksxajBkSG85VDF3R292Q0t6eVcy?=
 =?utf-8?B?bjRGOFgxcDNuc0U1dFIvbVEvazBYMjZxZ1A0aGllWGlYOHB1L1ZNM0RSdGtW?=
 =?utf-8?B?dE9nZHlibHovT1F4SGpRckR1b3k3SEVBQ2RGcEtyS2NhMk5UMllaM0xKRTJO?=
 =?utf-8?B?Y2s4ZVhGVGpmcjlTeFkwbWpadUI1d1RpUjREckg3N0dPeUlKVG8zU3Vpb2Qr?=
 =?utf-8?B?ZWhzalBpVFE4TnRqVlYvak5GQ21NUFdJbCs2NjdERCttRWp6TzQyNTRMVGlJ?=
 =?utf-8?B?bHRhaGVkTzF2OUtrcFpETDBldUNGNGpRL2hpOG96SlIvdDZ3TlE2c0RFWndY?=
 =?utf-8?B?VitDQWFMQ0VVeE1LOERaMk9QeXNkdkZHTWh3WG5OZUdZV1B1V0cyNytqLy9G?=
 =?utf-8?B?REdpL09vMFVnL2h3U3U3d3U4ZVVOdnVkenpzQmJQWjhNZnI5aDcrY29rL3NG?=
 =?utf-8?B?amZ3WldRMEtlNVNUK3k5M3NmYTlSRzVwVnA5MVdSa0RlRms3b3E5UE1zY1B2?=
 =?utf-8?B?RkVFYk1NWnNha2dMckpOdDUxSmNvSk11VU9icTFnNFJKblJweHl2RUt1RStQ?=
 =?utf-8?B?TmlrRHhkbEQ5d0EwVURsRUtwcll5UFpaSDdudU00VXhIeFArd3hZMndQV0R1?=
 =?utf-8?B?blRkSXorUWRRRVNZaWN0aFliVng4Y1FVR1Z5MmpwZWlKV2w4N2xpRWxYbEI4?=
 =?utf-8?B?aXRYR21DRlpNTUpkK2dDZ1U2LzRhWjgvWmNiSjdCV3VBSG1qTDYzNkNuT3lF?=
 =?utf-8?B?TXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B891474E172A64596627239B766AE48@EURPRD10.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c3338032-8b46-40e1-8e2b-08de2b3942d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 09:10:06.6757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2J2k7si5BRCbYsb0ymZEInEpE54Ii5y7ysDX1ksK2EXBZmYt2MT3eK4TVQ5iMiBFl1GbemKETXqvlYDtLbggeplrqAepmvhwm2042oCzX20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR10MB7927

T24gRnJpLCAyMDI1LTExLTIxIGF0IDEyOjA5IC0wNTAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gRnJvbTogIlN0ZXZlbiBSb3N0ZWR0IChHb29nbGUpIiA8cm9zdGVkdEBnb29kbWlzLm9yZz4N
Cj4gDQo+IFdoZW4gYSBjYWxsYmFjayBmcm9tIHRyYWNlY21kX2l0ZXJhdGVfZXZlbnRzX3JldmVy
c2UoKSByZXR1cm5zIG5vbi16ZXJvIGl0DQo+IGNhdXNlIHRoZSBmdW5jdGlvbiB0byBleGl0IG91
dCBlYXJseS4gQ2FsbGluZyB0cmFjZWNtZF9pdGVyYXRlX2V2ZW50c19yZXZlcnNlKCkNCj4gYWdh
aW4gd2l0aCBjb250PXRydWUsIGlzIHN1cHBvc2VkIHRvIHJlc3RhcnQgd2hlcmUgaXQgbGVmdCBv
ZmYuIEJ1dA0KPiBiZWNhdXNlIG9mIHRoZSB3YXkgdGhlIHJldmVyc2UgdHJhdmVyc2VzIGFsbCB0
aGUgZXZlbnRzIG9uIGEgcGFnZSwgYnkNCj4gY2FsbGluZyB0cmFjZWNtZF9yZWFkX2RhdGEoKSB0
byBmaW5kIHRoZSBuZXh0IHRhc2ssIGl0IGRvZXMgbm90IHBpY2sgdGhlDQo+IG5leHQgdGFzay4g
SXQgY2FuIHBpY2sgdGhlIG5leHQgdGFzayBhdCB0aGUgc3RhcnQgb2YgdGhlIHBhZ2UuDQo+IA0K
PiBJZiB0aGUgY2FsbGJhY2sgYmFjayBjYXVzZXMgdGhlIGZ1bmN0aW9uIHRvIGV4aXQgb3V0IGVh
cmx5LCByZWNvcmQgdGhlDQo+IHBhZ2Vfb2Zmc2V0IG9mIHRoZSBsYXN0IHJlY29yZCByZWFkLCBh
bmQgdGhlbiBzZXQgdGhlIGN1cnNvciBiYWNrIHRvIHRoYXQNCj4gZXZlbnQuDQo+IA0KPiBMaW5r
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNTExMjExMjAxMTcuMjBlODJkOWVAZ2Fu
ZGFsZi5sb2NhbC5ob21lLw0KPiANCj4gRml4ZXM6IDU2Y2JjNTIyNTE4YTUgKCJ0cmFjZS1jbWQg
bGlicmFyeTogQWRkIHRyYWNlY21kX2l0ZXJhdGVfZXZlbnRzX3JldmVyc2UoKSBBUEkiKQ0KPiBT
aWduZWQtb2ZmLWJ5OiBTdGV2ZW4gUm9zdGVkdCAoR29vZ2xlKSA8cm9zdGVkdEBnb29kbWlzLm9y
Zz4NCj4gLS0tDQo+ICBsaWIvdHJhY2UtY21kL3RyYWNlLWlucHV0LmMgfCAxNCArKysrKysrKysr
KysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1n
aXQgYS9saWIvdHJhY2UtY21kL3RyYWNlLWlucHV0LmMgYi9saWIvdHJhY2UtY21kL3RyYWNlLWlu
cHV0LmMNCj4gaW5kZXggYWZkYmQyYWE5OGI2Li44ZGZlZmY0NTg0ODUgMTAwNjQ0DQo+IC0tLSBh
L2xpYi90cmFjZS1jbWQvdHJhY2UtaW5wdXQuYw0KPiArKysgYi9saWIvdHJhY2UtY21kL3RyYWNl
LWlucHV0LmMNCj4gQEAgLTMwMzYsNiArMzAzNiw3IEBAIGludCB0cmFjZWNtZF9pdGVyYXRlX2V2
ZW50c19yZXZlcnNlKHN0cnVjdCB0cmFjZWNtZF9pbnB1dCAqaGFuZGxlLA0KPiAgCQkJCSAgICB2
b2lkICpjYWxsYmFja19kYXRhLCBib29sIGNvbnQpDQo+ICB7DQo+ICAJdW5zaWduZWQgbG9uZyBs
b25nIGxhc3RfdGltZXN0YW1wID0gMDsNCj4gKwl1bnNpZ25lZCBsb25nIGxvbmcgcGFnZV9vZmZz
ZXQgPSAwOw0KPiAgCXN0cnVjdCB0ZXBfcmVjb3JkICoqcmVjb3JkczsNCj4gIAlzdHJ1Y3QgdGVw
X3JlY29yZCAqcmVjb3JkOw0KPiAgCWludCBuZXh0X2NwdTsNCj4gQEAgLTMwNzIsNiArMzA3Myw4
IEBAIGludCB0cmFjZWNtZF9pdGVyYXRlX2V2ZW50c19yZXZlcnNlKHN0cnVjdCB0cmFjZWNtZF9p
bnB1dCAqaGFuZGxlLA0KPiAgCQkJcmVjb3JkID0gbmV4dF9sYXN0X2V2ZW50KGhhbmRsZSwgcmVj
b3JkcywgbmV4dF9jcHUpOzsNCj4gIAkJCXJldCA9IGNhbGxfY2FsbGJhY2tzKGhhbmRsZSwgcmVj
b3JkLCBuZXh0X2NwdSwNCj4gIAkJCQkJICAgICBjYWxsYmFjaywgY2FsbGJhY2tfZGF0YSk7DQo+
ICsJCQlpZiAocmV0KQ0KPiArCQkJCXBhZ2Vfb2Zmc2V0ID0gcmVjb3JkLT5vZmZzZXQ7DQo+ICAJ
CQl0cmFjZWNtZF9mcmVlX3JlY29yZChyZWNvcmQpOw0KPiAgCQl9DQo+ICAJfSB3aGlsZSAobmV4
dF9jcHUgPj0gMCAmJiByZXQgPT0gMCk7DQo+IEBAIC0zMDc5LDYgKzMwODIsMTcgQEAgaW50IHRy
YWNlY21kX2l0ZXJhdGVfZXZlbnRzX3JldmVyc2Uoc3RydWN0IHRyYWNlY21kX2lucHV0ICpoYW5k
bGUsDQo+ICAJZnJlZV9sYXN0X2V2ZW50cyhoYW5kbGUsIHJlY29yZHMsIGNwdXMsIGNwdV9zaXpl
LCBtYXhfY3B1cyk7DQo+ICAJZnJlZShyZWNvcmRzKTsNCj4gIA0KPiArCS8qDQo+ICsJICogSWYg
dGhlIGNhbGxiYWNrIGV4aXRlZCBvdXQgZWFybHksIHRoZW4gc2V0IHRoZSBjdXJzb3IgYmFjaw0K
PiArCSAqIHRvIHRoZSBsb2NhdGlvbiBvZiB0aGF0IHJlY29yZCBzbyB0aGF0IGlmIHRoaXMgZ2V0
cyBjYWxsZWQNCj4gKwkgKiBhZ2FpbiB3aXRoIGNvbnQgPSB0cnVlLCBpdCB3aWxsIGNvbnRpbnVl
IHdoZXJlIGl0IGxlZnQgb2ZmLg0KPiArCSAqLw0KPiArCWlmIChwYWdlX29mZnNldCkgew0KPiAr
CQkvKiBTZXQgdGhlIHJlY29yZCB0byB0aGUgcHJldmlvdXMgcmVjb3JkIHRoYXQgd2FzIHJlYWQg
Ki8NCj4gKwkJcmVjb3JkID0gdHJhY2VjbWRfcmVhZF9hdChoYW5kbGUsIHBhZ2Vfb2Zmc2V0IC0g
NCwgTlVMTCk7DQoNCkhpLA0KDQp3aGVyZSBkb2VzIHRoZSBtYWdpYyAiLSA0IiBjb21lIGZyb20/
DQoNCj4gKwkJdHJhY2VjbWRfZnJlZV9yZWNvcmQocmVjb3JkKTsNCg0KSSBzdGlsbCBkb24ndCBn
ZXQgd2h5IHRoaXMgZml4ZXMgdGhlIGlzc3VlLiBEb2VzIHRyYWNlY21kX3JlYWRfYXQgaGFzIGEN
CnNpZGUtZWZmZWN0IHRvIHNldCB0aGUgdGhlIGludGVybmFsIGN1cnNvcj8gSWYgc28sIGl0IElN
SE8gd291bGQgaGVscA0KdG8gZG9jdW1lbnQgdGhpcyBzaWRlIGVmZmVjdCBpbiB0cmFjZWNtZF9y
ZWFkX2F0KCkuDQoNCkZlbGl4DQoNCj4gKwl9DQo+ICsNCj4gIAlyZXR1cm4gcmV0Ow0KPiAgfQ0K
PiAgDQo+IC0tIA0KPiAyLjUxLjANCg0KLS0gDQpTaWVtZW5zIEFHDQpMaW51eCBFeHBlcnQgQ2Vu
dGVyDQpGcmllZHJpY2gtTHVkd2lnLUJhdWVyLVN0ci4gMw0KODU3NDggR2FyY2hpbmcsIEdlcm1h
bnkNCg0K

Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11012053.outbound.protection.outlook.com [52.101.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB181474DA
	for <linux-trace-devel@vger.kernel.org>; Mon, 17 Mar 2025 11:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742210681; cv=fail; b=FQqjJaoG+V15Y+Ro+sglODeiexxrAJImdiaWwt/nPG4DE7MpRSt1gbiuMGdY+AKTZlDBvxHrz4vlTSWTwqGAH/OLSTcy5F8aTQzEl/DvkDkIinfPnVG/YCSVmc/ZDT6jn6oNHBrSKyAjS106JXg8Xsa6O3qc6/2zV8e+nIS0p8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742210681; c=relaxed/simple;
	bh=6E5zv1VrdMhN5TfHzlZKCQjUU0YRC/xEG7+iIXQoNcI=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PrOLz+zPGzMZT7+NswWWFVNhOqe96inlIOmOe1ctWTcC2uq1+W90vC4UdcmeFZNDaqSslTmrulukVkjo9HXzAxveiwGOCWfEVdv4sn+8bzlwqTSQ0vTcQqObalj66n3cH4BITFDcfwfiqpc/YW4F4tkBknpuWPVm/2HuWVzOHdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens-healthineers.com; spf=pass smtp.mailfrom=siemens-healthineers.com; dkim=pass (2048-bit key) header.d=siemens-healthineers.com header.i=@siemens-healthineers.com header.b=VkASqdJ3; arc=fail smtp.client-ip=52.101.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens-healthineers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens-healthineers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens-healthineers.com header.i=@siemens-healthineers.com header.b="VkASqdJ3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LNf2AtN41L7e3cP6UB1lTEEl57STyRpVS9EoRglUEwYc8R16tRqJWw5SwdhCFl6UtXKLTfH6esqvtYaXpL+VMgQOWBSVxw9Z7BC99Zu1ELFu4MbP3BU1/ZBifPzQ8XeoPbeulz7hQoMmNlXgwsJtEt+4yM6z4vxi62Dn4iZnmA4cdmQI0rW0XTIGpx9GqrN+icVbHqrgRbIgivFGNMHE2cDdEoBBCHIuPiz2d0jW7p3jpsknVYJconLcnbL7MYnT/4cOA7MEbUAcng0QwMQP2iC6ieutA2vZnTvkuR5PGdMZHD9g8+G+wQeE3l2feaWhXzrS0wMYEs1Kll4urDrGSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGZKRjga5Mln91jg3WAhdFsTmy7SBAuEWk1zjuRE1SU=;
 b=hjZEos75KGyiIjBUip6xVbrqmMmNgvfqEuSE5QPqRTZ0HmDzHeonXN7kIPfoSTzlbPWCKDya42YFCqZFR+Drvbwl15ziYtn+D0fOu9AlDCCLYXsmdFZkJD2MDwTs9XT6CVfNxifDV0m5+rFAuPBaMp+IdhKBJXGXCzo4/iH0uHUz1dCiuVbAXhP2eEDYJfIzX41MjMCMxArKT6P9S7rERw61W1DP8s8jCE3MePJ4rzR3o0UkEMmtxn0nnNCNw8RVZwHJBQ4BimIoTkJ6UYFtre8bHoLOwHwcQlnNngVwXqEaWXlINyY1n8wthGmmEKfFvG9wculBaSOAgni1Ibs+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens-healthineers.com; dmarc=pass action=none
 header.from=siemens-healthineers.com; dkim=pass
 header.d=siemens-healthineers.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=siemens-healthineers.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGZKRjga5Mln91jg3WAhdFsTmy7SBAuEWk1zjuRE1SU=;
 b=VkASqdJ3jsJMp3EC9kKFO4k/1sCSsyGXL64l/nF93MlbpW8cPo245PwqHwd90WzGGIiKn6OCLffMnsugZX8zu6FVhkKxcPQW6l4HdgC+8eZ6VPO9l8HLjqtun4EpSp88vuRPmMkimIiSDvH8gWm+slUq9/iWnUmKxzdBoevKGABRu7eEKz0KkntjboYUFHia2L+6cm/D2VHsv9pnapLm2s3He2pvhytjwkEWY1GL0C45C3iRK7iTvjGdhCcLcnSVfy9wXfmLJhnXpx2qUN7t9v4SotKOvbOFtlsAGdpQbX71sQncSiYg8yP0ixkA3uH0ik6reiTFW7Oc4C7sTQiSuA==
Received: from AM9PR05MB7777.eurprd05.prod.outlook.com (2603:10a6:20b:2c5::23)
 by AM9PR05MB8594.eurprd05.prod.outlook.com (2603:10a6:20b:3a4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 11:24:36 +0000
Received: from AM9PR05MB7777.eurprd05.prod.outlook.com
 ([fe80::948a:5048:e01:8da5]) by AM9PR05MB7777.eurprd05.prod.outlook.com
 ([fe80::948a:5048:e01:8da5%6]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 11:24:36 +0000
From: "Kutzer, Philipp" <philipp.kutzer@siemens-healthineers.com>
To: "linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtrace: Fix memory leak in tracefs_cpu
Thread-Topic: [PATCH] libtrace: Fix memory leak in tracefs_cpu
Thread-Index: AduXK5tfnYbr3hwoRoGtV7EYmeYPdA==
Date: Mon, 17 Mar 2025 11:24:36 +0000
Message-ID:
 <AM9PR05MB77778BE58632548B4D3EEBECB5DF2@AM9PR05MB7777.eurprd05.prod.outlook.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_ff6dbec8-95a8-4638-9f5f-bd076536645c_ActionId=99ae0b53-0501-4130-9a6c-1a6962e7fa24;MSIP_Label_ff6dbec8-95a8-4638-9f5f-bd076536645c_ContentBits=0;MSIP_Label_ff6dbec8-95a8-4638-9f5f-bd076536645c_Enabled=true;MSIP_Label_ff6dbec8-95a8-4638-9f5f-bd076536645c_Method=Standard;MSIP_Label_ff6dbec8-95a8-4638-9f5f-bd076536645c_Name=Restricted
 -
 Default;MSIP_Label_ff6dbec8-95a8-4638-9f5f-bd076536645c_SetDate=2025-03-17T10:05:22Z;MSIP_Label_ff6dbec8-95a8-4638-9f5f-bd076536645c_SiteId=5dbf1add-202a-4b8d-815b-bf0fb024e033;MSIP_Label_ff6dbec8-95a8-4638-9f5f-bd076536645c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens-healthineers.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR05MB7777:EE_|AM9PR05MB8594:EE_
x-ms-office365-filtering-correlation-id: b8fee6c4-ca54-4917-844a-08dd65464c72
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?z/S3GB3o3xfxi1UTc5cm0d8QjTx1vyQ+3zTfApwkeNrIFGvgQdt5C3sNC59w?=
 =?us-ascii?Q?VhGgNLtS1UlIWF8ix84qnzwnuk8qcvNzew1TTgiZ0B7kE2D1YnQsqShA4QCA?=
 =?us-ascii?Q?r0oeTunk0Eq7CXSrVK/TTaMOg9nlF46SOSb4Ic7X4IDtH3tpMpxRgcZRPHmX?=
 =?us-ascii?Q?8NW2Eiwgh/42kfOo+yhBXOLNApLJPaj1bqJTul7GyKItyUPWhJWuOnD5eHXZ?=
 =?us-ascii?Q?L5FXjSoHO/YvnsCl4VgWCbCuSg3P8LXAjMeIwxTwjl7c0W4d4aW40rJVbTf+?=
 =?us-ascii?Q?njnTwPm5y3YRZJxKiDsNuLEut7gedW1y4Cy5CVvsAV4BwlXCyAFYkXYgF6gU?=
 =?us-ascii?Q?O/2RMEicQSts3W2rK9qgzFh/Aua3t1GTMgQW6oGcFZRLLVxzs8jW89i9QfRR?=
 =?us-ascii?Q?XY1pKEv9CEHmWTGGwcyBNdKZm+/jp+Ai8FBmXjpFUTBRkpI6GeYout+Kuvi1?=
 =?us-ascii?Q?Tjq9K8x3FLyylWEFhpKvI44Vfk34aZni1x9aQFnOWCRKXdzVMUp8GAx4b1DA?=
 =?us-ascii?Q?Ny0DqkE/iwyEzv18I0Wb1IhH3UqGGJnTfVqceYlwJ+5A9OpI1SqzhjXvqHFL?=
 =?us-ascii?Q?BXxtmEpaMi5d2qncIrVrQ8DLZn2sY4Ej9Dq8pqTfvbcNUZI2Q3uLyBfuPDZp?=
 =?us-ascii?Q?7mMLjlVWMI1T/8AWK0F5aWi6ufVq0u/ugPCj/NeMrLpMf6+weGCBRazN6xel?=
 =?us-ascii?Q?9Z4Or3mAd3i+AWQFQVcmM5Z1bVfbZqCSIEj2lBiDRzjjlWejcBm3ggEGcyA2?=
 =?us-ascii?Q?IgFVcmxpa/Ma+UhFOzRsEG72Inj0X03Sqf3axDfTbJJY2446jXZ5lAv/MaeA?=
 =?us-ascii?Q?HpguAfsNRVgqhHb+ZnlFu3HvDst1l5dYvmDAmJmQR6PjZP3tn/DUPPnxUSxp?=
 =?us-ascii?Q?stQHkqjUChh4VjzMWOcqa5iKDV9A4Kvot9+TKVmetmkOxtKM41SnIs1thuB2?=
 =?us-ascii?Q?wsPHQDpbeGBBf7M5rTgv4i+krdBBGICV6E2ItkBUucypSZFNL+5PLydaudt4?=
 =?us-ascii?Q?9ZoEIRX7eIjpGbdZSSTwqBx5+cGgpMMMgwkyKgy4VyGDigr986+YuCZ+JLHd?=
 =?us-ascii?Q?eaZ+7e1Z660B5SE+xHGjEGQN+4oW0BjqADoepS2NOlj66u/b1USFOnhebSv7?=
 =?us-ascii?Q?PYL+fGJDHECbqE4RCt59SChISje/oWvdqlxXsk8+5Xzj/ReJN3e2aURhZdPG?=
 =?us-ascii?Q?pyuKkIyaerTY6lm9H2gSB++fn3xS6BT5gguJo6UAk1ab1N4O3iF2eHpCSA0m?=
 =?us-ascii?Q?D5makUZbNXN9sErN2zEUxw2bAUus0423bQ6kHwj06BDlGPJfxmUvgZZ6Snlt?=
 =?us-ascii?Q?TLh37svfPHWo8QD5P+mL97cPSWjbr9HgrNjJ1CVzzsF1Ow25dfiEE9MsZKxE?=
 =?us-ascii?Q?xyo1UsLnZI9aKmtYX+LqH1I1wmTsc1PR6WMA3QmTtrW4CpHlgHMVwJk17XI4?=
 =?us-ascii?Q?0GAX4lDZvrMb+xCoRMn+aWhc3eGmAITM?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB7777.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?FqjBW5eD9NrZT9RSRSWws4Pf+xHq2+J+aWpDV9sjdalgAHC0/Pi/TjbkRk0q?=
 =?us-ascii?Q?HkHf8TDJwor+CIQNMyyv2vbopi+3/VureYoMAJff2sQTaf65avxKwHhyu384?=
 =?us-ascii?Q?T6f+ARpBW9b5h5Q4BaGXf8WmMKfIVwv5TGDrQLHzKAEJ7RsNV+dhSnCGnAGr?=
 =?us-ascii?Q?6hqHas0o6RrUft32+w5gYTkFlwCPJY+prs1IQcdTpvh9YJPmBzDQW1I3o3Tq?=
 =?us-ascii?Q?Ap8nRm5dOXf9EPDMPicqkqKFFit8TFLsUszYzbCyjFmou+9ylhXeON0OFmj1?=
 =?us-ascii?Q?UwzEFksQM7QWgLxJ7uLf6hGWj5wsYxB11Gzlse4XBAO3kds9l3ldIEcKAlsf?=
 =?us-ascii?Q?asvlGEIXIc2cZAq6UkRO9n3uAhccr/KBQJjJ9ewu1wutu9dnmVLeM2j4ZNT6?=
 =?us-ascii?Q?LA3Uoc+ls0CQzcJC78XLZIFwHax3ghKrhYXIIPo5H7MD1F3WIWcxikYTok5Z?=
 =?us-ascii?Q?Wnr/CNSLa+I9Vy95Sdt684hij4ghs7/WS8CLRt/N/pIcQgPoYAnWnpe6n8wI?=
 =?us-ascii?Q?h5G5PTTZ8QZtbREid+ENIaYG3HciUkEnvvsGS5vZaDHFJf02fuqlAWB2FoKU?=
 =?us-ascii?Q?/x+dYfqOgtmGp9TzxFQ9W+BneZCma0DDpVExmNmwrT9EMTFgtQ1L6+KKbHiA?=
 =?us-ascii?Q?eSx9SSgb21K7idRNbKM9wvZ2bgPd06koc1xQVJxo692wyuwnzstq7WBvLFTf?=
 =?us-ascii?Q?XgbEuHJv5yI2Xg+Ou7cgeEeQOXNPMLzdmP/wkGj68VepxH4/FN2cYdr5cjC+?=
 =?us-ascii?Q?+Az8rLjPylujqjW9g2lYR9AucRpGxftoiv8EmPV35zCi9Oodu/gpQ8VvVMeR?=
 =?us-ascii?Q?xwWc1o/Yf2KIIXJ4QIhRpKr7HOg1yGby1Re6oScxQDjHNKDoLYMGO000Sf1i?=
 =?us-ascii?Q?DlVkJbEs5WLEm5kF+Pcm0HQgrt9Ye+QArSCPQuPis0on2inzW4VbfAbIU6+S?=
 =?us-ascii?Q?91ZhAgvA9r/l2oh1YonptwBKF5JLHA70f56KP8Kztr2uO+Cka8HL1Yeu3175?=
 =?us-ascii?Q?gxrqKBNvJY7bOL2mWS7eEO5085l+lCEba3GxkKKSQySprft74zZ+zV2xCbFT?=
 =?us-ascii?Q?g++Va2bzDoXZgQ9AwjbxKUKBpL29c2afjb5BuzGDRBK+fapDyYEXXXR7Q9QK?=
 =?us-ascii?Q?/+BdlF+PJStRCy7NztZpX02hvyKzaoYFKiTAaETrW0iLnDjoRmYvVmJiA1Fo?=
 =?us-ascii?Q?+s0dsyGfXOBd8Ws/N51tFkCHzUZVkYvZWxzcBhD1HrfBdsgjBgCkJmLNP7Dg?=
 =?us-ascii?Q?7MyA0GB/B+QkcMipXH1gU9xmF9mtSu9hhtK/iCFdQEB1kSjpS273sCpWP+51?=
 =?us-ascii?Q?70Qtne5+1YcuMYbIFslu171D+bSS8+hx1jLI8fDxN36FKGxAtv64q0nfdM24?=
 =?us-ascii?Q?0NMRa1/v0Ue4stu0MIgFxXWXkTPUW3PzOFjxGdtvhVlPhVJWj2fK2cBPVuTs?=
 =?us-ascii?Q?QFWEe3JLj4ZyyyhvnY/1aaxyawjyvQMkXlLtFEhyvWFxQ+4pRnMIqHcyYwxs?=
 =?us-ascii?Q?ZXI6UbryjjTsoMJIOXenryOO8FmqYDuIx9iK3F9VxkX052LxptGng6gloKtB?=
 =?us-ascii?Q?nl28VdD5C0/DTqKBs92H6IghGwW4ubEtSBMkIEddEB0wKvc+l+KBXh9/Wnum?=
 =?us-ascii?Q?L7uX15bj8RxLiO3Bl6mzg3A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: siemens-healthineers.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB7777.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8fee6c4-ca54-4917-844a-08dd65464c72
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2025 11:24:36.0538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5dbf1add-202a-4b8d-815b-bf0fb024e033
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AfeVprK858K8ivO3DoTkgiW/F3fAsWvl+cq/V3HRuQ/pbq+gv9gnZu6JB47CQ9TQ/8V7m+LIYcwoBXgpMjT3vWBgAudICErOZc6vogDuq2BkeBLsvuoxIyZvU1E2UcHU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR05MB8594

From: Philipp Kutzer <philipp.kutzer@siemens-healthineers.com>

Hi,

with the introduction of the interface to allow the tracefs_cpu to handle b=
uffer allocation on their
 own a memory leak was built in.=20
(Commit 1e1cc549d7e7fa408081e03e4effd3591a131ae5 - libtracefs: Add API to r=
ead tracefs_cpu=20
and return a kbuffer)

We cyclically call the tracefs_iterate_raw_events function from one of our =
applications and=20
noticed that our application was increasingly allocating memory.=20

With the help of Address Sanitizer the root cause, allocating but not freei=
ng memory=20
for "tcpu->buffer" was found. The fix will free memory during close and cle=
anup function=20
and has been successfully tested in our environment. The original problem (=
memory leak)=20
has been resolved.

Signed-off-by: Philipp Kutzer mailto:philipp.kutzer@siemens-healthineers.co=
m
---

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index a2dcfc2..4cd0917 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -293,6 +293,8 @@ void tracefs_cpu_close(struct tracefs_cpu *tcpu)
        if (!tcpu)
                return;

+       free(tcpu->buffer);
+       tcpu->buffer =3D NULL;
        close(tcpu->fd);
        tracefs_cpu_free_fd(tcpu);
}






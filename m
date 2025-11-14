Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020128.outbound.protection.outlook.com [52.101.84.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01285242D6B
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Nov 2025 11:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.128
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763118642; cv=fail; b=kh/FRRY/A5hlfuZvKN4zp5Wqtvb6UsLPPpzHBCNPw2c/MPEB8ygiMvRVCt5x6beJqUs79zG3oSyvaME79KqVCW9kUOast+DrLe6UvoSQzHDXG9JPg19PvbN2Am5PKFlDOn+tK82rODAydBnNKr3EEdSvWiHbXnDvCzWmgWxKhaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763118642; c=relaxed/simple;
	bh=qEz6tf/cSwR/vdBqIs+Qpk7iiiKNpn3MeUwVbvmYCaI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UBQvdXov0RAlB7u7yw7MXNgJjLfPQNnt5kgeWTpW1D9BLJXA/D9sVTaGosjEhYG5aNrAz6N2n60qMEdhOYSM+e30fyQaoXC4mGxJBuARmJNdUXQF5scQz/uhFsSFpa38GU4lNXdzXFiZJvUE9ieG7+7n83vZTlH0lz1kvNt50ns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz; spf=pass smtp.mailfrom=cvut.cz; dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b=I5kRhEj6; arc=fail smtp.client-ip=52.101.84.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cvut.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b="I5kRhEj6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QbpABoLOsw01s280s6FKTy/aT1ai2v4WRJ4Dc8u46+wS7i6snrry3jddGTtjbwKD5SY8TpYZNXM5L0VmsYP2IWs51U0AsciPP9TYso/uaaUSyKu2rEmvVs+o9EqweYQvuyzwEBjO1HhLLhDUTpb3iXA1xIMKuu+vgHU0iqOnxJ4Cw9gCJI7kXRIn9R9G8KfLOZQhaJlbKY+pBQ3QRqdwYYUEWWpU7wLrVx1dgE+DI51TsDbZ2+sNhGBD7Wygi8J81+dKMXwzvbBlLUEi1VRc7j3dRLvrmPxth36y7lGeIhnqNm/WUxtahYEw2gt9218TmR/w0q6uAvvP0qyixg7Sgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lKWsN92bEvXwJzB4bUe8ksI74kXI28t4N7XpBGqUXmU=;
 b=TP1d6WzuQt/Dblig3QSiHkvHTzIy391inGUy+3uX2qP+X/JDtjggtVQNR35qwKgscLQzLuLsW1lE09d2taiMHDFByyOf/JjTM+skLYKE5aoIXmNKp2JAE5VhEFJYV44dp3YjvyShLlu8T9Z4Xvt/qQrd+f6bufpRmrdZuHq1D+NpYfDD5V2BuMJQXYJNfT9cdIpzAKjG8I3MQVhQDpirJgVmLrILIMYQ/2qi7dxw5vuGqTWwMOhe6hSt61OURD9/caeLjjkH4HnnE2lDB402jjdqJcMhEq4yLZR2B26X74Nm5e3DsTF6HAMxZjgl8gYXsuTk65PapWdbCEytaAD+lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cvut.cz; dmarc=pass action=none header.from=cvut.cz; dkim=pass
 header.d=cvut.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cvut.cz; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKWsN92bEvXwJzB4bUe8ksI74kXI28t4N7XpBGqUXmU=;
 b=I5kRhEj6E0DVAPkXUyys0yhsK619bZdk9TVToRJkjDWTb4jpx1QmIIBOX/a+zj3T9CseQplSfTAegFZQKpOjftZu5ZyK7d4ZXuxxjf6HKcn/7kauD+T9+FPZl3/0H1LQTkqTBKnfSmgUz6gTVJYxfiGKKhZfaXlzoLg8iwFvgIsd/PAuaGMZignPe7RiE9H5jVZVOH2QkyzhzrqkPaFwW2H3qfABinKj98EodSJZJ0JdqzT5O1Tz8Z3lVv0FPCwurubVQmhsvRyGnb2Bnkhdj7ZJWJ4NMMmmWwdH+F3Jx0qUsEWUEOU6OiHkLEkzjt0as+JiWJ9FNfTDg9JG4Gn8nw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cvut.cz;
Received: from PA6PR06MB10275.eurprd06.prod.outlook.com (2603:10a6:102:520::7)
 by AS8PR06MB7765.eurprd06.prod.outlook.com (2603:10a6:20b:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 14 Nov
 2025 11:10:35 +0000
Received: from PA6PR06MB10275.eurprd06.prod.outlook.com
 ([fe80::32e:9c6:423a:184]) by PA6PR06MB10275.eurprd06.prod.outlook.com
 ([fe80::32e:9c6:423a:184%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 11:10:35 +0000
From: Michal Sojka <michal.sojka@cvut.cz>
To: linux-trace-devel@vger.kernel.org
Cc: Petr Malat <oss@malat.biz>,
	Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH] meson.build: Build plugin_net.c
Date: Fri, 14 Nov 2025 12:10:25 +0100
Message-ID: <20251114111025.21303-1-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0019.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::31) To PA6PR06MB10275.eurprd06.prod.outlook.com
 (2603:10a6:102:520::7)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR06MB10275:EE_|AS8PR06MB7765:EE_
X-MS-Office365-Filtering-Correlation-Id: 1863bad6-62f9-4b85-a5ec-08de236e6f42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|19092799006|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9ZnxytAp2bRbe+maOipbW1uhkWIddH6ZarOew9EB9+1pdLbyWPtZ7z/0k8wV?=
 =?us-ascii?Q?QjHhkU/dG+0p5GnqxJvghZaMXcKxafrR2E+e7KDfvnRuPhvUEqWBsaYOnEKD?=
 =?us-ascii?Q?QbcgRimS9HKsj/zGBFXk0Q6RPoVJIBSd53OJh+lFbgTNADiv6ndoP7IBjvOl?=
 =?us-ascii?Q?ivkoYe06ICvWIxcIzJVhcQztmvhIZwGthUML4T4o9fl049Mli+5rpdqWWZlg?=
 =?us-ascii?Q?64XDtVGo7ueDDe3sOQMZPBC3mHFcLvg5RJhAZ6Ca1xh2dhMzVKgSy79o1WeZ?=
 =?us-ascii?Q?dFl3u3E8s54Vu5TydSZJV/Q10O8sLOjN90Ec5Wc9dF9ezzDk46alz6k+YF5F?=
 =?us-ascii?Q?U4EmJL0E0pu2mUhRCNfRGNbZsw0ZT9e82hBCI00A/rZ1snZ+MwOwDFDOmjKT?=
 =?us-ascii?Q?V+Bfeny97a3gogB0sBq6yez3qpR9D7RICcTdnidon2yaGYdauo4P8orHb4Ht?=
 =?us-ascii?Q?4ny20yLtfg8O2cWgl/zs2E+7QYqNIgXsF6hVYkUQT7mht/1QtwKCVXZl61hz?=
 =?us-ascii?Q?u+qTZQsPwKcSJ4unUX41IvgB9p9F9kz8kGvonE+6iFsInM6u0RHtmbTRGhAh?=
 =?us-ascii?Q?ESYgfPGDmxVMSgbJIgNZ0IkdS6x1nFo5ni6b17l0XKzyFFp4+NHtJhylZyWT?=
 =?us-ascii?Q?qXGOsz1evAC7YBgBBc/1BN0cuxwZxRCs9KPXgXUC3cOvzptTWdwa3Qs8jO1r?=
 =?us-ascii?Q?D+3Cd94S2KqjPUw0LHrv6HhHKUzN+z9LFSndfjrpMv6kM59/t3Tjp43FCFph?=
 =?us-ascii?Q?s39bdaHGsFvThGrGXNKL5RFTrul1wq5eCJjrSVhoVrvHmwuuwIR1RE+X/9pk?=
 =?us-ascii?Q?HBV62hLeRj9dTONIpZ5cG2tIIaM6ufGKq8gvnRBcjSe91ww5/7Ih4Knk3dIm?=
 =?us-ascii?Q?9SeE4xWEfqf52SZZRLbyJI2epySlo4rRSo97HEZon/mbpS5DPZaenUO8qfQf?=
 =?us-ascii?Q?AM1ReYY/FBLc5e7LeXiokCorwDm9GvIDIbo4L/H4yltvAOVdPusiXDbYLLG9?=
 =?us-ascii?Q?TsXTRoUytTqNhz/FY5ijLhwYI22doDGLvCKlAOlCuUX+rhiysyzmEP3AmFzh?=
 =?us-ascii?Q?luwin8cTGKaWm5UB1SGf9DDVwTfrrL9U4ENVL9F7VSITlk0Z2DLsuTNnoY0d?=
 =?us-ascii?Q?XjlbfZv3sKtREpidZLC1HZCFMfY6vqSI2GQeHp/8dqUByY2WhH34b6+LGfjR?=
 =?us-ascii?Q?vjhHZxIXxx/iyAUEkurydBd3NWm2E16MZJ4QjuI5LapA25FUaGXTju5Inb2h?=
 =?us-ascii?Q?vkNKY9KONwYSJszRPn7qls6OfpDPVICvNM07uwWJl/IIZ3cYM4IZp5fgHfHJ?=
 =?us-ascii?Q?ZIPIqGsl79yxJy5rzBXZsh0YYdJdorq+ixOx3FN3kmLn4tRfsgTdNf2LIPQG?=
 =?us-ascii?Q?/keAEDXfjFTOPmpsK1qd4H9yKhKvR8HuLyZ4/X3hNrv2YVDHqW2q7Dlxq5XW?=
 =?us-ascii?Q?La210clMWnU2qkxBBrZ+5bOpL2seciqH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR06MB10275.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QCWNUHVmwdfDLDwgogSl7erR/WiQVMEfyUtc/KUK61G01dBM6uT1rurfAvlW?=
 =?us-ascii?Q?CD1158kxwBE0sKwq2wRtP/I0LcPnhQoc1cOi75B+p/+jTXlazZqWeKH3IoOB?=
 =?us-ascii?Q?V9e3lwiZA8SJTP73IBJLBECuMXVe3wpf4GDgA4o/nsaII1xrTg7NuDEOP47z?=
 =?us-ascii?Q?1/kjVLOuyeXuDZrU9SU9oggg7NA+gMBM8esotzcWi7nbWUZCQMX1LdOEDd2E?=
 =?us-ascii?Q?XCLs0CEL4C6vGaK8jJq6mhqLUWzwgdQy9wo4xkL0s1D81BLbZyP59veVdWiI?=
 =?us-ascii?Q?gs76NtL6DpYlAdOq7CZudwlCd3+O0EH2EKYlIhPKAYk3RD3yjH9gEveUN2Pp?=
 =?us-ascii?Q?dvthPJowcSQh+Cc70NuUspODgr45kWA/kSIvCj4cHnUCGz3hcNDd+p9hJOjH?=
 =?us-ascii?Q?AxdHNdU1QcZCAqWB+98S7AJBoCnKQ5VttYMItzXBzHSD8LNn063SuNIPd6Hv?=
 =?us-ascii?Q?hWVjzz/XCa7WMQrK8P3JoVZAs3MUIs2Ba6bU7dt+EYkjR+fC0mU/qIdvxJbl?=
 =?us-ascii?Q?rREq9QuiXYykI2upMydYiAeS+TfqMZiIiQfMx1vIFFNTSzs9X9qJjNaoGVR3?=
 =?us-ascii?Q?srcQOBizZukNtm0AyfuuetLn9F2o8D5OM4CdbQcAWYTy5BGis3s/ITa9YOAW?=
 =?us-ascii?Q?2FZK2n2+8WglMETE+9gczl2VZDuecUCV7VWr9/hQ3C8RhsDXeoITb4nK2NnS?=
 =?us-ascii?Q?18KWEUOi3IQiotWXw9r2za9+U5LD5ZCbDWrc2l/ex/JZmxyociFQ7OBiarvj?=
 =?us-ascii?Q?z+YxLL3S+0sXxEdoLPIfv2uwJSVkcI2q8tp9AkYVa1+nbXhLBF+vOd7QACEJ?=
 =?us-ascii?Q?PZwEWVtr9vu10/ATQ8Etpw7t3TRv97u0KRBJ6Wz/7ju6Sjkxq8f9Z+A/kLKm?=
 =?us-ascii?Q?MDroPYufm9bbDCXXdt7AwIb/9czUmgtpDfRtItuQdCNVIoXz+VpYcEc/DmHg?=
 =?us-ascii?Q?o4o5XQ3XjjNAP7Je4w1XOlnmtybZPrjPkBIOzXavkNq7Y7XCuJR6aivigwYO?=
 =?us-ascii?Q?YyFLpeCeCXUD9aFQmNEhncYdw2hLZhLi6dNVxqwasgiwfolOPcACCEwvNsaB?=
 =?us-ascii?Q?2VJgvClBGymjMJKyhhknKkv/EIeisK7D16A2tJiDdwiyNGrbp5of9rkWQGuM?=
 =?us-ascii?Q?leDjACt9+fx4ViCO8u5AIeQFNDRLf5/O1LeQbNl7DYHpUe/guN4wWshwmxxA?=
 =?us-ascii?Q?/MJfEQvMKmE3wcW19+PdLCaOMG3zfdwnuMpMgDeLr2VZU36Xl8TjpJW2tXv4?=
 =?us-ascii?Q?0MqM8KVS/risBvDpQKlAUI4Eufg3NcV5Ik6Y23+sv7TrazwrW6fK2GmVQ582?=
 =?us-ascii?Q?KtL0djr0SQbPmqw60Pgm9Op/UYKJlTjJXB5RyR7Hgw/z/2HjrJhL0eYAUCFy?=
 =?us-ascii?Q?52ZQ2spouzZ2OVYjDQeeOlIYDSjibZClJm1WSSJIHXXxW9js5fFhhdqphIb3?=
 =?us-ascii?Q?fzu8l1QdvK64wJOlbJgmzHhU375gW56+jrr/WhgarpPIyUSkmr79u6K1ZUYN?=
 =?us-ascii?Q?y7OwWXSunkoD1vl/a+TZSr19fsUX0LFdsPKWbEgaY9WIkaXmGzUVxCXfH0fW?=
 =?us-ascii?Q?Ea2ushrBd6oO5uWYtyw=3D?=
X-OriginatorOrg: cvut.cz
X-MS-Exchange-CrossTenant-Network-Message-Id: 1863bad6-62f9-4b85-a5ec-08de236e6f42
X-MS-Exchange-CrossTenant-AuthSource: PA6PR06MB10275.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 11:10:35.4969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f345c406-5268-43b0-b19f-5862fa6833f8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KiIRTWTtnhNJos0yI89oLa6zvfHAiHxzUfMFZPZRSptgEuo3jllr6sgExhQJZw2c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR06MB7765

plugin_net was added to Makefile but not to meson.build. Fix it!

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
---
 plugins/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/plugins/meson.build b/plugins/meson.build
index 4919be4..23cfbed 100644
--- a/plugins/meson.build
+++ b/plugins/meson.build
@@ -11,6 +11,7 @@ plugins = [
     'plugin_kmem.c',
     'plugin_kvm.c',
     'plugin_mac80211.c',
+    'plugin_net.c',
     'plugin_sched_switch.c',
     'plugin_scsi.c',
     'plugin_tlb.c',
-- 
2.51.0


Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013033.outbound.protection.outlook.com [40.107.162.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8850434CFC0
	for <linux-trace-devel@vger.kernel.org>; Fri, 21 Nov 2025 13:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732885; cv=fail; b=tHsq4QDmAmoOiu7qgZzbK1BcdhFqdIgr94QWAyRVS4cJRc3PqsHkIwcVWvljt/Yc/Yb8NLPfHEkj8K1MoCe4yKzWXO8LjHwrDZw1dWaH+iJsdgeMGhPKuwOtdtx2sQwqs9W/kGdISAesZtXk8oaFLliuw7SXu0cyJ0t/iUell94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732885; c=relaxed/simple;
	bh=DsllY+0pG0g2sJUJHFjG5h/sMgJ3F5A1HHPO3lfu0M0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=iIslBKEPKhdDA/UynIp0m1grF+5YLG3GswWwzJv3/xlqO9oDw3DqjeVzi69FxLg6Z68OoGoeiTvHMfRUljOGfoql8dT1bnxWSt0az6IzDEp9aFG6q4uHF/yHRXrDI8pBf8+32qjybDwJEIuvf5G2JorkIk7YQaiISigDYSi8olM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=D8X+6OD8; arc=fail smtp.client-ip=40.107.162.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="D8X+6OD8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vpCg3wBw2WaDXKMkeVUo3NTR8hP8S6dWAMo1bg8xa90pJPUEVzJL7YeAd2hcYHhl+d3rVbPC1Iq4Uj2ZlQu7jLdVDUBLT2yN2xP/2DsAjArXrgZzrRega8OmcuxZRcCkiqgFyBWoKuEwqr7VMIkCELB446QJal7bUDAadWE5dnOhpKKUJW1WzfGLa/oj3vm16+xEj4FZ57amNh9mwOh58j/4FYVJ5chPD5iwL7sFurY9MTBu0gzEuX6qXbdkn7MNNXlXbMK4VHFBZqR5prWNbBaMdKfiKv6lQjilED7AsA1fJ01n3T3rioQ1SZlWC1WDXCE+Qga/A3bGgf4sn+3M3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1N9zJvc1c7gGWw9AVNs6eJcY5AndP1qqQi79YlQ6pRc=;
 b=kn8T4MHU+HEkhrsjOSrWUCpaXxz2h5qIJBNNqKc0bUpa++HX7DLsia3OTxru3bUXkm0JAqynwpCQBvVtAIejhjbqCD4YVo1xqtlavZ8KFi0c6bNsu5LUOahcB/FkC6jjqmrVZDRqJLC7J3UPBprRjVZqOPr9QmHUEB0RNamIek0DuQrIBRR86M9OsguDYU+qxrIjGSF+9h3hog/gjj5RXI3I4cjhXWEavX2po+a84Y6Lgx8xwYK8uZ4T0uCqHpOafimMmiACjl8D0vG1cReT7BbMrN2yKm8rTJAxsl67+85SN//Pk/plNJqMz/ZKMZm9+3njjdBq75w11ueZVk+jrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1N9zJvc1c7gGWw9AVNs6eJcY5AndP1qqQi79YlQ6pRc=;
 b=D8X+6OD8tfd135LCFpLzcA3uvMs1IP3JMt5namM5Hyyrh7rcpxHINMEXket34HOmKatXw7qY1eYTiDulZ/ujg/XUI7Aex814NOK5Mpdtd6BlKcVKtH70jjSSTfC7tqhPJ+bsUYbZmWv6/Uit9Yrb+BUkEoTA69ZoQX8TXXtoUeJB2x+fDrKxycjbgC9SUA1HuXJ7l3QKVg81v0RaI0/EIwm4Forlf4f7ipI4dQSOZa2dtR7nb7HolMYTbz7BHkJU6nytVm1YJTSw38ppnNVeMiHjFy+ZEqogVvYMVoaRjlwns4TFn1/Z7Et2QwIrGLiUGP0oQcFx0X6DAP8JyjpT/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:47f::13)
 by GVXPR10MB9483.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:323::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 13:47:59 +0000
Received: from DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe]) by DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8198:b4e0:8d12:3dfe%4]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 13:47:59 +0000
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: linux-trace-devel@vger.kernel.org
Cc: Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 1/1] libtracecmd: fix memory leak on partial reverse iteration
Date: Fri, 21 Nov 2025 14:47:49 +0100
Message-ID: <20251121134749.1530855-1-felix.moessbauer@siemens.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0185.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::18) To DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:47f::13)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR10MB6828:EE_|GVXPR10MB9483:EE_
X-MS-Office365-Filtering-Correlation-Id: 947a3524-9154-43e4-b6a9-08de290494fa
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yPDP8E06tLnk4LSeXekEfU7aGhsB/FJb5vyJA4Y3IY9EBa+CfDy3Gy6XM/tl?=
 =?us-ascii?Q?P15SeuQH/T89E5881G4YbgKMaQlobT7SgRuV6ml9rsyTMcDmDSrMRqeL6ZZ9?=
 =?us-ascii?Q?UQr9Zwyoxru9+26UUXRK7HQ+BPQgGqI/yfFD/gkaAEFpkht+I24lz0FTpFN9?=
 =?us-ascii?Q?TPL+bkCkZiLnG4ZVGEc7iH2gSmdqn6G7Qbz0PmbXBupOXKKeZxgzduqTe6vz?=
 =?us-ascii?Q?ulAozzYNUsSy1fNlBzH9hc5w7245eycQZPPf3CPzpA1Wy/XmixzcXmy23tjN?=
 =?us-ascii?Q?nmp7G7Lfv3aTiBLXOV3zLLpoMP/d77wOPQ19TRN48RweJLi7e0q9U+Wj4H/X?=
 =?us-ascii?Q?jA0kPT0HsfGY7F50oYTQ8etmKI/+JGWz2lj/G8qChqEx7iCcJ19V2rAno1IZ?=
 =?us-ascii?Q?eNHm0mnT/MYeEG9wgEmhpJ0VfXbr0ZBI/xTGMvH/ixGhgWq7HUSR18TzGVmi?=
 =?us-ascii?Q?vWXnyoi/Wq1tBOY7XZTDmbgLLUK29Ht+HxAVC0qlF3RIc5jVUMbcfYIjwYoc?=
 =?us-ascii?Q?u185CofsTO1/i8vGcRLrf7oBUqunI4RvDmTQ8sq/pchTi1YuW3gJSofmXE4P?=
 =?us-ascii?Q?6EQ0CWMsfBg0gq4wEyeH9Bg4wkRKBDDlgmyQsF11oO/gPAZVNxiXTwe+PUa3?=
 =?us-ascii?Q?R9razCsi4PR/G9Re81jWSPc899/YaU1X/+7DwtEIo8Ry5MD/uWuIj4b5uvzB?=
 =?us-ascii?Q?JQC93PFTNY29LZS3FHddcr2kBcgmXFX5iliicPcT7MNSB0I73WXRt4clnyKC?=
 =?us-ascii?Q?j2ZA/iDPhBgBN5VFwATOLIubtfa13XJmwsnHHEUs4lOz9Z4aW9RMuRzLt3sH?=
 =?us-ascii?Q?nhh3FeKjS8AGDsd0E1xd1rWlpbEShw9Uyb06Np4GevB7b+/PN7PGR728JwV3?=
 =?us-ascii?Q?hM/3vrDY+7FLVDv+/Brjfetch7+TIlaiyFhcFeRsrGzmQL322zs+1JQo3o6V?=
 =?us-ascii?Q?w33UdGU+OBQEnQzA8GGG7YTanSwQ/MXVwbPO16D+IgxvPbvv8s3RXw0NjqOT?=
 =?us-ascii?Q?F874ZfcJB9zeVjUo5S7YwjWf32q8Ie7+xXtR3Y7aapqCpu5ulAulYfT+fU9e?=
 =?us-ascii?Q?Q0b3/69tJt6ahEcQ+ovlJ3JcmdcbQEmYOUCiaLb89GrIf5itT3aF4PIas/tT?=
 =?us-ascii?Q?icg9asVvI/xel+EjKGhj8bKo28Ok37rAynjLSkl2XVhRsdGFCpzK3ksIGL1o?=
 =?us-ascii?Q?ho4MsMZ+Yi4dEUqf/0jAHFUM3A1MxK6r57KYCqxj8G+rDSrZLN2rQbruH75a?=
 =?us-ascii?Q?hitTnaAZ4dPuCmRTtp5wxpD6I94iF+Avf0XE88BVFCkzt9VfMjPdt867FiIW?=
 =?us-ascii?Q?8o35BIzmsI+ZVk62h3JBfuIPHkDboJJ9oO3ebe1/66YQcnASnDOTyUpqTC4u?=
 =?us-ascii?Q?zzLDpBbs2Aq6RqDeoOvaHKNazOeokxhRh1QpIDuCzCF1kQG8Q8Yl0Q7OWCX3?=
 =?us-ascii?Q?f5/y1JTbFPy2NqaGMmj0RC56fciBHGVdXrzTVNNitdegToX6fkwKDA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ap+eGNzvHWEpp0KX8oj33+IrVsYf8kKwfyVAlQdjV3pWpQWirevhZISG7CDM?=
 =?us-ascii?Q?qgvNgmQH6QjdMRTfG2xVYYrqnUJUcXG5jFgRDm+fHo5gL6kdLxRwbzTGZJuL?=
 =?us-ascii?Q?kPngWa1Ze6Gw0UmSMhoU1/jSrhGyQwEMHKJqSwak4n4K54AebGZi+EvuSs2N?=
 =?us-ascii?Q?VMMxOpNoyoDwdSwBEovpx192dx2Jr2DO1Ol+fXgxp3JGJPXugXdMoK/0BFtU?=
 =?us-ascii?Q?JtaLd2cW/AgYnA97qE29gw81tqGTknz96Sh+0YCzn7b55GQufbmNJLy+hsMA?=
 =?us-ascii?Q?KzrOcaCuJAG62yyyvvUDBVF4kQg0BV7eC9jYNIY1N4+oygXGUyEQsF/sHxa4?=
 =?us-ascii?Q?FlYa0Inw/jw1D+M8iPn64URpvML5ANvN7QpStnv3j1lmlPkS78BDPn/V/6Ky?=
 =?us-ascii?Q?+87dfNp84j4cdk5d7Pqi7msSr6rTUZcfgEPIFMAqOdZTnsK5hE4TfzieVVZ4?=
 =?us-ascii?Q?GIyKk3OVU08nEOk4W3DehFQHb+dmjMCxfBRfCPTT2oQ8y5Ma4juGvwn9Dit3?=
 =?us-ascii?Q?JrVzLSmT8xOFGZW1/DzGR8m55+ZjqOUQKALaTNlgIyDyKh3vMbXVnI+LSKoR?=
 =?us-ascii?Q?MgS1yYRF3kLER2Cf0Z6qxRuIopagDQj85Dkap6vF6vbc7z5Oat+chjUSuhmz?=
 =?us-ascii?Q?MFefSJbbi7GKdIqjkoY8J05kWoN19XhqxCOJdXutLlTPQLgkxqtcr9/a0og8?=
 =?us-ascii?Q?eDI8lN6lZYdWwJTDcNKemWYiG8eOOlgwEiJovFwYgepzhag8v1DmTTP8kOHu?=
 =?us-ascii?Q?fYebr/t8XT4zAkhxR3Xk5GFf8PHPXMfl32Ep8aeZn6hteOBhd6Msj7MIifrW?=
 =?us-ascii?Q?5IWWjmwQABov7iRaMMNyWcZ6d4Vx2qlXbx6hV/Blokg3E+dTqJimZ6NkNad/?=
 =?us-ascii?Q?/udNbIv0WYZmAUCj7RmKKKrFrdduV2EKTaLEZTFvqgsCVApbJ1gONocI25uH?=
 =?us-ascii?Q?VTeN48eulImzNDivMexh8tI4JhwIXuClhLWsdreLYwaoQn8jNH0+TzVD3Cac?=
 =?us-ascii?Q?5nqE9xIJn+fsHPGoCQRNGl1+7xoeCvjsGlUm1iRnMD93tIUUsPtZy8Rrzmo8?=
 =?us-ascii?Q?9mhWfI1IJZ2eR11Q8cMuI5+z8f7GlN9N1n3l877MB4nmL9/EAEv1/pO3Jb+Q?=
 =?us-ascii?Q?MoGNtXbiZwm72SpUiJcW7ik7ENoKlgC+PmsdGr02Klj+VAXXIzgCiHuFYFVf?=
 =?us-ascii?Q?G5GNtsiI51qSbG8dzt107W6JzR3zTd5bdz8xJmyBJiOAmM0bb+JlfhXLrTAF?=
 =?us-ascii?Q?KwhVxfkJIpHQDDaFuav6SD/E2cXOz/Fr1eULW/TleGhuuJcTzuIwKH945jgI?=
 =?us-ascii?Q?0/zQFL79SXNrrKWjBoip+iYFpHplQ95FvGK5pDZ0wFJOtxIluJ12OYFPfwM4?=
 =?us-ascii?Q?lMpjhX7FH63vngveS2LcXZFauAEyny7WPL/9fgJdgS4WQAoLpZEtQQi+/d+f?=
 =?us-ascii?Q?8aDE4vT9uP71qcylqRB/r8cRt8tAaDvXWzbV9nsfEy0AJp/qgKoOUW4fYalb?=
 =?us-ascii?Q?fVAhZ6muGCJuemh0WmSiawEbaRU8WslHxY36JE5tsSc3//16dN6dIHN7JZAd?=
 =?us-ascii?Q?ghLDMTYbJwFb+vx/EgIAJyJTeNs/QgM2hxK4f/nhn5UUPKvLnD7nhZf2Fkd0?=
 =?us-ascii?Q?3IDQaYclFqjW125Mi1g5AfXj1KfodbJncEBBoqvGQXJXsleY3mHn91bMqViT?=
 =?us-ascii?Q?KPnwqg=3D=3D?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 947a3524-9154-43e4-b6a9-08de290494fa
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB6828.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 13:47:59.1312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Wk0C5dEF0xmFMUakfraOlStJWFzm+74nphVo+Li+qMN3qF+2t40dggoqjYngWGX93rpcbT0Y0/Ba4DYVzr3ztgEX0iC1jQT/ad5IL++Jqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR10MB9483

When calling tracecmd_iterate_events_reverse with a callback that does
not always return 0, the trace is only partially iterated. By that, the
non-iterated records are leaked, resulting in the error:

 1 pages still allocated on cpu <cpu>

We fix this by always iterating the remaining events on all selected
CPUs. In the full iteration case, this stops on the first record as this
is already zero. In the partial iteration case, all remaining records
are freed, which is - by construction of the records list - at max a
page size.

Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
Note, that this bug has been reported in [1].

[1] https://lore.kernel.org/linux-trace-devel/0b4fb4b774a8754ed86a9212f0a253304a41245c.camel@siemens.com/

Best regards,
Felix Moessbauer
Siemens AG

 lib/trace-cmd/trace-input.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f2471c92..afdbd2aa 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2995,6 +2995,25 @@ static struct tep_record *next_last_event(struct tracecmd_input *handle,
 	return record;
 }
 
+static void free_last_events(struct tracecmd_input *handle,
+			     struct tep_record **last_records,
+			     cpu_set_t *cpu_set, int cpu_size,
+			     int cpus)
+{
+	struct tep_record *record;
+	int cpu;
+
+	for (cpu = 0; cpu < cpus; cpu++) {
+		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpu_set))
+			continue;
+
+		do {
+			record = next_last_event(handle, last_records, cpu);
+			tracecmd_free_record(record);
+		} while (record);
+	}
+}
+
 /**
  * tracecmd_iterate_events_reverse - iterate events over a given handle backwards
  * @handle: The handle to iterate over
@@ -3057,6 +3076,7 @@ int tracecmd_iterate_events_reverse(struct tracecmd_input *handle,
 		}
 	} while (next_cpu >= 0 && ret == 0);
 
+	free_last_events(handle, records, cpus, cpu_size, max_cpus);
 	free(records);
 
 	return ret;
-- 
2.51.0


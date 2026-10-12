Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013012.outbound.protection.outlook.com [52.101.72.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDDB42FCD8
	for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2026 14:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816680; cv=fail; b=rtDTMQHb/ttdQSk+9U2pBclFS2xXV1pGzAq8CeIq/ys5ztTjRyNa8/RdsquBd9tZYD+HMLieCJeTDu9zZAA0xPWCwm/sZrMaH6U+922lrHTUOvjWkHOBu9LS5RccUp4t+cOo336eZ4Yt4e6vaatwaE6PEMWxHr1ooiwdt7LpBKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816680; c=relaxed/simple;
	bh=EP/Xc1qS8HYEh3vhvJfAINuIAhLGibbW8tYsWiVszaM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=tOwZP6uPB7LLmZQzBz5ICrrKxg+0fu1ICeRt4I+0Jyfey4zePGVQVunjZKVLGAHUzA2IyZO/IpGlI4hj0ouMY5E2jh+YqFK/xg36v4WjgKezx/TkxbbQnebytGNFD2AKFYK3IAlm0ZnR3i535l4XCbAqn74s3PazYB0WYzfbLpM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=Jd7paixa; arc=fail smtp.client-ip=52.101.72.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="Jd7paixa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H6vlBx12wDa/eNCJH4nPHxc3redyUjaVkMZ+ZJL9kLu38tLEGi2hm3Ru84+kehJd4rPRf4i0CSpi5QC03BZUZLoDhZ/XZoYoZhjQ/ixHkbOGv+k3+MhIYmQDbVM+1Zps4laL3OIq7PtVe1qcRQqI3T6UtLN/MJnPaGfrHVAYsXzZUunFa02YKqbJeCz7vUp+/0e5clGJtjyvjGn5Z43sjNzh6I3mLdOuHE/jpORku4LsPK82LcZS0A9VkZsBkXa9nKICYVgXoAVU8vtDTOB3po0Uz1qLz/tcQJjp7h6HcrrSG51agB1YNLjj+3/OLoOA+JHl+XVmZXZhh9Bd37eoEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUpNf05z35ugfxZeyQSnzpQ4YKYVXghazYf0NF6B/5Q=;
 b=Fz2ewQe5+TCu5nSDtWMmPHVx6XUUpA9S8WrHAFDuO7BiYsFPIbAfLXa/yn28Il81ZewyZQqSPnnbByFIA1F8FfLB/346gZcglZRV974d7yb2k140qgWB7LAfSX/XBRwWNMKZNkYMrzjrUxsVAyeg1zCe9tsOH9JEPmyh2Kv+1U4z4ThqbCLy7Ecp+gV/lAalSZTiP2cTo8YGcfX3ufJs0l9jwGvjyxeV6E1NaqFN6RqYxdFi+3xAgClAXRDYsguTRsaGyzJASDPDm9uAZJPq2bpxWXk1xs8XoO6qnGPO6MMKytw9cGPDbFQp0JFs/odJyBw2IhmMqBsygw3fe9cbPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUpNf05z35ugfxZeyQSnzpQ4YKYVXghazYf0NF6B/5Q=;
 b=Jd7paixa8Hj0+YBk5HF+BF71L0ChoBNsTgEdylQs1Dbb/LHI6sNi+sMaEm2bLbnB4kz8bCF1KtVec0sAolxtnIMxxHAOgQn+ITEHATfl7ojovDJcnzXULToZ+OI7H0CWWBnFo8sGOYDKj4imdlXrE+V8Xulg1+CdcLJtP4kBhvWxauUDnDA5zHrwwy9Ftax4e5d4pyOf8ayS/0hstZas3znryx+KG0Somy8Y3hJ5al0tgMgD9r8YudcftG0anh5S7Wj2sjFae/5b3gO7AkOiVVkX9yZudjIy+13429JS8g9wLRrrWuNai/dhWBjejErw09jGVAZoeuDIvBQH+oY68g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:17e::10)
 by AM0PR10MB3491.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Mon, 12 Oct
 2026 14:51:15 +0000
Received: from AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c54c:ccd8:ebbf:477c]) by AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c54c:ccd8:ebbf:477c%3]) with mapi id 15.21.0496.020; Mon, 12 Oct 2026
 14:51:15 +0000
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 1/1] kbuffer: Fix kbuffer_missed_events() when sub-buffer starts with a timestamp
Date: Mon, 12 Oct 2026 16:51:05 +0200
Message-ID: <20261012145106.566628-1-felix.moessbauer@siemens.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0082.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::21) To AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:17e::10)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7PR10MB3956:EE_|AM0PR10MB3491:EE_
X-MS-Office365-Filtering-Correlation-Id: 1413709e-66a3-4d41-f037-08df287043da
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|56012099006|11063799006|10067099003|55112099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	RLmrjRskzrf3T2oLxj1cUg5GdYnsrqCIZ2WdGsnHx6NwGjF3pcBZdv4vmPWSkRMhQkmvHIbk9ttgk42toN2YGl1+dfcDSCSfvK6Ow6XkpCu9dmDOMAlMQHFHz4MAargD8xmIWbYU2EhHo/o7wUi8aI14ekXG4rscbgir1wEQOXw3JGiR8J6OJDWlTerKpFYiiFyka3/wj2/8CAXYj+J9b8Z2Su2di1JoIlf+doLupSW6mHtvj0JJDy4AIgA1iiTB9WrRXx4aXuPdYxSInyyqNidynkM0/mTEvtMrVEubi5i138wbwcItIkrlnvb2nnIhIdwYPNor07aohZg8KlMK35mEg11nm2EGjBHvEFyB6MS1WBv4dPn93LjKXdHWNcXk/Y2e8Nmu/Zq6ZMhzPdfrR8MiRDCIZ7dQn4OQuE7W1OK17E4I7aERdGVvYHjsLDea55kHnIeOhgviJ6DOW8Hgpe5MlmqNSnh0qBYbLnU7QCERX++lTY5ILgUZyWLIZeRyNd3xuPuhooJKZq3Gp3c/siVNCm5KQzBh6IEtrz58UX+XUryLoSeaTy9gdV6VF/Mx/Fj4putNMTOvfcsKv2blg8OCR5ZAeRHER9bzohzYU9T6B/xfXGgmHmz00qzxg18qT8N0NlEc5vi+PpU6NPPMmFpDx7IQ3ieXxTHc8uyClek=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(56012099006)(11063799006)(10067099003)(55112099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Am5efxvnc3h4CnoICovZT6C1ALiiVDFLhYcQOJHcr60GWPlSzUM9F/9s3b3r?=
 =?us-ascii?Q?U6OtXoU4g2xBkRGQv0xV9hkahxGLgBaE2xegkwdrY7QCGTaKvVrXZbX63AAF?=
 =?us-ascii?Q?NLGj5l5RJ714Kj+n6tht2HKGmN77bvTP0/IujHcmuVvBQg7xXUNGoRBuum5m?=
 =?us-ascii?Q?UKgeKZbKU1M1HCsEYNVeQJJyu26/r5ovidp/E+uy9toCTokZNCe9+F6PZrwT?=
 =?us-ascii?Q?fgCBAC1bWBoc2f5Q1+rtNBpQF8Cmn8ewi9OKOp0/SDt7Vs07/UrZXc4k0at4?=
 =?us-ascii?Q?u8IZ4AUtTs1A7H4NCM+XnHT2m9TyUoG7CUr7lu+eUmna5q6iQY6Q1Y9k7u20?=
 =?us-ascii?Q?uVT5Vahvhh+w6jRbqJUlW+JqR/nGjjGUghwNQ9ffiFQVNDFeTRCwnDwQ4GD5?=
 =?us-ascii?Q?P2t+c9ifO/W+TlUZuUNll6HRj7DSYnSNTabr3L23XC0a2lWCfBMm199AP8KB?=
 =?us-ascii?Q?KnMVbBZFEG2ji3Z+oNJrDWcCG3NqYgLFGOAVOEih3ORu3uGp6FjJyK6vCGZ+?=
 =?us-ascii?Q?DOkEJcOL5ZjqtN7oQYQgCCpfGEGpUf04cfhz3VbgSKH+wHO+kWJ4veJ8D5m+?=
 =?us-ascii?Q?szUQmTifnyjJxeDYuJwY2DEM7oNRzk7gcpM0NNE4/PL8eq0Kdsjw6cnVjobg?=
 =?us-ascii?Q?YJeF9u5IZyiEF8stXA05DVOnlYWm8fG7ASDBv5FzD2hN1L1GTAoCYyKGKtRE?=
 =?us-ascii?Q?NZ7Nr4aEOrrGWHm4et7h4xW2pTAFXHJXBSCBOnoXciZyxHCjxqzePfDRwuBV?=
 =?us-ascii?Q?Os9rmSKz4czX/61VmGhkTBU4aZRr3MV3bipzIv7LuwN89TGIcDFZZlUv1EQG?=
 =?us-ascii?Q?IGkiGDNAhJ1lv67ldja0JPxTSh9mzK8OGAvwVWXRkYpF6XzFWC8T2lMCA6zE?=
 =?us-ascii?Q?04E/RpXZHJ+STgbBAUiGz4MopU+AcTIicYR2I682vUaJo47wJ/Cf3aZnbBOI?=
 =?us-ascii?Q?kGuKyKXM7ZPjZR1c0UxqZUD2BXEKhdrmM9FE22bLiDHJp9Sle8uEnZWqrazF?=
 =?us-ascii?Q?4sW0ohY2n2uNJmPv8Uf96TWzjLHDLzdxf65d4zZiwUa4VEHrdRxL4PVwdRTW?=
 =?us-ascii?Q?WS2wF/Ywz10h6rjb2YH3qkNvSsx0xfbLNeF0vnKfL3yXNpORJCVsuYqrxWCr?=
 =?us-ascii?Q?jrSHh/4Fx+66V+3tWJedcimZUjCEvtO9C09FsrgrDdffRhMmiVJNfFjxC1En?=
 =?us-ascii?Q?8PzRmYcZsswrGhen2pq6pLeO7GtXP6bPLqb1+jI1086FdNat9ZnDPt5dsgy4?=
 =?us-ascii?Q?PL5s9B47budi53R2ppi4taYFsK2cUhYSzk3DZXe/j6w5xDbjiu7LITJi3NrY?=
 =?us-ascii?Q?Yj66BKmBy2jLMV/FOw9vd72VXd7x7jGd9MRFBNMAFKyDdKxVkIslcR/ngCGd?=
 =?us-ascii?Q?QM/EU/LU7yKpSke9ppbk3rCIdAeZNljhw0yW7LxEmRHkSxQznLOGeqrnJgzL?=
 =?us-ascii?Q?18hNndPtprgPwkwe2wjLnyrFfm5KhjcA7RgMonx/54KYwY1HSho8kCEAn9ah?=
 =?us-ascii?Q?J4ohpBQaSNut2A4cTdRUW4roO0DpWJzRWGtuJZeLibXE2qSj1HjC0+BAZBXE?=
 =?us-ascii?Q?dxCsdPiS2tXoYFj736/K9JbBvo+7ILGfy52PABE1yeBOimxDe9N99GYA0tnn?=
 =?us-ascii?Q?li68YeYxmwP4gsUE/56A5Ctg0v/dOh1o2DLOrJd/VhzbUFmampIYhWIlLWYn?=
 =?us-ascii?Q?Me2t3O3DMFLcHScQUbnX1iEIReh6oEJo7UUqmbrHcQaYKDE0vDiAWwKXlk/t?=
 =?us-ascii?Q?Lxa6YZPexO0KPMObIQtnZx9FD4gMsmg=3D?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1413709e-66a3-4d41-f037-08df287043da
X-MS-Exchange-CrossTenant-AuthSource: AM7PR10MB3956.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 14:51:15.1017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIb5EVSlbGQ3Ey16GsUcEkvvFE/Jkm/FX+bTjfcVTaSlTygOGRrqFHoQvNNczV0I0zieHJDnL6dJ8S9PfaWH3j+S+H0q5J/JkkD2mA3H7ug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3491

The first record of a sub-buffer is not necessarily at offset 0, as
time-extend, absolute-timestamp and padding records are skipped by
__next_event(). kbuffer_missed_events() still tested "kbuf->curr == 0" to
detect the first event, so whenever a sub-buffer began with one of those
records the lost event count was silently returned as 0.

Use kbuf->first, which already records the offset of the first data event,
as introduced by commit 42347e10aa05 ("tools lib traceveent: Fix
kbuffer_start_of_data() to return the first record") for the same reason.

Apply the same correction to kbuffer_read_buffer(), which used "!save_curr"
and therefore dropped the MISSING_EVENTS flag from the copied sub-buffer.

Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
---
 src/kbuffer-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index 232d168..4a38408 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -849,7 +849,7 @@ int kbuffer_curr_size(struct kbuffer *kbuf)
 int kbuffer_missed_events(struct kbuffer *kbuf)
 {
 	/* Only the first event can have missed events */
-	if (kbuf->curr)
+	if (kbuf->curr != kbuf->first)
 		return 0;
 
 	return kbuf->lost_events;
@@ -1014,7 +1014,7 @@ int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 	 * If reading the first event and there are lost events, add it
 	 * to the buffer.
 	 */
-	if (!save_curr && kbuf->lost_events) {
+	if (save_curr == kbuf->first && kbuf->lost_events) {
 		unsigned long long cnt_8;
 		unsigned int cnt_4;
 		int word_size;
-- 
2.55.0


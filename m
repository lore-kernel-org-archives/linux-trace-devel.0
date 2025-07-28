Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023135.outbound.protection.outlook.com [52.101.83.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D4B3C1F
	for <linux-trace-devel@vger.kernel.org>; Mon, 28 Jul 2025 14:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753713292; cv=fail; b=OMJnaWiBqsGp22ivkfqsrHr2cZUU7oXjWLu3u1OUwRCYFZEYk/D7Ro+af4bmWBHF+8e2ZfsXWuTQMLWZMirVsn1Nz30FEfVhoYK8HreX5f2ptAi2gMLcz+EQHrhosEo60+5c5+QASt8mMrfa2m2Rai2f52rp8eGXWR2E3ZLbiao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753713292; c=relaxed/simple;
	bh=sc8aGJnI9gCtW4Hhox544JWpsV2bR3dUiYfwmkYJr7A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tkpxQ6OMlTj4YM0JO8LqhaIMg5DN5b6HxPwI3l/NuapxfovkZpc9VtmpDnn2wmv5ulf8otJ1+yjmLU9kI2D2OkOQnOXwDBd9ycQpTW+VGUbvEt+La06Vivp1hnPQaqn5EXPu9d5+NYO6XCRSJTIPgC77w4puyxOmORF4jQ4To70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz; spf=pass smtp.mailfrom=cvut.cz; dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b=3ZqfdJ+V; arc=fail smtp.client-ip=52.101.83.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cvut.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b="3ZqfdJ+V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f1S/6W/6pVO0R1Rl0aN5p38/NBx+Yr3Eqh49ag+SdFzDqkOKirHZ8IiyWdZ9ax5owo9yV4RkeOBflW/sRKUNP6UDD58PG1bh1q3OZllljEAllJgVwO/gLXOnkG9ZaWUWNI5hCEBnHnQXrwjTj7g472XFiHvlI+FZ9uqnQQYTJoAW/CpDfsfQac3NTd2FnJQLrVtNE5T9vAWTpmPwoXvyQMxlu/+ttbYripw2iMwkutn8kKLYnVKwFcpmbBzX/vL8A2/RMFmlFp4tsl0DLS/PNDhvza7pXHJ97FGt/b+x8czXtmEKmXmMcPN3scKt/m+S9XqlJZoXMBXeEg9k1IZjYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7AvbeHzT9Wr3kf7uTCktveWDvQQojIZhrTAhud2xEM=;
 b=Z8H8AdAlXH00cqX2+UCHfX3bCDp+o5CRsQVQ9UtWh6wAQPWoqCSqPqIlaElE1M0rj74m6+1gLZjkrS0Vueql/zXCR3QyGNJG91X7OY2Q8NMXmbNM2jalWc8uyfNyHFIRT2IwwH7gfc01xQUmUi6VjpX7w6CQUNR2hafvC0M6xoI+7dn7MhGqj3H3U2qvqJfoYGwvkN/Ie6CQa2HC+Wjm8dFnM5npwWYSwKczdjlmKs1Q5LuUpvWx1kFif65r3gzueyG2r+tRHbgAd61zyOr/KW0dr/7WyN6y+F6rjBRmgsVHkG6QIDvqaz7p2EKbsU83zKt8QqqmvvinJT9FP52a0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cvut.cz; dmarc=pass action=none header.from=cvut.cz; dkim=pass
 header.d=cvut.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cvut.cz; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7AvbeHzT9Wr3kf7uTCktveWDvQQojIZhrTAhud2xEM=;
 b=3ZqfdJ+Vo206QsaNAg5Sk9RxJ+GSfz/0g04Ltz8D1CR+Kjxo2yPKtsZ7PVFomztrHk0g6iydSbaXS/LjwT845daXuO6pIoHoBVI52wBsv8COqWxLbclpeUjEoSxDu2E6mUvMqu8TfzkbjKoeVLCV/3Sntm+Zq1WwWrXgrGG/x1vs+XWRyvRTjfR4p9Xfdun5c16+Yd9WHLjXCNMqq4J5y57uuPNCEb4AXYiOc0o9fBFijv4tOAcj5/be3o9rxzJ3dkqTFOUTE9JBTeVorV/Ha5/WkFtBcprVQWYQZXGAS1UrisgfnlacsMWqW6UTI2gnmtOtzy7rjelNCfA21IrcVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cvut.cz;
Received: from PA3PR06MB9863.eurprd06.prod.outlook.com (2603:10a6:102:4b0::9)
 by AS5PR06MB8804.eurprd06.prod.outlook.com (2603:10a6:20b:682::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Mon, 28 Jul
 2025 14:34:45 +0000
Received: from PA3PR06MB9863.eurprd06.prod.outlook.com
 ([fe80::cd97:3323:477a:3ed3]) by PA3PR06MB9863.eurprd06.prod.outlook.com
 ([fe80::cd97:3323:477a:3ed3%6]) with mapi id 15.20.8964.025; Mon, 28 Jul 2025
 14:34:44 +0000
From: Michal Sojka <michal.sojka@cvut.cz>
To: Michal Sojka <michal.sojka@cvut.cz>,
	linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/2] libtracefs: utest: Return non-zero exit code when something fails
Date: Mon, 28 Jul 2025 16:34:33 +0200
Message-ID: <20250728143433.1114222-1-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250720221617.695311-1-michal.sojka@cvut.cz>
References: <20250720221617.695311-1-michal.sojka@cvut.cz>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR03CA0053.eurprd03.prod.outlook.com
 (2603:10a6:803:50::24) To PA3PR06MB9863.eurprd06.prod.outlook.com
 (2603:10a6:102:4b0::9)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3PR06MB9863:EE_|AS5PR06MB8804:EE_
X-MS-Office365-Filtering-Correlation-Id: fbdbf339-9891-4614-0e11-08ddcde3e54f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hn/FzqPiYCVCeC06gG7G9ZVy3eJBeWg19PiKjmHJblZQOWkfHxTw2+HOcSqC?=
 =?us-ascii?Q?wgroBNW/NNHhrB9yBu/J4AiO98fWrKHZEdxGSh2gif7TE8ulYOKOirRwAzv3?=
 =?us-ascii?Q?TqYxkkztRDOXcJi+8eqzNs8DFHNnVWbljojKlUsVa6q4GrHXJy8/isQj5LdP?=
 =?us-ascii?Q?grC1sDvSEseaI8rcDEl39eEwN3HdCnUB/mEmTa5W2O9GbvEr05PKH6avZcGu?=
 =?us-ascii?Q?4K5pYcCbkiwqprN4CheAJjT8fTum8thKqYhit97sIY7tK40+InGMXQwH2/ow?=
 =?us-ascii?Q?+WkapC0K8/8eM0l2BAtrZEpZdajuZms3vJB1HxWktUQ9Ve0VfMvTqtS6Yxad?=
 =?us-ascii?Q?I+akWinAu9dzFoPbql3p2llbTU6oYwx1zfcFsg2H79+aBZMpV+4p5dUI+D7m?=
 =?us-ascii?Q?EKq8f83cIAWkh5z0hUL2qohXyyxzkDNI8jeLL0YMThxNKLNMdXsW7FtPeZLd?=
 =?us-ascii?Q?AE/aUeEWbqyDGiekKQV5sfOYW2dITl2r4fXZJyCwHOEFim4U83RAMhiucCR0?=
 =?us-ascii?Q?i/3Fecf2zoUioEbdcqg8Ic2qwBSjo0+k5XtZFvjPlqyHBmfre9jKKzO217v5?=
 =?us-ascii?Q?YyXKnqlKS8IlQbsjmVFKW1r6LbNYSL/LctzIkIN7Hf5SzitxpRA4Pig4MUj+?=
 =?us-ascii?Q?GdHY2zHSubOUKL2tkMuJDNAV8A3N77PcV2Tly5jA2Euo2S2R1gkWGCDjDepc?=
 =?us-ascii?Q?IkElCU+8dUb7SjG2gZ7xowSqZkiIJ+7FF0acANHXlSBd1WLjCfbwfTQsnFA3?=
 =?us-ascii?Q?hDCr4npUYlQJO4mLsRTPFJ+iLzXQ4/Ic7/CD4cN/mr0DBJhTzWU8Hziqmdgq?=
 =?us-ascii?Q?6EJNDwOYUTro6JpOi75J2F822mAaPKrOxMZrUFY+kXCQzyueVtUODBfGb9Z8?=
 =?us-ascii?Q?NBEso9ltZbZqPT3Bajw1yanwsfzn4111xvOjAIt8bM08N1JWrQOcqyrHau99?=
 =?us-ascii?Q?mMfIbC8bvspiji2J44vj995f1LGkaYOwxqXYxGQpTZ4e6M9kHz2pJZ3zFK0h?=
 =?us-ascii?Q?JJ0mXlT8/zBPf/4HmG8TpBiCh27IOhTXOq+kmMaAieLsZGBerBMiD7Vr1h1e?=
 =?us-ascii?Q?o0t2FHET/UMBe1YDY6N11Zj4Nh4J1SLV+Jj4wSDnHog0JUdRoJJBCOa47zfV?=
 =?us-ascii?Q?ufU0g0F4ycs1qu+a9skfgrBVCaz2OlnO6ZJaWSywOSVj0roQH+wqi64esmZx?=
 =?us-ascii?Q?d12ehUx56JE8xYLAj9YdBvL3UvEBPuXDw+idxyxZdiOl1aHPXtu/CPcoAeR6?=
 =?us-ascii?Q?idm2gY/f2lOtGa9I4HNpmCrOI35i+eOVxyZ5k1MyuwRpG8PkkzdJN4I658ky?=
 =?us-ascii?Q?k5PyWtgXVV1c3SBToVwchMwguoAKvWKg05W1aclwgz8TsK3nwUhgCnwEiPNl?=
 =?us-ascii?Q?Le+dMPa10pQrenwjbazte766X1/ZOq9H40TnF3WdqDyJ4q9Ung=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3PR06MB9863.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jKPKnUCy9/2/+yDqm1VvSbhef+Y8YtN2mxOdZNPF4uyyiB0oue/TSHETV2cb?=
 =?us-ascii?Q?Y9buriD8tPNNIHv2yjgklPIwUEpYwQEa+IyL8bEmFqSyR0QA0MYaUx+0Y791?=
 =?us-ascii?Q?cEZwtYO9DjMpYhzrpDTZL/tllWzmXySQJNoGa/luSKEjHSzeu88YSymBlhDV?=
 =?us-ascii?Q?GqAlb8aLe/G48QzWWi9hIXroeb2P8e1EZMz299P0VeJa6nemL/dEbmbhxHPI?=
 =?us-ascii?Q?Gd8Ed2prMGO4KlHtQYe3PogsksqjoeuNdPWnXKp11n/Eb2ESYNhbk8iPvJwN?=
 =?us-ascii?Q?zBNoJ+QEc1a7JXphzr6CzMmVAK+uAvYJQNfOoH7/acn7yS/T3AhRBKbMpXW/?=
 =?us-ascii?Q?NWr+YHTQBkGYqUZmmipEi9z1uAe1yWu9fZaSDF0UmyLzaaTSB08VxI2BkPTS?=
 =?us-ascii?Q?tUvSt72+gJV5sPmeXJIFYg8ySD3K6p7csRZBR4KmWIXUZ7/P+rVdErJ0EIde?=
 =?us-ascii?Q?0UdHFpwIuDsQgxK1iEwj9v5RhGGCJQTw+WX43Kmsq/z4W2HsmZQhg5zMOttk?=
 =?us-ascii?Q?vVcmaZOcLmfASEWUixhExz9RftdVC7oSlA+k6Eb3dRx/CnMtzTR/zPzDAaxm?=
 =?us-ascii?Q?jNJaNThhSUN6LJV6TZl8PEuuOVaqRh+ObP6eQWU6HNOAV6cowG2Js1N0aCYD?=
 =?us-ascii?Q?CfyFmGc/QgpWRJdgyfLmTLgSPl2QKf5p5BvCX4VOYPHAYZiW6PYEn5CT16Xo?=
 =?us-ascii?Q?pw8OlGgbJ83ay3Tf7gmLsMOHbtb7lMIZRljfsHv2PD4kamyhPLIw2mN6CijB?=
 =?us-ascii?Q?gVqqEL5k61fCoM7YCV2XafA4q7mgiCwW6CQubaanFCfdXU+DdRXK0hkl0l+Q?=
 =?us-ascii?Q?HBTFu0XMZjjMMyOq2+lHbNy87pFaqVIYjwkuwfkzwG7GODXDieit4WhKc25j?=
 =?us-ascii?Q?pXUz86F2IBEIB8hgjY9W4EEoiU8Bu5oW+HAeGlQqGnFratxXZs6P5Bk2ZeYx?=
 =?us-ascii?Q?JwsxtXuOHHei2tDE/sH53o8slEEVzCpHtcxn61t9GSuU9unCDo9U8fX3Zv8i?=
 =?us-ascii?Q?erGbxBTDAxp1r3FNk8jh0J21PGcZI+wVxugYfbOn+LK/r2LDLjzf6fcIfUyr?=
 =?us-ascii?Q?PuC2+5R3m4NR1e2TO3GYN9TkW4M1Fc4OeSAwA13yoHJkG+jZSbOA2wlgOCsa?=
 =?us-ascii?Q?45yBn6zCOT9d/1/s7klqopxKDz/mnRXLy2pGMDc/g5he3AnQiITEef0uxXTF?=
 =?us-ascii?Q?R7ybWQ3Heb//LBp0zZ4Do2S3Ar/hyvAOfnbvGsk9y+T3M9VEDv7gfyceigKg?=
 =?us-ascii?Q?Pfqjx2gVhau+4U29Ta9rOG2CXX+gU6EW1NXk7bK0n10XRdXGk4OlndqMDOYB?=
 =?us-ascii?Q?5AXkJNo+iXjResJnd2Wmt/tte8bx/aI0eq/zjNk1QYQYMXtrHeHd+Ds/Lsmk?=
 =?us-ascii?Q?z0eFJxamT6p9EV1G2f/KuJcmF73z5Z+O5xR+uMoiF0PWaNlrb1OPxa8x/0UN?=
 =?us-ascii?Q?DAvsauWoa8R/KoARqS6gT9lsYDGRNPs5kuyqGkd840YUwRJzW7zy3RJm5eGB?=
 =?us-ascii?Q?nd414hmYBzPfiYLWdP4z5wyjY1gdgnHjoI7GlHDYgCkzaQ3twj+khDBlcNDa?=
 =?us-ascii?Q?M6RuH+Xe4YHSDiPKab4IOa+taK+jNSRneG7pTRVa?=
X-OriginatorOrg: cvut.cz
X-MS-Exchange-CrossTenant-Network-Message-Id: fbdbf339-9891-4614-0e11-08ddcde3e54f
X-MS-Exchange-CrossTenant-AuthSource: PA3PR06MB9863.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 14:34:44.7054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f345c406-5268-43b0-b19f-5862fa6833f8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UiTCWKK3qlIC5ZSza/kqWvgPCGLDCFvteO2j6tf8FkXw/Z+gOVmfhpsXre0lxQfF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR06MB8804

Previously, the test suite returned zero exit status even if something
failed. One could learn about the failure from the output, such as:

    WARNING - Suite initialization failed for 'tracefs library'.
    Run Summary:    Type  Total    Ran Passed Failed Inactive
                  suites      1      0    n/a      1        0
                   tests     37      0      0      0        0

However, when the test suite is run via meson, i.e. with:

    meson setup build && meson test -C build

Meson always reports success, because it primarily looks at process
exit code.

To not make meson mask failures, this commit sets the exit code to one
if some suite (we have just one) or test fails. Additionally, it
prints error messages in the suite initialization function, to make
the failure more understandable.

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>

---
Changes in v2:
- Fixed typos in the commit message.
- Use tabs instead of spaces for indentation.
---
 utest/trace-utest.c   | 8 +++++++-
 utest/tracefs-utest.c | 8 ++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index 39485a1..b40a217 100644
--- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -79,6 +79,12 @@ int main(int argc, char **argv)
 
 	CU_basic_set_mode(verbose);
 	CU_basic_run_tests();
+
+	int err = CU_get_error() != CUE_SUCCESS ||
+		CU_get_number_of_suites_failed() > 0 ||
+		CU_get_number_of_failures() > 0;
+
 	CU_cleanup_registry();
-	return 0;
+
+	return err ? 1 : 0;
 }
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index cc7e689..4a412b2 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -3849,11 +3849,15 @@ static int test_suite_destroy(void)
 static int test_suite_init(void)
 {
 	test_tep = tracefs_local_events(NULL);
-	if (test_tep == NULL)
+	if (test_tep == NULL) {
+		perror("tracefs_local_events");
 		return 1;
+	}
 	test_instance = tracefs_instance_create(TEST_INSTANCE_NAME);
-	if (!test_instance)
+	if (!test_instance) {
+		perror("tracefs_instance_create");
 		return 1;
+	}
 
 	mapping_is_supported = tracefs_mapped_is_supported();
 	if (mapping_is_supported)
-- 
2.50.0


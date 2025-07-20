Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022130.outbound.protection.outlook.com [52.101.66.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFA92E36E0
	for <linux-trace-devel@vger.kernel.org>; Sun, 20 Jul 2025 22:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.130
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753049795; cv=fail; b=f2ZYuYlPR7fuZIylCn0cmJ0gMYPmLYyM1H6LgP1jJB6+nsdTVozZwhe7NTEqU1h8VZyYpCnqGNivWtnqpL21XYAXH7u0A+3N0g6O1WBG7E9W8upclVjyPdjiu6zZDTXqrZ5/IVVmvoVh3LJASEe8xSdhpZ3k+JFcnr7pYWmo+L0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753049795; c=relaxed/simple;
	bh=7aDF90IIxsySXfSZWFqC9oZ49FN52tA8aNq5lZSXHHU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nu09QwGyst2qdZ3wDL+KTcFE3rEZ/PWz73Cj4ahMCsyNJq1NVcDz6dueghIMOftZrjhCgTG+NqkC3Db6AC/AFKRF6h1RGkYJPigxwswFe5JYFcw3R6SX1FXjGJyIQDEcVga42PHb7BUwpeOmdVxnePHymXpgPSYU/nVMajYqzh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz; spf=pass smtp.mailfrom=cvut.cz; dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b=zB/Yzfz/; arc=fail smtp.client-ip=52.101.66.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cvut.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cvut.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cvut.cz header.i=@cvut.cz header.b="zB/Yzfz/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cDzrNwAYs0K7APGHFZ1M/MdGhbAQpy/vf2yJHLv1o03WSQDtnLCyhB/hmzfvF3ZBwRJoYSRSGBj69OIf8zveST3IyxigIkWtiRQnpehWsiRtR/0CkI6k9Rpxpbnm0jAApWkJ8jEnsZsQlMXyCxPGVTU/sVM0xOkpzzkHgNkuqi2ZwhUfnOxCzKOVGhNYNCBU0MIvrqfs3hEKMftxQxxKze8P2vEU/GoFFqLAshizCSXt5RML40X3NoyOvphEDZqBCbFjq4jjvMEyNw6ln5D5FCX5YtrqamLKzVaELNJWI2k+AvTM6sK2Zhrpcj016WVe0jYgMwvsNdRDWIXlZJA34g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LvhotfHxv9BfZEYfduTOzgxRHavEIUDg3GHSoM5I2f4=;
 b=TGiY4rY+BZDC6wEyXAkLtzGG0XUa2Ojs5RwnubCUIzME55ec5kRy0VNou5jhF94PTbKvW0DAMmBM4HUO3kz8yjIYpt5oWXYGXQX0v6LL/SRGu2mHak65zqnz5iZkx0n7ff3oQZnaaIXtVcT2QQVDbybNNc9eovXG5NlFXI5myClz7YqRAWBBJFbGWEoqkJMwrBacCwjIy3L9Vh830a/Q3uTec7rRZIaNAh3NRbyES4gekKuqKDqDnUqDiO00S9qT4dXpl15OhzpupK5U7PZO6EyZ+Et7gSSdWwN6lPjmfEGDuVMa2n978DL0o96KshxChh94WnfJR6xUCL1twa+/BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cvut.cz; dmarc=pass action=none header.from=cvut.cz; dkim=pass
 header.d=cvut.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cvut.cz; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvhotfHxv9BfZEYfduTOzgxRHavEIUDg3GHSoM5I2f4=;
 b=zB/Yzfz//ptSAYvcOwuhfCdIbhDrMyi/jOiX6hAyJt2ZiMt9zpUO5zB1LH66nE+oL7nUWpli34Vf5xC/k74vNzoHCE8WCOPCLDH7SkR4odrTTtHtEne6CfI7kh03Z3sWQxjBqWpA1AUuVcMbarbA0v0f11ZKiuxW1ojcoz5fK4nSxcgmEhooadr1uhR3W70z+fqg8AWa3TBrsBG55Kn9O7o5a6DulxB5yIakGcVO0IMjGi2QwM/LrRA46X2T00qPEXu/S5bucQQD7qcyWw8l+7DgraLlSgNaheAGfKtBwYHaYPL2/R5BQBiPNzHG6/s4l+DA9tuYwu2JwLWt5RC5RQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cvut.cz;
Received: from PA3PR06MB9863.eurprd06.prod.outlook.com (2603:10a6:102:4b0::9)
 by DB9PR06MB7322.eurprd06.prod.outlook.com (2603:10a6:10:21a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Sun, 20 Jul
 2025 22:16:29 +0000
Received: from PA3PR06MB9863.eurprd06.prod.outlook.com
 ([fe80::cd97:3323:477a:3ed3]) by PA3PR06MB9863.eurprd06.prod.outlook.com
 ([fe80::cd97:3323:477a:3ed3%6]) with mapi id 15.20.8943.028; Sun, 20 Jul 2025
 22:16:28 +0000
From: Michal Sojka <michal.sojka@cvut.cz>
To: linux-trace-devel@vger.kernel.org
Cc: Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH 1/2] libtracefs: utest: Return non-zero exit code when something fails
Date: Mon, 21 Jul 2025 00:16:16 +0200
Message-ID: <20250720221617.695311-1-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.50.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0072.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::49) To PA3PR06MB9863.eurprd06.prod.outlook.com
 (2603:10a6:102:4b0::9)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA3PR06MB9863:EE_|DB9PR06MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d6c6f18-f0f7-4c58-58e6-08ddc7db1264
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|19092799006|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yvaQH7ZE38OXGn3O7vqnOmpiQallNVrYieL7Gon094zhq9f+XSMi8d2llyy6?=
 =?us-ascii?Q?y91G9eQYfG8zveshecn7UVShGuKXGdrpV7/+gaJ5I5+Gy3c0Izhu8fEcpNGB?=
 =?us-ascii?Q?ugBAD+QX1+Cc9al8CJBaOCc0q+6jZkcWeF4fds7oqs2A4TuRdSpbYX3uVUFY?=
 =?us-ascii?Q?c2Zowt38RNfGSp6k8AIKB18ZmnHOgHDEkaWIw2OE+0UCuHFmgCstIGyGI4Cy?=
 =?us-ascii?Q?xtGDD2bJ7XjEJl5u83xLER3v8Qw1Er3di5nxdy4sEJ2yGOR4/e6wTAGjCoa9?=
 =?us-ascii?Q?VxqXz1JpL0M6cmZtUtJcOl2V0RArGT2kKjPnfT48jicIRch+xsKoIjfPENhl?=
 =?us-ascii?Q?2/n5dPqm+jNDTZ2v61vefM5RMMbmjm8GpVdzMxdbJ7nLQJ58XAYhIH5tGO38?=
 =?us-ascii?Q?v+SR2LUv0eBs+8XMCtry4+/9FpSDXevM7jy8VimmLcL6MeIki2ZejFAm0DfA?=
 =?us-ascii?Q?1b5IK/mG5ycDpuqmJDsafJ1HYKjtfJg/MN9yaVhZanP33gzpY4yEDuQTQHWa?=
 =?us-ascii?Q?CfSB5wKZ/6pqwgBAO9DRT8RwHi/Gvo9ggVtnFGdGtYRNq1sDbU2wcJMTuchN?=
 =?us-ascii?Q?dhOoU7+OUZcSMEMLkEk/8goJ5Mv2MxARKKVchLQoR2M7EDYc6ynWHS2GYWzd?=
 =?us-ascii?Q?1ufEKrb5+JdPKGuAbHov8EMghFXt1ReMHsEumdKFQzq7J2nMfpA4xOsH+qpp?=
 =?us-ascii?Q?mf9Il/c1Wqq97TBXF+YjxJw1p5iC/D2ADul1hpdi/0OAqQ3O//zsvUz9+keC?=
 =?us-ascii?Q?d1V4rMLtDHhGKwQZhALldXh/UFrWSvILIthgqlGMSjxjgE3z5TRNazXmMYll?=
 =?us-ascii?Q?F9Z3y9orwdAavcUV14xnKPgN3VNYTnhBHPu/NEGQk2SMBcr2JubB2RxDUmzC?=
 =?us-ascii?Q?R+6F/kypkmkCIHzsruGHQnJ+117rrO9wj0y97QOv8VHm07sQ6rHtxq1n8+sb?=
 =?us-ascii?Q?wmtlsOHB66W029KXOtvlGrSTEiBh4RaTJT/QWXxbD2fc+rZHtMs5mfcoXiOP?=
 =?us-ascii?Q?VGKYuWQsJpkmzTtmx+f9448KUg02mJ9wDzVN8O/gHW8y0gKV7HOhEClWKjar?=
 =?us-ascii?Q?46Gta14LXl2ooKUcLnld4g7Nap0VvvlssNl1BUPrnoONuj3u5mr/sKeZBn3D?=
 =?us-ascii?Q?qwTIPlqJbq8Gao9tJmELqQ4h3iPBOrPVcRteZP1CiIVlYPiB8wNgE5kTbxlX?=
 =?us-ascii?Q?UWzt9UX7ZSEFdt8hm4l8ehASkwdp1Phd3Wv83M+4En2C6rkTm3fWmjUCQtNp?=
 =?us-ascii?Q?qBEhAq3Msk9JFclFPGbFcr+g6SRhUabAQWgNekH/2+OlsIMl2A0/1kaPmiWf?=
 =?us-ascii?Q?UAKdloU5LlTc7+6ddZPNTmMyB7a3/MxkAGJj1UNsyRscdcHYUaRIDKkkb4A4?=
 =?us-ascii?Q?TCqi6PGfXCxx2a+GguyDtfrHqxYAup+eNXogMzexiy57JF+WLled5slTFus1?=
 =?us-ascii?Q?wA4AAzaByN0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA3PR06MB9863.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2f0nZvOmUoNo9HJPmsGwQXRbEXgBWasAV0qH1Um4YOktWbmxdlvUgFC2PeUi?=
 =?us-ascii?Q?6UPE2iE6e6o58AGyJ6zAR0Bf9GQXrPWcpUxLQC8yzFyfvJfmO+4do7cNEUSV?=
 =?us-ascii?Q?OXgoFFex8zFPeHcZUdQ2l8+3fD0VKwRNtyetOxgdNyPXJYM+QHdvgvb09Luc?=
 =?us-ascii?Q?/p68GtnheIvdYS5NFuaRgfwYzqdie0g84nOVnBC+5wewvMUepy2CTlxsxiua?=
 =?us-ascii?Q?+wDC16Ek83ynoutnWWEkEAJe/NoTjxYqcHtd5NI49e95CFyBLleB6jSQuLBY?=
 =?us-ascii?Q?v3F//BVd1aFxE23/WeBzFh5bZCUutBSBkqHVIDKoPgDVG6ObjbIM/KXLIDq8?=
 =?us-ascii?Q?ADcnt+rcR+z76jRMRiHWv56g0f69NR4Rv9sGbKttmCbFPWcNaPQAyl/3Wsop?=
 =?us-ascii?Q?D+ZIV86CyyXDw3U3bZn7gFA1sKNfvvKG5SrFRDSTZZdWN9Bv4esYkDR+34GW?=
 =?us-ascii?Q?NxtB2EbrsmxNLxLMeuwmkm4IAqug06ixUm01zbyBYiiqog0P/f94ylMekXN4?=
 =?us-ascii?Q?LlSQjIqdBsYRdFvEZuPEUCRX/tEvAE8COOLAhBTYacRMEuktxDnn9+K9APPM?=
 =?us-ascii?Q?+h7GvNORNyK/X9qggZqg2feZcp0KUHBrhyCcXe254RIf6cVBqxO37HLObtMA?=
 =?us-ascii?Q?CNYDyrraHDZIE9eOMoR43AEdfmSFKCURTGScXjoRrvNz8BTK2VVT1cG7RU2n?=
 =?us-ascii?Q?Pf7vcSbOZb8ksSKaJKNEdw4Rd5muOAGL71Z7Y8Nh+ugJzjCG/4N1OR6qgw9N?=
 =?us-ascii?Q?6zwisCZBNyXAoB0wqAKQSNQzynOvm9D0I09zJNJ8G6s4gNr7w+WKtrTWbGn3?=
 =?us-ascii?Q?o6/eTGCSgKhv6PAl3onId6PYOUQ/4aOHdawR6wmDo2S5pXMtydzZIblzvuWx?=
 =?us-ascii?Q?G9cBFGS4otPUcYAiaK6JPmjhAGl987oaFLSku1CMSI9kvEcX83sPKbzHLT/b?=
 =?us-ascii?Q?ECZRFmEfC0WXg3w1gJQqLpDjAVge+SijvC7AxlTPf9//PlTvs0HETOyAFmme?=
 =?us-ascii?Q?8kdhYdzvSgPu7aZZuPDPtdmaKNBB39pfjpQxkkHjlF6TkX847dtSrtHOHcu0?=
 =?us-ascii?Q?OPXMsf0oSydVmNbrRObSFJuKkP9RLHpsPGv5hym5Xnz0tHONJs2XDIF3Flov?=
 =?us-ascii?Q?xBaDRS+5qbFsdAYiZhFyyKZbXYMqJwVNne5ENz+PDBl2iS4lOz2mbMTX8ISd?=
 =?us-ascii?Q?N1qNBrbd2agfsRhWRsWbYsgzEgjwCcoX51XQNiMZirBxywt7qepUQUee8BBo?=
 =?us-ascii?Q?tsT6Y6DRVHIbczOnnVvc7EP9AGo1R/00DgQFUsdRv6IOT+R6s6Al0Z87m/nm?=
 =?us-ascii?Q?JwHnASSxZMrttIUCJax/2j4/BKSVAl5GYRF6IAQOg8dEqSSGkahCRD1YJINU?=
 =?us-ascii?Q?fQbY49aFZFakTePyUDfE3lNxvySWI9cDizy2jtUROXeZtcl5KSyp51Q4/5sE?=
 =?us-ascii?Q?8kgK3Yc5rubirTuK1IQhHV5oAD26JbW85LID9ng9Nv8as5OfcxmSN/RMyVpV?=
 =?us-ascii?Q?nsVxKsPBAsoMnMszjJ9QtS8g9PU5cVPP1jhkKicfhOLD907qWu0rdrhdDH8O?=
 =?us-ascii?Q?ai6KesNZq4NyX/3X7UGhniwN4ojM+ZvjWTPzMbF8?=
X-OriginatorOrg: cvut.cz
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d6c6f18-f0f7-4c58-58e6-08ddc7db1264
X-MS-Exchange-CrossTenant-AuthSource: PA3PR06MB9863.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2025 22:16:27.8871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f345c406-5268-43b0-b19f-5862fa6833f8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZA4X+19tCHvL/RGB9OkNiSP158WyvCJbAg1OajhEMJ9P2GcKdS0Wdg7AWA6Uwkg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR06MB7322

Previously, the test suite returned zero exit status even if something
failed. One could lern about the failure from the output, such as:

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
prints error messages is suite initialization function, to make the
failure more understandable.

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
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
index cc7e689..ac76bf6 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -3849,11 +3849,15 @@ static int test_suite_destroy(void)
 static int test_suite_init(void)
 {
 	test_tep = tracefs_local_events(NULL);
-	if (test_tep == NULL)
+        if (test_tep == NULL) {
+		perror("tracefs_local_events");
 		return 1;
+	}
 	test_instance = tracefs_instance_create(TEST_INSTANCE_NAME);
-	if (!test_instance)
+        if (!test_instance) {
+		perror("tracefs_instance_create");
 		return 1;
+	}
 
 	mapping_is_supported = tracefs_mapped_is_supported();
 	if (mapping_is_supported)
-- 
2.50.0


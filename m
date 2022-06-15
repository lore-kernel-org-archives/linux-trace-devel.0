Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40655C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jun 2022 07:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243125AbiFOHgc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244208AbiFOHga (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jun 2022 03:36:30 -0400
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [221.176.66.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7C0E48E71
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jun 2022 00:36:26 -0700 (PDT)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.13])
        by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee862a98bf63b3-40079;
        Wed, 15 Jun 2022 15:36:24 +0800 (CST)
X-RM-TRANSID: 2ee862a98bf63b3-40079
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.101])
        by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee762a98befe10-c19d3;
        Wed, 15 Jun 2022 15:36:24 +0800 (CST)
X-RM-TRANSID: 2ee762a98befe10-c19d3
From:   jianchunfu <jianchunfu@cmss.chinamobile.com>
To:     bristot@kernel.org, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jianchunfu <jianchunfu@cmss.chinamobile.com>
Subject: [PATCH v2] rtla/utils: Use calloc and check the potential memory allocation failure
Date:   Wed, 15 Jun 2022 15:33:48 +0800
Message-Id: <20220615073348.6891-1-jianchunfu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Replace malloc with calloc and add memory allocating check
of mon_cpus before used.

Fixes: 7d0dc9576dc3 ("rtla/timerlat: Add --dma-latency option")
Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
---
V1 -> V2: using calloc, removing the memset and goto err
	  instead of returning when allocation fails.
---
 tools/tracing/rtla/src/utils.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index ffaf8ec84..56bdc9962 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -105,8 +105,9 @@ int parse_cpu_list(char *cpu_list, char **monitored_cpus)
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
 
-	mon_cpus = malloc(nr_cpus * sizeof(char));
-	memset(mon_cpus, 0, (nr_cpus * sizeof(char)));
+	mon_cpus = calloc(nr_cpus, sizeof(char));
+	if (!mon_cpus)
+		goto err;
 
 	for (p = cpu_list; *p; ) {
 		cpu = atoi(p);
-- 
2.18.4




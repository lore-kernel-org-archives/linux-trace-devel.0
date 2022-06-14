Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C8CC43334
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jun 2022 09:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbiFNJlh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jun 2022 05:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiFNJlh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jun 2022 05:41:37 -0400
X-Greylist: delayed 183 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Jun 2022 02:41:32 PDT
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [221.176.66.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3DB6403D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jun 2022 02:41:32 -0700 (PDT)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.19])
        by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee662a857138a6-31398;
        Tue, 14 Jun 2022 17:38:28 +0800 (CST)
X-RM-TRANSID: 2ee662a857138a6-31398
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.102])
        by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea62a856fa413-a18c5;
        Tue, 14 Jun 2022 17:38:27 +0800 (CST)
X-RM-TRANSID: 2eea62a856fa413-a18c5
From:   jianchunfu <jianchunfu@cmss.chinamobile.com>
To:     bristot@kernel.org, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        jianchunfu <jianchunfu@cmss.chinamobile.com>
Subject: [PATCH] rtla/utils: Fix the potential memory allocation failure
Date:   Tue, 14 Jun 2022 17:38:00 +0800
Message-Id: <20220614093800.8743-1-jianchunfu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add memory allocating check of mon_cpus before used in utils.

Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
---
 tools/tracing/rtla/src/utils.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index ffaf8ec84..2a86440b3 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -106,6 +106,10 @@ int parse_cpu_list(char *cpu_list, char **monitored_cpus)
 	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
 
 	mon_cpus = malloc(nr_cpus * sizeof(char));
+	if (!mon_cpus) {
+		perror("Failed to allocate memory");
+		return -errno;
+	}
 	memset(mon_cpus, 0, (nr_cpus * sizeof(char)));
 
 	for (p = cpu_list; *p; ) {
-- 
2.18.4




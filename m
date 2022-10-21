Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13464C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Oct 2022 01:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJUBov (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Oct 2022 21:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJUBot (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Oct 2022 21:44:49 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E1E437F8
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Oct 2022 18:44:48 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MtnHp4xGjzpVk5;
        Fri, 21 Oct 2022 09:41:26 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 09:44:46 +0800
Received: from huawei.com (10.175.100.227) by kwepemm600008.china.huawei.com
 (7.193.23.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 21 Oct
 2022 09:44:46 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <rostedt@goodmis.org>, <linux-trace-devel@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH] libtraceevent: Fix double free in event_read_fields()
Date:   Fri, 21 Oct 2022 09:43:59 +0800
Message-ID: <20221021014359.4656-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is a double free in event_read_fields(). After calling free_token()
to free the token, if append() failed, then goto fail, which will call
free_token() again. Triggered by compiling with perf and run "perf sched
record". Fix the double free by goto fail_expect instead of fail while
append() failed, which won't call redundant free_token().

BUG: double free
free(): double free detected in tcache 2
Aborted

Fixes: ae6c0749ca74 ("tools lib traceevent: Handle realloc() failure path")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index a0d7da5..d842f9d 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1779,7 +1779,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 			ret = append(&brackets, "", "]");
 			if (ret < 0) {
 				free(brackets);
-				goto fail;
+				goto fail_expect;
 			}
 
 			/* add brackets to type */
-- 
2.17.1


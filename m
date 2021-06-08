Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0661C47082
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Jun 2021 13:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6DB460240
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Jun 2021 13:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhFHN6M (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 09:58:12 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:36750 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbhFHN6M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 09:58:12 -0400
Received: by mail-wm1-f42.google.com with SMTP id h11-20020a05600c350bb02901b59c28e8b4so1533953wmq.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Jun 2021 06:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KOFWTsW32zObIKhBdqXmbhJ+NsPRPsEuIHdG7g4sxAI=;
        b=cneC/vVvOB4FTt6t62HGRC51tr0iITryHTpDYuQYXIQxPoiDViKILmZFYWR+r4Q1uI
         RK/E2P6K3ESBOjDbJOnmtZ39L612XSNrNfIrjI13LTFj9fulXLyvvCYpbAJcY2GD+kLh
         jetFSPo4TiACQVlFf5k+z/AN+vYRAIGmBXQajvNvrZbpGISlA/u5zWmag4duZoI0unn8
         D0x/e5ET7xLygrL7d5Kg22VoIDJTHAjrATmKFvlbz/BXBLfjpPZrJA1veuBIYfj4TN9I
         LYk7WX59qsBt67kyzUNSTHqK0JlyDmPgtG4GJfw4GlfL6yhWvRP7ntrF7Ua4AwMkKHhe
         ZpsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KOFWTsW32zObIKhBdqXmbhJ+NsPRPsEuIHdG7g4sxAI=;
        b=Laei0u5VBp918Bjn1AW5pdYO0ubePZT8NqVhvNxEqDZVuaKJEAMCHvRQnATwuPhX+3
         i80KPHsXt+ooFCwtfY/jbD5zxL2YwrgcM6ZGxqlz1hQ37slqDEkCHqY58nqngYo/kcHi
         DBvfFTAX2OTb+bsFGCkGaUKkNS6w9o6rjeiPCvLZkYCSYG1sqBQ5WrKuQvUwow5lGQYe
         r3uyjyeZVfT1RY/p/7QIO808qg9gv2Lv7+yGW5y/wIvUmIRjbYUMYBhrRyra/tLWggyB
         nItMy818TJiQOOLfniXXsDHghW0SDsZbev7B4H/srNpu5n+ZERsJqiljBTxBVWVlcUAe
         UvWA==
X-Gm-Message-State: AOAM531MzS/9Afax5SjqWjraOMcCxw5ufO+Bf3akZw0ipIU84me6Idv2
        +Gls1r1F/BITtg86KMUpqp8=
X-Google-Smtp-Source: ABdhPJxHbQdDyZCwpQ0PWmsvE1ibqoXhmAWvimP4Z5wFjGqg14bVNOJvBMqgLKKUR1N1u3cvMe+JgA==
X-Received: by 2002:a7b:cbd1:: with SMTP id n17mr22942730wmi.2.1623160518792;
        Tue, 08 Jun 2021 06:55:18 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id w13sm6806973wmi.48.2021.06.08.06.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 06:55:18 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/4] libtracefs: Propagate the return value of the callback function
Date:   Tue,  8 Jun 2021 16:55:03 +0300
Message-Id: <20210608135503.12135-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210608135503.12135-1-y.karadz@gmail.com>
References: <20210608135503.12135-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently the return value of the callback function can be used to
stop pulling data from the trace buffer, however this return value
is lost and the user has no idea if tracefs_iterate_raw_events()
terminated because there was no more data or because this was
requested from the callback function. If we propagate the return
value of the callback, this can be used in cases like the one below:

int callback(struct tep_event *event, struct tep_record *record,
	     int cpu, void *py_func)
{
	....

	return (something) ? 0 : 1
}

int main()
{
	int ret;

	....

	while(ret == 0)
		ret = tracefs_iterate_raw_events(tep, instance,
		                                 NULL, 0,
		                                 callback, NULL);

	....

Here the user can effectively terminate the pulling the data
from inside the callback.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/tracefs-events.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 0fef64f..0a87d28 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -131,7 +131,8 @@ static int read_cpu_pages(struct tep_handle *tep, struct cpu_iterate *cpus, int
 		}
 		if (j < count) {
 			if (callback(cpus[j].event, &cpus[j].record, cpus[j].cpu, callback_context))
-				break;
+				return -1;
+
 			cpus[j].event = NULL;
 			read_next_record(tep, cpus + j);
 		} else {
-- 
2.27.0


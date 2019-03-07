Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAE5C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B02220449
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfCGPFn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:05:43 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37547 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfCGPFn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:05:43 -0500
Received: by mail-wm1-f66.google.com with SMTP id x10so9511226wmg.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 07:05:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b88oxwvPmWDVA/FBp3A71q2ZVukyxicVOA5F9lDyxEU=;
        b=HtHUBA1hXnPci/yaznzCBY8nmC2rKYMrp2lrXWVhfOJCIOeW/odPJE+v+qGA0R4eSc
         30mHkh25BU8Xhc0ZohZpFAvwX2ep9uqnKAZJbkQXmTn82z8/5hq30V/byu6F+J0MUnPD
         Aa/wG5lrIIrOvkNHhKx7VUsDwrvSEa2A73XQUK0R2zaimNYSggmkcXzag/xwOuGSqFGD
         G1WzT61Lw8DLwIF71bporCQBe2cXkgTP5hiubULRj5KjBTFoTyx1EHri1YIEy+vveJn+
         ZnpbQdZDIyFe2/4tCX3mwoInAtMVo/CWGwgtTvnQ6Yb9V5bD0+iCVmKcQFVsjzI/yaDe
         CDLQ==
X-Gm-Message-State: APjAAAW4X9NNriNGQWIchpOUvh3NzFdOvqegSknxpvWHm501wxUz94Yq
        8ryTL+VsZdkZZwTWL+Zgr+0=
X-Google-Smtp-Source: APXvYqzIyJW1bwdemyRi0PnfhLyT36tH/nM0zDavGv9XAPJgwwzOZtb5PCP8ywUbWW6RKdggSTFJzg==
X-Received: by 2002:a1c:9c02:: with SMTP id f2mr5837985wme.91.1551971141151;
        Thu, 07 Mar 2019 07:05:41 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id d15sm10281274wrw.36.2019.03.07.07.05.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 07:05:40 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/4] kernel-shark: Fix Doxygen warning from sched_events
Date:   Thu,  7 Mar 2019 17:05:10 +0200
Message-Id: <20190307150511.17246-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190307150511.17246-1-ykaradzhov@vmware.com>
References: <20190307150511.17246-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There is no reason for find_wakeup_pid being non-static. In the same
time, because it is non-static, Doxygen complains about missing
documentation for this function.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/plugins/sched_events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
index c52fb29..724aa19 100644
--- a/kernel-shark/src/plugins/sched_events.c
+++ b/kernel-shark/src/plugins/sched_events.c
@@ -148,7 +148,7 @@ static void plugin_register_command(struct kshark_context *kshark_ctx,
 			tep_register_comm(kshark_ctx->pevent, comm, pid);
 }
 
-int find_wakeup_pid(struct kshark_context *kshark_ctx, struct kshark_entry *e,
+static int find_wakeup_pid(struct kshark_context *kshark_ctx, struct kshark_entry *e,
 		    struct tep_event *wakeup_event, struct tep_format_field *pid_field)
 {
 	struct tep_record *record;
-- 
2.19.1


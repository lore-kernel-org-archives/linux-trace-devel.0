Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D720C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C97B20652
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfCGPnq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:43:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36635 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfCGPnp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:43:45 -0500
Received: by mail-wm1-f66.google.com with SMTP id j125so9756571wmj.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 07:43:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b88oxwvPmWDVA/FBp3A71q2ZVukyxicVOA5F9lDyxEU=;
        b=PaJ8dFSKEZu321u4cn2CbNjGEcJtS3+0ZN4GRekkC9RvX7/+yZQQu77Bwjw1LQDMOW
         Gnb2lev7/08yp0AOYAQA0Hj5VPUkmrbJNBAdpPbztUcHhGEtYlABGwtXmIwzmYuQw63a
         oxJR/efXidK8m9dzqho1vIuGR3wkitnf9qdL4svgn31JmIsAIT7eowGqzujpoWfxwo03
         yJm2emiTHKrECVwa9ZFObCLqY6v2/WqUx2b7ZeaMp2YHu1OCjvyxVgjKsgkKYV4BQaMx
         fLE9Xw/hSJ719S6RJyrcTj9vqy5Evih8e6Ayt5gG2J63fIErgIN++3JXz1mlXBahaPr0
         vkRQ==
X-Gm-Message-State: APjAAAUqy5QQgZjQ5RF+PaUtUrXQJ6y0QrOZvTLWIsAy9g1yKr4Ou++n
        +7kPHtplB4G72AtHqHHUKyqQ83YA+tw=
X-Google-Smtp-Source: APXvYqx8stpBjFxn/6RqRA8ydCk4nHy3tBGQSjyignPWOVoNjccsaotXGdprvlhgHO5dHJ5GYcAlMw==
X-Received: by 2002:a7b:c777:: with SMTP id x23mr6368897wmk.71.1551973424020;
        Thu, 07 Mar 2019 07:43:44 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id h9sm10081463wrv.11.2019.03.07.07.43.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 07:43:43 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 3/4] kernel-shark: Fix Doxygen warning from sched_events
Date:   Thu,  7 Mar 2019 17:43:15 +0200
Message-Id: <20190307154316.19194-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190307154316.19194-1-ykaradzhov@vmware.com>
References: <20190307154316.19194-1-ykaradzhov@vmware.com>
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


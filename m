Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87B7C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 10:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E1A964FC3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 10:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhCKKgs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 05:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbhCKKg0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 05:36:26 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CB5C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 02:36:25 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id i61so1989933edd.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 02:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=udz0FSez069+iavVEEY5erC1SdRZEEb0sU4ICGFoIdM=;
        b=TsKrBBmMKbEPVEvDm/erGiE5+wF0A67J09AQ8R/gVSDTy6Rbe9BT+WVy2q22te1ALN
         cXj46uUuOVrQVJ3HKrZvUwQE9sHGGTwmmeox2aIZWUstvl6GaBie62CgHDhmI0MiAfpS
         7T9kR6+7HbLPWRPW3HKi3Br72LYpwm7An+fiHN1LIYskQ+ulxV1ccMNebpDwv6Vr9htp
         MQ9t4iM0WZC/tTmoyEUMqYnuWRDFYP9aJ9vz1QLprW3CtiulQS1aucSK+8NDr+vX7LOT
         uiAnSbiw2h7Uxo02zKb8w83mgZ9uxfg7sTEooeM/DSm3TT/Z2okHrirfWWfigF1yTpc5
         rkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=udz0FSez069+iavVEEY5erC1SdRZEEb0sU4ICGFoIdM=;
        b=bte/h42cYgO/1/nwyY3yHSIMmuvq+ZKycQxxlB3gHl9UoOx17wA/hfd6LIfyJRUOEA
         am7SUa/blCdcblhTG4N/e2QQuAaqhuEQnCxf4MzYroM1AjHRiuMNiXqPExVS0aBtY3jv
         CUuDm5nDB5ZCFP9fUhXv05MMLEb6pOsCnfA5aeP+kcuZPAjj5eNJpQS9AsRwevbn/Z5H
         ASEtsbfUoUKvczPIK44hAtgdbaEIkVdnbh3rM/LuonNdA6D29g74bbndjWq59OMRE9K7
         zhSTKiLrE3W/8LyafNAqN4/soBZhtvngiwCHG1nZtKDZaHwpn03mnszcJXyBuFZ0Xz6w
         vzLw==
X-Gm-Message-State: AOAM530K73Swaznu1ysbprIbsB5XMv3eOOc5C4KYkn930kpo2hyklPiP
        F4o93l7lXVBNkPnwZTFpupIxNGAQ3EIeXA==
X-Google-Smtp-Source: ABdhPJwBG7mbHTMk9GHyMni9cDOAdxDy34c+xN11BXj79K4ENCja4qAT+0X1raYsfRtH68Ljlelafw==
X-Received: by 2002:aa7:c353:: with SMTP id j19mr7715032edr.263.1615458984586;
        Thu, 11 Mar 2021 02:36:24 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g1sm1066838edh.31.2021.03.11.02.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 02:36:24 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, amikhak@wirelessfabric.com
Subject: [PATCH] libtraceevent: Fix build warning on 32-bit arches
Date:   Thu, 11 Mar 2021 12:36:22 +0200
Message-Id: <20210311103622.1962839-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed a compilation warning for casting to pointer from integer of
different size on 32-bit platforms.

Reported-by: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reported-by: Alan Mikhak  <amikhak@wirelessfabric.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
[
   Backport from kernel into the libtraceevent repo.
]

 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index a249b07..e4e2e36 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5240,7 +5240,7 @@ static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
 	default:
 		ret = 0;
 		val = eval_num_arg(data, size, event, arg);
-		trace_seq_printf(s, "%p", (void *)val);
+		trace_seq_printf(s, "%p", (void *)(intptr_t)val);
 		break;
 	}
 
-- 
2.29.2


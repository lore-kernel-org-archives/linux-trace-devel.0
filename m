Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C127C04A6A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Aug 2023 03:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjHCDKH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 23:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjHCDKF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 23:10:05 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72A512B
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 20:10:04 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-d1d398ec0ebso483664276.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Aug 2023 20:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691032204; x=1691637004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Gx9WQsbqiMinxut1Mpab4EVGz1/yJZfAqpYQMYh5lY=;
        b=NHNwG9tUADNcBJXGsBbiaGZc7RP5IoqF08R0dduh79ZU+7x0XKh1OfzY5fKl5vdY2u
         kCIfaJyYb+ew8tvZ94hLmfV+2mrb6U5OFubSVZ6FQh/4jtkvjTHIyQc194lGAlxRe0p5
         OloO085Dw2Tuk89AClnak4Zs99yBfQ/TmhbmZAJJjHiG65OJZe9YhaLJbfMrbcBu1KNl
         0DYV7YsUlmVifjMrxDBSw3N7DVqo7DJxioxWYBIa8oBGg9HKKdgNKcV99ge6EQwVJ5Sl
         I2CJcuxt3XhzF+zEgXM61WBwF8NNBKEINStAZrrWqr8lwuxZimp7A7kf3t/cbirxB0T3
         KLpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691032204; x=1691637004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Gx9WQsbqiMinxut1Mpab4EVGz1/yJZfAqpYQMYh5lY=;
        b=ajYBpm0V0OQnle0dLDmXAIL8hoC31iF8VbrUZcD++BA1vNoqEoUl994YjmTnxP9Lno
         b14QdSuYKa86PgrsGkjWqBTIjwXXh5bKA1nPjfE1h/VdRy3TangJIb8PoXs1K6qngIJF
         phhtCj0EYY2NvkoKcqeuO32ScxIxkpwor4AO7y9naz26UMMu8f9st6DEIT7EPoYIsbHa
         ul3M1FkMOmZxF5uQ/e07LxOwZ+c8kYXSau8lCAm7+xlFFYzkA2j4tjSzG39qVdsBASx9
         L2s+8APVEHzBoT/i0Gtl4ikoCdisOA/O8YqJthoTKVuYoAzudjw+7aBw8yoDRobIWKzw
         aglg==
X-Gm-Message-State: ABy/qLY2FRYhYNksvC9OU73Bz1iFScWyhxo53KVkIZkYQs043YDCl6Z5
        IzUHPb9+3vPS6HSZ8/4Wc8o=
X-Google-Smtp-Source: APBJJlFSnSKsC1MMA8akoxud6hBKLgb4P7eLRD30NT0k18/S+vskL26fn7NaiFhFdhi8mzqLiE4XBQ==
X-Received: by 2002:a81:7c87:0:b0:57a:40aa:3fe4 with SMTP id x129-20020a817c87000000b0057a40aa3fe4mr21328639ywc.22.1691032204000;
        Wed, 02 Aug 2023 20:10:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.87])
        by smtp.googlemail.com with ESMTPSA id g5-20020a17090adac500b00262e5449dbcsm1682401pjx.24.2023.08.02.20.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 20:10:03 -0700 (PDT)
From:   Ze Gao <zegao2021@gmail.com>
X-Google-Original-From: Ze Gao <zegao@tencent.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Subject: [PATCH v6 2/2] libtraceevent: prefer to use prev_state_char introduced in sched_switch
Date:   Wed,  2 Aug 2023 23:09:55 -0400
Message-ID: <20230803030955.380537-2-zegao@tencent.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803030955.380537-1-zegao@tencent.com>
References: <20230803030955.380537-1-zegao@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Since the sched_switch tracepoint introduces a new variable to
report sched-out task state in symbolic char, we prefer to use
it to spare from knowing internal implementations in kernel.

Also we keep the old parsing logic intact but sync the state char
array with the latest kernel.

Signed-off-by: Ze Gao <zegao@tencent.com>
---
 plugins/plugin_sched_switch.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index e0986ac..d96bd22 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -11,7 +11,7 @@
 
 static void write_state(struct trace_seq *s, int val)
 {
-	const char states[] = "SDTtXZPI";
+	const char states[] = "SDTtXZPIp";
 	int found = 0;
 	int i;
 
@@ -99,8 +99,14 @@ static int sched_switch_handler(struct trace_seq *s,
 	if (tep_get_field_val(s, event, "prev_prio", record, &val, 1) == 0)
 		trace_seq_printf(s, "[%d] ", (int) val);
 
-	if (tep_get_field_val(s,  event, "prev_state", record, &val, 1) == 0)
+	/* find if has prev_state_char, otherwise fallback to prev_state */
+	if (tep_find_field(event, "prev_state_char")) {
+		if (tep_get_field_val(s,  event, "prev_state_char", record, &val, 1) == 0)
+			trace_seq_putc(s, (char) val);
+	}
+	else if (tep_get_field_val(s,  event, "prev_state", record, &val, 1) == 0) {
 		write_state(s, val);
+	}
 
 	trace_seq_puts(s, " ==> ");
 
-- 
2.41.0


Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D883C001E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Aug 2023 09:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjHAJCX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 05:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjHAJCO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 05:02:14 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEFB2121;
        Tue,  1 Aug 2023 02:01:56 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id 5614622812f47-3a3efebcc24so4104504b6e.1;
        Tue, 01 Aug 2023 02:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690880516; x=1691485316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1czaeXwKPoW79DQXCoJFC1V8bFxJyQ215iwxz8lUyU=;
        b=ms8c2ZbB4R4fcbOy+mUJuwgXu4e0yufWtAlHMDXY2WnBmnyeTwE7ArkyOg6QsjA2bF
         SFuuk5Az0zk8szoQauYILOraZ47zU/hlFz++Kexz1kHY7bRL5ni1Q7n2u0vma1bhrKcx
         9is5gEAYNI8Q7DXpoPBNDolyn3ifDb+Cswg7wY6ws96ts/SHMg7sXLMaBIx6NHz8eA4x
         IiW+VBQfO6KbRqBTLiKIqqnLAa+MoQil/+hq8vda8g3cCzy8U0SgyUK+PfNSBjd1m68g
         PZnJjsRC6jhWQm29Eo9oSg0WFrasNY1uIsqDwVxjf/q75cC/ICsVPyEhobGM1jBNjrCH
         MOcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690880516; x=1691485316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1czaeXwKPoW79DQXCoJFC1V8bFxJyQ215iwxz8lUyU=;
        b=aWBV2NJ9WTJ7m5VPHRi50sDgRREdhC84t+HJQoKN6hegMFAGhL13iGVHt/AqtOibhd
         segJb3lyOYaoXDi0S2NbMf2ZkudZyupzvsXO5mImsYz5eewNUlhS6Q9+9fnmDwbXzict
         zlIQ17lPTHWgiZzGihJQ+dJxV51PKMkv+510CEMopK0IV3lMoSzBIlDGX7PocvYp/nEd
         JZBB31t6K5fnnrkdnlQNjRt0t56Ua/y714yFrPYFo4By20r68C8byH+OB1Y/ILOP3Y/L
         /bveExIat7XcD+X+4NFS3mOmVSHEpYXh9vfjbnHodoZU5Noo8nu0OKceN1+oQK3COib+
         05Wg==
X-Gm-Message-State: ABy/qLa3M5vnEp1eNchkDI/3EVhj7Gwwp2eRXojbqhxQ1kB7F4Cv0rrO
        Jo8IfQND0hbaA1MChE6P1mA=
X-Google-Smtp-Source: APBJJlEgEGfL/Sa0Hc20kBqI0KCpcup53YVIjfJ2cJlZF3NxpUjHae3cj6zpEWs3NbpHX6xjWwFvxw==
X-Received: by 2002:a05:6808:1595:b0:3a7:4e0c:faa9 with SMTP id t21-20020a056808159500b003a74e0cfaa9mr910611oiw.29.1690880515818;
        Tue, 01 Aug 2023 02:01:55 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.20])
        by smtp.googlemail.com with ESMTPSA id x34-20020a17090a6c2500b00264044cca0fsm1592523pjj.1.2023.08.01.02.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 02:01:55 -0700 (PDT)
From:   Ze Gao <zegao2021@gmail.com>
X-Google-Original-From: Ze Gao <zegao@tencent.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Subject: [RFC PATCH v3 6/6] libtraceevent: prefer to use prev_state_char introduced in sched_switch
Date:   Tue,  1 Aug 2023 17:01:24 +0800
Message-Id: <20230801090124.8050-7-zegao@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230801090124.8050-1-zegao@tencent.com>
References: <20230801090124.8050-1-zegao@tencent.com>
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
 plugins/plugin_sched_switch.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 8752cae..4c57322 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -11,7 +11,7 @@
 
 static void write_state(struct trace_seq *s, int val)
 {
-	const char states[] = "SDTtZXxW";
+	const char states[] = "SDTtXZPIp";
 	int found = 0;
 	int i;
 
@@ -99,7 +99,12 @@ static int sched_switch_handler(struct trace_seq *s,
 	if (tep_get_field_val(s, event, "prev_prio", record, &val, 1) == 0)
 		trace_seq_printf(s, "[%d] ", (int) val);
 
-	if (tep_get_field_val(s,  event, "prev_state", record, &val, 1) == 0)
+	//find if has prev_state_char, otherwise fallback to prev_state
+	if (tep_find_field(event, "prev_state_char")) {
+		if (tep_get_field_val(s,  event, "prev_state_char", record, &val, 1) == 0)
+			trace_seq_putc(s, (char) val);
+	}
+	else if (tep_get_field_val(s,  event, "prev_state", record, &val, 1) == 0)
 		write_state(s, val);
 
 	trace_seq_puts(s, " ==> ");
-- 
2.40.1


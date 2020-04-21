Return-Path: <SRS0=ZUfG=6F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85659C54FC9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 10:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 630D62073A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 10:47:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQqfWy32"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgDUKrV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 06:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgDUKrU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 06:47:20 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469D9C061A0F
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Apr 2020 03:47:20 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id u10so10712588lfo.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Apr 2020 03:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qdhig9Iue2DbW7wnNGDuDiwGtQVc8I+T83wthqD2YAQ=;
        b=JQqfWy329fNI5odUkw1OruGZz8wdGz5YvCNuSMGshS/g4mBdPMsOYLIsZzhlfcI1z8
         4bhMSE1FoOMImSElRkl14W+D2g9dRHVWsS05lvwQzK/jtbeRllqmriif4OqZYImmcT7y
         YUYKv6+HLIDgk4tK3TgLnkNxVvjlK6K7cASXN8YegWCnJ0sYS05pIs2FRwn/YxS1sYQ5
         hg7uZP5dCAG5p4qsNQG0w6hY+089+JtovIZuGSQUA2H5dKOUf/uAaRtLnRUpQRizYf9S
         hvK4wtGPnnhk8/xBPVixoPDysos4UTJsyOK/AOXex3mo3pyoVrfjv4ZtYFKQil23yUr2
         4MdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qdhig9Iue2DbW7wnNGDuDiwGtQVc8I+T83wthqD2YAQ=;
        b=tFJCOOxAYWeeDFgBIt22nDjZTp9BYYA9X+IKKzngsdLrrVemmNyBENpzOqFJQATxWr
         Bw7z7e4lF11RpX8qSYNLglanseJ5NMdt48LpSyr9sLqxMUF3WpyvIquQ49W0xAQrfOlh
         6Tg+wy5ASxTQ+iJQtiMs6Trxf9JINNyTPn3eC/4ayq+J16yBu8n5/8k6XmXWMPiQ8BB3
         /hlFXkmPyWR7IUP059egIg9F21Lrh1iw7U6gkT1sLykVNzfD2gQwUy2QdkJ4x/jBeboV
         vTh20Lm0zY+SwfMsX8H+XjrU+iUj2LIoSizy64LW/4KIrDAwX9f2OfTlOeZVVBfFL4Lj
         xklw==
X-Gm-Message-State: AGi0Pua8mDDbPunXHa7DPLwkQv6kggGv1JzxUelu/DNiIb0dsWffhZ5x
        OgFxtQdKdhv4lwnq/ohxdPg=
X-Google-Smtp-Source: APiQypI8j7oDMrWCcQh17jLW7LODOz7WI+fh8/5lpc/EzYGF8IwOJUuZdZk5B2zS4Q9nkBY4TFG6RA==
X-Received: by 2002:a19:2d1d:: with SMTP id k29mr13415225lfj.46.1587466038162;
        Tue, 21 Apr 2020 03:47:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m23sm1680202ljb.87.2020.04.21.03.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 03:47:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Print configured filtered PIDs in trace-cmd stat command
Date:   Tue, 21 Apr 2020 13:47:13 +0300
Message-Id: <20200421104713.31762-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200421104713.31762-1-tz.stoyanov@gmail.com>
References: <20200421104713.31762-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Print information of currently configured filtered event PIDs and
filtered function tracer PIDs in trace-cmd stat command. This information
is part of the ftrace configuration and should be displayed by the stat command.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-stat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 2e3d83c3..e9369842 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -900,6 +900,9 @@ static void stat_instance(struct buffer_instance *instance)
 	report_file(instance, "tracing_max_latency", "0", "Max Latency: ");
 	report_kprobes(instance);
 	report_uprobes(instance);
+	report_file(instance, "set_event_pid", "", "Filtered event PIDs:\n");
+	report_file(instance, "set_ftrace_pid", "no pid",
+		    "Filtered function tracer PIDs:\n");
 	report_traceon(instance);
 	report_file(instance, "error_log", "", "Error log:\n");
 }
-- 
2.25.3


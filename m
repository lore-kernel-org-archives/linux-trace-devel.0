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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DB6C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 358D961155
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhEJGRs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhEJGRs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:48 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451A5C061573
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:43 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id zg3so22729975ejb.8
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T9eIxjxaxhocZQRyjD0lWh0WnJn5g8jbP9shwgVRU1Y=;
        b=lcKLqPUkiO1K9BMErZLPGPNl5pNvtRaqcAgzn5UUlth6u19EaELUVwH4I7mnyM/yy0
         rgqQRwYNnMkxGIuibxgzhe43fTq5ZkSmtBcJ1gjSoDnBOitGu5PCgFsuhspxFyZyJfRR
         sasUxs2PEF5PHHSaQU+hZATyOvOz/fmn2b7nxPt7EglbIZSDmKI7dsanz6LM8Rf9h/Pr
         gPo9uWz4J7g9QjEG/EaVWzfdssA8L6fiJeJuFQ+p0hV34+KkaG5cLHAWi4OuuW+zLaCn
         6jOX653Bf8Gh56qN/v2Gzds22rPhd2pWXD3DJxS6NtGINw41keQ0WC7fvS8gd0F4MM+z
         1nbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T9eIxjxaxhocZQRyjD0lWh0WnJn5g8jbP9shwgVRU1Y=;
        b=mukijxOhAw4YKHL19xjjDs2wD/JjmDVNpgGBXXVGqne1m9FSaAVZrYqUVJoZo9OJQx
         XD2OcuD69ojIFOgs59VG1W+a6rjV/Vf7eRwHM9OXnTvk7Nlk1q6lBAmGMLGAbvqtOHBQ
         eH4e9xxuWURspkVMiy8ZEUdsiRa+WOTz2Rhj1+W2eH0aPeE8Cwf30E81SHnDHgivI4U9
         YI/XGZhsfXSopRxC7uPFBPy5MahzU5+UtJtt8/W61LB/vOtDR33xhnIn9EFTYq8xbr7N
         FBTyn3BXc2c2HET2dBjdU4J4GWReUwum81WiFyQdfSxj6bMZPP8FWuoKPH/ivtSyVOky
         Nrrg==
X-Gm-Message-State: AOAM531j/7PkMPjYyV8Qx/C6l1WtQSwoxYT0xj/vyVUU6ZqVhMxQOJWH
        W+YstUoLZ73POAYf6yXkhr0=
X-Google-Smtp-Source: ABdhPJzSBnWK5Kydwp/7S3kmDxJzf065yVzmE7yCaHu1jNGGl1yIk2Hzod9EqFYGH6RLhoWzCebEQQ==
X-Received: by 2002:a17:906:551:: with SMTP id k17mr24105898eja.69.1620627402087;
        Sun, 09 May 2021 23:16:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 04/21] trace-cmd library: Add new API to get file version of input handler
Date:   Mon, 10 May 2021 09:16:19 +0300
Message-Id: <20210510061636.1794357-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added an API to get the version of the trace file, associated with given
input file handler.
  tracecmd_get_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 lib/trace-cmd/trace-input.c                       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 136057b4..6a211333 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -232,6 +232,8 @@ int tracecmd_set_cursor(struct tracecmd_input *handle,
 unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
+unsigned long tracecmd_get_file_version(struct tracecmd_input *handle);
+
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
 tracecmd_show_data_func
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b095004d..9c9180d6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4046,6 +4046,15 @@ struct tep_handle *tracecmd_get_tep(struct tracecmd_input *handle)
 	return handle->pevent;
 }
 
+/**
+ * tracecmd_get_file_version - return the trace.dat file version
+ * @handle: input handle for the trace.dat file
+ */
+unsigned long tracecmd_get_file_version(struct tracecmd_input *handle)
+{
+	return handle->file_version;
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.31.1


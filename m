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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7ADC49360
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 748BE61289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhFNHyL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:11 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:34610 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbhFNHyK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:54:10 -0400
Received: by mail-ed1-f46.google.com with SMTP id cb9so45255782edb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CFwrGL/hfwhsvJgPKC75KzRj+oILJaqU4e0nSiGVm0U=;
        b=ejZiqxNMQQ3WGv3dI0LQ9egcL9arpVLuEupFVAOmfOYtBLXRzeAeS+1Aw0EPnattlS
         Vk9qwOB5AyHJ8ofIYucglsI45kUZDeQuqnAcqg7ZtGLy2Sn/WIa70M8uVeo3uHmLTIbO
         yX1S8UFeZC5hgrFBy+Wg5r0ORVGJP7fdk5wIOqzvJ/HtJNuyhlAX2k/5az61nqHypx/P
         AJFIpuUep2OG3+S2EyKV/r31wasab3B+zgN7I2fnxttEXVnXBjPNfVP6PgwXup4s5WL9
         hHW0tyyarL3LHL22nlBuzbBBeJoaF0qBQz3ujNPp0j425giXd28Znub9tOZK6EGx7bjf
         cYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CFwrGL/hfwhsvJgPKC75KzRj+oILJaqU4e0nSiGVm0U=;
        b=J/G9sa2KVkpJ99M8j5lHpS7qcyZjUggUPt517VuxI1gAP0ypnIZtjPLTPuug+9CrYf
         JgaUiOPfG8mcNPoJ5wtYK0BCPnsZIPZA2FvHawvyxvfDAU6md3fl6oLgt5GrxN4+yBpe
         Hymn9+u6MMfqbh8V7rA3W5592N/nXdsKltfn1/g8xJ3qTc0Z6JqSt3MpJbyV/hvDDEGo
         TCsYPQ+5DA7XreKA8XHBdqmBQPFj2Gm2g/QH4KtgjYDRS58/7nPLPRl3NGyr1t0ymwVk
         +eTu3ZRHGqQ5TtOyUZOppZ4QQ4eRujWJm2ZNDSA0nYOeKPZ/Rb08GEUsT++XJqsMU2dL
         ug2Q==
X-Gm-Message-State: AOAM531wZWUN9VjIifgU1gtDGAemlhlG0VnKZGGeuFMeQCm0e/UZsGgE
        Uid+omYuHE/4FmEBo+HeBZ4=
X-Google-Smtp-Source: ABdhPJzIjfM77LSEBETzL4LcqRtIUhZHvvkMcdSZ+D0HZSDyZbuX8NQiYZySAjPvUEhlNI714wAbJA==
X-Received: by 2002:aa7:d785:: with SMTP id s5mr2117322edq.19.1623657067011;
        Mon, 14 Jun 2021 00:51:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 37/45] trace-cmd library: Refactor the logic for writing CPU instance trace data
Date:   Mon, 14 Jun 2021 10:50:21 +0300
Message-Id: <20210614075029.598048-38-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a helper function, internal to the library, for updating CPU
instance offset in the trace file. This allows to reuse the logic inside
the library, will be used in the tracecmd_copy API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  2 ++
 lib/trace-cmd/trace-output.c            | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 970087c7..3cb171ea 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -72,4 +72,6 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data);
 
+int out_update_buffer_cpu_offset(struct tracecmd_output *handle, const char *name);
+
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e5da4cdb..54134d03 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1853,8 +1853,7 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
 }
 
-int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
-				    const char *name, int cpus, char * const *cpu_data_files)
+__hidden int out_update_buffer_cpu_offset(struct tracecmd_output *handle, const char *name)
 {
 	tsize_t b_offset;
 	tsize_t offset;
@@ -1883,6 +1882,14 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 		tracecmd_warning("could not seek to %lld\n", offset);
 		return -1;
 	}
+	return 0;
+}
+
+int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
+				    const char *name, int cpus, char * const *cpu_data_files)
+{
+	if (out_update_buffer_cpu_offset(handle, name))
+		return -1;
 
 	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
 }
-- 
2.31.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425BEC43462
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14935613B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhELGjr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhELGjq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:46 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27129C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:38 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id c22so5194800ejd.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xlVP7vcl2IIrsv9q322xpUVzXj6w983u8QgNphroLKE=;
        b=jKvPhVkIJDsQoGWr4ONKnJ78M7fgAZLnB5yIs50YmYeAQX60TiCeN4mYAg22hlRNRG
         t0xhEoDUnl4jAFIEfBa/4u1P2P0urfVH1NAiGqT84vDa+46cTm1SqWOPiCd8D1O7TQnX
         nKu2E+s9f8jcbzPxYlslzZb5iqYvFiMKKkAJ1XYf8dPaIHjJZTMM98Og+7HBEZi88Ila
         N63l5JMa8kkQIRiLajCBwOVvsMxRJaQPWfk2a4dMUVIps5sW7M0+Qw4cHBTpEaN2fKwb
         YuYFsEUkLRBYojGq0Uhjtoji3xtKJsNRGrGKPazUTOQfF7keovQ3zd/glReShs1a3C7i
         pTGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xlVP7vcl2IIrsv9q322xpUVzXj6w983u8QgNphroLKE=;
        b=ss0FFYzvvX4gakOWiY6HMha+Trbd2LtzNgAROou0e58U6Bg79PLcfud1LhaWAKrenP
         mI0GRQyFJ+mNMk791zwZI6H2E4joDpQCxR5YVP92uOSurPi7VyqYuo450anYyi6E88Kx
         KSkz51DmmFlcJ05tihR1LZ4BIEWp7Lff8gKx9C60RDmSb3VaE1NE6brhN3lHIQRVw3SG
         p8noqZ4/6UxBnCHy5RA5RmUGDvm8uHWJT9gAp3W/CF86PrFSjaEswNFGVjoMKz0z3fx9
         iH8IcrNky5RQqS6ot8WlTSYbCIrSo6rN5NP/Az1iqDOwZUvFv3L+FyY2U4A1wq2YIWmt
         4FVA==
X-Gm-Message-State: AOAM533R5+8xe0YUIUyCQZsCoqjhhP96X3uMxcorNuuTvbr+50RZKVFp
        4cyC8ApoyGkeNKH+BSsTBTo=
X-Google-Smtp-Source: ABdhPJzu8JSH6sOJuN6DFOHjbCnc1BQwzmeWS2EnpnK5PNAywxJtfJbssNfLeDLRH3K0/rAvmX6I7A==
X-Received: by 2002:a17:906:a0a:: with SMTP id w10mr35555729ejf.416.1620801516959;
        Tue, 11 May 2021 23:38:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 12/25] trace-cmd library: Add new API to get compression of input handler
Date:   Wed, 12 May 2021 09:38:10 +0300
Message-Id: <20210512063823.324610-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API returns name and version of the compression algorithm,
used to compress the trace file associated with given input file handler:
 tracecmd_get_file_compress_proto()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h          |  2 ++
 lib/trace-cmd/trace-input.c                      | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 602817cb..4265e37a 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -236,6 +236,8 @@ unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 unsigned long tracecmd_get_file_version(struct tracecmd_input *handle);
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a23c26bd..9dff2188 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4150,6 +4150,22 @@ unsigned long tracecmd_get_file_version(struct tracecmd_input *handle)
 	return handle->file_version;
 }
 
+/**
+ * tracecmd_get_file_compress_proto - get name and version of compression algorithm,
+ *				      used to compress the trace file
+ * @handle: input handle for the trace.dat file
+ * @name: return, name of the compression algorithm.
+ * @version: return, version of the compression algorithm.
+ *
+ * Returns 0 on success, or -1 in case of an error. If 0 is returned, the name and version of the
+ * algorithm are stored in @name and @version. The returned strings must *not* be freed.
+ */
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version)
+{
+	return tracecmd_compress_proto_get_name(handle->compress, name, version);
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.31.1


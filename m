Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99166C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358147AbhLBMZv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbhLBMZ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:27 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1D8C061761
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:04 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x6so114895878edr.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yU/W9MShv6HmDcX097p5qgDqnEwfqoXg/dbYgnIOI/U=;
        b=IWTNpa8h1onq/JuJyRR0Y49gPFJDsHstYT7Mz/t3DgePkqjQesAy4WK2q+RoPYM+nb
         YtjPhWJ3ssuTN7Qa6GF2j8ju+P2ik/sZdLdoGb0LGZ8RLKIS624pOC6JhPZzKcRuCapr
         AjiTS7zKAkqHU+xZEZRgL+i5ccq70Yl/MLtG0LDFBqXbwmOnB15qgMcJg4LrSHuBcczI
         nMc5R9v7h0LsW56fUFkeYV2NTGUt6tLug4ZwuR0Ip3SO8pFoLtYSlGteCqb/Kj1TeFlS
         PL9ZtoMR6IzXp7iw7AG3Q/WTFpCdbLlne2xVROU+/cuxbUnlqajZmpPy3zEC4lnqDVw3
         fYBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yU/W9MShv6HmDcX097p5qgDqnEwfqoXg/dbYgnIOI/U=;
        b=1axI3C3AUqRNmk7fZMidrxHZEzmoy6u3hNCXSLlSY3pBFJWhfur0y9iemcsJ/2qIdq
         4w922j5N2GHv+Ve0XuhI7I8nU7MG4fJ9S5g8YYSLvr9DE+7FRNryIuPe3UfGyDw0cbS5
         Oqe4QLkLZhfTxhjnVNTw3PFaNJ8Oo7Uh7bEKp099l9MB2IiRfLcnuu7rj0brCtDWNJwQ
         mQv/2WBLF9dS/0IIdOD9itHSIw/C5CezVc2uGdDt8U3Zb6n6X6Rll15QpLvGvd2S8xsf
         xNZZfAiI9sLGS+yb5KFLyUtsrMWXY46LHpZKBWGfs497vZb8VfCwZbcVoESvpSLXQz3z
         AB/A==
X-Gm-Message-State: AOAM532y2/d//bUQuww+n9CjZt++TXA6HGIpkBO0ZqUcfjXOKOUvjtx4
        Z58YIjlw9XC7PPFj2fNsOnwgRCWGznKS0A==
X-Google-Smtp-Source: ABdhPJxGE898IQv5lQ8xSe6133JApZHPdTnEG4l+0FDaUbU3kdA79o+r348F8yW0zdhmXnMypbg/WQ==
X-Received: by 2002:a05:6402:270c:: with SMTP id y12mr17289817edd.258.1638447723358;
        Thu, 02 Dec 2021 04:22:03 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 09/23] trace-cmd library: Add section header before flyrecord trace data
Date:   Thu,  2 Dec 2021 14:21:38 +0200
Message-Id: <20211202122152.43275-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, write a section header at the beginning of each
section with flyrecord trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 2298c102..ea36fab3 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1904,10 +1904,12 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
 	struct data_file_write *data_files = NULL;
+	enum tracecmd_section_flags flags = 0;
 	tsize_t data_offs, offset;
 	unsigned long long endian8;
 	unsigned long long read_size;
 	char *clock;
+	char *str;
 	int ret;
 	int i;
 
@@ -1926,6 +1928,13 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
+		goto out_free;
+	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
+	free(str);
+	if (offset == (off_t)-1)
+		goto out_free;
+
 	data_files = calloc(cpus, sizeof(*data_files));
 	if (!data_files)
 		goto out_free;
@@ -2014,6 +2023,9 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		return -1;
 
+	if (out_update_section_header(handle, offset))
+		goto out_free;
+
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
 	return 0;
-- 
2.33.1


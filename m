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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775C0C433E4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B97B61A14
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbhCXNF1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbhCXNEm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:42 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEADC061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:41 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so2664235wmq.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HqCDMS6/zKiTKr+JmBzugazZXnt0+q8DIKy+t/24CuM=;
        b=hHibC0QPbQr0dbeOi5EqOv0n7Pjokd8qVLyzWDAYGF3CnPsHR8ootuA9LqisWGg27a
         iDD2FojO2LkGwCW0Rmak2ALGbXpQjUy+JkLSB7wOnaSWwHSb4dBXK4N3F+xJHyWH747R
         ppxilxN2vMDEuwfRTP42fZrhVn9lSv0hYgqkfBCELb77n6hoHhjXkpS4szcpT8qSRE0d
         Xn8YhWIEBba6Utf5fB3+ZNdhbHPGqjfrw98q60IZgwwGW86prRD0ZGd/iUXq9RIhr9fL
         8SQp29eueE27D780Oo2QBqqQjZqVOmz9xIclEh36EftCe0nWoTEZhmDGV5/7O86pGwP/
         IbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HqCDMS6/zKiTKr+JmBzugazZXnt0+q8DIKy+t/24CuM=;
        b=fUQN1i9x5wGuY/lsM3c4XhoeF/D0+hKXIqlfWDTKl9iTfIkhmw1y7Avx/WBiYzz4GQ
         RRUW8qDPggwllKH8fzFbPvUwkFw1eG/meCCU7LfrW5DlV9UNmmNRnCMbVeCk1gBlyltt
         l8Kvp6eah71w6it784M97ONRYrstr4JYl7tY/IucWvDE7o6x+WJmzAcBedrvLPCvSFud
         9m96yip+0Bz2LQm8wAOnOge9rEHmEStfJZ8tzIOe0VcKJVWe9BPANe/7yrRIW5qAv5yf
         DcJIi5ev7Ct6U4vxx0KlqmjovxLl34zMjLQ9nrIBh50H63XZQgfj72HAgu7EeiSFIlSb
         skdQ==
X-Gm-Message-State: AOAM533kfr/75oAqky8deJM2FjJGEKwd6/I39CGZsQLJJjYWeEHVm8em
        0JdEe4XlqQDqYEd6zUQLbf2mmgnwcwI0eA==
X-Google-Smtp-Source: ABdhPJzU61nt8oZcLszrecNOUlq2N4GljbLuyFKv7ffaFVrCRwEQN/gHSAAFx5NeMjDc9mZlJmkd5Q==
X-Received: by 2002:a05:600c:2947:: with SMTP id n7mr2913179wmd.61.1616591080251;
        Wed, 24 Mar 2021 06:04:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 13/23] trace-cmd: Perform all timestamp corrections in a single function
Date:   Wed, 24 Mar 2021 15:04:08 +0200
Message-Id: <20210324130418.436206-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading event timestamps from a trace file, there could be various
corrections depending on the metadata information from the file. Move
all logic that performs timestamp calculations in a single function.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index be8a7919..e1842cce 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1276,6 +1276,17 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 					 &host->ts_samples[mid+1]);
 }
 
+static unsigned long long timestamp_calc(unsigned long long ts,
+					 struct tracecmd_input *handle)
+{
+	ts = timestamp_correct(ts, handle);
+
+	if (handle->ts2secs)
+		ts *= handle->ts2secs;
+
+	return ts;
+}
+
 /*
  * Page is mapped, now read in the page header info.
  */
@@ -1297,10 +1308,8 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
-
-	if (handle->ts2secs)
-		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
+	handle->cpu_data[cpu].timestamp = timestamp_calc(kbuffer_timestamp(kbuf),
+							 handle);
 
 	return 0;
 }
@@ -1930,10 +1939,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
-
-	if (handle->ts2secs)
-		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
+	handle->cpu_data[cpu].timestamp = timestamp_calc(ts, handle);
 
 	index = kbuffer_curr_offset(kbuf);
 
-- 
2.30.2


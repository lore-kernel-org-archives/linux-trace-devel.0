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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73622C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E49560F6D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbhIMMbT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbhIMMbS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:18 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168BFC061762
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:03 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t8so9382715wrq.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jxMjUtFNcnngojS0O3wFxoxRQrLI3Inwj7czIHLEG08=;
        b=j8XkHGhJzAR/2eBT0GyRaf2qDaaoLQb1kWcEVd44KthqFiNrbh9DasHrba6ztp5mJG
         mC4glVfKCm5MElDh/LeZEX6ADIvjUt8h8Zjo8oIKE35mcY4vnqcSg+M7oknYtI5JAHXE
         48A90b2k/WU5e7QTMg1wmgk3CMoGildhnNICaPvI4ew1Vg8sy8hiC5vs3RXlAhp6nA8z
         SFHZOLyDP+v+QJ1gb3a/9xgr8hS60+heJE8dLlJjkLgeGYus+iaVDs1WEC7KU7A/jauI
         2JqGhu8YCsyeB2WowfNSHYli4BP7+EclhK2YeLrATBrGVYw9zGa5/o0ocIo/cShxASjz
         LzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jxMjUtFNcnngojS0O3wFxoxRQrLI3Inwj7czIHLEG08=;
        b=VRJCuxeZ91d/c4pRt1QmDoFG2HOZY9p6cYPurmE5r0oec6n4OJzanAK5SpD5JZPhZw
         FZ3SJunoW1r2S1nhBCWARC4bNrY6S3ibzIrgm9F40lkEa+CwGgmcFJyfiOPB8Z/bKirU
         yQzngb0YgBtn/LChpkPxQegF4X3zZrjYq1IEX3ki7k0M3qStCeWeC6pNm0H0iP7zV1dV
         l/FCLFX7aR0uQkgxX8r6C6CGz00oU13F8oSo/ECvMUgxYD9Ml8N1WqgLKFJ73QJZgJHx
         kas4vNxVhv7Q831+aIqtHyO4ocIevXZuCHFToFm468PIhoxRN4kCvbztSXI0YN6RzsJv
         8Eow==
X-Gm-Message-State: AOAM532HSy6hRmJg3HVCUkDUrb3n4oLg4dR6h62lpzZ+Sznclqj6uq8j
        8yhwfcITKbyNXp8g4JbX4aTdSVU6cD0=
X-Google-Smtp-Source: ABdhPJyqhlROjTvviIc4MUCJGmzAtI+8irbIUj4xuc4hgGALjEvarF440xF0uGsl4tNwwKs9P7B3Sw==
X-Received: by 2002:adf:ec4b:: with SMTP id w11mr6665799wrn.389.1631536201753;
        Mon, 13 Sep 2021 05:30:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 12/25] trace-cmd library: Do not write CPUs with empty trace data
Date:   Mon, 13 Sep 2021 15:29:34 +0300
Message-Id: <20210913122947.3673239-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has more flexible design, which allows to write only
CPUs with trace data in the file. If a CPU has no recorded trace data,
do not put it in the trace file version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 329ef5d3..810b7265 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2074,8 +2074,10 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	if (i < cpus)
 		ret = -1;
-	else
+	else if (size || !HAS_SECTIONS(handle))
 		ret = out_write_cpu_data(handle, cpus, data, buff_name);
+	else
+		ret = 0;
 
 	for (i = 0; i < cpus; i++) {
 		if (data[i].fd >= 0)
-- 
2.31.1


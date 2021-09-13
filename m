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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6647C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D13AB60FDA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240009AbhIMMb2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240000AbhIMMb2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:28 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972CEC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:12 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id j17-20020a05600c1c1100b002e754875260so6474397wms.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1E5wKgsEJ4be0W+zzNbr3DwRHrau1BT5rA0OWAEmn9Q=;
        b=i/TtXMzwTC0ZZ9qpGtZnfPKkMR7NJlumXwBGPhY6KbguNf1yC8VHNqTbirOD/HB1/x
         KAANuLo+1XUVtSn7XNpru0apJs1Ufl+uw56VpjJYYw2AnAufMI3rDGGsNuP2mTX4Th/a
         U1LMRKpuCtPccdUTtsmYWu16qNi1gdKMnaZ+WMSAcHKx1kPi6Ct302zQiEKELfshfifV
         1XI7Dogx0vehKJ+3ZpLBLUz5PYnNJEdZTzfrdpaVTju0ZJO37ooYObWYF8V4YD5V0XSU
         Kx8984lSuDavzyz/mGYaCrqjFgU0vCEnuino8XcaN24dWcDapKT3Pm0aMUHQBkOMuAdC
         x5Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1E5wKgsEJ4be0W+zzNbr3DwRHrau1BT5rA0OWAEmn9Q=;
        b=O5IID2LMQbTAd5qlyuN95yuQJMl3pRw0RUoNGl8mn72j4BNCNhYpVOSl21wbfvdvRP
         7J0UZNgUXBM77pS4uqsWDtyztsb7g9PXLZw6NPeSMtLhJA+/tmG9Be1UPLfz6akF1vYf
         yqVn3aX7wT41UJAJjK6uX2csHuU4uF8asezvBAqY0ugDCrNHSH7V0qbLe8DFEZEuPoLA
         gwoJfN6sOCH+4PNBmtLEEeO/VNciHTPf5U3OwY3gkoJn2FWwL80rE2TxpqNT+JvPfCGf
         aKem705WL+BC3Y4TksGqW04QYDyGzI5sNb5smSQXmydr117KKnU8fHcocdy4RRXlw2jn
         3o4Q==
X-Gm-Message-State: AOAM531TqbpzirhOkL75emUK8tqoaNxwCwMp1FrIKC8PRpte6eNqoLr4
        FN5vkQ/f/Mbvx4hzuFKWS6JKFFMnm84=
X-Google-Smtp-Source: ABdhPJzENpGZyXJ7d2Gu/naJlvz9k1BmjM+Tq3pTa6ptLTBsfNBZyBDEedTBn5uU/wC+34J71A7xLw==
X-Received: by 2002:a7b:cf09:: with SMTP id l9mr10849075wmg.115.1631536211201;
        Mon, 13 Sep 2021 05:30:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 22/25] trace-cmd library: Handle buffer trace data init for version 7 files
Date:   Mon, 13 Sep 2021 15:29:44 +0300
Message-Id: <20210913122947.3673239-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

CPU data initialization is different for trace files version 6 and 7.
When a new input handler to trace buffer is created, initialize the CPU
data according to the file version.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 55 +++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 77e2a53e..b7d78a3a 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4479,34 +4479,37 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->flags |= TRACECMD_FL_BUFFER_INSTANCE;
 
 	new_handle->pid_maps = NULL;
+	if (!HAS_SECTIONS(handle)) {
+		/* Save where we currently are */
+		offset = lseek64(handle->fd, 0, SEEK_CUR);
 
-	/* Save where we currently are */
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
-	if (ret < 0) {
-		tracecmd_warning("could not seek to buffer %s offset %ld\n",
-				  buffer->name, buffer->offset);
-		goto error;
-	}
-
-	/*
-	 * read_options_type() is called right after the CPU count so update
-	 * file state accordingly.
-	 */
-	new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
-	ret = read_options_type(new_handle);
-	if (!ret)
-		ret = read_cpu_data(new_handle);
-	if (ret < 0) {
-		tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
-		goto error;
-	}
+		ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
+		if (ret == (off64_t)-1) {
+			tracecmd_warning("could not seek to buffer %s offset %ld\n",
+					  buffer->name, buffer->offset);
+			goto error;
+		}
+		/*
+		 * read_options_type() is called right after the CPU count so update
+		 * file state accordingly.
+		 */
+		new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
+		ret = read_options_type(new_handle);
+		if (!ret)
+			ret = read_cpu_data(new_handle);
 
-	ret = lseek64(handle->fd, offset, SEEK_SET);
-	if (ret < 0) {
-		tracecmd_warning("could not seek to back to offset %ld\n", offset);
-		goto error;
+		if (ret < 0) {
+			tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
+			goto error;
+		}
+		ret = lseek64(handle->fd, offset, SEEK_SET);
+		if (ret < 0) {
+			tracecmd_warning("could not seek to back to offset %ld\n", offset);
+			goto error;
+		}
+	} else {
+		if (init_buffer_cpu_data(new_handle, buffer) < 0)
+			goto error;
 	}
 
 	return new_handle;
-- 
2.31.1


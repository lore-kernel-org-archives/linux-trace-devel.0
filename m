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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA421C48BE8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4D1F6124B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhFNHxY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbhFNHxX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:23 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3679C061787
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:05 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s6so45189514edu.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L7aeLr4lc1KENvDwyPAuCgASeUBhtlmmst7Nub9ec/o=;
        b=meNCIekbRgMRnF4O1zkN5TFgSSKNU+unXvb7GMgFPKODuIRjqUIwSLvQH+SDm51HDK
         B99Eu3zGGKam8RJdUP9gN89xQs59GH4RIla8d9ITopQmp47tP9ik8S3uP//UKXT93PgT
         BhxtYS/XUnhrVZ5ZnZ9KUJW+1FifbOx7xxyP0jycBaW22diJa/Br3YJFrMxny6ofI2NY
         R6mbHi9NpYF3xI0IhEtAjm9UjO3Fe4lB3XrjdeNbQ8Eg7j5+eS6GFVERh/m659rWZe3g
         qHGQ1TmrIL25tz54kAJ/Zf9OfRjC0fpjkaLtDpATWQKLhm3m3yDUZotVZLoJQlvMpfFn
         2GvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L7aeLr4lc1KENvDwyPAuCgASeUBhtlmmst7Nub9ec/o=;
        b=H9ogU1QDlfInIkXX+EaIOK0ZL/gMHGrJZ1wX3X6yM/TYuLG1eOxBNO84RzpijZU7GG
         0xIRhZIaY6dH9EmlZKkQSyHZlCCmlnNHzZ/3y3GR8lKutEHrmmj84bIq7/s4BvcoHo4E
         8Jple19EqpMINy5k6oRsXoIcgCdinKSoE1Aq4XoSBoH3syLkIrhOw8nBhhHbVbrleX2w
         Yb/v3bIMydinz07PWfB3cA/pd0sOI9PHJz8tDNCHy4K/kJJEM24V/fsopx/+/RGq0L3y
         EUALDZV814qQB5IaVFvcCm9Wgk4tIKou5p0bj4CgWYMFmvQrpK7QAlTSTsluqQylaGTT
         bryA==
X-Gm-Message-State: AOAM533ok6pSGkmfz2y//SHxa0ciAVRsn4KiCX3UA/tPnophk2f4xS4h
        D/LNjkb9B7hf5IxCBowzwhlnNt54ZNOIgg==
X-Google-Smtp-Source: ABdhPJzSnTUlsS49XZsT3J6NHdoSicY2IOnwlTHwQ+3TBb/N7RCxafvNUTXjIk2MHEctOyhl9U/pfg==
X-Received: by 2002:a05:6402:2552:: with SMTP id l18mr15749775edb.166.1623657064310;
        Mon, 14 Jun 2021 00:51:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 34/45] trace-cmd: Copy buffers description in tracecmd_copy
Date:   Mon, 14 Jun 2021 10:50:18 +0300
Message-Id: <20210614075029.598048-35-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extend the tracecmd_copy() API to support copying of trace buffers
description from input to output trace handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 +
 lib/trace-cmd/trace-input.c                   | 38 +++++++++++++++++++
 lib/trace-cmd/trace-output.c                  |  3 ++
 3 files changed, 43 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 2c31be5f..3735586d 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -174,6 +174,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 289102bf..7d0a41c2 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4173,6 +4173,44 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 	return ret < 0 ? -1 : 0;
 }
 
+static int skip_buffers(struct tracecmd_input *handle)
+{
+	unsigned long long offset;
+	unsigned int count;
+	char *bname;
+	int i;
+
+	if (read4(handle, &count) < 0)
+		return -1;
+
+	for (i = 0; i < count; i++) {
+		if (read8(handle, &offset) < 0)
+			return -1;
+		bname = read_string(handle);
+		free(bname);
+	}
+
+	handle->file_state = TRACECMD_FILE_BUFERS;
+	return 0;
+}
+
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle)
+{
+	int i;
+
+	if (in_handle->file_version >= 7) {
+		if (!check_in_state(in_handle, TRACECMD_FILE_BUFERS))
+			return -1;
+		skip_buffers(in_handle);
+	}
+	for (i = 0; i < in_handle->nr_buffers; i++)
+		tracecmd_add_buffer_description(out_handle,
+						in_handle->buffers[i].name, 0);
+
+	return tracecmd_write_buffers_description(out_handle);
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index b4bdaeeb..ca9024bf 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1952,6 +1952,9 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char
 	fstate = state > TRACECMD_FILE_CPU_COUNT ? TRACECMD_FILE_CPU_COUNT : state;
 	if (tracecmd_copy_headers(ihandle, handle, 0, fstate) < 0)
 		goto out_free;
+	if (state >= TRACECMD_FILE_BUFERS &&
+	    tracecmd_copy_buffer_descr(ihandle, handle) < 0)
+		goto out_free;
 
 	/* The file is all ready to have cpu data attached */
 	return handle;
-- 
2.31.1


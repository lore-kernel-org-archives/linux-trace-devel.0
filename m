Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A64C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D3FC61108
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhKKPLB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbhKKPLB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:11:01 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C2CC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:12 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c8so25025794ede.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RAGSfu5oLO8nXabFlXdMGNLb/vGke1IHWcJ2BZgo0sc=;
        b=Uqkrx3DfjowWudkYcPvzCcUsHEAGjNtwyQ6sJwU4FtzMq6XhFhJx1QKHfKT/ytYOOa
         /OeIif2q+moEeIgHJpgfAhcVsm4eoLh02eUPA1Xg998q80vVBs0MK2DtchHZv7Q5GMtk
         avDGvNxX6mv3hkN4/nKr7UVgSlJZ2TUHPi7DJ/Qhb0+FnsOyZB2Y/+gUWGachXpF5a7c
         Q/GJgdsyZWvYIFIBwHQGTTEx6Xe0ggSTxmdno4oVkiuXcXyULWfDA5saFU/6Kg6bIhDM
         NYNezgTPYtOzs0VEyydZHTkqg16dWf0OpKlM7/9ZHNEfUyRxqCkb6oi5ighiU+a/3wcH
         nhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RAGSfu5oLO8nXabFlXdMGNLb/vGke1IHWcJ2BZgo0sc=;
        b=uGN8la+hgUy95qv6EvRGcGHDhvWKgMA1+ZThH/1vnTmLjU/S9zj5QArg1L6KAQLo97
         bCqRIVQX8030sZxWq5qe0YDabfRTgKYQ6i6ySFkt/kWB2iF1T/UyfP4EGJJ8G9vc+1vS
         HhjQB3z9yWoZcScT2i2kIvalontMtyR09LOMBnzymRVnoY6vNpl/oGEl54vc2zSLXNKC
         6lmA96JbvXNuBwIhPiMMMkg8VOIMoZM36eFWRJPTUjSfvslE4I3JVBOTHr3x2DTphFPZ
         SMy7TpKGcMgkpDYQLI+eXgN732t3I3mSeNLCES8HYrFp6MatoHtFLvfO02RXNN1zB9yd
         qnpQ==
X-Gm-Message-State: AOAM532Is1+KDV9plobVlV/jY3+Rjtzdw5ADdEp91L3ldYpuXg4uQFoa
        CAUVkoP06YZ0SnKrHUT0jNrQINRq94R2yg==
X-Google-Smtp-Source: ABdhPJy20qzQ/Cm8rvbOMHwg+YrUvHV+MPY2Yes+uvkIBd+rG6BTdckSBmAfcwrPAKDx///MPC+RPw==
X-Received: by 2002:a05:6402:1c1c:: with SMTP id ck28mr10871332edb.300.1636643290638;
        Thu, 11 Nov 2021 07:08:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y15sm1869027eda.35.2021.11.11.07.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:08:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/4] trace-cmd library: Helper logic to update the trace buffer offset
Date:   Thu, 11 Nov 2021 17:08:04 +0200
Message-Id: <20211111150805.86419-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111150805.86419-1-tz.stoyanov@gmail.com>
References: <20211111150805.86419-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new helper functions can be used the update the trace buffer
metadata with the real offset within the trace file, where the buffer
data are stored.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 49 ++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 1f144d28..17607b93 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1395,6 +1395,20 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
 	return 0;
 }
 
+static tsize_t get_buffer_file_offset(struct tracecmd_output *handle, const char *name)
+{
+	struct tracecmd_buffer *buf;
+
+	list_for_each_entry(buf, &handle->buffers, list) {
+		if (!strcmp(name, buf->name)) {
+			if (!buf->option)
+				break;
+			return buf->option->offset;
+		}
+	}
+	return 0;
+}
+
 int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 {
 	int ret;
@@ -1487,6 +1501,41 @@ out:
 	return ret;
 }
 
+static int update_buffer_cpu_offset(struct tracecmd_output *handle,
+				    const char *name, tsize_t offset)
+{
+	tsize_t b_offset;
+	tsize_t current;
+
+	if (!name)
+		name = "";
+
+	b_offset = get_buffer_file_offset(handle, name);
+	if (!b_offset) {
+		tracecmd_warning("Cannot find description for buffer %s\n", name);
+		return -1;
+	}
+
+	current = lseek64(handle->fd, 0, SEEK_CUR);
+
+	/* Go to the option data, where will write the offest */
+	if (lseek64(handle->fd, b_offset, SEEK_SET) == (off64_t)-1) {
+		tracecmd_warning("could not seek to %lld\n", b_offset);
+		return -1;
+	}
+
+	if (do_write_check(handle, &offset, 8))
+		return -1;
+
+	/* Go back to end of file */
+	if (lseek64(handle->fd, current, SEEK_SET) == (off64_t)-1) {
+		tracecmd_warning("could not seek to %lld\n", offset);
+		return -1;
+	}
+	return 0;
+}
+
+
 static char *get_clock(struct tracecmd_output *handle)
 {
 	struct tracefs_instance *inst;
-- 
2.33.1


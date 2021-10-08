Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3ABC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5E2D60F6B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbhJHEWH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237403AbhJHEWH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:07 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7150CC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:12 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g8so31245123edt.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gd0cDqdn2qY2404b9VCs8fTfE7hm13m3VAh6s+lr2x8=;
        b=TOe0PLqdy8GSxKu/iO/FgKB2+5rlE48lB3v0vFmqEseimapNtA5Pru92nsIVfZHPue
         XhuwJHwOoNMIm9DavREioObkEHb3Q1NuAVdWaYXHH68O2fJwiAh0cCwENAW/Gv5lHHwW
         MMApHFUZXPkj9/6ib6+OCCX4U8HJfDHdA/Usf1Xj6MUJ3mLxG4J5iJxCM9gVYPlHbeCE
         QuHvn7nHcrvv1H8WH8DQUAAjWsnrPHg3+g3scyUrWyTVk4cPivme2LB6kC28mO0wqYbt
         utACvJX0hiuDkKpsqof1oXBZIzFHUvW0VXVM2WQLEIOBBLZpo5Ss4YLq++93VWPL4O6o
         yiBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gd0cDqdn2qY2404b9VCs8fTfE7hm13m3VAh6s+lr2x8=;
        b=eZfqgpBLTcJE1b+/l/jbwGiZG+3u1jHrp36iUjZ1STTweqAWxYOjhM4jfmpljkDKPc
         yg6GEebgxafUkgTbcAqOUadTytQNvTalNppNq83vGE43vmZSbzSGPiGEy4L4DmDzVx29
         3Xkd6f8G8milJ235YGgm5zntwdUNqCSk2mUsy5VBR7LSHuYGeNgW5kGXml2qx4dp87cX
         GaT0PcwEKSd1Koq4/ZNaoLtABoubZXHrON2lewBxpY1HQcBVUXy/soop0FEEkc+nuijs
         tshJS/pi6hUlrdGuZhSrEso3Oi6oIW3wwz8OhMZ2XR54E3xUlpIu3qE2X5106nMfrPYy
         Vx4A==
X-Gm-Message-State: AOAM531pT3rz5vxfZhtXa08+tkaWSPW+cJ8kxpx3yymLKwfsC39XUb3w
        42ldNn4RQSNJlH++pIvajj2ekYWrfJWOUA==
X-Google-Smtp-Source: ABdhPJyQQGs6rwvKnbgrbD8zwTUKbp7tCciM1d0JIrtThAFBDgrbXNexAt86q9n0TiG9VgyG0dFXkQ==
X-Received: by 2002:a17:906:f6cd:: with SMTP id jo13mr1233379ejb.563.1633666811126;
        Thu, 07 Oct 2021 21:20:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 10/25] trace-cmd library: Add section header before flyrecord trace data
Date:   Fri,  8 Oct 2021 07:19:43 +0300
Message-Id: <20211008041958.976309-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index 63f00cba..a5025d50 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1892,10 +1892,12 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
 
@@ -1914,6 +1916,13 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
@@ -2002,6 +2011,9 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		return -1;
 
+	if (out_update_section_header(handle, offset))
+		goto out_free;
+
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
 	return 0;
-- 
2.31.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C68C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhLBM2m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbhLBM2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:42 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C684C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:19 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id g14so115268542edb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h89mIIiJTT0/Hk8nW5znXdSqyLULJPfcrTfMFa+RWh4=;
        b=gTXGJ0eOwdnfFxoyUeAYt7+Ol/eaA5Kv/qX8zkJRh3WK8b3bnIE+ztJC3vz8KuGcab
         vao3maRzcGjL/swUuomUtY9LkhQoJRTnm7nox4nnsGfPhEmRAm/WjSXQIpajZyskDY0g
         mYg3gBmVAsUROlnFQvbG1h7DGykatDy07fUGf3GJf5zcCB90hAOc4YwHAbqL+VeDAx1T
         ZueNOpU37M9LvkT5ALVuLxW5DAw6X3F/Z1UxN+FbRG5/CqhO5fu1Sx3CvRfVZoerm0/q
         wp/Ugh6/jiJj3BD/mNCWjEdUGqLyZvBRPo9cPiVq7vlwMzoZMlaNrLenVQ+4ztTaz7B0
         l9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h89mIIiJTT0/Hk8nW5znXdSqyLULJPfcrTfMFa+RWh4=;
        b=fZDtlNg41LBZAiElD/0FfVIX/aEEcP/VCHuAa/kO1ofkOCZ1vSHX+lcnXiU/0wZkmW
         FKIuv7sEaP98himoBLV8olz6I8iJDk6huzGS9xz2QGeG25RMKbgzCOBMfvdj9RtjV5Om
         cNykoUdvfSMbkw7mYkaB7fWatEK2tZYwgZbz1Ol7nq0wwxZymAyisjeANr33m79GaYp4
         j7hoEjdZS6CNJEGfe+aW2iNWTCIACm6LY4cSVJtNoJoaQE2m/tbPTZ4SjWpXJ6NoiTGX
         jRd2ObCkqP+bJrSqLnYsZOAzoB8gEQAp6ma1bu7Ip/R/FNBlaTmMXT25ZWYh+3/qJrW3
         YNBw==
X-Gm-Message-State: AOAM532V7yC1GrzRKx4fjN39HaV/tOAbFsVSTZVZY1/J5lD53/9Oiu83
        viD4B/ea09vDQmhOMpLBQRi6zFcpEfhy6Q==
X-Google-Smtp-Source: ABdhPJyDGoch9Z3e51/8fKTl3uwPGtOY2wbwAOM589qwWsyG5rKfGRJpmrN/er+FzSt7wSifkQ9KwA==
X-Received: by 2002:a17:907:8a1b:: with SMTP id sc27mr14976624ejc.572.1638447917267;
        Thu, 02 Dec 2021 04:25:17 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 09/20] trace-cmd library: Compress the trace data
Date:   Thu,  2 Dec 2021 14:24:56 +0200
Message-Id: <20211202122507.43572-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the output file handler supports compression, use it to compress the
flyrecord and latency trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index bfd99b8a..bd838d1d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2092,11 +2092,13 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (HAS_SECTIONS(handle) &&
 	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
 		goto out_free;
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 
 	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
 					  "buffer latency", flags, false);
 
-	copy_file(handle, path);
+	copy_file_compress(handle, path, NULL);
 	if (out_update_section_header(handle, offset))
 		goto out_free;
 
@@ -2199,6 +2201,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
 		goto out_free;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
@@ -2251,14 +2255,15 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		if (data[i].size) {
 			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 				goto out_free;
-			read_size = copy_file_fd(handle, data[i].fd, data[i].size);
+			read_size = out_copy_fd_compress(handle, data[i].fd,
+							 data[i].size, &data_files[i].write_size);
+
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
 				tracecmd_warning("did not match size of %lld to %lld",
 						 read_size, data_files[i].file_size);
 				goto out_free;
 			}
-			data_files[i].write_size = read_size;
 		} else {
 			data_files[i].write_size = 0;
 		}
-- 
2.33.1


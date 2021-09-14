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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF18C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9A8460F38
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhINNSP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNSP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:15 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC196C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:57 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id e26so9255409wmk.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1xeFo4S6vZ7qlDDHpiyWHcYeuT+Npnk8w3qOqgBkQtg=;
        b=kRgQll3y1oZaHKyaDF81iQAFhBZI2m8vZ+CGLNHLS37/ip3uuX0oBH+7RRB/GhckrQ
         r+47ZvLjv80qrGOrwVL4n5ranUev28vVhe1+jH57Ii7TyhrRJ7ctZIfY/vx2PyS9QnTJ
         Z+5rL62lj/+LaqUp/YgWcvfz9eLcDR9w0/vm8yqDtq9HEvxqRrBbzmkve2nn0kfBKZRU
         iBHL3+NEEWUlt4CBI+0KPvctq4GTHVr2+7ghKAr6yIsWg8m+bU3odtGPKm3Tm/gYSJwP
         iFdXWXeKx3yG2++eSBaRau/1slAoeHgkaNI2+yJYlZxAiqOmCsL5TeaOPXwCaE+Z3u87
         4bCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1xeFo4S6vZ7qlDDHpiyWHcYeuT+Npnk8w3qOqgBkQtg=;
        b=2Czm5Kw7OMYln96SvO83XRaHkdCFtu08gG8IdNTCA0ZLW1w+3LiTqHlXG4Gd4rg7aJ
         vXDmewXErJNuIA7Tzn8aw4NvdHJ9EW/12idTvbx/qqJWSuMFMkzngx3zKbCo/TSPt2w+
         5JVnk1T3/ku+6DELy571gJHBelcrA3Dq1PNmfmwe4t9t0Pnb5dPUzfKWzByNwQRXSvt+
         Ssn2WnnKN3o7cFOi3kUVpP8KFGmgqkXsBAu/Qh+BhJIdFAFZzaUE+bhaFUDjx/0/djZe
         KTzzEk6CiT2t4dJCrbo4e+vN+G1xfgCJlTMzfpP5+nd1HXV9ecErSqGyJTpjHlPct4G0
         fDKw==
X-Gm-Message-State: AOAM5320wTiLAADPmLDTANS9CQBS1BgzaS0xGnSU4ZSY6AHsob2c6RVk
        6xxzWzla008KSSEJ6Ik0W8CccJMkZpc=
X-Google-Smtp-Source: ABdhPJztcXsVXWCY3Psnp7mle22us6ulhPfkj+983pTj3h3N6oscejfharTVFHHji70zZjqZ9cTDZw==
X-Received: by 2002:a1c:9d4e:: with SMTP id g75mr2203595wme.20.1631625416319;
        Tue, 14 Sep 2021 06:16:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 09/20] trace-cmd library: Compress the trace data
Date:   Tue, 14 Sep 2021 16:16:34 +0300
Message-Id: <20210914131645.3966308-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index 3fafdb1f..33fb812b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2086,11 +2086,13 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
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
 
@@ -2191,6 +2193,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
 		goto out_free;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
@@ -2236,14 +2240,15 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
2.31.1


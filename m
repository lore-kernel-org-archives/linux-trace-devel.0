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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9761C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF66160C51
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhINNSO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNSO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:14 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3973C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:56 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d21so12469014wra.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ga6slhVdV+CGvPHwW+wkYug19e5c110ATjll1l/h8/I=;
        b=S0/zmU2gawfVRUcRRsk1y5NURhR5vwXKpEa8vf9g7PeX93fjFlepcL08lORvxe5jW+
         5N7QdD7W76omtuoUKEVlDV5e1NxmmeXIBJeAupow5x8qPAUqe+5ZmjxurfuwpoWIe0p1
         MgTPdXsBa8sjCmWdMTgd3waU9+NRcC+m+rO8x46a6baI3iJUPVtVb+XsEHgrw9XhbMi6
         hrkEeJAXlh3JDg8naXA00w0hAYy0cM7Wt9iURhTooZuWobRDk6saINsAu099QqfWibOx
         1l1JCMeWtAi7HvZdR56TQHk0qIYEms+vipibA7R7F22G2rqDogeUYOSuB6mAOyglkJ9+
         PP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ga6slhVdV+CGvPHwW+wkYug19e5c110ATjll1l/h8/I=;
        b=PdNwTmSEKHfbD6xJHSsXDbA11RdB0wb4BI/AVbhT1gFhoitO6lewG+IPAmhtQw0lmO
         G3ahvaIomcoYpGL3QGq0ErCR3bjBDTKTV4g4wBeZMahNBaao41jDGxFqNpOW+oq3zwv7
         t7bRcqEgVG2N9Xjk9xsqG8UvxbZojRwRiwidwQrssqJsM+EQ5aUgJA5AI11gmx0tRF9p
         Z8G2OOKH5Gr4u9KDQWxmhoZFig8vXiA1ka6F9Z/ShYlXSNjutIGlAeZAlXL3Zn3Kqe6a
         vt/gLzyEidhIhkK9kNwJw0/SppeX70VaqDc7u9SmbFnh793Hg/NgvpMozRYVpWluiQSX
         K1Ew==
X-Gm-Message-State: AOAM531EE6FhEgtH+41ATvcP5+UofTdR1hAEsGOl7Rvkw+cDZxQnLRId
        qAkjNpKkAjnET+oyastAWFaq7agAUNs=
X-Google-Smtp-Source: ABdhPJxexdSJWNgcbbSiN4qE7JmbSgNo6Wol3STYw4+tuVODF045MuaVENN2YiY4FsBojr0mrw+TLA==
X-Received: by 2002:a5d:66d1:: with SMTP id k17mr14330432wrw.200.1631625415312;
        Tue, 14 Sep 2021 06:16:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 08/20] trace-cmd library: Add local helper function for data compression
Date:   Tue, 14 Sep 2021 16:16:33 +0300
Message-Id: <20210914131645.3966308-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly added helper functions read data from a file and compress it,
before writing into the trace file. The trace data is compressed in
chunks, which are page aligned. A new local define is introduced:
  PAGES_IN_CHUNK
which can be used to tune how big a compression chunk is.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 71 +++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 9c80042f..3fafdb1f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -283,18 +283,27 @@ static unsigned long get_size(const char *file)
 	return size;
 }
 
-static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd)
+static tsize_t copy_file_fd(struct tracecmd_output *handle, int fd, unsigned long long max)
 {
+	tsize_t rsize = BUFSIZ;
 	tsize_t size = 0;
 	char buf[BUFSIZ];
 	stsize_t r;
 
 	do {
-		r = read(fd, buf, BUFSIZ);
+		if (max && rsize > max)
+			rsize = max;
+
+		r = read(fd, buf, rsize);
 		if (r > 0) {
 			size += r;
 			if (do_write_check(handle, buf, r))
 				return 0;
+			if (max) {
+				max -= r;
+				if (!max)
+					break;
+			}
 		}
 	} while (r > 0);
 
@@ -312,12 +321,62 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 		tracecmd_warning("Can't read '%s'", file);
 		return 0;
 	}
-	size = copy_file_fd(handle, fd);
+	size = copy_file_fd(handle, fd, 0);
 	close(fd);
 
 	return size;
 }
 
+#define PAGES_IN_CHUNK 10
+__hidden unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
+						 int fd, unsigned long long max,
+						 unsigned long long *write_size)
+{
+	unsigned long long rsize = 0;
+	unsigned long long wsize = 0;
+	unsigned long long size;
+	int ret;
+
+	if (handle->compress) {
+		rsize = max;
+		ret = tracecmd_compress_copy_from(handle->compress, fd,
+						  PAGES_IN_CHUNK * handle->page_size,
+						  &rsize, &wsize);
+		if (ret < 0)
+			return 0;
+
+		size = rsize;
+		if (write_size)
+			*write_size = wsize;
+	} else {
+		size = copy_file_fd(handle, fd, max);
+		if (write_size)
+			*write_size = size;
+	}
+
+	return size;
+}
+
+static tsize_t copy_file_compress(struct tracecmd_output *handle,
+				  const char *file, unsigned long long *write_size)
+{
+	int ret;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		tracecmd_warning("Can't read '%s'", file);
+		return 0;
+	}
+
+	ret = out_copy_fd_compress(handle, fd, 0, write_size);
+	if (!ret)
+		tracecmd_warning("Can't compress '%s'", file);
+
+	close(fd);
+	return ret;
+}
+
 /*
  * Finds the path to the debugfs/tracing
  * Allocates the string and stores it.
@@ -513,7 +572,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
@@ -539,7 +598,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
 		goto out_close;
-	check_size = copy_file_fd(handle, fd);
+	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s'", path);
@@ -2177,7 +2236,7 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		if (data[i].size) {
 			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 				goto out_free;
-			read_size = copy_file_fd(handle, data[i].fd);
+			read_size = copy_file_fd(handle, data[i].fd, data[i].size);
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
 				tracecmd_warning("did not match size of %lld to %lld",
-- 
2.31.1


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39B3C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8908B611AB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhETDVv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhETDVv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:51 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D53C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l1so22955244ejb.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eOA7n18lW1M1FakMU6/vCmTAO3qDfgKSz00bVksdClA=;
        b=h9O/7iQPFiMN1Jw00q4T0jDbwojvpHfzAsxlDntxtCFs84e1zrMtNIKvGyxdsOBFS+
         xfc8+e7IGdrok1wasiKK4IES9TgRBwK/4JNQfgBLiGGibjTz7eyduk27Iz4Pk7GBNiwH
         owyjm55NS3wjYBRBZ07mxOBnEMXTc/emQi+qL4rwtSUUwwoItI47KqfSDfw96DdlHNBC
         BRT1lk/o81+eK2SluObIVAoznDTIw5H3WYWTaOy989R3D8sp0vYprEnGcDAupctNAk40
         HIYMuQkLRULyZhUt4+ZVdsVpf8iHB3ydlzgUHbWEhDwqKrWZmbaIAruLVGCmNPC1hOum
         G7Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eOA7n18lW1M1FakMU6/vCmTAO3qDfgKSz00bVksdClA=;
        b=KITTeWpKupbJsuvUJkAy7AgmP0FRg6dPu9ut4BFt2nXLC5xIWBZ6MJnNrhCdLqOP1W
         4jGYX8yWMWQ0m7yzTbL7W5bdUZMI1MloTSJdqueV3boZmcZHtsy4QoMC1V+ql/2NFlE1
         AVS78TYQvRaHXU8a7XDGQ9lM8eiIDBzIXFqeRMTfTCS+HBHXbKy9nqDpDv0xqXDd/IHN
         G0bqItQFbQTPNQBKHzTFiybedNnIVfBKqO2CdWwvo0f3MdMH+BwAECif+wwpAOPwU6fp
         R69njRBmuVJaE4JPeDuMaG44s+TPrcDCZ1OPacsZjHfTSv9ODKyUrSMHgTxLP0McirAF
         dr6w==
X-Gm-Message-State: AOAM533DnM64mP04G7Ew0vUG+KGtzdImA/u/jDi97XWIwG3kJGYrk8zN
        pqDg+4r9QRioBRersKTcT5Q=
X-Google-Smtp-Source: ABdhPJzbS4IahR8udAd1DZSOPnQMvvPfwwbXJjRuXHy1+XfHDTfWsNMH58MpW6E4F42wGqYxbVCSnQ==
X-Received: by 2002:a17:906:606:: with SMTP id s6mr2448293ejb.206.1621480828358;
        Wed, 19 May 2021 20:20:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 24/29] trace-cmd: Compress trace data
Date:   Thu, 20 May 2021 06:19:54 +0300
Message-Id: <20210520031959.346165-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When creating a trace.dat file of version 7, compress the trace data.
The data is compressed in chunks. The chunk size is a compile time
parameter, set by default to 1MB.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 50 +++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 046fa2d7..dbc956d4 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -321,6 +321,41 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 	return size;
 }
 
+#define COMPRESS_CHUNK_SIZE (1*1024*1024)
+static tsize_t copy_file_compress(struct tracecmd_output *handle,
+				  const char *file, unsigned long long *write_size)
+{
+	unsigned long long rsize = 0;
+	unsigned long long wsize = 0;
+	tsize_t size;
+	int ret;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		tracecmd_warning("Can't read '%s'", file);
+		return 0;
+	}
+
+	if (handle->file_version >= 7) {
+		ret = tracecmd_compress_copy_from(handle->compress, fd,
+						  COMPRESS_CHUNK_SIZE, &rsize, &wsize);
+		if (ret < 0) {
+			tracecmd_warning("Can't compress '%s'", file);
+			close(fd);
+			return 0;
+		}
+		size = rsize;
+		*write_size = wsize;
+	} else {
+		size = copy_file_fd(handle, fd);
+		*write_size = size;
+	}
+
+	close(fd);
+	return size;
+}
+
 /*
  * Finds the path to the debugfs/tracing
  * Allocates the string and stores it.
@@ -1685,8 +1720,9 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	struct data_file_write *data_files = NULL;
 	off64_t offset;
 	unsigned long long endian8;
+	unsigned long long read_size;
+	unsigned long long write_size;
 	char *clock = NULL;
-	off64_t check_size;
 	char *file;
 	struct stat st;
 	int ret;
@@ -1742,11 +1778,11 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
 				i, (unsigned long long) data_files[i].data_offset);
 
-		check_size = copy_file(handle, cpu_data_files[i]);
-		if (check_size != data_files[i].file_size) {
+		read_size = copy_file_compress(handle, cpu_data_files[i], &write_size);
+		if (read_size != data_files[i].file_size) {
 			errno = EINVAL;
 			tracecmd_warning("did not match size of %lld to %lld",
-					 check_size, data_files[i].file_size);
+					 read_size, data_files[i].file_size);
 			goto out_free;
 		}
 		/* Write the real CPU data offset inthe file */
@@ -1756,14 +1792,14 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			goto out_free;
 		/* Write the real CPU data size in the file */
 		offset = lseek64(handle->fd, data_files[i].soffset, SEEK_SET);
-		endian8 = convert_endian_8(handle, check_size);
+		endian8 = convert_endian_8(handle, write_size);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
-		offset = data_files[i].data_offset + check_size;
+		offset = data_files[i].data_offset + write_size;
 		offset = lseek64(handle->fd, offset, SEEK_SET);
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "    %llu bytes in size\n",
-				(unsigned long long)check_size);
+				(unsigned long long)write_size);
 	}
 
 	if (lseek64(handle->fd, 0, SEEK_END) == (off64_t)-1)
-- 
2.31.1


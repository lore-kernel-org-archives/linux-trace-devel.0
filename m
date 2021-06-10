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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D26BC48BD1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 464DE613FF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhFJLiC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:38:02 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:54861 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhFJLiC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:38:02 -0400
Received: by mail-wm1-f43.google.com with SMTP id m3so742688wms.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NEhPGyloHjAqC5x3xEBshV9EuN0/dWE1r+Si3CUPt1k=;
        b=G30HsMaMMu4EvvDPCSKlOjil0xwynpFrQY0QC5dD3Xc6YAfuAdll07bGvPFKY+XbOK
         DD5ccjZxAqhf8Akm6JrvFYPNRf8rmIYN+588ohHORL4TrGggjeeSK4DkRGgA65vOZVmH
         WCas7pfbg4sfB3uL1UV0q75hYdYVl/oUPY/v3c0zGhMx6SLbwqH9WYV8yLMYvTfXuwuO
         VKy5JePMbM+nFmQGMGY64rSgoGjEUK75xrI1u4k9nyADfbCPz3j3ApE0/w3sCGd6Kecv
         AbzB140R03d21R8LYbBy2/EXjAqTV+7z1eYKEuVLBQLN+8JHpHCXDsDr5wYPS+Z7TzvT
         LS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NEhPGyloHjAqC5x3xEBshV9EuN0/dWE1r+Si3CUPt1k=;
        b=JW1ue03ZiCQzlBW/+70pVhauqihbrTAzMrDo/L3PQVhY11oEprT/1Aj/WnunakKaWM
         OD3glMJWGJSk+h+3I1V4/99gz3xDnhoQ8ukxDFw0wvuqsGv1A1JG3eMBkFBXUanl5IA0
         by1EtXvcY+/vICoG2zS066Ndmm33cH0YIKgUfVD7m20Q4CfmlpWXljGQFLNQAjNPEAYA
         LhyycXs4neMB5L/ENeMgKya4sHtorSOxUXvma/vDXeEvz8FXRPbKhRc4WcccJmHJZfU8
         1/ed+L9hA8gAT77MplDrynUtfmHKSGDpMngLj0WRZSsB+TEnMEBL2yjHqRI/z5MLlJJ0
         xlLg==
X-Gm-Message-State: AOAM533jwH2mT8Cxnd4cO91m1kCG7nv3v+hABj3ifY5s+oqVIhCWvkey
        vspSfhUGf1fsqY5w5lodfA8=
X-Google-Smtp-Source: ABdhPJxZ+OuofO5t6Y9LFrzV7NKcqqyRoI+wkaCVybS84KhOpk8TMqa++aNpoNKhhoKbQ8JzOb4r6Q==
X-Received: by 2002:a1c:e91a:: with SMTP id q26mr14748660wmc.170.1623324890838;
        Thu, 10 Jun 2021 04:34:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 24/40] trace-cmd: Compress trace data
Date:   Thu, 10 Jun 2021 14:34:10 +0300
Message-Id: <20210610113426.257931-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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
index 860be759..bd14452a 100644
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
@@ -1692,8 +1727,9 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
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
@@ -1749,11 +1785,11 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
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
@@ -1763,14 +1799,14 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
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


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9523C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C2C3613BA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhELGkE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhELGj5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:57 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBB9C06175F
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:49 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id s6so25663169edu.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g1oiBlQjU7BXkc4N3aSbi+iGHH5sqHO8pTrGqpp+wn4=;
        b=AJNHMYNj6SjaLClRrFMdzZAMHIMIJUySmbAi5teAQ2R1HqZyIrl5HHHE1YYKMA1Bhc
         KaBcRqsgOYKdKjrN0Ex/9QEvYqHpgRu4436d5FWfMX3soYeO6cv2+PGOITNjedGbaLnW
         SsihucLzOa3fLZYxENpvHg0AUHIqRHVnfNr5qLV1YeQ8r7efooZNYD2qys/24uNyyRvE
         Jg5kh8juSSzHizvjSxe7KsKd7V8pCh+xpC61krdp9wDczyIqF+MDJk6nVPostX5F37zT
         DR8BB18tMt6g5vBVdnsRyVuIYRtpLwfdXXot5wi+IUc2qZXmFsxPoUGWh4C6TaNa9gIk
         ycMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g1oiBlQjU7BXkc4N3aSbi+iGHH5sqHO8pTrGqpp+wn4=;
        b=FV7zT/PLlXAWIqdSsosWyZGfn4ybyZewrFr+T9hzVXkVhRm0qzAqEnYu52abwoaGBE
         YKe7JbAMfZ9x9dNL9TIiSKsxraPh1BR14zifN87UYRQSGVKH+a6/LDsbiHlLMVseNyoi
         RpPX+JCIu/3onCNp98vNffHs6+Ik4wIRp9uUc1OEdiIkCTHLHZICOW+jbTcR9/t1evzL
         F+Gn2tBaWo20SH4nWk20WKKicbtcibgAE49P/VSK9/AMR/Fvsj1RNqMHo1/f+VKakWcu
         SyPOABUmEmVfThTbJPRZ28Okg8MfF+mwa0hwI5NPVSK6fQ8IIEBIf8pOBSOk5JMnBc7R
         WmvA==
X-Gm-Message-State: AOAM532fEdlfZ9z+iilenyUuYDcfyYL/vKr8nd/FZRms9+tJU4S4tAI3
        1TGebDk1J7sway95kSNBoQZ+siq/uOUImQ==
X-Google-Smtp-Source: ABdhPJyelqriB4FTDthOVM5+ZgM5mKZPva1Iky8GK3Gk3FcBfy5kN4OJxoV8f9bf6BgIlkZcIxon8w==
X-Received: by 2002:a05:6402:750:: with SMTP id p16mr41157019edy.156.1620801527988;
        Tue, 11 May 2021 23:38:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 24/25] trace-cmd: Compress trace data
Date:   Wed, 12 May 2021 09:38:22 +0300
Message-Id: <20210512063823.324610-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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
index 08d05744..fab01f56 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -320,6 +320,41 @@ static tsize_t copy_file(struct tracecmd_output *handle,
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
@@ -1684,8 +1719,9 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
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
@@ -1743,11 +1779,11 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
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
@@ -1757,14 +1793,14 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
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


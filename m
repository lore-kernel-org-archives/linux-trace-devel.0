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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DEFC48BE8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28C6861352
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbhFNHx7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:59 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:37793 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbhFNHx6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:58 -0400
Received: by mail-ed1-f49.google.com with SMTP id b11so45215626edy.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cJCBtvbxRLcQPMRtRDEoPrHPiqKGSweLWU23nOhOF0E=;
        b=W0a8jbbQnLU0RVCaot6H+6NzXogfKOUV4upnHkl0KipRyuJzxTEDC3/CIVN0rAdxSW
         Dv2MAsqXyr6WVtwRyKWW+yBqX2YOjdWC9khJB9kmUDi9nAioBqI9Gr5BzxkYIO1T7iy6
         gpbZh5/bbGOf4q+l1oCkKWeB2QKdHASBSVMgiX30PodpPHGBZBXghI6hJ/xt5u+w/2HM
         IWgaPiXRPQyhTgw/I77o8gb477nYu2qIwGzz13ifBC5YlnEYfbeGp6POC5dYgXIDfVQg
         5Zxz/qFkqOdsmHXGcPw8nimiPF/hNrmDy5LHUVlDHCE+o2yd8s4CmVmSMxoTpfzQEs1t
         5Mzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cJCBtvbxRLcQPMRtRDEoPrHPiqKGSweLWU23nOhOF0E=;
        b=iMtiTDTG0lj0Wyo3MK0+nJ/GSzOzt6fK6FHk10lJ1+kRcMneKUxW72btFioVi5luT9
         tjTa2hWeMDJyQcIxX2yHHMATUePB4J0/oLEPB1iqqBIAjdbqTfQ6QvTibP7M50ytba7q
         tXQpj7RhDabWPxdnLD/CRV168jMvevljmclYJMIlmI/3kSWNHVVmrHAJGA7LxIBod68s
         f6jBt9XdCr/2Oxktf5Dh+8gwBWfMqRibF2ZgXdk4vZ3FQh/DdcElr5FHBQYEE+ZLz7hs
         ARPqKLEzo7QN2AcTx05aSV+xrAJH+hrumdaob6ihU1KMU3NdukkJhjKBKC+S+fZyx+6M
         W29A==
X-Gm-Message-State: AOAM531SVwyJCQP9Cs5dTc6bSIrXmBTmhmrX/8PeOc61Dl7qd9aDRulh
        oPJ4APTQt5Yb0p736DK8yraqpIBa9AZpiQ==
X-Google-Smtp-Source: ABdhPJzCtXsJGQsxWF7qc7wPTrdhzU3UkWtrBVQ7w/X5t9mbHwvMfEB7YGCEbJVr+bSPe717LKWsQw==
X-Received: by 2002:a05:6402:1c11:: with SMTP id ck17mr16273132edb.102.1623657055044;
        Mon, 14 Jun 2021 00:50:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 24/45] trace-cmd: Compress trace data
Date:   Mon, 14 Jun 2021 10:50:08 +0300
Message-Id: <20210614075029.598048-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
index ed4ef638..20a646af 100644
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


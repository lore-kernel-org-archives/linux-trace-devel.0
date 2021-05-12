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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BEEC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC2B8613B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhELGj4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhELGj4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:56 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC6EC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:47 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id u13so25710546edd.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VBejlyIMKlFLT2t7QvD/+a7jOXPgFEcU9SQMoSVZ4vs=;
        b=PeACu3we6HkiNCHKj+7Yr+zlOxv2TRXbL4tpJoA6uNQbrUmKCNCAcVNadtEWUvm9LR
         jWaxRiJasyeAPqmeHpIRDDejtLHvCh37pfL0c3R5VlIZA7J246lA3zfUbXF3oTm6GcmC
         9qwi0KrNF6CDFb+f+GWdk5m2mjSwY0YV4mb8nl+ynp1c066kalNQlJEYkgWoRGG38x2e
         TAVktuplpTpER3m4EP2MjNKPhSMO0UDJnAxtNI5KOPA/gothTk/iWLaOMj0DNOmUsTBc
         aObqX7I418f9WR4N3SMq2Iu5kERMO41q3h9uooFSMyHBBUDnWezA9CjRkohFUjktrNRQ
         RlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VBejlyIMKlFLT2t7QvD/+a7jOXPgFEcU9SQMoSVZ4vs=;
        b=drv6WTIg7wk3ciA1+fuyT4kBIaTBpbxUNcSLUBS2FxH/+nWyTMHaKZG4hTg/afE4o1
         RnraYqj1tSxj1IbuC3BpY6qukwguxnSxMg+MMtQFcgW8F0n3lc2SHEZ5sM0oITfrCqZp
         SDooyUNZmqpainHBuR18jHRfSut/vEDpvU2XROM0+lTPAtFx9fhViUIwdH2BCmdR5hmA
         G3ncbG8IpEshNA5o2Mw5Yh6/AzcY4BRPKPp6hJWvNJ9ZFSQF69B2JsEGsXEl8VHSv9eQ
         3U4oqYly7XzZWdd8YyTaN6tLSpJ79q40FixQqQTNMbZVQNh5rISm9Ue+RHHoai4yiz4w
         3qtw==
X-Gm-Message-State: AOAM531dG3LbYNxD4u7oFchOPF1z6WJ1Z809zhZFAWZbNyNO5eJXrKDT
        NGY1IfAYs0diJhyRErlNFYrr4pUh9FDAiw==
X-Google-Smtp-Source: ABdhPJzyceX3tr/uLhZJCpsDcnI5rYbjUcLtPLrp7YCwlJu1hfMrEE0bexQvzVXAOxnDaejjY+O4UA==
X-Received: by 2002:aa7:c9cb:: with SMTP id i11mr41728473edt.331.1620801526329;
        Tue, 11 May 2021 23:38:46 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 22/25] trace-cmd library: Refactor the logic for writing trace data in the file
Date:   Wed, 12 May 2021 09:38:20 +0300
Message-Id: <20210512063823.324610-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Refactored the internal logic of tracecmd_write_cpu_data() API to be
suitable for adding trace data compression.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 97 +++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 51 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index ca115872..08d05744 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -155,8 +155,7 @@ static int uncompress_block(struct tracecmd_output *handle)
 	int ret = 0;
 
 	if (handle->file_version < 7 || !handle->compress)
-		return 0;
-	ret = tracecmd_uncompress_block(handle->compress);
+		return 0;	ret = tracecmd_uncompress_block(handle->compress);
 	if (!ret)
 		handle->do_compress = true;
 	return ret;
@@ -1672,11 +1671,17 @@ static char *get_clock(struct tracecmd_output *handle)
 	return handle->trace_clock;
 }
 
+struct data_file_write {
+	int file_size;
+	off64_t soffset;
+	off64_t data_offset;
+	off64_t doffset;
+};
+
 int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			    int cpus, char * const *cpu_data_files)
 {
-	off64_t *offsets = NULL;
-	unsigned long long *sizes = NULL;
+	struct data_file_write *data_files = NULL;
 	off64_t offset;
 	unsigned long long endian8;
 	char *clock = NULL;
@@ -1698,37 +1703,11 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	if (do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
-	offsets = malloc(sizeof(*offsets) * cpus);
-	if (!offsets)
-		goto out_free;
-	sizes = malloc(sizeof(*sizes) * cpus);
-	if (!sizes)
-		goto out_free;
-
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	/* hold any extra data for data */
-	offset += cpus * (16);
-
-	/*
-	 * Unfortunately, the trace_clock data was placed after the
-	 * cpu data, and wasn't accounted for with the offsets.
-	 * We need to save room for the trace_clock file. This means
-	 * we need to find the size of it before we define the final
-	 * offsets.
-	 */
-	clock = get_clock(handle);
-	if (!clock)
+	data_files = calloc(cpus, sizeof(struct data_file_write));
+	if (!data_files)
 		goto out_free;
-	/* Save room for storing the size */
-	offset += 8;
-	offset += strlen(clock);
-	/* 2 bytes for [] around the clock */
-	offset += 2;
-
-	/* Page align offset */
-	offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
 
+	/* Write 0 for trace data offset and size and store offsets of these fields */
 	for (i = 0; i < cpus; i++) {
 		file = cpu_data_files[i];
 		ret = stat(file, &st);
@@ -1736,53 +1715,69 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			tracecmd_warning("can not stat '%s'", file);
 			goto out_free;
 		}
-		offsets[i] = offset;
-		sizes[i] = st.st_size;
-		offset += st.st_size;
-		offset = (offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
+		data_files[i].file_size = st.st_size;
 
-		endian8 = convert_endian_8(handle, offsets[i]);
+		endian8 = 0;
+		data_files[i].doffset = lseek64(handle->fd, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
-		endian8 = convert_endian_8(handle, sizes[i]);
+		data_files[i].soffset = lseek64(handle->fd, 0, SEEK_CUR);
 		if (do_write_check(handle, &endian8, 8))
 			goto out_free;
 	}
 
+	clock = get_clock(handle);
+	if (!clock)
+		goto out_free;
 	if (save_clock(handle, clock))
 		goto out_free;
 
 	for (i = 0; i < cpus; i++) {
+		data_files[i].data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+		/* Page align offset */
+		data_files[i].data_offset = (data_files[i].data_offset + (handle->page_size - 1)) & ~(handle->page_size - 1);
+		data_files[i].data_offset = lseek64(handle->fd, data_files[i].data_offset, SEEK_SET);
+		if (data_files[i].data_offset == (off64_t)-1)
+			goto out_free;
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
-				i, (unsigned long long) offsets[i]);
-		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
-		if (offset == (off64_t)-1) {
-			tracecmd_warning("could not seek to %lld\n", offsets[i]);
-			goto out_free;
-		}
+				i, (unsigned long long) data_files[i].data_offset);
+
 		check_size = copy_file(handle, cpu_data_files[i]);
-		if (check_size != sizes[i]) {
+		if (check_size != data_files[i].file_size) {
 			errno = EINVAL;
 			tracecmd_warning("did not match size of %lld to %lld",
-					 check_size, sizes[i]);
+					 check_size, data_files[i].file_size);
 			goto out_free;
 		}
+		/* Write the real CPU data offset inthe file */
+		offset = lseek64(handle->fd, data_files[i].doffset, SEEK_SET);
+		endian8 = convert_endian_8(handle, data_files[i].data_offset);
+		if (do_write_check(handle, &endian8, 8))
+			goto out_free;
+		/* Write the real CPU data size in the file */
+		offset = lseek64(handle->fd, data_files[i].soffset, SEEK_SET);
+		endian8 = convert_endian_8(handle, check_size);
+		if (do_write_check(handle, &endian8, 8))
+			goto out_free;
+		offset = data_files[i].data_offset + check_size;
+		offset = lseek64(handle->fd, offset, SEEK_SET);
 		if (!tracecmd_get_quiet(handle))
 			fprintf(stderr, "    %llu bytes in size\n",
 				(unsigned long long)check_size);
 	}
 
-	free(offsets);
-	free(sizes);
+	if (lseek64(handle->fd, 0, SEEK_END) == (off64_t)-1)
+		goto out_free;
 
+	free(data_files);
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
 	return 0;
 
  out_free:
-	free(offsets);
-	free(sizes);
+	lseek64(handle->fd, 0, SEEK_END);
+	free(data_files);
 	return -1;
 }
 
-- 
2.31.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF408C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346842AbhLBM0C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358228AbhLBMZW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:22 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59A1C06175B
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:21:59 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id v1so115057065edx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QehmBWhPFbnCI3aPwLEUMwj3cuTfD4pUXZbIxzH99K4=;
        b=AekmHj+dfO9eF1ioFTYmvFJ2AzudXGYeJ/LJSeqIfE7g2y6ZalOCNzpRyAFhCbyyJv
         EeVQqT1+foEpxLciJN+YzA15R3O5ECMN5M6ekcgjjTky5SKDoIyQcOyXcudKK1hJzSkS
         WY5uGr8djT5810xAXXxOjeCn/1xUUpeYOJgFYrnb/NzqdllwlsRhJdZks900+QxT0mEw
         LQiEKFaNRCM2Oe2SY+nHy4TFsB9JXy+7HUefEm5oZvgVGK15urVYVTCS5tLy2PllA8Jm
         lWw5C1pVLn3UXTC8miZuqjmRPakqbQYmo0l9rzArMut39arVu1wN7KPgi51Xui0JlL4S
         KUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QehmBWhPFbnCI3aPwLEUMwj3cuTfD4pUXZbIxzH99K4=;
        b=t0+9X8ZYByh/IbIzARCUGKeMtDERADcc7pPPlXboMLytaTDDqbeWkmmsQNAJPaS4UM
         1nBFW27RBFcl94nhr8kwIN/ZTQGBYscan/umpMw3M+JHgIO1bKt6GfJIXN1aMhOFNZf8
         F0fK9dPfj3n5ccaN0DmaD8hnnlay4GTB75bJYpl3ITfTDHzLX1D1fRz1mETWrjgv48Ov
         2S2nFKK13B62+Ps7BfG6TqfKk12E2ZqMD+pXe04TDiVhRG7uxf3plOxuxEvy9fMeOhNO
         6N7njufsInMpIRieTGvH5O603sLrkWS2KqsjeJAESpf+YUuSCx10ouox8oANLfcmXolL
         niBQ==
X-Gm-Message-State: AOAM530p5rAD9wWKc39rbzMCNBFGJAcfVs57bzwHJdZKVeKfYPecqbxX
        x7NJXNSQyp9ZOQ8g1lPnaN++SoC3v9sVzg==
X-Google-Smtp-Source: ABdhPJyNpRfUBu0MNyNIdF43rUUDaq0VZxed+uF0ZcWXDiI7ylRpS7nMuSPHllbbwvVl0LhVz9P22Q==
X-Received: by 2002:a17:906:9753:: with SMTP id o19mr15220159ejy.243.1638447718436;
        Thu, 02 Dec 2021 04:21:58 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:21:57 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 04/23] trace-cmd library: Add internal helper function for writing headers before file sections
Date:   Thu,  2 Dec 2021 14:21:33 +0200
Message-Id: <20211202122152.43275-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce headers before each file section, in trace file version 7. The
section header has the following format:
 <2 bytes>, header ID
 <string>, null terminated ASCII string, description of the header
 <2 bytes>, section flags:
     1: the section is compressed
 <4 bytes>, size of the section

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h                 |  5 ++
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/include/trace-cmd-local.h       |  5 ++
 lib/trace-cmd/trace-output.c                  | 68 +++++++++++++++++++
 4 files changed, 79 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 7fea4e01..5d71e8ba 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -15,6 +15,11 @@ enum tracecmd_open_flags {
 	TRACECMD_FL_LOAD_NO_PLUGINS		= 1 << 0, /* Do not load plugins */
 	TRACECMD_FL_LOAD_NO_SYSTEM_PLUGINS	= 1 << 1, /* Do not load system plugins */
 };
+
+enum tracecmd_section_flags {
+	TRACECMD_SEC_FL_COMPRESS	= 1 << 0, /* the section is compressed */
+};
+
 struct tracecmd_input *tracecmd_open_head(const char *file, int flags);
 struct tracecmd_input *tracecmd_open(const char *file, int flags);
 struct tracecmd_input *tracecmd_open_fd(int fd, int flags);
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ed25d879..15e53740 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -138,6 +138,7 @@ enum {
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
 	TRACECMD_OPTION_TSC2NSEC,
+	TRACECMD_OPTION_MAX,
 };
 
 enum {
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 7f280533..4a0a691c 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -39,6 +39,11 @@ struct data_file_write {
 bool check_file_state(unsigned long file_version, int current_state, int new_state);
 bool check_out_state(struct tracecmd_output *handle, int new_state);
 
+unsigned long long
+out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
+			 char *description, int flags, bool option);
+int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset);
+
 struct cpu_data_source {
 	int fd;
 	int size;
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 4d165ac2..f502b354 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -332,6 +332,74 @@ int tracecmd_ftrace_enable(int set)
 	return ret;
 }
 
+__hidden unsigned long long
+out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
+			 char *description, int flags, bool option)
+{
+	tsize_t endian8;
+	tsize_t offset;
+	short endian2;
+	int size;
+
+	if (header_id >= TRACECMD_OPTION_MAX)
+		return -1;
+	if (!HAS_SECTIONS(handle))
+		return 0;
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	if (option) {
+		endian8 = convert_endian_8(handle, offset);
+		if (!tracecmd_add_option(handle, header_id, 8, &endian8))
+			return -1;
+	}
+	/* Section ID */
+	endian2 = convert_endian_2(handle, header_id);
+	if (do_write_check(handle, &endian2, 2))
+		return (off_t)-1;
+
+	/* Section description */
+	if (do_write_check(handle, description, strlen(description) + 1))
+		return (off_t)-1;
+	/* Section flags */
+	endian2 = convert_endian_2(handle, flags);
+	if (do_write_check(handle, &endian2, 2))
+		return (off_t)-1;
+
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	size = 0;
+	/* Reserve for section size */
+	if (do_write_check(handle, &size, 4))
+		return (off_t)-1;
+	return offset;
+}
+
+__hidden int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset)
+{
+	unsigned long long current;
+	unsigned int endian4;
+	int size;
+
+	if (!HAS_SECTIONS(handle) || offset == 0)
+		return 0;
+
+	current = do_lseek(handle, 0, SEEK_CUR);
+	/* The real size is the difference between the saved offset and
+	 * the current offset - 4 bytes, the reserved space for the section size.
+	 */
+	size = current - offset;
+	if (size < 4)
+		return -1;
+	size -= 4;
+	if (do_lseek(handle, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	endian4 = convert_endian_4(handle, size);
+	if (do_write_check(handle, &endian4, 4))
+		return -1;
+	if (do_lseek(handle, current, SEEK_SET) == (off_t)-1)
+		return -1;
+	return 0;
+}
+
 static int read_header_files(struct tracecmd_output *handle)
 {
 	tsize_t size, check_size, endian8;
-- 
2.33.1


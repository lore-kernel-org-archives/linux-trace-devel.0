Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCD3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352348AbiASIZR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352370AbiASIZR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:17 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7C9C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:16 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c71so7587694edf.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6fNTUIWdW75sP4ix2ktwJ53a4hbge6GLMCdTHFHxVQ=;
        b=h7xFh9/eYcDj1sf9hQThEpDg9fEd4Z5PIAH04ONzks34en9+7Ql4ntMiTXhb5sEaV3
         1n3KDIC0oHh98R7tyAZsMgp8Nxo9vov8XJmkob/VplpkuMA2gZkVbJ+9UVT3oxREt3Wd
         rrAtg+lzVAeZ7TKerZB7KjzhASWW3XBpmmPxhz7FEXFNZ8E9mNInO023X5fp4iURHZM+
         cTbgfs8ElC5P0xPkWqe7DaJicfe0p96O8h0dB+qEEm7hJ53cO6BR9qPUulK2r+HKR5XB
         zYyi39mqmsXllAfdOIa1yk9o0geg9Jw5QRhfYNotHeiu8VixrTjzeW7sXdvgFji2dIKM
         UU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6fNTUIWdW75sP4ix2ktwJ53a4hbge6GLMCdTHFHxVQ=;
        b=hcNF9fyPik1eFbo6iassHOeJEVktO24v/ql9eO/1tmaZI6nNru78WYOu76AJRLlxt+
         gy1jatBUA1+um0YTCzP5oCuqTxDfnDZ+1AJpCsSFI0abWIzdzEpCMlg2QkxTVGlxZIbF
         28dYJD6Vglq+9CpjXcOfs5rHlqC+WoLyLkBav/Jvyf5CNqax1bOkb7GB1jnqSvXQ8iMR
         4nae7qU7/Z5sGCgmKaMQMWXksFbi7ppldzm4Tc9vjEcD2txpqz22h/2JZuUZ71zkHuaW
         P8z9owAJZMVQgzUq2VM+YGkOsfZ13E9vFGiKzjLdjKWIUHcJusNbe154Lozh0RfVWt50
         KqMA==
X-Gm-Message-State: AOAM533DQWOfkJGLwHp07fi8e8PkKkU5DN4efI72O7opDWxTIZ7gzybp
        89iNLUF6rFZjylTtgE0ofz1lrfBM58E=
X-Google-Smtp-Source: ABdhPJzKJ0XZLbkWhZ2Jne6pJEFmCYYw3FSMwzl0RvGjNPltms3XZGp44U/FH6f6n/IIuY3PPf8fDQ==
X-Received: by 2002:a17:906:3103:: with SMTP id 3mr21270767ejx.289.1642580715148;
        Wed, 19 Jan 2022 00:25:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 05/25] trace-cmd library: Add internal helper function for writing headers before file sections
Date:   Wed, 19 Jan 2022 10:24:47 +0200
Message-Id: <20220119082507.245600-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce headers before each file section, in trace file version 7. The
section header has the following format:
 <2 bytes>, header ID
 <2 bytes>, section flags:
     1: the section is compressed
 <4 bytes>, offset within the strings section, where the section
            description string is located.
 <8 bytes>, size of the section

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h                 |  5 ++
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/include/trace-cmd-local.h       |  5 ++
 lib/trace-cmd/trace-output.c                  | 77 ++++++++++++++++++-
 4 files changed, 87 insertions(+), 1 deletion(-)

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
index e1467971..2eb077c8 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -144,6 +144,7 @@ enum {
 	TRACECMD_OPTION_GUEST,
 	TRACECMD_OPTION_TSC2NSEC,
 	TRACECMD_OPTION_STRINGS,
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
index d3c73ceb..e1803dbd 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -365,6 +365,82 @@ int tracecmd_ftrace_enable(int set)
 	return ret;
 }
 
+__hidden unsigned long long
+out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
+			 char *description, int flags, bool option)
+{
+	tsize_t endian8;
+	tsize_t offset;
+	long long size;
+	short endian2;
+	int endian4;
+	int desc;
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
+		return (off64_t)-1;
+
+	/* Section flags */
+	endian2 = convert_endian_2(handle, flags);
+	if (do_write_check(handle, &endian2, 2))
+		return (off64_t)-1;
+
+	/* Section description */
+	if (description)
+		desc = add_string(handle, description);
+	else
+		desc = -1;
+	endian4 = convert_endian_4(handle, desc);
+	if (do_write_check(handle, &endian4, 4))
+		return (off64_t)-1;
+
+	offset = do_lseek(handle, 0, SEEK_CUR);
+	size = 0;
+	/* Reserve for section size */
+	if (do_write_check(handle, &size, 8))
+		return (off64_t)-1;
+	return offset;
+}
+
+__hidden int out_update_section_header(struct tracecmd_output *handle, tsize_t offset)
+{
+	tsize_t current;
+	tsize_t endian8;
+	tsize_t size;
+
+	if (!HAS_SECTIONS(handle) || offset == 0)
+		return 0;
+
+	current = do_lseek(handle, 0, SEEK_CUR);
+	/* The real size is the difference between the saved offset and
+	 * the current offset - 8 bytes, the reserved space for the section size.
+	 */
+	size = current - offset;
+	if (size < 8)
+		return -1;
+	size -= 8;
+	if (do_lseek(handle, offset, SEEK_SET) == (off64_t)-1)
+		return -1;
+
+	endian8 = convert_endian_8(handle, size);
+	if (do_write_check(handle, &endian8, 8))
+		return -1;
+	if (do_lseek(handle, current, SEEK_SET) == (off64_t)-1)
+		return -1;
+	return 0;
+}
+
 static int save_string_section(struct tracecmd_output *handle)
 {
 	if (!handle->strings || !handle->strings_p)
@@ -390,7 +466,6 @@ error:
 	return -1;
 }
 
-
 static int read_header_files(struct tracecmd_output *handle)
 {
 	tsize_t size, check_size, endian8;
-- 
2.34.1


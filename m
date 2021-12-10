Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9A3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbhLJK6b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbhLJK6b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:31 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6F5C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:56 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id e3so29033274edu.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=duEsFbpA//myTvDWkZPu8BlTIWcXguTmFScWEaOmN7I=;
        b=avIKOKzqJMJA0wkeGvViRSE3b8xkf0EnkCUcWEE+11ID/VPZEN59RPTeDNYF5nyZA3
         iR8YxpwSlCUu/3dbJ/U8n0Ts3o/xy9HsDuLSNPJFTUwGDbmohLy2mLS7plFMbePgcheC
         QHbTaqHPMG/rBW1+BEkzsJBgsVHQ3Ii6slNb0YW3FipNm3evPZpP87dmMDj0cOKQUJ+Y
         AfFAxnz/BueH2kAVRv9v2/z8ZVX+q3g1tsUMKJhTSp00GZIIDi7RI4aMgunC3MGHFNuM
         dcTt75mODedzwKIVrpIbNd34Dmtp5jUixcXIOebcAJT9Utv82So2yn5olOnvMkkoFu10
         tmww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=duEsFbpA//myTvDWkZPu8BlTIWcXguTmFScWEaOmN7I=;
        b=edH6+54xtod2X4JGAYi75eZpKnNeeDNGJO4Y+JSuNpqHR+UAj6cRmHfIPbawcJHVaF
         Z+UZEeVPXtrGAXOF+0Cp3n54rje8Ogzh0FfPM+BOvwGAYuNmrPeLUiALnmTyHsaOoR/D
         NdQBtIN8saLSS2U/b6fBhrA4NksDSoZzmAh9U0gmRp2nWSY/WEf9mpgWZnQqFJlEUmrS
         4jFnRN8/lqH7R8UQe/lH95GN8i2PZw50LN14WFQMGw6Hm6llnCvAJuBCRBp9eklADPNt
         gz8aJliuntwxhP8kj6+fEnjiCLnlJNUs/8JgUHk47S/cFrTGpblaMY/6IssviblRl9YP
         ICkg==
X-Gm-Message-State: AOAM533eJ9AUgxcC2veMUbqEUMDesTo1vajs1+fEMu84moEft8f5+nVU
        M/7iZVtWOT4zF8Ibdh4BdNFNaKqV5aw=
X-Google-Smtp-Source: ABdhPJxSRejc8Xrnosn+FsCLI0fz/rGvQEYffyI5n5++PTOCV91waOqlFQFJUbF4eQ/NrUP7VX3Cbw==
X-Received: by 2002:a17:907:6ea1:: with SMTP id sh33mr23599917ejc.150.1639133694956;
        Fri, 10 Dec 2021 02:54:54 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:54:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 05/25] trace-cmd library: Add internal helper function for writing headers before file sections
Date:   Fri, 10 Dec 2021 12:54:28 +0200
Message-Id: <20211210105448.97850-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce headers before each file section, in trace file version 7. The
section header has the following format:
 <2 bytes>, header ID
 <4 bytes>, offset within the strings section, where the section
            description string is located.
 <2 bytes>, section flags:
     1: the section is compressed
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
index ed8fbf11..1584d65a 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -139,6 +139,7 @@ enum {
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
index ed505db6..457da305 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -360,6 +360,82 @@ int tracecmd_ftrace_enable(int set)
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
+	/* Section description */
+	if (description)
+		desc = add_string(handle, description);
+	else
+		desc = -1;
+	endian4 = convert_endian_4(handle, desc);
+	if (do_write_check(handle, &endian4, 4))
+		return (off64_t)-1;
+
+	/* Section flags */
+	endian2 = convert_endian_2(handle, flags);
+	if (do_write_check(handle, &endian2, 2))
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
@@ -385,7 +461,6 @@ error:
 	return -1;
 }
 
-
 static int read_header_files(struct tracecmd_output *handle)
 {
 	tsize_t size, check_size, endian8;
-- 
2.33.1


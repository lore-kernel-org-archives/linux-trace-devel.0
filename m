Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C27C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 694E061090
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbhJHEWB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhJHEWB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:01 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A87FC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:06 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id d9so7362740edh.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xuhmDPnIjxOvYa1K/t1ngIUM7JIrPrj3Tfy9VKh0USc=;
        b=q623+B1AT0kx1rpLZubsIRQS/w86JkOLMyWyWaFP2t8RHFjyOMEE8c6Kl/Fk/LxPnd
         oEW9F4AbUbe0yvPz9yBx9MyptXBGJChP9KzIuKsPBxATd+hEaevS10+nqaOphXHy3QCZ
         FNCYtvrQiupY+VV4Z6ww4a4mzUnFdYpYOCrbc+JWSF9AExJx15FRYCHXKGYR4/OUKl3n
         mL6PurzzmSFPEPglAdBx3sPPmhtd52tyHn3xGeR/6l0gPHuZFbWP2lOFkIEmJJBlqVkT
         vMjPLkLiQ2XDxMzBSSnmOsFsl4Aw3LGwLDr4OI7zyCb3vgkoiWMYw9UHS5yC9nWpeZwH
         mOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xuhmDPnIjxOvYa1K/t1ngIUM7JIrPrj3Tfy9VKh0USc=;
        b=my7GOCXrCvHVNtR3UZ7hzaHv7I/Ircq2sjqjZbV7BZ5YqumxZkHER6d1nU+Z9Kq6sU
         nQt4mn8Kx1gr7FmBRn35UIjIbZegC/Trf6frFWW3zfQorCaHM2vbmelP/PRUjAagp3l6
         ly0bCSJP3fIDbwiKSIMlXScZo/wb3N3i69T7vK05w9ZQQcoe253s9xo8EWBduPKfj9lM
         yVG8fGslYeKyiinFG46jviuuh/GDeMwMXqC6260vAtIRExqXVizcu4A4p872/EkkqK+T
         PTEV22CsogFFi/DAvPNtYBWui+rRpfUbzU1OMdL3KmQrh/MFqVG7rGkR9hmP3YvBFIsY
         c6RQ==
X-Gm-Message-State: AOAM533IYtguK5PQjXrpXg1Z4ifhdhxdRCRPuHPK1wJeUelAQu0zI5mB
        WZ2DPb7VAeaKuL4TG5ktG+ddaEGpYMYl5A==
X-Google-Smtp-Source: ABdhPJxluxPldVw6sQUgPVg1zbtNpoVnGdlAVhmzg0VqCJQA+WcSmm+GEmm0nxAnT/XrNmSFQNPSIQ==
X-Received: by 2002:a17:906:fb08:: with SMTP id lz8mr1313136ejb.45.1633666804901;
        Thu, 07 Oct 2021 21:20:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 04/25] trace-cmd library: Add internal helper function for writing headers before file sections
Date:   Fri,  8 Oct 2021 07:19:37 +0300
Message-Id: <20211008041958.976309-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index ae930c2f..6d524c99 100644
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
index d65ff599..d3760483 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -37,6 +37,11 @@ struct data_file_write {
 bool check_file_state(unsigned long file_version, int current_state, int new_state);
 bool check_out_state(struct tracecmd_output *handle, int new_state);
 
+unsigned long long
+out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
+			 char *description, enum tracecmd_section_flags flags, bool option);
+int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset);
+
 struct cpu_data_source {
 	int fd;
 	int size;
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index fa11fe77..c305d61f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -332,6 +332,74 @@ int tracecmd_ftrace_enable(int set)
 	return ret;
 }
 
+__hidden unsigned long long
+out_write_section_header(struct tracecmd_output *handle, unsigned short header_id,
+			 char *description, enum tracecmd_section_flags flags, bool option)
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
2.31.1


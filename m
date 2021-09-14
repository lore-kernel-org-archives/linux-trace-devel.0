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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51392C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36A97610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhINNQD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhINNQD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:03 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1F3C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:46 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id i3so9241770wmq.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85pfohYGbXwR6/110iSbSA2Yv/Hfu/2WNR5u/7SKQ04=;
        b=mK1rJYf1PoURrcQJ3GWPFbFpzTG7KRViUGEedSA8hv5pLmoOJgZ3AHF6CpkkAPFQaY
         lwpU4GHA9xxUk1BmnMckBpQLhRrvLZDTQYIsdC+8H0z1vS0Q7WEDa23znfK3kPxIsq1z
         AiqLaeVltznFqMCs8mveuCoTqVAfUChRb+5A12Wonyim9QD4BIhjhu6TYNl5t8I81+Jc
         +a83YshDTk1myjD0dmlKGw22Ou4trKF1n2SLS9OEtEnNT7JMndWyIAngSap8plP6/m0b
         zWonFopkFZtbDVP33vHEnAWr2zIxNK0AMpNuhxCxUJQ2/Sto31nM4Ov5zrkpplaEzwOt
         MBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=85pfohYGbXwR6/110iSbSA2Yv/Hfu/2WNR5u/7SKQ04=;
        b=MFbIPyX8eTv5c0AfdjTAX6te4hGUUwLHZ/azVeuyXNNXY7V7R/nSKwkY7aQ5219HkG
         +AOGrQDP+0F6hDKC8jUz1LxsJGuYLvMJhb4ruaz4I+63Q5fV9f9teZvG7bWVWbR/FKZj
         RjV0N8mgaz7B8JW4zb2FRehMyqNlFGSie8QHTMk1S+vrgKZAzcRM+UcmDsQgwIXUuv8x
         +ZVMZHzFOSj36yyA7g3hw1IZrbRxfdhCFvs14Tns9eHG2SpPqPZitQNXcPvDmDcT2lTx
         mmFMXfVT6Of8KUFsRKSgIHJu3cEQsEy4YgW7vmC+N7WBcGT+cX0ThaiitZReVYJa0neu
         eCJg==
X-Gm-Message-State: AOAM532w8OpF49NvJ22NUiVo4i1ObEvWR3mw55ein1xo+z/L697kn66v
        iiZDuP/tcamMuWSqARnL7To/KdWMZLg=
X-Google-Smtp-Source: ABdhPJwyhTbpGywy4y4IAiAfbQN/JkJxI0UImzPyaXhTW2HRA+nMbXvacAjbSEz9uLpT4ibQKK3z+w==
X-Received: by 2002:a05:600c:510a:: with SMTP id o10mr2139019wms.81.1631625284742;
        Tue, 14 Sep 2021 06:14:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 04/25] trace-cmd library: Add internal helper function for writing headers before file sections
Date:   Tue, 14 Sep 2021 16:14:17 +0300
Message-Id: <20210914131438.3965484-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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
index 362b9fc0..405b7dae 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -35,6 +35,11 @@ struct data_file_write {
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
index 73e05d07..5deabfe3 100644
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


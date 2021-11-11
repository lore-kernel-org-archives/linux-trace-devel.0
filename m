Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D393DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6EC461108
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhKKPOF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbhKKPOE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:04 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A74C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:15 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id m14so25733019edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+4RDUY3qWgE4rgsV+KFWJN5mACr2UCj9iRlQaroPQz8=;
        b=DnFO08Wew95Hg3EOEujJLFBgvclua0CNzIKIq+zdsQHVvGSTY+jbiDseArwLG+QjfQ
         3OAvSQljnu3PHcAMvl00SPb6edAP41gqDWltyEt2TKuJhlrGQe9WHtU17hiKHGqN/Qtn
         GO/qD3bcsqz7jrWq8kpYpnMsKV3gkuyJr10eO/bMrSN3IALcT+158R9aPyIylORShhGZ
         oJ2DejD716+x1fI2mqyiL/8Zk8s4+5UXBjNSAY182A/pKC9/lFJjGQBTNJR4sP15UoGq
         rNOP5EOiMAXkV+XDoKxYTo7k9EtOJmWlqqtuw/PND7mUbyztlFnYX1DtgE5NbtiXL/9M
         m9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+4RDUY3qWgE4rgsV+KFWJN5mACr2UCj9iRlQaroPQz8=;
        b=VxedDpw2eQ86tlFMnAmgFI1i3XLKiw8cBNDsQKtAeoxGdC3popF+dRb/MJzqbYZDMB
         DNSbZpc9Rc45AGw3fM/J9wJmWZYxrcAylSFimd1SR0qQoe/CayaroGHZIc6yc31pD395
         mzIM1MPr4Jup63+3FkJkiXPe6H7+BO4zMkN8ULmcwggYPtboI10Kh88z3jLFUhf+N1yc
         KXkynxASFud5JqIkL/p+KKPqCdfPHiXF3PUOMeMqGb3Tia/Q3IjDiavEPVCNBn2aTw+v
         0IRPGn4nHdP6RAlR6ZK1p4S87hixDPbbHTEOhVgYcW/BSdVmMa9Zjzx7w/Hs1Vl0Dqd/
         7frQ==
X-Gm-Message-State: AOAM530p9dLKc/IfFv1iQujmdfCotdOz0SYkNn1N0tG06NLyErsOxAc1
        xlft3yVgndcMwMZEyylN6Kjed8AOe3mFZg==
X-Google-Smtp-Source: ABdhPJxhv5wZPhKTQsRa3AI0AO1AnBS8x7+fZEq8iPtdLutbaZHVk2LeD2jwlelx4RMM0hP1L7hyAQ==
X-Received: by 2002:a17:907:d14:: with SMTP id gn20mr9909304ejc.73.1636643473832;
        Thu, 11 Nov 2021 07:11:13 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id nc30sm1648803ejc.35.2021.11.11.07.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 10/25] trace-cmd library: Add section header before flyrecord trace data
Date:   Thu, 11 Nov 2021 17:11:03 +0200
Message-Id: <20211111151112.86751-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, write a section header at the beginning of each
section with flyrecord trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 1f846742..baa262fb 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1892,10 +1892,12 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 				int cpus, struct cpu_data_source *data, const char *buff_name)
 {
 	struct data_file_write *data_files = NULL;
+	enum tracecmd_section_flags flags = 0;
 	tsize_t data_offs, offset;
 	unsigned long long endian8;
 	unsigned long long read_size;
 	char *clock;
+	char *str;
 	int ret;
 	int i;
 
@@ -1914,6 +1916,13 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
+		goto out_free;
+	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
+	free(str);
+	if (offset == (off_t)-1)
+		goto out_free;
+
 	data_files = calloc(cpus, sizeof(*data_files));
 	if (!data_files)
 		goto out_free;
@@ -2002,6 +2011,9 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (do_lseek(handle, 0, SEEK_END) == (off64_t)-1)
 		return -1;
 
+	if (out_update_section_header(handle, offset))
+		goto out_free;
+
 	handle->file_state = TRACECMD_FILE_CPU_FLYRECORD;
 
 	return 0;
-- 
2.33.1


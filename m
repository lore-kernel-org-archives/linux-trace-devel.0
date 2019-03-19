Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C015C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 365842085A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfCSPzm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:55:42 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36525 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfCSPzl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 11:55:41 -0400
Received: by mail-wr1-f67.google.com with SMTP id y13so17271634wrd.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Mar 2019 08:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FqFD0+SNXkWScg4eQN2fiGCZ2PdfRLNFg7lshgeVR6Q=;
        b=J3KDc+JblOccTPDjVZArnOPL+LePtFNCd+kNFCHskD0b87RyKeflg1ly+6DZ/jSK3w
         m3RQopQg+Iy3CmZ/XJKrvM9i7I3KBZOcLYtJPsH62VcUOOrrfW02WHQmHVoXOQn0UAIp
         0Wu3jyh15MKpOMsTt6O7lzxoX9vOiWpaYCyB97raMFb6YGk63qhLjWeG5BpNzwgDuf4Y
         UYxnpo8KNbPSPcoWKZIqAe1FQFNlkNA85G7Iq5w4PRxICKn0girRKJYIx8ISnmF4llp+
         UwrvpGhw2t5WrJZlPWL1uIxtVsFsPr14/dLgSDvU0Q/s5s8EVmYsrOADk17TGwCfYfAD
         ckDg==
X-Gm-Message-State: APjAAAVtlROMFmX1ooU9Z8Hoa4rzZMunUwgB+Gg+K6BcTi+h7NThctyL
        KQgnwv/Lqv7dlvYWB4kuK9YxiVzM
X-Google-Smtp-Source: APXvYqw1sN8u1h97+o7tfH9G0NNEw65SGQScgpBH1frSfx063obgxEEcOMURbOY54D+B/4+lfTwuxg==
X-Received: by 2002:adf:ed8f:: with SMTP id c15mr2624873wro.144.1553010940412;
        Tue, 19 Mar 2019 08:55:40 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t15sm9365911wrr.16.2019.03.19.08.55.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 08:55:39 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 2/9] trace-cmd: Added support for negative time offsets in trace.dat file
Date:   Tue, 19 Mar 2019 17:55:29 +0200
Message-Id: <20190319155536.19381-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190319155536.19381-1-tstoyanov@vmware.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When synchronizing timestamps between different machines, there are cases
when the time offset is negative. This patch changes the way time offset is
written and read from trace.dat file - as signed decimal, instead of hex.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h | 2 +-
 lib/trace-cmd/trace-input.c   | 6 +++---
 tracecmd/trace-read.c         | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 21f83e2..428d792 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -126,7 +126,7 @@ int tracecmd_is_buffer_instance(struct tracecmd_input *handle);
 void tracecmd_create_top_instance(char *name);
 void tracecmd_remove_instances(void);
 
-void tracecmd_set_ts_offset(struct tracecmd_input *handle, unsigned long long offset);
+void tracecmd_set_ts_offset(struct tracecmd_input *handle, long long offset);
 void tracecmd_set_ts2secs(struct tracecmd_input *handle, unsigned long long hz);
 
 void tracecmd_print_events(struct tracecmd_input *handle, const char *regex);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 34a8301..be6720c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -91,7 +91,7 @@ struct tracecmd_input {
 	bool			read_page;
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
-	unsigned long long	ts_offset;
+	long long		ts_offset;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -2082,7 +2082,7 @@ static int init_cpu(struct tracecmd_input *handle, int cpu)
 }
 
 void tracecmd_set_ts_offset(struct tracecmd_input *handle,
-			    unsigned long long offset)
+			    long long offset)
 {
 	handle->ts_offset = offset;
 }
@@ -2099,7 +2099,7 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
 
 static int handle_options(struct tracecmd_input *handle)
 {
-	unsigned long long offset;
+	long long offset;
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 804022a..e309672 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -58,7 +58,7 @@ static struct list_head handle_list;
 struct input_files {
 	struct list_head	list;
 	const char		*file;
-	unsigned long long	tsoffset;
+	long long		tsoffset;
 	unsigned long long	ts2secs;
 };
 static struct list_head input_files;
@@ -1413,7 +1413,7 @@ void trace_report (int argc, char **argv)
 	struct input_files *inputs;
 	struct handle_list *handles;
 	enum output_type otype;
-	unsigned long long tsoffset = 0;
+	long long tsoffset = 0;
 	unsigned long long ts2secs = 0;
 	unsigned long long ts2sc;
 	int show_stat = 0;
-- 
2.20.1


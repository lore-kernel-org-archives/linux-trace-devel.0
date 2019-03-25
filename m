Return-Path: <SRS0=I4ei=R4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498D3C4360F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C62920863
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Mar 2019 14:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbfCYOYp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:24:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43515 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbfCYOYp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 10:24:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id k17so2437473wrx.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Mar 2019 07:24:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FqFD0+SNXkWScg4eQN2fiGCZ2PdfRLNFg7lshgeVR6Q=;
        b=AtGWUrUN+UqsNAXFyFcdUP1VeA2qHXhsjRaIiu9a9lt9LacrcEorCDiJSxS+soocF/
         MWDjQg6E2zeN/9rLKg3VjNqKfnYoEM2K0/nVy7DmOelSN95R3DFlu3BgjABa5cY3NSAF
         JmhrXOD1oCtOyGYUianwcNPR4gqHwG3Ro8bbEUvcan8tGK051BRVnNTauICv8iila9/k
         N27dogL3GEjLAhvK2+KBFHNAd3M6qDy7UTJ/0ewpxR6+i5pnl0WpETQEDTky5eDLJH03
         4P9OT+mHGa9gcRZoGqgFf7OVsiUORTYh9LqCHSjpVWBSheOlfbdhRUeDEHKx1N0Aeiel
         sIgQ==
X-Gm-Message-State: APjAAAXS14Ef9R+jRmyA34qgftGDSrIjarzJ85AdPXhFIw/kD1WIvE5k
        mzcN2pF6q+mC88IIadwo9CY=
X-Google-Smtp-Source: APXvYqyombDN4kII7070pSHiNQqy2KxwkC9hABcaE5YjS7p3Dq/QexCBi7+mKWmaZDezE8k5nfLK4g==
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr15333492wru.150.1553523883802;
        Mon, 25 Mar 2019 07:24:43 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s2sm1293440wmc.7.2019.03.25.07.24.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:24:43 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v9 2/9] trace-cmd: Added support for negative time offsets in trace.dat file
Date:   Mon, 25 Mar 2019 16:24:32 +0200
Message-Id: <20190325142439.22032-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190325142439.22032-1-tstoyanov@vmware.com>
References: <20190325142439.22032-1-tstoyanov@vmware.com>
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


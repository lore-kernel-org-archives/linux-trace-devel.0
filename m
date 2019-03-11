Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77541C10F0C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4682620643
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfCKIdq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 04:33:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54500 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfCKIdq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 04:33:46 -0400
Received: by mail-wm1-f67.google.com with SMTP id f3so3423162wmj.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 01:33:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HjgYILSVk6MYR5w1Q9TxlsvwEb/cp6vZNW3Z/pHTu9g=;
        b=F8FgSOaM9pchGOpLr/bMujImkSiXlg+AHFw9rCfwyt8opnb/qnRNvVS0Il/dIpUCGJ
         hO5t9XQwcdDRKKu4XW760d1l3ZsfcU5OuTNC6Bgleeuo87vGhMcc8xGMulwvMV/DZOOp
         rfs2tVjI/koVYk4b04rdwmSfvqG9yFwTLQBrOUweTffVB+5saGar51H3Ld56hn7gqsax
         /DAgZS1/PVHFEI5gtYHPudbZiVIxd5xcCGXjOmgdKot6eM1DqBWAFSphlBqm2P4fvaC4
         I8zcPk7kxdAv9ymIILkC17hU7NlZLNVdic46m9JURMpWqy94Q6g1HloyasmBhg2MoSRz
         SINA==
X-Gm-Message-State: APjAAAV/bej+e7oesm0+n0otwkUh/XW5MwMWwYvb2NzWthZV8ZA4L/sN
        l2gvQHpbv1ngSEj4jSK5NgCDF1yr
X-Google-Smtp-Source: APXvYqxvoifdyGhpkwA9MFb4T8AGFkdHRlZfhpTCEr0eXw/HphBg5NhOL/vv75bolUFzHEp3V5TYZw==
X-Received: by 2002:a1c:6506:: with SMTP id z6mr15916594wmb.153.1552293224271;
        Mon, 11 Mar 2019 01:33:44 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x17sm19683835wrd.95.2019.03.11.01.33.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 01:33:43 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/6] trace-cmd: Fix "trace-cmd reset" command to restore default clock
Date:   Mon, 11 Mar 2019 10:33:36 +0200
Message-Id: <20190311083339.21581-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190311083339.21581-1-tstoyanov@vmware.com>
References: <20190311083339.21581-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command should restore ftrace to its default state.
This patch sets "tracing/trace_clock" to its default value "local",
when the "trace-cmd reset" command is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d7267fe..6972b9f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3793,6 +3793,14 @@ static void clear_filters(void)
 		clear_instance_filters(instance);
 }
 
+static void reset_clock(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		write_instance_file(instance, "trace_clock", "local", "clock");
+}
+
 static void clear_triggers(void)
 {
 	struct buffer_instance *instance;
@@ -4494,6 +4502,8 @@ void trace_reset(int argc, char **argv)
 	set_buffer_size();
 	clear_filters();
 	clear_triggers();
+	/* set clock to "local" */
+	reset_clock();
 	tracecmd_remove_instances();
 	clear_func_filters();
 	/* restore tracing_on to 1 */
-- 
2.20.1


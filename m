Return-Path: <SRS0=bjmZ=QG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9D2C282D9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC86B20857
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbfA3Koc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:44:32 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33363 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfA3Koc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jan 2019 05:44:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id r24so15141869wmh.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jan 2019 02:44:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oDePjZsBlUkGv8i5axMEwFpCZSBLwXX9Yi3vtL/fVV4=;
        b=RRJVlKaSNlZ3CRPkGVSEbZCxgU+2g8SbXCxE7xmyDOjlR9rw7h2xrSz5by64gAEpcj
         o9qRO7eY2gnzET21ntLpb/PYX7Zrg+fv9BJE5YynvkiehFkMLqKdYOJ8/ktnlhlbrWBZ
         YkeT5+VAV1UnvU3sJuQ/6v8fGvGXSrNVu8kxsETX3l4aYoUQ3D27pdIwmyy0wO/NJL8V
         JOJ9ubXbPxScwa6K1qPn4eh+FMrvh7W+aCabjLhoqHd7STieYMOOxxstgXj8AmeuIvxJ
         PVkGMd68LXySjPOzA2/Vtl9zlqN7F0SyHlgqqY1Uf1teJ8b3I0FDWst5xleWmWzQFu9h
         lwXw==
X-Gm-Message-State: AJcUukfETPhc3Jjs8SqStmm17z1HGOYMGBk5hdG1BJaBrkisYzGFUGsg
        k6KLoCcHpMQnRlL7oJXUVX4=
X-Google-Smtp-Source: ALg8bN7UHFp9Kjp0gAcf5A4/bzImO8o5rLVkQzhBg1OQHOtQsUpRmHeVravfMZiVHrT0N4/OUbNyiw==
X-Received: by 2002:a1c:e1d5:: with SMTP id y204mr24730079wmg.65.1548845070652;
        Wed, 30 Jan 2019 02:44:30 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w12sm503079wrr.23.2019.01.30.02.44.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 02:44:30 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/6] trace-cmd: Changed return logic of trace_seq_printf() and trace_seq_vprintf() APIs
Date:   Wed, 30 Jan 2019 12:44:22 +0200
Message-Id: <20190130104425.8813-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130104425.8813-1-tstoyanov@vmware.com>
References: <20190130104425.8813-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to make libtraceevent into a proper library, its API should be
straightforward.

The trace_seq_printf() and trace_seq_vprintf() APIs have inconsistent
returned values with the other trace_seq_* APIs.

This path changes the return logic of trace_seq_printf() and
trace_seq_vprintf() to return the number of printed characters, as the
other trace_seq_* related APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181201040852.485792891@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/trace-seq.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/lib/traceevent/trace-seq.c b/lib/traceevent/trace-seq.c
index 7f0c2f0..a20dab1 100644
--- a/lib/traceevent/trace-seq.c
+++ b/lib/traceevent/trace-seq.c
@@ -100,7 +100,8 @@ static void expand_buffer(struct trace_seq *s)
  * @fmt: printf format string
  *
  * It returns 0 if the trace oversizes the buffer's free
- * space, 1 otherwise.
+ * space, the number of characters printed, or a negative
+ * value in case of an error.
  *
  * The tracer may use either sequence operations or its own
  * copy to user routines. To simplify formating of a trace
@@ -129,9 +130,10 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 		goto try_again;
 	}
 
-	s->len += ret;
+	if (ret > 0)
+		s->len += ret;
 
-	return 1;
+	return ret;
 }
 
 /**
@@ -139,6 +141,10 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
  * @s: trace sequence descriptor
  * @fmt: printf format string
  *
+ * It returns 0 if the trace oversizes the buffer's free
+ * space, the number of characters printed, or a negative
+ * value in case of an error.
+ * *
  * The tracer may use either sequence operations or its own
  * copy to user routines. To simplify formating of a trace
  * trace_seq_printf is used to store strings into a special
@@ -163,9 +169,10 @@ trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 		goto try_again;
 	}
 
-	s->len += ret;
+	if (ret > 0)
+		s->len += ret;
 
-	return len;
+	return ret;
 }
 
 /**
-- 
2.20.1


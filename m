Return-Path: <SRS0=bjmZ=QG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA59C282D9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E18F2184D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfA3Koa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:44:30 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52000 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfA3Koa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jan 2019 05:44:30 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so21116027wmj.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jan 2019 02:44:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JralAxeVGx+pGJ06i5VjKWmYVAl7H1mEusrh+LLkpuE=;
        b=P9/BzXNdQzY7vtgB8RxnIUaQ/A/wZfZOo5teVqZh8FImD81ZJgOuFdOqkoxFOLW6Ba
         JKHxMQPt57rZ/QHFXvjZUK+wmMCIREJJLkeaeC3d9RGU9CVK93ygsoz6d8Cfy7lDJcv8
         3EFIQuc+B81yiV4XOuVDI0aI/N/oB+3sgKZ9QKzJD5rY3L9IakVxcaXVPYPJ87LxaxpQ
         hrumLT7Pvkx4t73IhiHHBeAnelKFWbNPYgmBsf2XEe2iaz6QdeU9k0uj8EeyFmsKRjIq
         2q7SNWT2I79oKP//45+8DCdUcg4uDLpalrWros2i3kF5T1WSN4tHHD8UqWruRe/fJJ5K
         Izaw==
X-Gm-Message-State: AJcUukcO6yrotZ0NBaZq4gbSzy984slKwGToxnlxluuHPGE8KU9jOkHI
        x7g65EMYUSEjkRLZ22Wf3oE=
X-Google-Smtp-Source: ALg8bN7eh3ajNBbwjgYlVSz+VGm0mhioI7dD/8uGyHzwyKqubHE2W3NTUxOBOKL7RllroCG6fcXazg==
X-Received: by 2002:a7b:c44d:: with SMTP id l13mr25131475wmi.144.1548845068485;
        Wed, 30 Jan 2019 02:44:28 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w12sm503079wrr.23.2019.01.30.02.44.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 02:44:27 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] trace-cmd: Initialize host_bigendian at tep_handle allocation
Date:   Wed, 30 Jan 2019 12:44:20 +0200
Message-Id: <20190130104425.8813-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130104425.8813-1-tstoyanov@vmware.com>
References: <20190130104425.8813-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch initializes the host_bigendian member of the tep_handle
structure with the byte order of the current host, when this handler is
created - in tep_alloc() API. We need this in order to remove the
tep_set_host_bigendian() API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181201040852.216292134@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/event-parse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 3f85b94..b506dc7 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -6829,8 +6829,10 @@ struct tep_handle *tep_alloc(void)
 {
 	struct tep_handle *pevent = calloc(1, sizeof(*pevent));
 
-	if (pevent)
+	if (pevent) {
 		pevent->ref_count = 1;
+		pevent->host_bigendian = tep_host_bigendian();
+	}
 
 	return pevent;
 }
-- 
2.20.1


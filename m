Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841B0C10F14
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 573302148E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfDHPXr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:23:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36898 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728820AbfDHPXr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:23:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id w10so16931194wrm.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uhgiUqsUnDvA12E4xKfeq70eNpYJG3400KoRQP7wWpU=;
        b=qj6rfmyFdo6PCDzY2jAW72iiTvBs8DN06cfwVY7JQMomc792m5LpCw7scpLuevEWFh
         uJEb/o2LftK/pvniaa4YUoJ/Q7V/pXo8ImJIyrg+mdt/mS29TVUFxWESt8le1EuMu2gz
         tdj3VRlzlpxs+tRJqnohHHz6shknW3v9hicNWS2dAdgWnsBFc8/7HeHn+TtIH2H8dbzL
         LDBEwuh1IG0di8FN/d8PXL4nydOkWZ4xOdktbBGBkIaZVjzmqMh3O/mmn0mvcXiO2dYK
         sb60F9/g+4gdqvlhwdUVmwgNmC/qSmtxVLTzNCCqcI5fH/7BrBb1RbQtTBa7CWu0ZGhR
         F5eA==
X-Gm-Message-State: APjAAAXvAPaPI2wvObikQbHhF5BkjWyep7F+f4Q3wMbUvdlvnjlO64IO
        sH4shq9yHq3Yhm4P5R86UsVMTdjk
X-Google-Smtp-Source: APXvYqwJuoSDRmx/YclDjaQWCosaJoB8QYlYFvrIrMZSXiE4Z5HpMsw6XjrbxUd2/5X+h/n1beN59Q==
X-Received: by 2002:adf:c10e:: with SMTP id r14mr18621164wre.168.1554737025069;
        Mon, 08 Apr 2019 08:23:45 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c6sm11142498wmb.21.2019.04.08.08.23.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 08:23:44 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 03/10] tools lib traceevent: Removed unneeded !! and return parenthesis
Date:   Mon,  8 Apr 2019 18:23:33 +0300
Message-Id: <20190408152340.12450-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190408152340.12450-1-tstoyanov@vmware.com>
References: <20190408152340.12450-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

As return is not a function we do not need parenthesis around the return
value. Also, a function returning bool does not need to add !!.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Link: http://lkml.kernel.org/r/20190401164343.817886725@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/event-parse-api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-api.c
index f2e5d18..fb49d1b 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -88,7 +88,7 @@ void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag)
 bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 {
 	if (tep)
-		return (tep->flags & flag);
+		return tep->flags & flag;
 	return false;
 }
 
@@ -367,7 +367,7 @@ int tep_get_parsing_failures(struct tep_handle *tep)
 bool tep_is_old_format(struct tep_handle *tep)
 {
 	if (tep)
-		return !!(tep->old_format);
+		return tep->old_format;
 	return false;
 }
 
-- 
2.20.1


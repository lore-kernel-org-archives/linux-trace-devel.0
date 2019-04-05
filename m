Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D869C10F00
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7748221850
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbfDEODm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 10:03:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39199 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729987AbfDEODl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 10:03:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id j9so8171712wrn.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 07:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v6G+QUj4MP4Z4WiHOY2csqsbs6lznvZV6Rg8bE4ZHaY=;
        b=MfhgMU/WDtnvIqAw0J16QO06dsI/+k0nv/lLBo0dve0Lg4nSz80mhfA+X4zZ6wD0dm
         9DlW4MBNNhmxbn5176TRoMemCIcDRbET+PINk2ie5W+0sZOGxqmEY0Undqqi+GbkniWk
         gxLyjGbtTVMqVjBEC5EKoPY9/v0OxDpsRFky8AmhE+bx42WYCycXnlTn0juYzHfEpS7N
         n70LGS/v+3DvQNRsaed8JVAFdPKQtm+F1jv6UCU7YvsEhCDdVu+kib/V70jlxmdBgNG6
         zKJM+CoEivj/n7AURennMawEZEHRF+EH4iO5d4ou4L4LhkQB9Z8JsC/aNXsKO6qq9k9S
         VbXA==
X-Gm-Message-State: APjAAAVxq6s23MgNScMLmMAQS9/OcRqNVi320UZ37G7ARga4gArR2rQf
        Yxl9+b1d+AjXrq0owZgee20=
X-Google-Smtp-Source: APXvYqxJMY9UgrGfAr5WeUr1k8gVnMEyWxpCri2tZyD2znSAicu/ovVJdsd6UVELJ3LU6Eu9xPgWYg==
X-Received: by 2002:adf:e94d:: with SMTP id m13mr9365590wrn.141.1554473020289;
        Fri, 05 Apr 2019 07:03:40 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w16sm29604647wrt.84.2019.04.05.07.03.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Apr 2019 07:03:39 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/10] tools lib traceevent: Remove call to exit() from tep_filter_add_filter_str()
Date:   Fri,  5 Apr 2019 17:03:27 +0300
Message-Id: <20190405140332.10949-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190405140332.10949-1-tstoyanov@vmware.com>
References: <20190405140332.10949-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch removes call to exit() from tep_filter_add_filter_str(). A
library function should not force the application to exit. In the
current implementation tep_filter_add_filter_str() calls exit() when a
special "test_filters" mode is set, used only for debugging purposes.
When this mode is set and a filter is added - its string is printed to
the console and exit() is called. This patch changes the logic - when in
"test_filters" mode, the filter string is still printed, but the exit()
is not called. It is up to the application to track when "test_filters"
mode is set and to call exit, if needed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flkml.kernel.org%2Fr%2F20190326154328.28718-9-tstoyanov%40vmware.com&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7Ca85c00102f8946a5a65008d6b78541b2%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180295236164&amp;sdata=2bP6ffKd0dTVskeHiJBvhMkgGNaqyskxRGuShZiD3ME%3D&amp;reserved=0
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flkml.kernel.org%2Fr%2F20190401164344.121717482%40goodmis.org&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7Ca85c00102f8946a5a65008d6b78541b2%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180295236164&amp;sdata=lq%2BDgVReaUgoo0NqCLPCxvNoBI6CVK1Gzb3gP7fGiBs%3D&amp;reserved=0
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/parse-filter.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 4ffd8b2..3320c0a 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1346,9 +1346,6 @@ enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 
 	free_events(events);
 
-	if (rtn >= 0 && pevent->test_filters)
-		exit(0);
-
 	return rtn;
 }
 
-- 
2.20.1


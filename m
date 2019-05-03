Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96274C04AAA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71FD62089E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfECJLa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37509 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfECJLa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id k23so6880475wrd.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4xSuZZbHlNlsu6ymSziPSFNQpccmVlofHngbwQkqMgE=;
        b=Cw/AjzXzFxOwzoK+/aM9FZPtqq8BR7nxmQHRvcgyrogF3sXaTNDd9IMrUvstTcPEoD
         Z7pyG0wJAWghQPa/s82VJCDy5pCVzU8afw1jMCkf2zdl9ibqN/Y5SSHqRfx00lo063OG
         1cDWklerVpkr5VfvlGFGtKRgmIu116kz3IaL0CdtmHdwQ/2rAIOHOVkyFOZXdi5Gzjb3
         9iDwvARjOcWVB52nu7qhiqp9HLoPuouTFpEL9CNBnP0Zo6JSmQ6Jei6CJmZjePmHRKzY
         hltr1iS8JhiTdkuVw/2AA1CF1baBOygGr3lEXm6dON/77rUrAgZwKvfOUl+PWIEuH9Ko
         pqSg==
X-Gm-Message-State: APjAAAWSBptMpkfD/3O4t9kfFox+ewGNaSqWD8kZD3LYyO8FueDGa/FW
        ChEvAcGf6AXnYcis8klM0Z+WSH+K
X-Google-Smtp-Source: APXvYqyc7RxJ23rXVZMmoqCGF+gyURA85CvvzRcPTIupmmrklxF1w7hnVu3XRJumlbJMgdGEei+Ktg==
X-Received: by 2002:a5d:52c6:: with SMTP id r6mr6371465wrv.131.1556874688524;
        Fri, 03 May 2019 02:11:28 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:28 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 08/26] tools/lib/traceevent: Man page for page size APIs
Date:   Fri,  3 May 2019 12:11:01 +0300
Message-Id: <20190503091119.23399-9-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503091119.23399-1-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for libtraceevent APIs:
  tep_get_page_size()
  tep_set_page_size()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-page_size.txt | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_size.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
new file mode 100644
index 000000000000..452c0cfa1822
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
@@ -0,0 +1,82 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_page_size, tep_set_page_size - Get / set the size of a memory page on
+the machine, where the trace is generated
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
+void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_get_page_size()_ function returns the size of a memory page on
+the machine, where the trace is generated. The _tep_ argument is trace
+event parser context.
+
+The _tep_set_page_size()_ function stores in the _tep_ context the size of a
+memory page on the machine, where the trace is generated.
+The _tep_ argument is trace event parser context.
+The _page_size_ argument is the size of a memory page, in bytes.
+
+RETURN VALUE
+------------
+The _tep_get_page_size()_ function returns size of the memory page, in bytes.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <unistd.h>
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	int page_size = getpagesize();
+
+	tep_set_page_size(tep, page_size);
+
+	printf("The page size for this machine is %d\n", tep_get_page_size(tep));
+
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.20.1


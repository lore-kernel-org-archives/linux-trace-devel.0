Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5C8C10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4865F208E4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfCHNhF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36522 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfCHNhE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id o17so21410555wrw.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O8Ihw8mfOqn4HmP/IhUtDZYk7yYKQJVm+yP9ixou6+c=;
        b=ghPN/79vecrvfTJ2uB7wHwspmMGPCZsvGIGi9iFPVKr9/wFQhCnYNfd/3t/d833T2h
         r2lRz/hfR65DthKesAyq/rpZsKRamqVCwTcMi33x9I9niWlnkajEGXRT7mmCBHW5k7Sa
         d0kS3iyBL9AEt+rvXQrxQFvd3/PgXFItmV05aTIv4VzlZWxbfIz1cT+Io4mYlJzsspzb
         94ETYSPxkOzr5ZK3CSnBKdbiKLfLN4qpKh3cf/BBGHdHDw0XzbvfYk5PxLTIwvFH8T+5
         Sw8cJl3nXuCOyoDGw48S92ekUeY5CVSfzRexw9uNa2rVn/85KFMkKt65TNJrmay/9ABG
         JtIA==
X-Gm-Message-State: APjAAAW2o3Hh+tZfbvc33jFqa2aoWVHuLXuUZde0FAXrABrNCFc9P1jY
        7mEs7cKBBw2I/E/pJkNp9Jlt/EKs
X-Google-Smtp-Source: APXvYqyP14M+Ly7xAbPHZCx2paprdCfxK3GwSVDVwtZJZq4bVg8D487s7Igzh1oQLyP7BLviIMg9BQ==
X-Received: by 2002:adf:9f54:: with SMTP id f20mr11289100wrg.88.1552052223221;
        Fri, 08 Mar 2019 05:37:03 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:02 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 06/46] tools/lib/traceevent: Man page for tep_get_header_page_size()
Date:   Fri,  8 Mar 2019 15:36:14 +0200
Message-Id: <20190308133654.21264-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create a man page for tep_get_header_page_size(),
as part of the libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-header_size.txt             | 73 +++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-header_size.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-header_size.txt b/tools/lib/traceevent/Documentation/libtraceevent-header_size.txt
new file mode 100644
index 000000000000..5810a4cdc2ea
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-header_size.txt
@@ -0,0 +1,73 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_header_page_size - Get the size of a long integer, in kernel context.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
+
+--
+DESCRIPTION
+-----------
+The _tep_get_header_page_size()_ function returns the size of a long integer,
+in kernel context. The _tep_ argument is trace event parser context.
+This information is retrieved from /sys/kernel/debug/tracing/events/header_page,
+ "commit" field.
+
+RETURN VALUE
+------------
+The _tep_get_header_page_size()_ function returns the size of a long integer,
+in bytes
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	int lsize = tep_get_header_page_size(tep);
+	printf ("The size of a long in kernel context is %d bytes", lsize);
+...
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


Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC89C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 484062084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfDLNiS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55454 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfDLNiS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id o25so11274359wmf.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FLXNULcmM8V+HAfXfH+q1nJkgQ2LtsvRkPzQ0znRZiU=;
        b=o2VTb0w5o3zTrQIgWTssnbaegZPYxW9e7M/MLYqtAj3qu+R9giq9A8eUsvZydJhe9v
         4DqXBxCWtj/lJzl1PxJDBLIl9BZkJefjOAE9aR0GN7M6Q1UEHLrqD4oIWRZ2TeJTEqVP
         c241z127MnjedT+vyqXkInTvZRL9YwFlWYtQw675IDqHV3H4vhSrf1Yj4slenodYGhf7
         igCtrUkY8Izc0QRiCunxDE12y6oI/UBUHIUDJBfoWKT8xV5xtFPgQXNoZ0Wrd/4o+fT0
         wSgWThZ86RFD5iVFkqbaUvjgHyCaYH6BSq+Udw8J9bFVrOQ34BhPNt8kx59m69vLFSns
         EP5g==
X-Gm-Message-State: APjAAAWvzldkoogtH5lPYcVNK7LpKSP6TK2fozmYVyu34tFKpsHYWY/7
        0mjdQq+8tpe+3wGFOIt5kSg=
X-Google-Smtp-Source: APXvYqwb30Syf225Lr9NOd5NWIMwYrS3CWTKQs52pMItMPf+YcJASBU2xmiKdJNHL+OIDlMjbmammw==
X-Received: by 2002:a1c:c504:: with SMTP id v4mr11591509wmf.45.1555076296460;
        Fri, 12 Apr 2019 06:38:16 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:15 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 04/30] tools/lib/traceevent: Man page for header_page APIs
Date:   Fri, 12 Apr 2019 16:37:45 +0300
Message-Id: <20190412133811.15878-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create a man page for libtraceevent APIs:
  tep_get_header_page_size(),
  tep_get_header_timestamp_size(),
  tep_is_old_format()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-header_page.txt             | 105 ++++++++++++++++++
 1 file changed, 105 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-header_page.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-header_page.txt b/tools/lib/traceevent/Documentation/libtraceevent-header_page.txt
new file mode 100644
index 000000000000..e1bd664ac123
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-header_page.txt
@@ -0,0 +1,105 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_header_page_size, tep_get_header_timestamp_size, tep_is_old_format -
+Get the data stored in the header page, in kernel context.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
+int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
+bool *tep_is_old_format*(struct tep_handle pass:[*]_tep_);
+--
+DESCRIPTION
+-----------
+These functions retrieve information from kernel context, stored in
+/sys/kernel/debug/tracing/events/header_page. Old kernels do not have header
+page info, so default values from user space context are used.
+
+The _tep_get_header_page_size()_ function returns the size of a long integer,
+in kernel context. The _tep_ argument is trace event parser context.
+This information is retrieved from /sys/kernel/debug/tracing/events/header_page,
+ "commit" field.
+
+The _tep_get_header_timestamp_size()_ function returns the size of timestamps,
+in kernel context. The _tep_ argument is trace event parser context.
+This information is retrieved from /sys/kernel/debug/tracing/events/header_page,
+ "timestamp" field.
+
+The _tep_is_old_format()_ function  returns if the kernel is old one and has no
+/sys/kernel/debug/tracing/events/header_page.
+
+RETURN VALUE
+------------
+The _tep_get_header_page_size()_ function returns the size of a long integer,
+in bytes.
+
+The _tep_get_header_timestamp_size()_ function returns the size of timestamps,
+in bytes.
+
+The _tep_is_old_format()_ function returns true, if an old kernel is used to
+generate the tracing data, which has no
+/sys/kernel/debug/tracing/events/header_page. If the kernel is new, or _tep_ is
+NULL, false is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	int longsize;
+	int timesize;
+	bool old;
+
+	longsize = tep_get_header_page_size(tep);
+	timesize = tep_get_header_timestamp_size(tep);
+	old = tep_is_old_format(tep);
+
+	printf ("%s kernel is used to generate the tracing data.\n",
+		old?"Old":"New");
+	printf("The size of a long integer is %d bytes.\n", longsize);
+	printf("The timestamps size is %d bytes.\n", timesize);
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


Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC3BC10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7FE82087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfCHNhd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:33 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34722 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfCHNhd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:33 -0500
Received: by mail-wr1-f68.google.com with SMTP id f14so21396742wrg.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eYfbKuT/9aeiIdAap/LKVglvcfScVRvIq0TqaS8lLhk=;
        b=oQDsY/FCXhJtWG+NEztOalnvT7sDt0NAt6nEmHMLsGlawfeqDXUrozUo6J7obhW2iJ
         Zn2m4/wZC0a4Y3+R/Vsie+iaibJr8oY1tOjFCG8yq4y+pUIMiaUoRlh6GhMfYq0bBVSA
         x6oGlc/SYIVVi+TM+DatzCCQ5jvNx/mfnFZmfXpwleoLNXP83EJMiAQ2E13FVeP9L3uL
         g3lT/eOn6s9udWSFNKyoVEvEmz8QOCtEt5MDakNdiiXnz1GZBTkoRXQuVzWCJzIz35Z6
         ikaXkf3OsG7/Xlp1WQq5E87scdrQVlz+5csuL/b52o0d7TbnKIk+Q0pshzP/fu7TfyH4
         hnTQ==
X-Gm-Message-State: APjAAAWMFoRb+F/WGAY9eTfABGN9Lxdtkwx5Zt93TgN/TFbqy0KSIBSe
        76/4r+GCr463gk32p3B/MyI=
X-Google-Smtp-Source: APXvYqyTiEbdZwKCxHFGd6X/CMWXsfHXMGbHhDKR/NK4AEvA3cjXnCJZJrdcqPYKH/g18nEos+SDXQ==
X-Received: by 2002:adf:edd1:: with SMTP id v17mr11105288wro.300.1552052252102;
        Fri, 08 Mar 2019 05:37:32 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:31 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 37/46] tools/lib/traceevent: Man pages for tep_parse_event() and tep_parse_format()
Date:   Fri,  8 Mar 2019 15:36:45 +0200
Message-Id: <20190308133654.21264-38-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_parse_event() and tep_parse_format()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-parse_event.txt             | 90 +++++++++++++++++++
 1 file changed, 90 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt b/tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt
new file mode 100644
index 000000000000..64c9f0df58aa
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt
@@ -0,0 +1,90 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_parse_event,tep_parse_format - Parse the event format information
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum tep_errno *tep_parse_event*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
+enum tep_errno *tep_parse_format*(struct tep_handle pass:[*]_tep_, struct tep_event pass:[*]pass:[*]_eventp_, const char pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
+--
+
+DESCRIPTION
+-----------
+The _tep_parse_event()_ function parses the event format and creates an event
+structure to quickly parse raw data for a given event. The _tep_ argument is
+the trace event parser context. The created event structure is stored in the
+_tep_ context. The _buf_ argument is a buffer with _size_, where the event
+format data is. The event format data can be taken from
+tracefs/events/.../.../format files. The _sys_ argument is the system of
+the event.
+
+The _tep_parse_format()_ function does the same as _tep_parse_event()_. The only
+difference is in the extra _eventp_ argument, where the newly created event
+structure is returned.
+
+RETURN VALUE
+------------
+Both _tep_parse_event()_ and _tep_parse_format()_ functions return 0 on success,
+or TEP_ERRNO__... in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+char *buf;
+int size;
+struct tep_event *event = NULL;
+buf = read_file("/sys/kernel/tracing/events/ftrace/print/format", &size);
+if (tep_parse_event(tep, buf, size, "ftrace") != 0) {
+	/* Failed to parse the ftrace print format */
+}
+
+if (tep_parse_format(tep, &event, buf, size, "ftrace") != 0) {
+	/* Failed to parse the ftrace print format */
+}
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


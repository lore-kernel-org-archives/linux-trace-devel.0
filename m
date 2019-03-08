Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7890C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85B952087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfCHNh0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:26 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44826 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfCHNh0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:26 -0500
Received: by mail-wr1-f66.google.com with SMTP id w2so21389336wrt.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K2nyS3OpjbzlgNx4KdcnUbUA5cdjGGXiq/FsyP8aCbE=;
        b=BWD2BBaiam2g/UbnrXkK7EweGKt2WVmwcRMSnZNTuRc3Bb8MDEAbcQsiSyI3p9Dtjq
         61jk5/aoetQkpqH0tNAD6uwDh1upvjW752GsGlIOT+ToUlxpBRRFpU2WsrRvLnahKFsN
         /7AL/UkJrR0gE8OCfchrtMmggKmp4Fmhlky5CC+cOOSksBwQk7a3U2EHO/CnI4vsId5E
         jlKLZyJol70gUSAwgniAe2TnAoKpmIObVDKVyiUI+D//EDUq1wzWLbkT4Bep2ljZpy+U
         81MyfK+en+9pwOVd5vbslDuu1st1/1EFE1ugSp4gsND10M0228YhJnzpcrWsH5CpDH/F
         Kcbg==
X-Gm-Message-State: APjAAAV57yOCnwjbbZkWgFytuE02/GaFQNtWesHyAAxuw+frwOXVkjJK
        d7vYZffCxQMsgsb+oShml5RYVmbi
X-Google-Smtp-Source: APXvYqxAkl6VY1BCPrW6GCHKnrX/8B4v2ie/eYHe13hdznYtkxa4OrirOkgE3Uryp3TsSZaLKDIpEA==
X-Received: by 2002:a05:6000:10cf:: with SMTP id b15mr11280406wrx.32.1552052244489;
        Fri, 08 Mar 2019 05:37:24 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:24 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 29/46] tools/lib/traceevent: Man page for tep_filter_strerror()
Date:   Fri,  8 Mar 2019 15:36:37 +0200
Message-Id: <20190308133654.21264-30-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_filter_strerror()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_error.txt            | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_error.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_error.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter_error.txt
new file mode 100644
index 000000000000..57bd19ad5d53
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_error.txt
@@ -0,0 +1,78 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_filter_strerror - Fills the filter error message in a buffer.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_filter_strerror*(struct tep_event_filter pass:[*]_filter_, enum tep_errno _err_, char pass:[*]buf, size_t _buflen_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_strerror()_ function copies the _filter_ error buffer into the
+given _buf_ with the size _buflen_. If the error buffer is empty, in the _buf_
+is copied a string, describing the error _err_.
+
+RETURN VALUE
+------------
+The _tep_filter_strerror()_ function returns 0 if message was filled
+successfully, or -1 in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+struct tep_event_filter *filter = tep_filter_alloc(tep);
+...
+int ret;
+char errstr[200];
+ret = tep_filter_add_filter_str(filter, "sched/sched_wakeup:target_cpu==1");
+if(ret < 0) {
+	tep_filter_strerror(filter, ret, errstr, sizeof(errstr));
+	/* Failed to add a new rule to the filter, the error string is in errstr */
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


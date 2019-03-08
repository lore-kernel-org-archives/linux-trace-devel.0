Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A08AC10F0C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CAEF2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfCHNho (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54797 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfCHNhn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:43 -0500
Received: by mail-wm1-f67.google.com with SMTP id f3so12671434wmj.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uF9DYVikNw0nzU/qEt8DMny7TZ9T/e4pyUutAT1d2GQ=;
        b=I3oAki6mAu1pjA9YY8rypF8m8LgNj2DxOKnddgoypxz8DdifCwFXuUTMiP8uOMvlOx
         05Fq9oFVmoQsufjWaoOklzgtljK+7XwQ+a3Mh/uKQjAE3zMNQgz1WalYIEhBYixQHXqF
         UjoYpU+hqduU26iLQ4mN56u/lyD8uHWcDkHdJUTg8U5ku3JuJW3yXU0N0VDtJZ96Jsns
         Kn0H7niLk+frN2kXboiprUv83Ia0bcHkdnKfAfV3+oG9l1iiT3MIM5/bxRFETs7YRrUY
         9VD1onrVQb8A0mUPL49A3pWKWT7ZHVDMr6MpfIuLUK2RejqhexLns7gvRiN/vo/elfOX
         uhQg==
X-Gm-Message-State: APjAAAU3x2EdDKPBbPBVE6WnVHhl6U2MAsypWNrUgkpyWLBL5bXhixt5
        ffwVyROxRrXk6R0NmASKFvQ=
X-Google-Smtp-Source: APXvYqxzXv7wI+F0PhL/FzwqJUVXyah4WjI5+hh4NgJNzvzi5JcKzFpMbfdzgGFeOuQ6wIUe33fzWQ==
X-Received: by 2002:a7b:c017:: with SMTP id c23mr9057414wmb.50.1552052261109;
        Fri, 08 Mar 2019 05:37:41 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:40 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 46/46] tools/lib/traceevent: Man pages for trace_seq_reset() and trace_seq_terminate()
Date:   Fri,  8 Mar 2019 15:36:54 +0200
Message-Id: <20190308133654.21264-47-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for trace_seq_reset() and trace_seq_terminate()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-tseq_reset.txt              | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_reset.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq_reset.txt b/tools/lib/traceevent/Documentation/libtraceevent-tseq_reset.txt
new file mode 100644
index 000000000000..a70c0b2f152f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq_reset.txt
@@ -0,0 +1,78 @@
+libtraceevent(3)
+================
+
+NAME
+----
+trace_seq_reset,trace_seq_terminate - Reset / terminate a trace sequence.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+void *trace_seq_reset*(struct trace_seq pass:[*]_s_);
+void *trace_seq_terminate*(struct trace_seq pass:[*]_s_);
+--
+
+DESCRIPTION
+-----------
+Trace sequences are used to allow a function to call several other functions
+to create a string of data to use.
+
+The _trace_seq_reset()_ function re-initializes the trace sequence _s_. All
+characters already written in _s_ will be deleted.
+
+The _trace_seq_terminate()_ function terminates the trace sequence _s_. It puts
+the null character pass:['\0'] at the end of the buffer.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct trace_seq seq;
+trace_seq_init(&seq);
+...
+trace_seq_reset(&seq);
+...
+trace_seq_terminate(&seq);
+...
+--
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*trace-seq.h*
+	Header file to include in order to have access to trace sequences related APIs.
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


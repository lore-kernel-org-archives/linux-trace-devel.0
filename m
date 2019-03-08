Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390E0C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18A4C2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfCHNhi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:38 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34731 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfCHNhi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:38 -0500
Received: by mail-wr1-f68.google.com with SMTP id f14so21397001wrg.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rxaTuOdFyr7viy6HJr4N/sRYnw3ZIhTdXnSHREWJTo0=;
        b=RlyV/myVfmgHcdbUiFYaeDur66vi/rTzUCQMzVmwTHbbFVpjyPkQnfRJGaFFIW5/M2
         M2AQZr7sf/WAc3CJtJWDEWdRqQG2DedCu/suT5U50hzn1Y+NgvZSZAz63MSdNWfM/e6w
         QK/uN5BgitjoelxgqEIe+RBTryaEXuGpnkxyPrkdoT04ig0hJ+uDakEUhcDKv72s8YPv
         IohLRsS3DoYynUA0SoPjif2heXb6mYuuL51Hpr2xmmQx+Fu9Ntwy5v7IU6Q4szt6WhT6
         0uoEmnKxllaPLaWOxuuXt2q/hX0Y/WUgquF2ebvnpONIcFfHQ9lhclvA2grfp4+vik2X
         krag==
X-Gm-Message-State: APjAAAXAGHWe0/4niS8BmyHFmPJ4CEwwQoZqvgPz6Fbx5i6dgu63JI5W
        Zqao5wrB00V5KHUoEYdR1M3C1IHi
X-Google-Smtp-Source: APXvYqxtdcE7AzMajG8V2V+vePkkLFyw/8r4Lww9sXbSSC/+e87g3GSTfKuBL0S2c/+Xh4YJYvQu7g==
X-Received: by 2002:a5d:4686:: with SMTP id u6mr11322144wrq.206.1552052257006;
        Fri, 08 Mar 2019 05:37:37 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:36 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 42/46] tools/lib/traceevent: Man pages for trace_seq_init() and trace_seq_destroy()
Date:   Fri,  8 Mar 2019 15:36:50 +0200
Message-Id: <20190308133654.21264-43-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for trace_seq_init() and trace_seq_destroy()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-tseq.txt      | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq.txt b/tools/lib/traceevent/Documentation/libtraceevent-tseq.txt
new file mode 100644
index 000000000000..d11732c460ba
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq.txt
@@ -0,0 +1,76 @@
+libtraceevent(3)
+================
+
+NAME
+----
+trace_seq_init,trace_seq_destroy - Initialize / destroy a trace sequence.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+void *trace_seq_init*(struct trace_seq pass:[*]_s_);
+void *trace_seq_destroy*(struct trace_seq pass:[*]_s_);
+--
+
+DESCRIPTION
+-----------
+Trace sequences are used to allow a function to call several other functions
+to create a string of data to use.
+
+The _trace_seq_init()_ function initializes the trace sequence _s_.
+
+The _trace_seq_destroy()_ function destroys the trace sequence _s_ and frees
+all its resources that it had used.
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
+trace_seq_destroy(&seq);
+...
+--
+
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


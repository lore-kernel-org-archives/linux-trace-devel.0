Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D88AC10F14
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD3932084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfDLNiW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36794 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfDLNiW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:22 -0400
Received: by mail-wr1-f67.google.com with SMTP id y13so12038721wrd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EgOzSQgupW8jx8Y3CtIHNk89ioZzbxqg1rnCSF3TTxE=;
        b=mYQWpHIYyE3EaMadIrcPs2HneiEZ/fA5K6VlirgYjHGSH+UgK4A+QAfnwNWk89Rs+p
         XA6Nv8uUMcYbtJ/KHwx9Xsq8vnrVFa/y1wchfI9Rqv8QXiBZnlMD8lATTtlIbUj1/Zgb
         LQmbP8zqRHB//h3ES7UQCz/advX1Roybqzd3jvWhw+TQ73Kpj7URHqvfOxLDotF2P0Zi
         A7HUKMuzRlmlw1wjFbfnMllcZPUqIn0bf0boTTHFwdBmgItQ1iHL5ayG8+mdv3yw4rFh
         RGwQ7aadfUyTxrQFbzetIVOtTa3FvJICf/jWV29aeUkTnKE61I1rdsElnRxfWlMHCtcV
         ZY7g==
X-Gm-Message-State: APjAAAVYeQKKgE3N+wt2rRLGG2393TMW//VVwv5mToStADS3rYrP4Xyw
        aC5WEFjDES1lYMWSknLyFqXcHlFf
X-Google-Smtp-Source: APXvYqydu3vmnPKLQFxapF5u2sOo9MvnbsCkKnyrBlJ5wE83J9amFCce5bW61B6+UmIKvnzUmm0ssg==
X-Received: by 2002:adf:ed8a:: with SMTP id c10mr28958742wro.40.1555076300953;
        Fri, 12 Apr 2019 06:38:20 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:20 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 09/30] tools/lib/traceevent: Man page for tep_strerror()
Date:   Fri, 12 Apr 2019 16:37:50 +0300
Message-Id: <20190412133811.15878-10-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_strerror() libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-strerror.txt  | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-strerror.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt b/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
new file mode 100644
index 000000000000..b3d625d01a8d
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
@@ -0,0 +1,80 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_strerror - Returns a string describing regular errno and tep error number.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnum_, char pass:[*]_buf_, size_t _buflen_);
+
+--
+DESCRIPTION
+-----------
+The _tep_strerror()_ function converts tep error number into a human
+readable string.
+The _tep_ argument is trace event parser context. The _errnum_ is a regular
+errno, defined in errno.h, or a tep error number. The string, describing this
+error number is copied in the _buf_ argument. The _buflen_ argument is
+the size of the _buf_.
+
+RETURN VALUE
+------------
+The _tep_strerror()_ function returns 0, if a valid _errnum_ is passed and the
+string is copied into _buf_. If _errnum_ is not a valid error number,
+-1 is returned and _buf_ is not modified.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+char buf[32];
+char *pool = calloc(1, 128);
+if (tep == NULL) {
+	tep_strerror(tep, TEP_ERRNO__MEM_ALLOC_FAILED, buf, 32);
+	printf ("The pool is not initialized, %s", buf);
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


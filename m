Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8C2C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6637D206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfECJLb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46967 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfECJLb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:31 -0400
Received: by mail-wr1-f67.google.com with SMTP id r7so6838259wrr.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NlMNWD+qEGWOcH44MjbyeRLiCuQsVhKEcjt4oXu1FcU=;
        b=og+/MVcPJXkky/4lVowmQpJe6if+4VimoQKtAZ5f1kjTFI92DJBlqc4tCVv3WGIH+b
         1SsbeFQB1uNMPTNbNtcjazTdCwSnvdI2ohXfXgLCQj0op5SAH8ibLQGYwcrZ+QrQo6l7
         KCcmMFJHRS8bv8SME5XZ+iItUX0BZrdsw+34dh5PrQe48lzkYdqG5NP/hMNPKGrW9aZh
         4Jw+ROLVw/yT1sMGGdjgo1y8Ig9O2epAHO7XGuh93FZSNMeHiLTQ30vF8Irc2H1XNL20
         VgF2UNIpV9gwYF4uMgFlVVnE1BahpM6UI1jEqOJJc/dSfOQMQZzufVa1vkJSKGXYP9CB
         IFSw==
X-Gm-Message-State: APjAAAUl7p2auzOmw4TQiJA/bxpJgrpOC4DCPxYCabUqd7gABEHRhrWh
        4dlE+LhdsIBIk8iQm9BXZVY=
X-Google-Smtp-Source: APXvYqzw6v5gp8lBj8+jxEB9o1pAADjUxHZ/JragRA1k9TkDwNcInJfdSuO8ZVNBJsLRRMfC4HzWqA==
X-Received: by 2002:a5d:604d:: with SMTP id j13mr6024969wrt.55.1556874689319;
        Fri, 03 May 2019 02:11:29 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:28 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 09/26] tools/lib/traceevent: Man page for tep_strerror()
Date:   Fri,  3 May 2019 12:11:02 +0300
Message-Id: <20190503091119.23399-10-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503091119.23399-1-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_strerror() libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-strerror.txt  | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-strerror.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt b/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
new file mode 100644
index 000000000000..14a9c6b916e1
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
@@ -0,0 +1,84 @@
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
+It as a thread safe wrapper around strerror_r(). The library function has two
+different behaviors - POSIX and GNU specific. The _tep_strerror()_ API behaves
+as the POSIX version - the error string is copied in the user supplied buffer.
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


Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39501C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 154472087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfCHNhb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:31 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36567 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbfCHNhb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:31 -0500
Received: by mail-wr1-f67.google.com with SMTP id o17so21412049wrw.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4AUlEZDXs0rJc3s+R/Ui2JHLB2ulm6OL4/sNQfEurS0=;
        b=iw7HDF9EZ8sPtnCf+p06ujKFzHwQxBBqOSyqi6xu2yj1+QEQFMjs8vpg0PmQfh4zrQ
         z/U+dFf2C+qh4vVxC4wOwRZbdP8ry3Q2paWZDQyc1TxG10kyopFnw8JonKJmBYrCBJAC
         fXc9qDM8Ffdfvn8xgvYiMplm0kHqTTPeEyqW0cqtTwL59pI034d+KPv7adwafcvuqltV
         T58YD/HviosAZMekzZBL2FPJkE8e/r25ijnv2VooFob2HjBXm+cplbWDEoo8QbDuD+B+
         PovmWxQ3hfNRRcoLfNzD3n2TDeT0+vBmKrcqZ4IIdm5cAOoqWA66Jni6G4aWMX6/Xn6Y
         zoDw==
X-Gm-Message-State: APjAAAX+wBts0dwlBqPclG31Hoka9NmEULucunpxy0Ft3tjlPHW7+KK+
        5LKOpsLo+y8WEeKzcexOszg=
X-Google-Smtp-Source: APXvYqzcINXbbvPy+ivMId77wtJDY3quv5zSZU0qDGx0qrPUY4XcelOkkqFAVLK5sAfkLJWuTsQFaA==
X-Received: by 2002:a5d:5386:: with SMTP id d6mr10513122wrv.104.1552052250300;
        Fri, 08 Mar 2019 05:37:30 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:29 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 35/46] tools/lib/traceevent: Man pages for tep_find_function() and tep_find_function_address()
Date:   Fri,  8 Mar 2019 15:36:43 +0200
Message-Id: <20190308133654.21264-36-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_find_function() and tep_find_function_address()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-func_find.txt | 88 +++++++++++++++++++
 1 file changed, 88 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_find.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-func_find.txt b/tools/lib/traceevent/Documentation/libtraceevent-func_find.txt
new file mode 100644
index 000000000000..04840e244445
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-func_find.txt
@@ -0,0 +1,88 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_find_function,tep_find_function_address - Find function name / start address.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
+unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
+--
+
+DESCRIPTION
+-----------
+These functions can be used to find function name and start address, by given
+address. The given address does not have to be exact, it will select the function
+that would contain it.
+
+The _tep_find_function()_ function returns the function name, which contains the
+given address _addr_. The _tep_ argument is the trace event parser context.
+
+The _tep_find_function_address()_ function returns the function start address,
+by given address _addr_. The _addr_ does not have to be exact, it will select the
+function that would contain it. The _tep_ argument is the trace event parser context.
+
+RETURN VALUE
+------------
+The _tep_find_function()_ function returns the function name, or NULL in case
+it cannot be found.
+
+The _tep_find_function_address()_ function returns the function start address,
+or 0 in case it cannot be found.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+void show_function( unsigned long long addr)
+{
+	const char *fname = tep_find_function(tep, addr);
+	unsigned long long fstart = tep_find_function_address(tep, addr);
+
+	/* addr is in function named fname, starting at fstart address, at offset (addr - fstart) */
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


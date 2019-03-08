Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7A2C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87A432087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbfCHNhd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:33 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44837 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfCHNhd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:33 -0500
Received: by mail-wr1-f68.google.com with SMTP id w2so21389709wrt.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oo0O/MAZmlGzFkHfBsIxr/+fbcPQYA6JQ+329h6gQlM=;
        b=DwALBS+sYB+20eVXoXDbyjJtykxSnI92pH8EDOoFmTqEnldAgWwjA1bSuIzPr7zOoV
         ADAvvRgaTFueMu+KvuwIoAP+ClZitht5QFgBoqLZO2MARGlNBwjqKbZxe1cqGvbkxrLE
         FQhYDlYVnzVlAgcbBbGp6ErwYJK3a9v+EfM7X7HFY1a71HDYsuxqhiPsqvxrUss968cd
         61u+njAWcVorEDPaxtC2T3ONJrV/oK8NVIWmpXagGMJd2Ijirn5a1e+4E8drUJTBhxoj
         /HS34OrmjFaTWSobSVx6+mjJ0yNCAP/TZJd1+kKw24yWHa4FQLbx3X3yPMHMVKGLuYg4
         D3/Q==
X-Gm-Message-State: APjAAAW7zv9qUGA+par6fNOSAs9vxsBX2JB/8YpKrWePLCDpS9sxUrXC
        +jUIV26fvF/v/OKs/ox7QTU=
X-Google-Smtp-Source: APXvYqykGFv9oTPVIQQKgkQvdwNKrcGKlwLih0LUQz6gJFBGxqLwHaSqszr09snDtqjiYWNAsQ6wGw==
X-Received: by 2002:adf:afe3:: with SMTP id y35mr10840515wrd.318.1552052251239;
        Fri, 08 Mar 2019 05:37:31 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:30 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 36/46] tools/lib/traceevent: Man pages for tep_set_function_resolver() and tep_reset_function_resolver()
Date:   Fri,  8 Mar 2019 15:36:44 +0200
Message-Id: <20190308133654.21264-37-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_set_function_resolver() and tep_reset_function_resolver()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-func_resolve.txt            | 96 +++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_resolve.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-func_resolve.txt b/tools/lib/traceevent/Documentation/libtraceevent-func_resolve.txt
new file mode 100644
index 000000000000..38b715bd926c
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-func_resolve.txt
@@ -0,0 +1,96 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_set_function_resolver,tep_reset_function_resolver - Set / reset an alternative function resolver
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+typedef char pass:[*](*tep_func_resolver_t*)(void pass:[*]_priv_, unsigned long long pass:[*]_addrp_, char pass:[**]_modp_);
+
+int *tep_set_function_resolver*(struct tep_handle pass:[*]_tep_, tep_func_resolver_t pass:[*]_func_, void pass:[*]_priv_);
+void *tep_reset_function_resolver*(struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+Some tools may have already a way to resolve the kernel functions. These APIs
+allow them to keep using it instead of duplicating all the entries inside.
+
+The _tep_set_function_resolver()_ function registers _func_ as an alternative
+kernel functions resolver. The _tep_ argument is trace event parser context.
+The _priv_ argument is a custom context of the _func_ function.
+
+The _tep_reset_function_resolver()_ function resets the kernel functions
+resolver to the default function.  The _tep_ argument is trace event parser
+context.
+
+The _tep_func_resolver_t_ type is the prototype of the alternative kernel
+functions resolver. This function receives a pointer to its custom context
+(set with the _tep_set_function_resolver()_ call ) and the address of a kernel
+function, which has to be resolved. In case of success, it should return
+the name of the function and its module (if any) in _modp_.
+
+RETURN VALUE
+------------
+The _tep_set_function_resolver()_ function returns 0 in case of success, or -1
+in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+char *my_resolve_kernel_addr(void *context, unsigned long long *addrp, char **modp)
+{
+	return NULL;
+}
+...
+	if (tep_set_function_resolver(tep, my_resolve_kernel_addr, NULL) != 0) {
+		/* failed to register my_resolve_kernel_addr */
+	}
+...
+	tep_reset_function_resolver(tep);
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


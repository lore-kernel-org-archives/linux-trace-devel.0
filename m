Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938ACC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FBFB2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfCHNhP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:15 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42272 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfCHNhP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:15 -0500
Received: by mail-wr1-f67.google.com with SMTP id r5so21382004wrg.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/rHvcNAVSxUe96RX1fH+jJRbSx39a+JiDDGo5Umc3Y=;
        b=E+l3UzgUYCXKJSQIwp/wgA+kc+XE+iHtMeTnPdOrz0LklX6fffQfljO7AlkuHLmzUt
         VhPgZWsHT5/eGSaK6ZwVHxHnwcIb0TeO69eSA6KGjAm21qIwMSl34zP9DXKzU8dpT9eF
         PCOSMpALgUz+3mBe27EiE/F5ytGKw2NGc151Lb54MqRX9JmMDuV4tNPO4Zr/rriXDVaX
         x4+NA++Ae3QMJJBee9uDwg45vQg6SbCg9MeZbMC3oDbVSpxtxMIH8jb4rbwXaiC9ZvqK
         YPQBVbSq5/2+5LDoTTn5MFrvKhyHdPn+p3dEP6P+mm3pjJ6ek5AeTAqWOspAm2siG4Ko
         HN5g==
X-Gm-Message-State: APjAAAXXV8Md+ZWm3/Yl86fWWh7S0X+7oeZ8e4ogjQhJq1e/ey1eWxUk
        Pe9EAKKLDXhPpvyeUnl7O0wD2RTt
X-Google-Smtp-Source: APXvYqxHXlS/nPiBV1gXu5M5Vrv6udzQ87IBQsU8DagUSkEDnYqqxkIVrEB/gOyMD7PzNEoAB2TSiw==
X-Received: by 2002:adf:9f54:: with SMTP id f20mr11289614wrg.88.1552052232579;
        Fri, 08 Mar 2019 05:37:12 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:11 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 16/46] tools/lib/traceevent: Man pages for tep_register_print_function() and tep_unregister_print_function()
Date:   Fri,  8 Mar 2019 15:36:24 +0200
Message-Id: <20190308133654.21264-17-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_register_print_function() and tep_unregister_print_function()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-reg_print_func.txt          | 128 ++++++++++++++++++
 1 file changed, 128 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
new file mode 100644
index 000000000000..59cef18b71f1
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
@@ -0,0 +1,128 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_register_print_function,tep_unregister_print_function - Registers / Unregisters
+a helper function.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_func_arg_type* {
+	TEP_FUNC_ARG_VOID,
+	TEP_FUNC_ARG_INT,
+	TEP_FUNC_ARG_LONG,
+	TEP_FUNC_ARG_STRING,
+	TEP_FUNC_ARG_PTR,
+	TEP_FUNC_ARG_MAX_TYPES
+};
+
+typedef unsigned long long (*pass:[*]tep_func_handler*)(struct trace_seq pass:[*]s, unsigned long long pass:[*]args);
+
+int *tep_register_print_function*(struct tep_handle pass:[*]_tep_, tep_func_handler _func_, enum tep_func_arg_type _ret_type_, char pass:[*]_name_, _..._);
+int *tep_unregister_print_function*(struct tep_handle pass:[*]_tep_, tep_func_handler _func_, char pass:[*]_name_);
+--
+
+DESCRIPTION
+-----------
+Some events may have helper functions in the print format arguments. This allows
+a plugin to dynamically create a way to process one of these functions.
+
+The _tep_register_print_function()_ registers such helper function. The _tep_
+argument is the trace event parser context. The _func_ argument is the address
+of the helper function. The _ret_type_ argument is  the return type of the
+helper function, value from the _tep_func_arg_type_ enum. The _name_ is the name
+of the helper function, as seen in the print format arguments. The _..._ is a
+variable list of _tep_func_arg_type_ enums, the _func_ function arguments.
+This list must end with _TEP_FUNC_ARG_VOID_.
+
+The _tep_unregister_print_function()_ unregisters a helper function, previously
+registered with _tep_register_print_function()_. The _tep_ argument is the
+trace event parser context. The _func_ and _name_ arguments are the same, used
+when the helper function was registered.
+
+The _tep_func_handler_ is the type of the helper function. The _s_ argument is
+the trace sequence, it can be used to create a custom string.
+The _args_  is a list of arguments, defined when the helper function was
+registered.
+
+RETURN VALUE
+------------
+The _tep_register_print_function()_ function returns 0 in case of success.
+In case of an error, TEP_ERRNO_... code is returned.
+
+The _tep_unregister_print_function()_ returns 0 in case of success, or -1 in
+case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+static long long
+process_custom_helper(struct trace_seq *s, unsigned long long *args)
+{
+	unsigned long long param = args[0];
+	trace_seq_printf(s, "the helper was called, with argument %lld", param);
+	return 0;
+}
+...
+	if ( tep_register_print_function(tep,
+				    process_custom_helper,
+				    TEP_FUNC_ARG_STRING,
+				    "custom_helper",
+				    TEP_FUNC_ARG_LONG,
+				    TEP_FUNC_ARG_VOID) != 0) {
+		/* Failed to register my process_custom_helper function */
+	}
+...
+	if (tep_unregister_print_function(tep, process_custom_helper,
+				      	  "custom_helper") != 0) {
+		/* Failed to unregister my process_custom_helper function */
+	}
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
+	Trace sequences are used to allow a function to call several other functions
+	to create a string of data to use.
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


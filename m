Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84333C04E87
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55F1B21848
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121938;
	bh=QS7Av0RHWpCgG60MpTZInt8QLnA+TY+wdp3PKR4FlnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=heEI6BzGZeDBPlzle6C77YR+ltrWYUoh/jdxEFGWhwggQJdKzkX0BtSN8SR9m+d8s
	 Oxa5Nvip+lAqS4NfIMi47hL7Fms/U1shd9gAIY9AisL7H+6rkfW6wfhwZSv+mtjxAO
	 tpefCf6rXfXSjErX04kBvZXBL4Qs6Ar0q11S0n2I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbfEQTio (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbfEQTio (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:38:44 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDB092182B;
        Fri, 17 May 2019 19:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121922;
        bh=QS7Av0RHWpCgG60MpTZInt8QLnA+TY+wdp3PKR4FlnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOarFsE6+fGF3doWy5jdGjIfHgCF6uzZRzrO0oAmRmdp33wPHLKjKyHuHRZbQZldr
         MULK3SCbFIZDaj39SotjHjgCESjTat1VPOYnb+pI9MZ9DpmULxRi/o41Pa1iY37gjU
         AXfGfFcQbtyhqlaOVvCX/zz24e+Zsjsdx1WrqQms=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 32/73] tools lib traceevent: Man pages for registering print function
Date:   Fri, 17 May 2019 16:35:30 -0300
Message-Id: <20190517193611.4974-33-acme@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517193611.4974-1-acme@kernel.org>
References: <20190517193611.4974-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man pages for libtraceevent APIs:

  tep_register_print_function()
  tep_unregister_print_function()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20190510200107.857252818@goodmis.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-13-tstoyanov@vmware.com
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../libtraceevent-reg_print_func.txt          | 155 ++++++++++++++++++
 1 file changed, 155 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
new file mode 100644
index 000000000000..708dce91ebd8
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
@@ -0,0 +1,155 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_register_print_function,tep_unregister_print_function -
+Registers / Unregisters a helper function.
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
+Some events may have helper functions in the print format arguments.
+This allows a plugin to dynamically create a way to process one of
+these functions.
+
+The _tep_register_print_function()_ registers such helper function. The _tep_
+argument is the trace event parser context. The _func_ argument  is a pointer
+to the helper function. The _ret_type_ argument is  the return type of the
+helper function, value from the _tep_func_arg_type_ enum. The _name_ is the name
+of the helper function, as seen in the print format arguments. The _..._ is a
+variable list of _tep_func_arg_type_ enums, the _func_ function arguments.
+This list must end with _TEP_FUNC_ARG_VOID_. See 'EXAMPLE' section.
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
+Some events have internal functions calls, that appear in the print format
+output. For example "tracefs/events/i915/g4x_wm/format" has:
+[source,c]
+--
+print fmt: "pipe %c, frame=%u, scanline=%u, wm %d/%d/%d, sr %s/%d/%d/%d, hpll %s/%d/%d/%d, fbc %s",
+	    ((REC->pipe) + 'A'), REC->frame, REC->scanline, REC->primary,
+	    REC->sprite, REC->cursor, yesno(REC->cxsr), REC->sr_plane,
+	    REC->sr_cursor, REC->sr_fbc, yesno(REC->hpll), REC->hpll_plane,
+	    REC->hpll_cursor, REC->hpll_fbc, yesno(REC->fbc)
+--
+Notice the call to function _yesno()_ in the print arguments. In the kernel
+context, this function has the following implementation:
+[source,c]
+--
+static const char *yesno(int x)
+{
+	static const char *yes = "yes";
+	static const char *no = "no";
+
+	return x ? yes : no;
+}
+--
+The user space event parser has no idea how to handle this _yesno()_ function.
+The _tep_register_print_function()_ API can be used to register a user space
+helper function, mapped to the kernel's _yesno()_:
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+static const char *yes_no_helper(int x)
+{
+	return x ? "yes" : "no";
+}
+...
+	if ( tep_register_print_function(tep,
+				    yes_no_helper,
+				    TEP_FUNC_ARG_STRING,
+				    "yesno",
+				    TEP_FUNC_ARG_INT,
+				    TEP_FUNC_ARG_VOID) != 0) {
+		/* Failed to register yes_no_helper function */
+	}
+
+/*
+   Now, when the event parser encounters this yesno() function, it will know
+   how to handle it.
+*/
+...
+	if (tep_unregister_print_function(tep, yes_no_helper, "yesno") != 0) {
+		/* Failed to unregister yes_no_helper function */
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
+	Header file to include in order to have access to trace sequences
+	related APIs. Trace sequences are used to allow a function to call
+	several other functions to create a string of data to use.
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


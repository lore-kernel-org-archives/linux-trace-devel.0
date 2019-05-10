Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81854C04AB2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46ACC217F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfEJUCn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 16:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbfEJUBJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 16:01:09 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A735821851;
        Fri, 10 May 2019 20:01:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hPBhb-0006jP-QE; Fri, 10 May 2019 16:01:07 -0400
Message-Id: <20190510200107.701962205@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 10 May 2019 15:56:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 12/27] tools/lib/traceevent: Man pages for function related libtraceevent
 APIs
References: <20190510195606.537643615@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Added new man pages, describing function related libtraceevent APIs:
  tep_register_function(),
  tep_register_print_string(),
  tep_find_function(),
  tep_find_function_address(),
  tep_set_function_resolver(),
  tep_reset_function_resolver()

Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-12-tstoyanov@vmware.com

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../Documentation/libtraceevent-func_apis.txt | 183 ++++++++++++++++++
 .../Documentation/libtraceevent-func_find.txt |  88 +++++++++
 2 files changed, 271 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_find.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt b/tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt
new file mode 100644
index 000000000000..38bfea30a5f6
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt
@@ -0,0 +1,183 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_find_function, tep_find_function_address, tep_set_function_resolver,
+tep_reset_function_resolver, tep_register_function, tep_register_print_string -
+function related tep APIs
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+typedef char pass:[*](*tep_func_resolver_t*)(void pass:[*]_priv_, unsigned long long pass:[*]_addrp_, char pass:[**]_modp_);
+int *tep_set_function_resolver*(struct tep_handle pass:[*]_tep_, tep_func_resolver_t pass:[*]_func_, void pass:[*]_priv_);
+void *tep_reset_function_resolver*(struct tep_handle pass:[*]_tep_);
+const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
+unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
+int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
+int *tep_register_print_string*(struct tep_handle pass:[*]_tep_, const char pass:[*]_fmt_, unsigned long long _addr_);
+--
+
+DESCRIPTION
+-----------
+Some tools may have already a way to resolve the kernel functions. These APIs
+allow them to keep using it instead of duplicating all the entries inside.
+
+The _tep_func_resolver_t_ type is the prototype of the alternative kernel
+functions resolver. This function receives a pointer to its custom context
+(set with the _tep_set_function_resolver()_ call ) and the address of a kernel
+function, which has to be resolved. In case of success, it should return
+the name of the function and its module (if any) in _modp_.
+
+The _tep_set_function_resolver()_ function registers _func_ as an alternative
+kernel functions resolver. The _tep_ argument is trace event parser context.
+The _priv_ argument is a custom context of the _func_ function. The function
+resolver is used by the APIs _tep_find_function()_,
+_tep_find_function_address()_, and _tep_print_func_field()_ to resolve
+a function address to a function name.
+
+The _tep_reset_function_resolver()_ function resets the kernel functions
+resolver to the default function.  The _tep_ argument is trace event parser
+context.
+
+
+These APIs can be used to find function name and start address, by given
+address. The given address does not have to be exact, it will select
+the function that would contain it.
+
+The _tep_find_function()_ function returns the function name, which contains the
+given address _addr_. The _tep_ argument is the trace event parser context.
+
+The _tep_find_function_address()_ function returns the function start address,
+by given address _addr_. The _addr_ does not have to be exact, it will select
+the function that would contain it. The _tep_ argument is the trace event
+parser context.
+
+The _tep_register_function()_ function registers a function name mapped to an
+address and (optional) module. This mapping is used in case the function tracer
+or events have "%pF" or "%pS" parameter in its format string. It is common to
+pass in the kallsyms function names with their corresponding addresses with this
+function. The _tep_ argument is the trace event parser context. The _name_ is
+the name of the function, the string is copied internally. The _addr_ is
+the start address of the function. The _mod_ is the kernel module
+the function may be in (NULL for none).
+
+The _tep_register_print_string()_ function  registers a string by the address
+it was stored in the kernel. Some strings internal to the kernel with static
+address are passed to certain events. The "%s" in the event's format field
+which has an address needs to know what string would be at that address. The
+tep_register_print_string() supplies the parsing with the mapping between kernel
+addresses and those strings. The _tep_ argument is the trace event parser
+context. The _fmt_ is the string to register, it is copied internally.
+The _addr_ is the address the string was located at.
+
+
+RETURN VALUE
+------------
+The _tep_set_function_resolver()_ function returns 0 in case of success, or -1
+in case of an error.
+
+The _tep_find_function()_ function returns the function name, or NULL in case
+it cannot be found.
+
+The _tep_find_function_address()_ function returns the function start address,
+or 0 in case it cannot be found.
+
+The _tep_register_function()_ function returns 0 in case of success. In case of
+an error -1 is returned, and errno is set to the appropriate error number.
+
+The _tep_register_print_string()_ function returns 0 in case of success. In case
+of an error -1 is returned, and errno is set to the appropriate error number.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+char *my_resolve_kernel_addr(void *context,
+			     unsigned long long *addrp, char **modp)
+{
+	struct db *function_database = context;
+	struct symbol *sym = sql_lookup(function_database, *addrp);
+
+	if (!sym)
+		return NULL;
+
+	*modp = sym->module_name;
+	return sym->name;
+}
+
+void show_function( unsigned long long addr)
+{
+	unsigned long long fstart;
+	const char *fname;
+
+	if (tep_set_function_resolver(tep, my_resolve_kernel_addr,
+				      function_database) != 0) {
+		/* failed to register my_resolve_kernel_addr */
+	}
+
+	/* These APIs use my_resolve_kernel_addr() to resolve the addr */
+	fname = tep_find_function(tep, addr);
+	fstart = tep_find_function_address(tep, addr);
+
+	/*
+	   addr is in function named fname, starting at fstart address,
+	   at offset (addr - fstart)
+	*/
+
+	tep_reset_function_resolver(tep);
+
+}
+...
+	if (tep_register_function(tep, "kvm_exit",
+				(unsigned long long) 0x12345678, "kvm") != 0) {
+		/* Failed to register kvm_exit address mapping */
+	}
+...
+	if (tep_register_print_string(tep, "print string",
+				(unsigned long long) 0x87654321, NULL) != 0) {
+		/* Failed to register "print string" address mapping */
+	}
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



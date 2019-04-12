Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF0EC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 571372084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfDLNi1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52613 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfDLNi1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id a184so11295269wma.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CY1D/yN46Y8efOfIDfVfmxQVFib2qqsDhe066xRSLHQ=;
        b=C8mmD7UJ9W4P2kd4biFzp7w1VCn7IlEnR5SpkOcNnqfzroElJEjn8/rKtINiwPm8iI
         TYhc429pEpe4/HPRhpUBcu6X5Sh5Kreb9Bty7YA5CbNgoaPtVONRfmxt+cHKfkF0U62Q
         wVEQPehUERL4VJ0XJBQlJvnZL8M1Ta47Y5AIl4j+DPN4Uf2CzMIq3svydcgzRfuiACRZ
         e8pYvhUcy6f83a8YfgLXYeiAWxlTi3xM1w6/A1WkfVSBix6yJ6v4qIoZyHY9/UCTXtl2
         x1RtPkHJsuOd0OMZIuV+RTAvKZEWRyT6PEQg28egm+McEHz1VbWMhzybZKn5l9UhB4ra
         Xsfw==
X-Gm-Message-State: APjAAAVJp4eNiiXacD1YfklovDp5UrVEDPQRbC2mfPSp41U7Mpu/LZ8M
        uTZ5TybI4pZxIhCr0t52WoQ=
X-Google-Smtp-Source: APXvYqwQSkU2JpuOEmvzxcXow6WPXcD/iM5kGOiNw77pd/WEDVAwJ7DtZUnU42js+/NpcXx0aEt3Ow==
X-Received: by 2002:a7b:c00e:: with SMTP id c14mr11663189wmb.110.1555076304615;
        Fri, 12 Apr 2019 06:38:24 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:23 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 13/30] tools/lib/traceevent: Man pages for registering print function
Date:   Fri, 12 Apr 2019 16:37:54 +0300
Message-Id: <20190412133811.15878-14-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for libtraceevent APIs:
  tep_register_print_function()
  tep_unregister_print_function()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-reg_print_func.txt          | 155 ++++++++++++++++++
 1 file changed, 155 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
new file mode 100644
index 000000000000..d95e0b19e4ca
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
+The _tep_register_print_function()_ API can be used to register an user space
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


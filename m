Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F96DC4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D3012087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfCHNhN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40360 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfCHNhN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:13 -0500
Received: by mail-wr1-f68.google.com with SMTP id t6so2188128wrw.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/4n/L2s0dTIzxQAtSNlZSWxxEJquqJsNBgrWC2/+lNA=;
        b=TSa5jnm5lab0VvsqHqgfvS4VHc4r+KIxvgBh/UiELhB4qERhGvb8I8SD9zfWYrluF5
         xQgScG2H6tY2kmm2glr4VOtqfVQveB/lPd+Y0HMTIUoCVrSi2Nf7dTi0OI012qKer120
         kyVp1QOxPL43v3/VJcZx0XLE9z9dageVvumEWj2EPQFYjkzwgCJEm0oTN/9hyFXIGFIb
         V1lJ+ZHVo/VGCrcx1tIPmdlQ+jljZACf2HPgepqcG1GfxaSNcnooVOQwVLeEjv/cUNlc
         LEYenEjq+4zJCtEkUG7Cw/6hUVJj25f0ECerR4Z7IhKlyp68eIo7Ru7xiw7X6I1ITtKM
         cTeA==
X-Gm-Message-State: APjAAAXS+UgrGaq4uuRVLTFVpam48H4bAInwOkLiej6rBuPUfS5fnkXw
        jc46ogD9mqNBO9FWEZgwaXGTsezq
X-Google-Smtp-Source: APXvYqxuwSVEO04QbzX/Y0uz9ApFLOdZqJ06d4ttzAix2qhEjQV9TaLHKe8ITcs8tOeWvQmt2aLeHg==
X-Received: by 2002:adf:f40d:: with SMTP id g13mr10947382wro.18.1552052231607;
        Fri, 08 Mar 2019 05:37:11 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:11 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 15/46] tools/lib/traceevent: Man pages for tep_register_function() and tep_register_print_string()
Date:   Fri,  8 Mar 2019 15:36:23 +0200
Message-Id: <20190308133654.21264-16-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_register_function() and tep_register_print_string()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-reg_funcstr.txt             | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt
new file mode 100644
index 000000000000..fdb9e0352586
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt
@@ -0,0 +1,89 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_register_function, tep_register_print_string - Registers a function / string
+with a given address.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
+int *tep_register_print_string*(struct tep_handle pass:[*]_tep_, const char pass:[*]_fmt_, unsigned long long _addr_);
+--
+
+DESCRIPTION
+-----------
+The _tep_register_function()_ function registers a function name with an
+address and module. The _tep_ argument is the trace event parser context. The
+_name_ is the name of the function, the string is copied internally. The _addr_
+is the start address of the function. The _mod_ is the kernel module
+the function may be in (NULL for none).
+
+The _tep_register_print_string()_ function  registers a string by the address
+it was stored in the kernel. The _tep_ argument is the trace event parser
+context. The _fmt_ is the string to register, it is copied internally. The _addr_
+is the address the string was located at.
+
+RETURN VALUE
+------------
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
+	if (tep_register_function(tep, "my_custom_func",
+			  	 (unsigned long long) 0x12345678, NULL) != 0) {
+		/* Failed to register my_custom_func address mapping */
+	}
+...
+	if (tep_register_print_string(tep, "print string",
+			  	 (unsigned long long) 0x87654321, NULL) != 0) {
+		/* Failed to register "print string" address mapping */
+	}
+--
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


Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E13C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FECB2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfCHNhN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39568 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfCHNhN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:13 -0500
Received: by mail-wr1-f68.google.com with SMTP id l12so4941071wrp.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qEx2avDLM7gbP4wxYMZBd5eHGGBftNDQRqqfbx8Z/do=;
        b=oThugCv5DnzcFTeiqlA25UbPHeMBK6A+/qKgJx7W/S62HeWRFecoGD91XSIia80Nrb
         K7N4T68F/8pLPt/80IHStlksNL92wbFxsF9R/J8iAEM/bLUMdhTSDcCxSVZ3eEHH6Fqy
         r/bJYxLHYL5PNsCw00g2aTNF9loN+8I0ogrVawhIjT3R/HSsPQhMH7/5K/xmHVykXgMV
         MtyKXd7fDNoPZa2qs8wvrM7wiKVC/wQTSGX9OvDil1ZuCZJ5sxClnU7wm+4HVs4z7sc8
         eXOThpZ1ZtTjI6f8LpliybHvEsV0Uz3qR5GQq8g8cV5FHCYMxIB5dBcFi/k+tSDBhMVm
         SiAQ==
X-Gm-Message-State: APjAAAUdMYVenMI75eyjo/Jqn2eys75qM2bA/cqSgvmsSwl1i/+5F/Ga
        HEhwgLuaNX2+luyCFnwK0r2AS+oP
X-Google-Smtp-Source: APXvYqy3eW8S3ddEm01mHPxjEPTCkKs8dOGhxX8BC7drYjJC2KoCsRwdnpKAgDjJuyKmkEyAJAUh2Q==
X-Received: by 2002:a5d:6542:: with SMTP id z2mr10906834wrv.237.1552052230874;
        Fri, 08 Mar 2019 05:37:10 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:10 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 14/46] tools/lib/traceevent: Man pages for tep_register_event_handler() and tep_unregister_event_handler()
Date:   Fri,  8 Mar 2019 15:36:22 +0200
Message-Id: <20190308133654.21264-15-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_register_event_handler() and tep_unregister_event_handler()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-reg_event_handler.txt       | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt
new file mode 100644
index 000000000000..bf96dc825e19
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt
@@ -0,0 +1,129 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_register_event_handler,tep_unregister_event_handler -  Register / unregisters
+a callback function to parse an event information.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_reg_handler* {
+	_TEP_REGISTER_SUCCESS_,
+	_TEP_REGISTER_SUCCESS_OVERWRITE_,
+};
+
+int *tep_register_event_handler*(struct tep_handle pass:[*]_tep_, int _id_, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_event_handler_func _func_, void pass:[*]_context_);
+int *tep_unregister_event_handler*(struct tep_handle pass:[*]tep, int id, const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_handler_func func, void pass:[*]_context_);
+
+typedef int (*pass:[*]tep_event_handler_func*)(struct trace_seq pass:[*]s, struct tep_record pass:[*]record, struct tep_event pass:[*]event, void pass:[*]context);
+--
+
+DESCRIPTION
+-----------
+The _tep_register_event_handler()_ function registers a handler function,
+which is going to be called to parse the information for a given event.
+The _tep_ argument is the trace event parser context. The _id_ argument is
+the id of the event. The _sys_name_ argument is the name of the system,
+the event belongs to. The _event_name_ argument is the name of the event.
+If _id_ is >= 0, it is used to find the event, otherwise _sys_name_ and
+_event_name_ are used. The _func_ is a pointer to the function, which is going
+to be called to parse the event information. The _context_ argument is a pointer
+to the context data, which will be passed to the _func_. If a handler function
+for the same event is already registered, it will be overridden with the new
+one. This mechanism allows a developer to override the parsing of a given event.
+If for some reason the default print format is not sufficient, the developer
+can register a function for an event to be used to parse the data instead.
+
+The _tep_unregister_event_handler()_ function unregisters the handler function,
+previously registered with _tep_register_event_handler()_. The _tep_ argument
+is the trace event parser context. The _id_, _sys_name_, _event_name_, _func_,
+and _context_ are the same arguments, as when the callback function _func_ was
+registered.
+
+The _tep_event_handler_func_ is the type of the custom event handler
+function. The _s_ argument is the trace sequence, it can be used to create a
+custom string, describing the event. A _record_  to get the event from is passed
+as input parameter and also the _event_ - the handle to the record's event. The
+_context_ is custom context, set when the custom event handler is registered.
+
+RETURN VALUE
+------------
+The _tep_register_event_handler()_ function returns _TEP_REGISTER_SUCCESS_
+if the new handler is registered successfully or _TEP_REGISTER_SUCCESS_OVERWRITE_ if
+an existing handler is overwritten. If there is not  enough memory to complete
+the registration, TEP_ERRNO__MEM_ALLOC_FAILED is returned.
+
+The _tep_unregister_event_handler()_ function returns 0 if _func_ was removed
+successful or, -1 if the event was not found.
+
+The _tep_event_handler_func_ should return -1 in case of an error, or 0 otherwise.
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
+int custom_event_handler(struct trace_seq *s, struct tep_record *record,
+			 struct tep_event *event, void *context)
+{
+	trace_seq_printf(s, "kvm_exit event");
+	return 0;
+}
+...
+	if (tep_register_event_handler(tep, -1, "kvm", "kvm_exit",
+				   custom_event_handler, NULL)) {
+	/* Failed to register the handler for event "kvm_exit" from "kvm" system */
+	}
+...
+	if (tep_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
+				     custom_event_handler, NULL) != ) {
+	/* Failed to unregister the handler for event "kvm_exit" from "kvm" system */
+	}
+
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


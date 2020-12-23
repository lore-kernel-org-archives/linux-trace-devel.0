Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3EEC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11B1720936
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 04:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgLWEfQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgLWEfQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 23:35:16 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0174C061794
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:35 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id 91so17341526wrj.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 20:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G4+1mxLSkD5Jqgk/EFsgqdRCUpuErUS8PeWMv+kyQw4=;
        b=jBHAMn28GPMz84tMnno3cj8B6DZdg2dfMmcHPoB2PnMxZXzi4cLG0GLt0xtQKwv54F
         HHEncXDT0FjPXhZUtry06wEXAsrvrZ5jH2xeIstyZWypC0+WR1MUkbxlMfgXjSA+bhC3
         Cx8L1eXatIfLb+flVu71VdrpMDWXtv22ex8075WN8ukBVQTuoZOiL5KY2x69rJNvVgHS
         jtz6JPrgU7sIResfBxTNB8mk214jMiLMYtdNuQT3mfZ8HoNjAn6/wxkP2U5bhzp2Q2kt
         9FKHvftbAft0QdHxAaxKS+yeFPCbu9Jaq8Cb8e1nzgn5CjnJIRJYEn2HvE20GkfJWnUi
         dfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G4+1mxLSkD5Jqgk/EFsgqdRCUpuErUS8PeWMv+kyQw4=;
        b=XFTqtKAUMROhHtRAITZzlkyXf3Eg0GvSonYG1EiiD41gfAG6+zPjGKAWI/uZtR4YRy
         WVd9IG0MyGBUE/PN+7y3LLkOi4t/TTfYfWushNMur7k5Ek3Ti5cwA0XGqtEm6Tj86H3E
         UzZzkKs9USxa6TPPnG82c4S6vwM+Uivq+wmr1qdtUCXdlRdPVUNLaKSx6tkVmAgrXp6V
         tU3YDkDHJwhddw5LJLifaKzXpYQ1dJ/FBPt7J+VSNa9HMfvIA43zk8x3fhooENmj2etw
         Q9+f+QPFHb9jxg3PHJZFxUF5gLgDg/KJja99CT9EHjFJtGYvUsYgBe2rIx+TqCSc23+7
         QimA==
X-Gm-Message-State: AOAM533SN2u0tjW4C/5CQdaHBZ9IpjtBjxIbn4KN0uk4YECDlZvee3Vn
        AImsAUPKWtOzfcOOuoWMO38mdk2zGg3VB/77
X-Google-Smtp-Source: ABdhPJx40dkhsSh1kEvvo37dodCWD3BEXbROpa0Tuw5e5uCjXKAuY+/8GSUPEgU9h9ya2optWlcbpQ==
X-Received: by 2002:a5d:4f90:: with SMTP id d16mr26943581wru.120.1608698074763;
        Tue, 22 Dec 2020 20:34:34 -0800 (PST)
Received: from oberon.vmware.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s13sm28909095wmj.28.2020.12.22.20.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 20:34:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/6] trace-cmd library man pages: Read recorded events from a trace file.
Date:   Wed, 23 Dec 2020 06:34:26 +0200
Message-Id: <20201223043429.586162-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201223043429.586162-1-tz.stoyanov@gmail.com>
References: <20201223043429.586162-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
 tracecmd_init_data()
 tracecmd_read_cpu_first()
 tracecmd_read_data()
 tracecmd_read_at()
 tracecmd_free_record()
 tracecmd_get_tep()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../libtracecmd/libtracecmd-record.3.txt      | 152 ++++++++++++++++++
 1 file changed, 152 insertions(+)
 create mode 100644 Documentation/libtracecmd/libtracecmd-record.3.txt

diff --git a/Documentation/libtracecmd/libtracecmd-record.3.txt b/Documentation/libtracecmd/libtracecmd-record.3.txt
new file mode 100644
index 00000000..194b1670
--- /dev/null
+++ b/Documentation/libtracecmd/libtracecmd-record.3.txt
@@ -0,0 +1,152 @@
+libtracecmd(3)
+=============
+
+NAME
+----
+tracecmd_init_data, tracecmd_read_cpu_first, tracecmd_read_data
+tracecmd_read_at, tracecmd_free_record, tracecmd_get_tep
+- Read recorded events from a trace file.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <trace-cmd.h>*
+
+int *tracecmd_init_data*(struct tracecmd_input pass:[*]_handle_);
+struct tep_record pass:[*]*tracecmd_read_cpu_first*(struct tracecmd_input pass:[*]_handle_, int _cpu_);
+struct tep_record pass:[*]*tracecmd_read_data*(struct tracecmd_input pass:[*]_handle_, int _cpu_);
+struct tep_record pass:[*]*tracecmd_read_at*(struct tracecmd_input pass:[*]_handle_, unsigned long long _offset_, int pass:[*]_cpu_);
+void *tracecmd_free_record*(struct tep_record pass:[*]_record_);
+struct tep_handle pass:[*]*tracecmd_get_tep*(struct tracecmd_input pass:[*]_handle_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to read tracing data from a trace file opened
+with _tracecmd_open_head()(3)_
+
+The _tracecmd_init_data()_ function initializes the _handle_ for reading
+trace data from the file associated with it. This API must be called before
+any of the _tracecmd_read__ APIs.
+
+The _tracecmd_read_cpu_first()_ function reads the first trace record
+for a given _cpu_ from a trace file associated with _handle_. The returned
+record must be freed with _tracecmd_free_record()_.
+
+The _tracecmd_read_data()_ function reads the next trace record for
+a given _cpu_ from a trace file associated with _handle_ and increments
+the read location pointer, so that the next call to _tracecmd_read_data()_
+will not read the same record again. The returned record must be freed
+with _tracecmd_free_record()_.
+
+The _tracecmd_read_at()_ function reads a trace record from a specific
+_offset_ within the file associated with _handle_. The CPU on which the
+recorded event occurred is stored in the _cpu_. The function does not
+change the current read location pointer. The returned record must be
+freed with _tracecmd_free_record()_.
+
+The _tracecmd_free_record()_ function frees a _record_ returned by any
+of the _tracecmd_read__ APIs.
+
+The _tracecmd_get_tep()_ function returns a tep context for a given
+_handle_.
+
+RETURN VALUE
+------------
+The _tracecmd_init_data()_ function returns -1 in case of an error or
+0 otherwise.
+
+The _tracecmd_read_cpu_first()_, _tracecmd_read_data()_ and
+_tracecmd_read_at()_ functions return a pointer to struct tep_record or
+NULL in case of an error.The returned record must be freed with
+_tracecmd_free_record()_.
+
+The _tracecmd_get_tep()_ function returns a pointer to tep context or
+NULL if there is no tep context for the given _handle_. The returned
+tep pointer must *not* be freed.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <trace-cmd.h>
+...
+struct tracecmd_input *handle = tracecmd_open_head("trace.dat");
+	if (!handle) {
+		/* Failed to open trace.dat file */
+	}
+...
+unsigned long long offset = 0;
+struct tep_record *rec;
+int cpu = 0;
+
+	if (tracecmd_init_data(handle) < 0) {
+		/* Failed to initialize hadle for reading the trace data */
+	}
+
+	rec = tracecmd_read_cpu_first(handle, cpu);
+	while (rec) {
+		...
+		if ( /* some interesting record noticed */) {
+			/* store the offset of the interesting record */
+			offset = rec->offset;
+		}
+		...
+		tracecmd_free_record(rec);
+		rec = tracecmd_read_data(handle, cpu);
+	}
+	...
+	if (offset) {
+		rec = tracecmd_read_at(handle, offset, &cpu);
+		if (rec) {
+			/* Got record at offset on cpu */
+			...
+			tracecmd_free_record(rec);
+		}
+	}
+
+...
+	tracecmd_close(hadle);
+
+--
+FILES
+-----
+[verse]
+--
+*trace-cmd.h*
+	Header file to include in order to have access to the library APIs.
+*-libtracecmd*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+_trace-cmd.dat(5)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracecmd is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.28.0


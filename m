Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62327C433E9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 04:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 329F523122
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 04:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgLVExu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 23:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVExt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 23:53:49 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65735C0613D6
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 20:53:09 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id t30so13252334wrb.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 20:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sEfskUCaMtIg5ObFzR2e1RiHkRq6t351yM0xRx7rYSU=;
        b=Tu/bo7V33RgXnFsQRt7/6i1BFHrpXXViD78Wabg/IZ+//lffmTcGmC0WErzhcR3m1/
         icNlU99Lpn/oIhbetgXUkZSkaT9tgJ6OBexqTiJkcP1/VE3Vibv9WS1evjYCa6K1+S12
         VNZRdfXXLcCF25Mhaot3r6qnRqZ//UIoNgDeM7L0MEIv87xzyyfSD97MX4sjhSQ23sb8
         DiW9yFsyot/SnxGjd7H5o/ni3D87JNqo3MeIXDpC24kRNcO2S+4c1c6CJGwPX3SbfKiU
         FQRREZkvedXqVyAO+02otHVDFxePUCkfJwXhIQdWGTF1oCUgULnzWU+G/MgXrp/Lolil
         1TPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sEfskUCaMtIg5ObFzR2e1RiHkRq6t351yM0xRx7rYSU=;
        b=OH7xMieY4kirQF5i9bbj3EwMbBuZ5EXJc/lMsnPv2RwnCr8/RGNA9TpDzDFHToojqr
         7kPa8hyS0U1PV7uFoONwZewYacDcjD0mT8TUkHyZyvoenZe/1vr+Swx88SJJ5hrf2joh
         f2uS8X84c1qSsQrUrdOzCobHpX19xv5+HzovPgRmdpnxVkzhyFNAOuqLgVwdRprF7AP/
         S64RFN1ntbLXEBvP3wjYSfGT7xok5Imr5tcBVjFiZGsayFcMFZnQZ9CKj6U10IzknI9z
         0RTUoJh7XZ6PYVYjUHalTfEjNxSCzX254qX+nCvN1/lUOSxgs+DiWu/jiYRt9Z5oPozm
         jG9Q==
X-Gm-Message-State: AOAM533lUx+CTNe4tPo/O1HvMDm5s3FE49K1UEnSY8UxXKNURrue88nk
        3aatKYehzZfsVWi33vxY+kI=
X-Google-Smtp-Source: ABdhPJyrZtQy8RXDBIhP4amgwBSlnDLhTMVz1GAoeowOMg+M3UAXOKvMAIYcFXNBGHtFKqUwCm78ZA==
X-Received: by 2002:adf:ed49:: with SMTP id u9mr22312952wro.292.1608612788173;
        Mon, 21 Dec 2020 20:53:08 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c7sm32924159wro.16.2020.12.21.20.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 20:53:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/2] libtracefs man pages: APIs for initializing a tep handler with trace events from the local system.
Date:   Tue, 22 Dec 2020 06:53:03 +0200
Message-Id: <20201222045304.369175-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201222045304.369175-1-tz.stoyanov@gmail.com>
References: <20201222045304.369175-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_local_events()
tracefs_local_events_system()
tracefs_fill_local_events()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-events-tep.txt | 130 ++++++++++++++++++++++++
 1 file changed, 130 insertions(+)
 create mode 100644 Documentation/libtracefs-events-tep.txt

diff --git a/Documentation/libtracefs-events-tep.txt b/Documentation/libtracefs-events-tep.txt
new file mode 100644
index 0000000..f7d7a61
--- /dev/null
+++ b/Documentation/libtracefs-events-tep.txt
@@ -0,0 +1,130 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_local_events, tracefs_local_events_system, tracefs_fill_local_events -
+Initialize a tep handler with trace events from the local system.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
+struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
+int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
+
+--
+
+DESCRIPTION
+-----------
+Functions for initializing a tep handler with trace events from the local system.
+
+The _tracefs_local_events()_ function allocates a new _tep_ handler and
+initializes it with events from all trace systems, located in the given
+_tracing_dir_ directory. This could be NULL or the location of the tracefs
+mount point for the trace systems of the local machine, or it may be a path
+to a copy of the tracefs directory from another machine.
+
+The _tracefs_local_events_system()_ function allocates a new _tep_ handler
+and initializes it with events from specified trace systems _sys_names_,
+located in the given _tracing_dir_ directory. This could be NULL or the
+location of the tracefs mount point for the trace systems of the local
+machine, or it may be a path to a copy of the tracefs directory from another
+machine. The _sys_names_ argument is an array of trace system names, that
+will be used for _tep_ handler initialization. The last element in that
+array must be a NULL pointer.
+
+The _tracefs_fill_local_events()_ function initializes already allocated _tep_
+handler with events from all trace systems, located in the given _tracing_dir_
+directory. This could be NULL or the location of the tracefs mount point
+for the trace systems of the local machine, or it may be a path to a copy
+of the tracefs directory from another machine. The _tep_ argument must be
+a pointer to already allocated tep handler, that is going to be initialized.
+The _parsing_failures_ argument could be NULL or a pointer to an integer,
+where the number of failures while parsing the event files are returned.
+
+RETURN VALUE
+------------
+The _tracefs_local_events()_ and _tracefs_local_events_system()_ functions
+return pointer to allocated and initialized _tep_ handler, or NULL in
+case of an error. The returned _tep_ handler must be freed with _tep_free(3)_.
+
+The _tracefs_fill_local_events()_ function returns -1 in case of an error or
+0 otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+struct tep_event *tep;
+...
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		/* Failed to initialise tep handler with local events from top instance */
+		...
+	}
+...
+	tep_free(tep);
+...
+	const char *systems[] = {"ftrace", "irq", NULL};
+	tep = tracefs_local_events_system(NULL, systems);
+	if (!tep) {
+		/* Failed to initialise tep handler with local events from
+		 * ftrace and irq systems in top instance.
+		 */
+		...
+	}
+...
+	tep_free(tep);
+...
+	int parsing_failures;
+	tep = tep_alloc();
+	if (!tep) {
+		/* Failed to allocate a tep handler */
+		...
+	}
+	if (tracefs_fill_local_events(NULL, tep, &parsing_failures) < 0) {
+		/* Failed to initialise tep handler with local events from top instance */
+	}
+...
+	tep_free(tep);
+--
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
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
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
-- 
2.28.0


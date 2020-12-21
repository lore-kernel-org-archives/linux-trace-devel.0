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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D359AC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A95C422513
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgLUGEC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgLUGEC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:04:02 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C90C0611CF
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:03:05 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id q22so11821695eja.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UGI7x9XGf8QdyR8SMGBQIxUmxZG5OF3RDAyFwTys9vM=;
        b=GIS/eIUx7i/JAVzWDaGkZa+Wlj1Cq4VYZmbnsBnV7SOmmXo0BoBSVPiYo9t3de7GlW
         5QMqC3Ma7p0ouC1MS/yOlmZtO66OmpDlqyDOjfiQ8nVi9m8dp0fUWbvz69dXt1/jpt1b
         D8hD1aw0ee1q2taIj4KPfHIaJ4Vtt+ZKUCv2yRJdUiFkOhzzYx+OCqnOqi8AqG0R137M
         zFgLUd9EDCwGvTAzULwnpO+XoDh6C3AneDaiF0ErQGhyszX0evAUIU1RYKqrmOYpfZwC
         nxy7RSDdgDuAW5yFosqrgJ/qpSVXWG1ZA7/ZuUCfmBlo3UT2EIFmqR40lyQcLKtT0+BE
         hWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UGI7x9XGf8QdyR8SMGBQIxUmxZG5OF3RDAyFwTys9vM=;
        b=ofLSIzlgBl4JjxxAVWsJb+mfHTBgFbLN8yZ8781kKVi1gjkmlV392WcybMT29sq8WJ
         K6RdUm2OIMlKkiZINgN67gIIbQupGie/7h/j9i251eUBHKNm6NO1irW83ucfi6hJN4m+
         ua5sq51i/J8QaMRZijw8HY9XRcuRH1ZKo2eiEhEmCwkHd1c4Ne9egqWEK9fFNK+IyJpE
         1sgFKo9WhX8bawPHnisHo6RpVKWDTPBsSgfr0vXZ9z3/n21lHrwDWWAmuDH67QJWWIwL
         fRBvM6szhrRlONTOwCs4bCAyMio2zjYN7w14LYY7C5HNdUfhSoTtDixpy3jwduAh8CXu
         oMfA==
X-Gm-Message-State: AOAM532l/37fXG5cOjf/GghMk96fUY8o/5uxfvR+Ym4KlKM7sZLB2rC0
        uFlWgLXchhqD0qBqFI/3jgo=
X-Google-Smtp-Source: ABdhPJxhC4a0lZ/13B2uhko3YWJocySrGMkQYPSqKFAoHN2YMhnM/YGeVHQ27XK5Snf+atNVQv9glw==
X-Received: by 2002:a17:907:720e:: with SMTP id dr14mr13996188ejc.303.1608530584253;
        Sun, 20 Dec 2020 22:03:04 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z10sm8560885ejl.30.2020.12.20.22.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:03:03 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 7/8] libtracefs man pages: APIs for initializing a tep handler with trace events from the local system.
Date:   Mon, 21 Dec 2020 08:02:51 +0200
Message-Id: <20201221060252.177890-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201221060252.177890-1-tz.stoyanov@gmail.com>
References: <20201221060252.177890-1-tz.stoyanov@gmail.com>
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
 Documentation/libtracefs-events-tep.txt | 131 ++++++++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100644 Documentation/libtracefs-events-tep.txt

diff --git a/Documentation/libtracefs-events-tep.txt b/Documentation/libtracefs-events-tep.txt
new file mode 100644
index 0000000..a01ce0e
--- /dev/null
+++ b/Documentation/libtracefs-events-tep.txt
@@ -0,0 +1,131 @@
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
+*#include <event-parse.h>*
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
+_tracing_dir_ directory. This could be NULL or tracefs mount point, for
+trace events in top instance, or full path to a trace instance, for trace
+events in that instance.
+
+The _tracefs_local_events_system()_ function allocates a new _tep_ handler
+and initializes it with events from specified trace systems _sys_names_,
+located in the given _tracing_dir_ directory. This could be NULL or tracefs
+mount point, for trace events in top instance, or full path to a trace instance,
+for trace events in that instance. The _sys_names_ argument is an array of
+trace system names, that will be used for _tep_ handler initialization.
+The last element in that array must be a NULL pointer.
+
+The _tracefs_fill_local_events()_ function initializes already allocated _tep_
+handler with events from all trace systems, located in the given _tracing_dir_
+directory. This could be NULL or tracefs mount point, for trace events in
+the top instance, or full path to a trace instance, for trace events in that
+instance. The _tep_ argument must be a pointer to already allocated tep
+handler, that is going to be initialized. The _parsing_failures_ argument
+could be NULL or a pointer to an integer, where the number of failures while
+parsing the event files are returned.
+
+RETURN VALUE
+------------
+The _tracefs_local_events()_ and _tracefs_local_events_system()_ functions
+return pointer to allocated and initialized _tep_ handler, or NULL in
+case of an error. The returned _tep_ handler must be freed with _tep_free()_.
+
+The _tracefs_fill_local_events()_ function returns -1 in case of an error or
+0 otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+#include <event-parse.h>
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


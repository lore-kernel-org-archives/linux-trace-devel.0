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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC3AC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A6222513
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgLUGD6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbgLUGD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:03:57 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F57C0611CB
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:03:00 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c7so8456586edv.6
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5GZNYh356HhEcIbSlefkqNxXutdLhcij5aCTg2yE2II=;
        b=OOu9G1N2Ngbo7GeJyj7bZ10neJjiIn1F4udsLj79TmDadjVsAB0ivDh1T6UL1gyiGZ
         55iSwoWnqy58LU02bJcZuHafFW8ErVIvFkUuGMz1Ps4bnKRCSwep5fmoCQv/k5qV6V5e
         jQHNjmAjoYdwuqNsobnGO7OHKzs+BNpLKyWW7QDS8IkatyI0l79RKKEFIjAR2qXgTnt0
         wsTBuwunIRdR2QbGvyApPh5pe3IXgQQ2Wdee8apfjEsEMR++kWP2rD3bPZ26Dk3ma/pw
         RpR0ZqNJFF+rlFnkOgyWnpc9QiQJxolVHc3rfvz64njdazV6MvZrDCgc7hnRM0r1jTjg
         O8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5GZNYh356HhEcIbSlefkqNxXutdLhcij5aCTg2yE2II=;
        b=HT/glIEpWUnoADoomPyjLhwhx31BhvZTmeUp2AqzpaZDLCrQ86P8f/tfnpPGhwJzl4
         kM2pu4/BI/COKlIJ5/oGhg5WbRMKTwx8qTTu5PnnHci7Ic3kuKsntBYXLLCm4pklqKtM
         kFGBbVDHogwcKJzwF5LYXz0x+uy0N28rxe61vK1/FYbGxe/AXk+EReJnWp1tZNxmj1VQ
         1364w6gCv/tM89RFYF3D1nqqDciOtj5YEi+HL7y8o2Avjhcfn3eQbF1RI+k4MvWFgCFn
         B0W0sB4URbuKCGIdmeOdIHyyTaHVVd/mbic442yDW+h846hHB0Yw20L4l1ausiMbQk/j
         iGKw==
X-Gm-Message-State: AOAM532GeI/rxqwqvvVMvuLfF1k68KwnYr+wVZteQaOiJqSGiCzXyEe4
        wU/PDzVyZE3BTATxHhuOzS0=
X-Google-Smtp-Source: ABdhPJyL4jkks0W5LxtMxW0vS0iwIw4ffjnz4Fn6OEalAXCTBYBsXjA5Oa5f9BqFRYUzjODLP4hzZQ==
X-Received: by 2002:a05:6402:a45:: with SMTP id bt5mr14721203edb.130.1608530578840;
        Sun, 20 Dec 2020 22:02:58 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z10sm8560885ejl.30.2020.12.20.22.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:02:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/8] libtracefs man pages: APIs for working with trace systems and events.
Date:   Mon, 21 Dec 2020 08:02:47 +0200
Message-Id: <20201221060252.177890-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201221060252.177890-1-tz.stoyanov@gmail.com>
References: <20201221060252.177890-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_event_systems()
tracefs_system_events()
tracefs_iterate_raw_events()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-events.txt | 143 ++++++++++++++++++++++++++++
 1 file changed, 143 insertions(+)
 create mode 100644 Documentation/libtracefs-events.txt

diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
new file mode 100644
index 0000000..3a51055
--- /dev/null
+++ b/Documentation/libtracefs-events.txt
@@ -0,0 +1,143 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_event_systems, tracefs_system_events, tracefs_iterate_raw_events -
+Work with trace systems and events.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
+char pass:[*]pass:[*]*tracefs_system_events*(const char pass:[*]_tracing_dir_, const char pass:[*]_system_);
+int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
+
+--
+
+DESCRIPTION
+-----------
+Trace systems and events related APIs.
+
+The _tracefs_event_systems()_ function returns array of strings with the
+names of all registered trace systems, located in the given _tracing_dir_
+directory. This could be NULL or the location of the tracefs mount point
+for the trace systems of the local machine, or it may be a path to a copy
+of the tracefs directory from another machine. The last entry in the array
+is a NULL pointer. The array must be freed with _tracefs_list_free()_ API.
+
+The _tracefs_system_events()_ function returns array of strings with the
+names of all registered trace events for given trace system specified by
+_system_, located in the given _tracing_dir_ directory. This could be NULL
+or the location of the tracefs mount point for the trace systems of the
+local machine, or it may be a path to a copy of the tracefs directory
+from another machine. The last entry in the array as a NULL pointer.
+The array must be freed with _tracefs_list_free()_ API.
+
+The _tracefs_interate_raw_events()_ function will read the tracefs raw
+data buffers and call the specified _callback_ function for every event it
+encounters. An initialized _tep_ handler is required (See
+_tracefs_local_events_(3)). If _instance_ is NULL, then the toplevel
+tracefs buffer is used, otherwise the buffer for the corresponding
+_instance_ is read. To filter only on a subset of CPUs, _cpus_ and
+_cpu_size_ may be set to only call _callback_ with events that occurred on
+the CPUs specified, otherwise if _cpus_ is NULL then the _callback_
+function will be called for all events, and _cpu_size_ is ignored. The
+_callback_ function will be called with the following parameters: A
+pointer to a struct tep_event that corresponds to the type of event the
+record is; The record representing the event; The CPU that the event
+occurred on; and a pointer to user specified _context_. If the _callback_
+returns non-zero, the iteration stops.
+
+
+RETURN VALUE
+------------
+The _tracefs_event_systems()_ and __tracefs_system_events()_ functions return
+an array of strings. The last element in that array is a NULL pointer. The array
+must be freed with _tracefs_list_free()_ API. In case of an error, NULL is returned.
+
+The _tracefs_iterate_raw_events()_ function returns -1 in case of an error or
+0 otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+char **systems = tracefs_event_systems(NULL);
+
+	if (systems) {
+		int i = 0;
+		/* Got registered trace systems from the top trace instance */
+		while (systems[i]) {
+			char **events = tracefs_system_events(NULL, systems[i]);
+			if (events) {
+				/* Got registered events in system[i] from the top trace instance */
+				int j = 0;
+
+				while (events[j]) {
+					/* Got event[j] in system[i] from the top trace instance */
+					j++;
+				}
+				tracefs_list_free(events);
+			}
+			i++;
+		}
+		tracefs_list_free(systems);
+	}
+....
+static int records_walk(struct tep_event *tep, struct tep_record *record, int cpu, void *context)
+{
+	/* Got recorded event on cpu */
+	return 0;
+}
+...
+struct tep_event *tep = tracefs_local_events(NULL);
+
+	if (!tep) {
+		/* Failed to initialise tep handler with local events */
+		...
+	}
+	if (tracefs_iterate_raw_events(tep, NULL, NULL, 0, records_walk, NULL) < 0) {
+		/* Error walking through the recorded raw events */
+	}
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


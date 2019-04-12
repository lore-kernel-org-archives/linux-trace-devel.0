Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EE6C10F14
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 240BE2171F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfDLNii (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50265 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfDLNih (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id z11so11357682wmi.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5yCAbnZCZuiOjMAzwBzpHz2LoDzKckLz/J6WzycyfQ=;
        b=DCoJK7zMyHjaJoU9sQ0Z72cAelmUm/HME16UthCPTbqAg7aIGLAa/vdMVmDyeOr8xI
         Kch1uNgsWJi7HTjtcerFwEK2GDYXYDvZUSthfATBUN6a/RElGRgyI1SnbH+o23+GpI/g
         SBjcbG6bey4sf0VakMKnktKhqD2KTEt5wsvFz7C7sz8AjGTJqFBmuX84WtbwoHSmshaZ
         oioSQjarUyoRulb6Prw1/F8bS+2ta1VH3kjonbc+3ZNrK3lStW7wpSC7d+ywPz7gObHg
         PPspijRdUz4Ns1rZK142l2IdI3qlvo7x50ClX56xM32YeUyqR8WXKMX3vw1SAd2xSZSb
         Ro5Q==
X-Gm-Message-State: APjAAAVfhm02FJGAG0KVDYhLo1AANyf0IajHnM9M5fIIG5yajR6+JZ+d
        wkZQ1Sdx2s9QTx93oUT83A93Eq5i
X-Google-Smtp-Source: APXvYqz+PsmiI+e+GBM3eSslp8Mw6BCilVTri9TgynQJqrSVkxyuXuPVc08+qnLW1oTpZyioqT0ZrA==
X-Received: by 2002:a1c:cf83:: with SMTP id f125mr11036154wmg.96.1555076314988;
        Fri, 12 Apr 2019 06:38:34 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:34 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 24/30] tools/lib/traceevent: Man pages for event filter APIs
Date:   Fri, 12 Apr 2019 16:38:05 +0300
Message-Id: <20190412133811.15878-25-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new man pages, describing libtraceevent event filter APIs:
  tep_filter_alloc()
  tep_filter_free()
  tep_filter_reset()
  tep_filter_add_filter_str()
  tep_filter_strerror()
  tep_event_filtered()
  tep_filter_remove_event()
  tep_filter_match()
  tep_filter_copy()
  tep_filter_compare()
  tep_filter_make_string()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-filter.txt    | 210 ++++++++++++++++++
 1 file changed, 210 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter.txt
new file mode 100644
index 000000000000..df49e4f10697
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter.txt
@@ -0,0 +1,210 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_filter_alloc, tep_filter_free, tep_filter_reset, tep_filter_make_string,
+tep_filter_copy, tep_filter_compare, tep_filter_match, tep_event_filtered,
+tep_filter_remove_event, tep_filter_strerror, tep_filter_add_filter_str -
+Event filter related APIs.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_event_filter pass:[*]*tep_filter_alloc*(struct tep_handle pass:[*]_tep_);
+void *tep_filter_free*(struct tep_event_filter pass:[*]_filter_);
+void *tep_filter_reset*(struct tep_event_filter pass:[*]_filter_);
+enum tep_errno *tep_filter_add_filter_str*(struct tep_event_filter pass:[*]_filter_, const char pass:[*]_filter_str_);
+int *tep_event_filtered*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
+int *tep_filter_remove_event*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
+enum tep_errno *tep_filter_match*(struct tep_event_filter pass:[*]_filter_, struct tep_record pass:[*]_record_);
+int *tep_filter_copy*(struct tep_event_filter pass:[*]_dest_, struct tep_event_filter pass:[*]_source_);
+int *tep_filter_compare*(struct tep_event_filter pass:[*]_filter1_, struct tep_event_filter pass:[*]_filter2_);
+char pass:[*]*tep_filter_make_string*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
+int *tep_filter_strerror*(struct tep_event_filter pass:[*]_filter_, enum tep_errno _err_, char pass:[*]buf, size_t _buflen_);
+--
+
+DESCRIPTION
+-----------
+Filters can be attached to traced events. They are useful for picking out only
+the desired information, and not to flood the ring buffer with needless events.
+Each event can be filtered based on its parameters, described in the event's
+format file. This set of functions can be used to create, delete, modify and
+attach event filters.
+
+The _tep_filter_alloc()_ function creates a new event filter. The _tep_ argument
+is the trace event parser context.
+
+The _tep_filter_free()_ function frees an event filter and all resources that it
+had used.
+
+The _tep_filter_reset()_ function removes all rules from an event filter and
+resets it.
+
+The _tep_filter_add_filter_str()_ function adds a new rule to the _filter_. The
+_filter_str_ argument is the filter string, that contains the rule.
+
+The _tep_event_filtered()_ function checks if the event with _event_id_ has
+_filter_.
+
+The _tep_filter_remove_event()_ function removes a _filter_ for an event with
+_event_id_.
+
+The _tep_filter_match()_ function tests if a _record_ matches given _filter_.
+
+The _tep_filter_copy()_ function copies a _source_ filter into a _dest_ filter.
+
+The _tep_filter_compare()_ function compares two filers - _filter1_ and _filter2_.
+
+The _tep_filter_make_string()_ function constructs a string, displaying
+the _filter_ contents for given _event_id_.
+
+The _tep_filter_strerror()_ function copies the _filter_ error buffer into the
+given _buf_ with the size _buflen_. If the error buffer is empty, in the _buf_
+is copied a string, describing the error _err_.
+
+RETURN VALUE
+------------
+The _tep_filter_alloc()_ function returns a pointer to the newly created event
+filter, or NULL in case of an error.
+
+The _tep_filter_add_filter_str()_ function returns 0 if the rule was
+successfully added or a negative error code.  Use _tep_filter_strerror()_ to see
+actual error message in case of an error.
+
+The _tep_event_filtered()_ function returns 1 if the filter is found for given
+event, or 0 otherwise.
+
+The _tep_filter_remove_event()_ function returns 1 if the vent was removed, or
+0 if the event was not found.
+
+The _tep_filter_match()_ function returns _tep_errno_, according to the result:
+[verse]
+--
+_pass:[TEP_ERRNO__FILTER_MATCH]_	- filter found for event, the record matches.
+_pass:[TEP_ERRNO__FILTER_MISS]_		- filter found for event, the record does not match.
+_pass:[TEP_ERRNO__FILTER_NOT_FOUND]_	- no filter found for record's event.
+_pass:[TEP_ERRNO__NO_FILTER]_		- no rules in the filter.
+--
+or any other _tep_errno_, if an error occurred during the test.
+
+The _tep_filter_copy()_ function returns 0 on success or -1 if not all rules
+ were copied.
+
+The _tep_filter_compare()_ function returns 1 if the two filters hold the same
+content, or 0 if they do not.
+
+The _tep_filter_make_string()_ function returns a string, which must be freed
+with free(), or NULL in case of an error.
+
+The _tep_filter_strerror()_ function returns 0 if message was filled
+successfully, or -1 in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+char errstr[200];
+int ret;
+
+struct tep_event_filter *filter = tep_filter_alloc(tep);
+struct tep_event_filter *filter1 = tep_filter_alloc(tep);
+ret = tep_filter_add_filter_str(filter, "sched/sched_wakeup:target_cpu==1");
+if(ret < 0) {
+	tep_filter_strerror(filter, ret, errstr, sizeof(errstr));
+	/* Failed to add a new rule to the filter, the error string is in errstr */
+}
+if (tep_filter_copy(filter1, filter) != 0) {
+	/* Failed to copy filter in filter1 */
+}
+...
+if (tep_filter_compare(filter, filter1) != 1) {
+	/* Both filters are different */
+}
+...
+void process_record(struct tep_handle *tep, struct tep_record *record)
+{
+	struct tep_event *event;
+	char *fstring;
+
+	event = tep_find_event_by_record(tep, record);
+
+	if (tep_event_filtered(filter, event->id) == 1) {
+		/* The event has filter */
+		fstring = tep_filter_make_string(filter, event->id);
+		if (fstring != NULL) {
+			/* The filter for the event is in fstring */
+			free(fstring);
+		}
+	}
+
+	switch (tep_filter_match(filter, record)) {
+	case TEP_ERRNO__FILTER_MATCH:
+		/* The filter matches the record */
+		break;
+	case TEP_ERRNO__FILTER_MISS:
+		/* The filter does not match the record */
+		break;
+	case TEP_ERRNO__FILTER_NOT_FOUND:
+		/* No filter found for record's event */
+		break;
+	case TEP_ERRNO__NO_FILTER:
+		/* There are no rules in the filter */
+		break
+	default:
+		/* An error occurred during the test */
+		break;
+	}
+
+	if (tep_filter_remove_event(filter, event->id) == 1) {
+		/* The event was removed from the filter */
+	}
+}
+
+...
+tep_filter_reset(filter);
+...
+tep_filter_free(filter);
+tep_filter_free(filter1);
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


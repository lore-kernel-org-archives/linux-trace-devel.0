Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B20C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 761292087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfCHNhb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:31 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39007 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfCHNhb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:31 -0500
Received: by mail-wm1-f65.google.com with SMTP id z84so12440031wmg.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vu6QT8s5Srnk+GrxWrbQBtIyr3fk9VDzF7tIoJo3eI0=;
        b=mUI4yNVsOBr346L8eZHQk9PhUyrxQ3dHj4LJFBu39wXvYT79eo5/2Pk7LsDFVCuP16
         HOxx+a1U2hiJ/GyDmphNkQc9gf1+ZLw8WkddJasPpeBiTBTB+h2BdQHDyPl/8AiPn04x
         bLIrGRjlDutNzutRXjkjyDnH0A5bJo2y4NXbwPk1sye08Wq/1W/ZCdQL5WL3am9XIv+s
         VSH1zn//aNE7Cti6K+utxYHqYy30DKGqCW1lBAfnQUXVOxqGIGe7c3ubI3/SlE9O035D
         8xLganCmbG3t6ibXD0CKl7KDIeV9LJAYQIIcyeVs6KXe1oOxz1G/rxjggNjSvzoW4UTE
         MYtg==
X-Gm-Message-State: APjAAAVSS++FoWuIHQOn2Nrh05rDDP40uLC+808gZIW8kYo7oaxDdDHs
        GvJbqx9oVsSx+R5ka2qVWKU=
X-Google-Smtp-Source: APXvYqzlN6oSQizlK9rSWzUbP7VqQOtqOZQV0wP/XsqM91tPV7ceyNFSPuwf919faxKZcukGpUFLcA==
X-Received: by 2002:a05:600c:2115:: with SMTP id u21mr9717766wml.70.1552052249344;
        Fri, 08 Mar 2019 05:37:29 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:28 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 34/46] tools/lib/traceevent: Man pages for tep_filter_event_has_trivial(), tep_update_trivial() and tep_filter_clear_trivial()
Date:   Fri,  8 Mar 2019 15:36:42 +0200
Message-Id: <20190308133654.21264-35-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_filter_event_has_trivial(),
tep_update_trivial() and tep_filter_clear_trivial()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_trivial.txt          | 112 ++++++++++++++++++
 1 file changed, 112 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_trivial.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_trivial.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter_trivial.txt
new file mode 100644
index 000000000000..7114192d3640
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_trivial.txt
@@ -0,0 +1,112 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_filter_event_has_trivial,tep_update_trivial,tep_filter_clear_trivial - Check / update / clear trivial rules of given filter.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_filter_trivial_type* {
+	_TEP_FILTER_TRIVIAL_FALSE_,
+	_TEP_FILTER_TRIVIAL_TRUE_,
+	_TEP_FILTER_TRIVIAL_BOTH_,
+};
+
+int *tep_filter_event_has_trivial*(struct tep_event_filter pass:[*]_filter_, int _event_id_, enum tep_filter_trivial_type _type_);
+int *tep_update_trivial*(struct tep_event_filter pass:[*]_dest_, struct tep_event_filter pass:[*]_source_, enum tep_filter_trivial_type _type_);
+int *tep_filter_clear_trivial*(struct tep_event_filter pass:[*]_filter_, enum tep_filter_trivial_type _type_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_event_has_trivial()_ function checks if the event with
+_event_id_ contains a trivial _filter_ of _type_.
+
+The _tep_update_trivial()_ function updates the trivial rules with the given
+filter. It scans _dest_ for trivial events matching _type_ to replace with
+the _source_.
+
+The _tep_filter_clear_trivial()_ function clears TRUE and FALSE rules.
+It removes rules in the _filter_ that only contain a given _type_ boolean arg.
+
+The trivial _type_, used as argument of these functions can be:
+[verse]
+--
+	_TEP_FILTER_TRIVIAL_FALSE_	- TRUE
+	_TEP_FILTER_TRIVIAL_TRUE_	- FALSE
+	_TEP_FILTER_TRIVIAL_BOTH_	- TRUE or FALSE
+
+--
+
+RETURN VALUE
+------------
+The _tep_filter_event_has_trivial()_ function returns 1 if the event contains
+a matching trivial type, otherwise 0.
+
+The _tep_update_trivial()_ function  returns 0 on success, or -1 if there was
+a problem updating, but events may have still been updated on error.
+
+The _tep_filter_clear_trivial()_ function returns 0 on success, or -1 if there
+was a problem.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+struct tep_event_filter *filter1 = tep_filter_alloc(tep);
+struct tep_event_filter *filter2 = tep_filter_alloc(tep);
+...
+if (tep_filter_event_has_trivial(filter1, 1857,TEP_FILTER_TRIVIAL_FALSE) == 0) {
+	/* There are FALSE rules in filer1 for the event 1857 */
+}
+
+if (tep_update_trivial(filter1, filter2, TEP_FILTER_TRIVIAL_TRUE) != 0) {
+	/* Failed to update TRUE trivial rules of filter1 with filter2 */
+}
+
+if (tep_filter_clear_trivial(filter, TEP_FILTER_TRIVIAL_BOTH) == 0) {
+	/* Failed to clear TRUE and FALSE trivial rules of filter1 */
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


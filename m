Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA73C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7000A2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfCHNh3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:29 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39005 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfCHNh3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:29 -0500
Received: by mail-wm1-f65.google.com with SMTP id z84so12439956wmg.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NKi0RPd+/+/jSQfXotQ+wmF/Y6LhamUzgX6OcrfcCRw=;
        b=GPxbBadlxBon5ahh4plcOm4SWKduFc6vhFtOedF/ABVvSOnQfFHhZdysCcc+9eTZ48
         UKqk4sBzmhXBtDs/LeMX4rsnB0OSwh6IRPyk9N4fCY56nP3SZGk9BXTN4U1t0vQHnOKQ
         eQe2/FF4XEnK4yebf+rgHYqKEU1ax2qzWYj2c+v+QQfNtYwRUZYu1jnAttxHYY8nU7m8
         AW0g5DaOlXiWnoveOlrME/Skm+2u1I97EmUgpilgFPTC1Z47RbgUkK5lRf1Q4I4sbV2v
         2VZo/TDFRSS7ALEwo5mqwRQ5Ac5ZCWph1uSnWE/To2Os4TpDbQ70OzT2hfxSefhAnnuu
         ZHLg==
X-Gm-Message-State: APjAAAU5okjs21epdT3D6hTXNGVmapEDJpSdn1IIGoNUAzmAXytPoqiI
        T42d3q4MxOr1gfnjh6eq4ua0a1Am
X-Google-Smtp-Source: APXvYqy3A0QSHw3qcCSmbjmmldHtg30pPet2zZ1tz8ve749Se9h/+oIWpseNnUYchlnnqbxb4kNvWQ==
X-Received: by 2002:a1c:7e58:: with SMTP id z85mr9438494wmc.52.1552052247385;
        Fri, 08 Mar 2019 05:37:27 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:26 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 32/46] tools/lib/traceevent: Man pages for tep_filter_copy() and tep_filter_compare()
Date:   Fri,  8 Mar 2019 15:36:40 +0200
Message-Id: <20190308133654.21264-33-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_filter_copy() and tep_filter_compare()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_oper.txt             | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_oper.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_oper.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter_oper.txt
new file mode 100644
index 000000000000..dce4cc649ad0
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_oper.txt
@@ -0,0 +1,84 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_filter_copy,tep_filter_compare - Copy / compare operations with event filters.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_filter_copy*(struct tep_event_filter pass:[*]_dest_, struct tep_event_filter pass:[*]_source_);
+int *tep_filter_compare*(struct tep_event_filter pass:[*]_filter1_, struct tep_event_filter pass:[*]_filter2_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_copy()_ function copies a _source_ filter into a _dest_ filter.
+
+The _tep_filter_compare()_ function compares two filers - _filter1_ and _filter2_.
+
+RETURN VALUE
+------------
+The _tep_filter_copy()_ function returns 0 on success or -1 if not all rules
+ were copied.
+
+The _tep_filter_compare()_ function returns 1 if the two filters hold the same
+content, or 0 if they do not.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+struct tep_event_filter *filter1 = tep_filter_alloc(tep);
+struct tep_event_filter *filter2 = tep_filter_alloc(tep);
+...
+if (tep_filter_copy(filter1, filter2) != 0) {
+	/* Failed to copy filter2 in filter1 */
+}
+...
+if (tep_filter_compare(filter1, filter2) != 1) {
+	/* Both filters are different */
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

